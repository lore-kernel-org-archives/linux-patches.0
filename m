Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 899EF2FD7C3;
	Sat, 12 Sep 2026 13:45:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789220758; cv=none; b=rOQabsawve8txg0RNh3D6J7OgkR1RpHayKUriIE85N95mDOMNl7qQv1QB6qxeOT/c8XXQALs9/14UuQR8GPu7RLCK4ji/VF1HFEUQH163xnhYvHilxRzLuwr2PfeXPGdoiTFryyFzwB6qiH3QzjDdSW2/vjNgdrdjmSrnecZlEI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789220758; c=relaxed/simple;
	bh=5NbX5I49mw+CtQTSUWPxD2BfGQacgxVpQBn5Ax+tC5g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=i6ZtD81dYxJ817J1CjUdLapEbKzMiaNh2z4KqQ2rbmDEOE7PxeNEvpGtVbhgg4nqw1MiPy6zC6zwHRW6SMTvZQompBKcmsRe8gDcnTCH6QZZK7VTqeWO/9WnnVkr3IfEquUmc0j3y40lJ2KgsOFWB6cLd2InjehO0fXrmHg/aws=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bPyggjz+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bPyggjz+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 432FE1F000FF;
	Sat, 12 Sep 2026 13:45:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789220757;
	bh=QqjaR0PWPTKopIPSHqotETe7H15FZMh0PhbkTfo97mM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bPyggjz+ekK6JundC8oIHTuWgpwd3ghVTwp97VBh2qj6t7Pu4sBkeh0oxZcnqHpzq
	 Tfr0jPwWNX49GeZOzV/dKwp2y8y+Y5nzszq0JspL4ae3/LUYRhFHQrPITvalaDn7PQ
	 kVtmUvnCbgFzPIi9rUzJxGvgAGns1dFp9TLU7TWQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Muhammad Bilal <meatuni001@gmail.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
Subject: [PATCH 6.6 0242/1424] platform/x86: hp-bioscfg: bound ordered-list parsing by the package count
Date: Sat, 12 Sep 2026 08:44:34 +0200
Message-ID: <20260912065612.702635133@linuxfoundation.org>
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

commit 1d143d78299d0eb4536698bf98c1815ec69f22a9 upstream.

hp_populate_ordered_list_elements_from_package() differs from the other
per-type parsers: its main loop is bounded only by the fixed per-type
count and never checks elem against the number of elements actually
present in the package,

  for (elem = 1, eloc = 1; eloc < ORD_ELEM_CNT; elem++, eloc++)

whereas the string, integer, enumeration and password parsers bound
their main loop with "elem < count" as well.

This is safe today because hp_init_bios_package_attribute() rejects any
package with fewer than ORD_ELEM_CNT elements before the parser runs.
An upcoming change, however, relaxes that check to accept shorter
packages.

Bound the loop by the validated element count as well, so it stops at
whichever comes first, the per-type count or the real package size,

  for (elem = 1, eloc = 1; eloc < ORD_ELEM_CNT && elem < order_obj_count;
       elem++, eloc++)

order_obj_count is the validated element count, now correctly forwarded
from the caller. No functional change for packages that enumerate
correctly today.

Cc: stable@vger.kernel.org
Signed-off-by: Muhammad Bilal <meatuni001@gmail.com>
Link: https://patch.msgid.link/20260709165900.30615-3-meatuni001@gmail.com
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/platform/x86/hp/hp-bioscfg/order-list-attributes.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/platform/x86/hp/hp-bioscfg/order-list-attributes.c
+++ b/drivers/platform/x86/hp/hp-bioscfg/order-list-attributes.c
@@ -148,7 +148,7 @@ static int hp_populate_ordered_list_elem
 	if (!order_obj)
 		return -EINVAL;
 
-	for (elem = 1, eloc = 1; eloc < ORD_ELEM_CNT; elem++, eloc++) {
+	for (elem = 1, eloc = 1; eloc < ORD_ELEM_CNT && elem < order_obj_count; elem++, eloc++) {
 
 		switch (order_obj[elem].type) {
 		case ACPI_TYPE_STRING:


