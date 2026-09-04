Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AF4D4248B1;
	Fri,  4 Sep 2026 06:19:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788502777; cv=none; b=pyJxX4wzpIJPrP/uXIuGiIb8rCy3OUyTZIpuDdfgSbe6ud9Xr31lkBcUJ73WFe2BulBAmy3VsNtSWkpzbxTMy2DPfY/Du+W/qihPdKYm0uNLZBOLUSvdAkvEi/+AcDpgUFFYWRpClBKOCXcGfv1LVRFOLTvnZnGbV0TySQyAup4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788502777; c=relaxed/simple;
	bh=FiH147QWA983tsBs8OtxNvbNWuGJfga0FonNgUz9mjQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=E077+yM3dTO6YSCyEIjgdeO4y6FERoN2m42uBRlaIiJAxa1ojhRKJ1wkiGxSXeT3KWyzXhZTLnzkoj36d3lKYPw6S0CYGCu+lLrjVKghFgGpYIN5sbAibkfkB4h3ScgiBvA6YBpigpg+HiNkP+asAE2nEwp3MUXVIen5XhyY0KU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MxCQlc9F; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MxCQlc9F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C274D1F00A3D;
	Fri,  4 Sep 2026 06:19:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788502776;
	bh=Tf78txEcxdtNTdhXLun6AF69Qfp7PKFNhO38kvowEOk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MxCQlc9FZ1UbVfUahbu/RThD+lNvmFSvm9nNO9Scvtd86//bnKeKh+DosRCMfXvHI
	 VsSdykd3EB0l8xvSoWSyiqpTFzoy+93Uzh9IDj3byuv5i4qIozUFl7athfqtzv4rVm
	 5CWPUdJLL2FDJR+w4Ei7xOcZ2OPLp77q3CYBR/Ks=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Muhammad Bilal <meatuni001@gmail.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
Subject: [PATCH 6.12 327/403] platform/x86: hp-bioscfg: fix ORD_LIST_ELEMENTS never being parsed
Date: Fri,  4 Sep 2026 07:02:10 +0200
Message-ID: <20260904045742.264694488@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045734.806166532@linuxfoundation.org>
References: <20260904045734.806166532@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -264,7 +264,9 @@ static int hp_populate_ordered_list_elem
 			 * Ordered list data is stored in hex and comma separated format
 			 * Convert the data and split it to show each element
 			 */
-			ret = hp_convert_hexstr_to_str(str_value, value_len, &tmpstr, &tmp_len);
+			ret = hp_convert_hexstr_to_str(order_obj[elem].string.pointer,
+						       order_obj[elem].string.length,
+						       &tmpstr, &tmp_len);
 			if (ret)
 				goto exit_list;
 


