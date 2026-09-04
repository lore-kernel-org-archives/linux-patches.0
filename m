Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 517B3417BCA;
	Fri,  4 Sep 2026 05:31:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788499897; cv=none; b=TB94aWLCVXfGOteLm5zG1sQdM1y1C7Ug4iBPwljuAcx4LYxD2dRx0a/Acct1V06++dTTdLKKDooHrjhWD+uE4Y+lgiOWBWL2ze70YOpOB7KklSn9ZmbToF9XwxLw+xLjTUWqm9LGMuY1nAivwtfYYNXM5GHdvp1INlx+Be2ovOY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788499897; c=relaxed/simple;
	bh=Wkzlnstt1Y6BjTaoIBaPtN6olJ0kIJXvRlB765CEAOo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=V5lg4EXN+TyooWD3XQOA8M6jNUu/MHB6LK8INNGHLjlon580BA6lTcpHtOZCxelS0QQr3mi3J8YhBCPNyVMea4ytS0iJskQMSDeHsS5nDrx+KWIUxQnrO1RG9xPm7pwmkTI5TVOSxqWAoSOAJEE3+JPJsDFbuDwSFwWNJEblF2o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W7x6md2O; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W7x6md2O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB71F1F00A3D;
	Fri,  4 Sep 2026 05:31:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788499896;
	bh=6kWYy9SiYbow5yUDeryEIpIlhkQLMs+b2YD9l8IKuM8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=W7x6md2O/hdbSTqnZz/hR4EHZ4+FjVB4OTlduQ10IbtBdvLlyPh62f5S728EM/pFn
	 mlQk0nt+uv7f644f6wDqQNDELekqyRHrg5r6XK6rcoP/ygmEsaEATV1zv7j6F3Yv8F
	 revA7YdySQAvQbHZ38/pbZeuSyXUdrVT5ZuL67SY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Muhammad Bilal <meatuni001@gmail.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
Subject: [PATCH 7.2 578/713] platform/x86: hp-bioscfg: bound ordered-list parsing by the package count
Date: Fri,  4 Sep 2026 06:59:06 +0200
Message-ID: <20260904045816.776492112@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045803.810145556@linuxfoundation.org>
References: <20260904045803.810145556@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
@@ -145,7 +145,7 @@ static int hp_populate_ordered_list_elem
 	if (!order_obj)
 		return -EINVAL;
 
-	for (elem = 1, eloc = 1; eloc < ORD_ELEM_CNT; elem++, eloc++) {
+	for (elem = 1, eloc = 1; eloc < ORD_ELEM_CNT && elem < order_obj_count; elem++, eloc++) {
 
 		switch (order_obj[elem].type) {
 		case ACPI_TYPE_STRING:


