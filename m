Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80CF7320CD3;
	Sat, 12 Sep 2026 13:46:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789220789; cv=none; b=q8heju6zhLDZytQ/Dx5bDcFIap2iTSQfES0WB2aIPRue3CeIgKEObCi6PKaUz3OSj0fk2TIBaeyLaghd4YzdZhLyv1VA1D80f+W0zqg1O2/ngegDPiT6OoCrnqIGtAmHgcjsGt8ll3Io05Qdb7Jsezvr9KCiYwC2mC5vnVpbiDU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789220789; c=relaxed/simple;
	bh=GNywk5IUYs0cL0aj6HqQ5ntWsxi98qdXbpXaUDC/omg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=EGUvXCkj46kx5l2ZDj5aMcZnrqMbU0AL6vJ3ZSwuflCrDBkMwrqgqgImEgkoNtQzJ2kICvrJAkaHLCoWFS00tq5guSlWaaBDVdCwN5dbZUwrCpVD47jTOV4zw+9LyLyrphC6xnawr5Hw9/+kWoP1R1OFimsswjOAbYGUHbzAPuA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e7Y4Kiic; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e7Y4Kiic"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01AD91F000FF;
	Sat, 12 Sep 2026 13:46:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789220787;
	bh=eZSLKDKR8NOGeUOS39mF0QInA1RaDSJDj71Dvv5GxnM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=e7Y4KiicLQOIOdrCAH5XLuR3FQ2CA0c41rc5S58Ey8sdmxALegSis9+bKc2WTVYR8
	 EzQVkQo+jnxPi/pOzFoNusCLbiee+Cit/SN8tDzgCPsyQZBhSExtG0LxGXxsUyV0x2
	 SYDUNDbiXKXwR51nj7q0Oq0FA75lM4azDWfFbrfY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Muhammad Bilal <meatuni001@gmail.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
Subject: [PATCH 6.6 0247/1424] platform/x86: hp-bioscfg: fix ORD_LIST_ELEMENTS never being parsed
Date: Sat, 12 Sep 2026 08:44:39 +0200
Message-ID: <20260912065612.812170936@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Muhammad Bilal <meatuni001@gmail.com>

commit cb6b1b0fb236a9581cae213c2a9182e68cc3ffe5 upstream.

The ACPI_TYPE_STRING case explicitly skips the string conversion for
elem == ORD_LIST_ELEMENTS:

	if (elem != PREREQUISITES && elem != ORD_LIST_ELEMENTS) {
		ret = hp_convert_hexstr_to_str(..., &str_value, &value_len);
		if (ret)
			continue;
	}

so by the time the ORD_LIST_ELEMENTS case in the eloc switch runs,
str_value is NULL (it was freed and reset to NULL at the end of the
previous iteration). That case then does:

	ret = hp_convert_hexstr_to_str(str_value, value_len, &tmpstr, &tmp_len);

hp_convert_hexstr_to_str() rejects a NULL input with -EINVAL, which
sends this function to exit_list, and exit_list unconditionally
returns 0. The net effect is that any ordered-list attribute with
elements present silently ends up with an empty elements list, with no
error surfaced anywhere.

Fix by converting the current element directly, order_obj[elem], the
same way the PREREQUISITES case already handles its own array
elements, instead of reusing the unrelated str_value/value_len left
over from earlier processing.

Fixes: 4b2672ec71a3 ("platform/x86: hp-bioscfg: order-list-attributes")
Cc: stable@vger.kernel.org
Signed-off-by: Muhammad Bilal <meatuni001@gmail.com>
Link: https://patch.msgid.link/20260812111829.172273-9-meatuni001@gmail.com
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/platform/x86/hp/hp-bioscfg/order-list-attributes.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/platform/x86/hp/hp-bioscfg/order-list-attributes.c
+++ b/drivers/platform/x86/hp/hp-bioscfg/order-list-attributes.c
@@ -270,7 +270,9 @@ static int hp_populate_ordered_list_elem
 			 * Ordered list data is stored in hex and comma separated format
 			 * Convert the data and split it to show each element
 			 */
-			ret = hp_convert_hexstr_to_str(str_value, value_len, &tmpstr, &tmp_len);
+			ret = hp_convert_hexstr_to_str(order_obj[elem].string.pointer,
+						       order_obj[elem].string.length,
+						       &tmpstr, &tmp_len);
 			if (ret)
 				goto exit_list;
 


