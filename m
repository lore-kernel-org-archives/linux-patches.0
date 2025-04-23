Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83218298CB7;
	Wed, 23 Apr 2025 15:22:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745421768; cv=none; b=goaAtu/bu8FNv3gMW+1isgd8PPb7uDFujCY80Lzocuid8ZvAeWLvfuabqQMo+toeHXWcH+WVZP6I8vHbRKTepivg4Z7JQNWC/dbtAalv8RBaN2NZfFBWwnC6oCHsfeDJ/A4RPwXLRMTlAQhTDibGcZb8JoMJZbU6hr4RIIFS4No=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745421768; c=relaxed/simple;
	bh=QIVVz7h57aBIk89y8ZUm6fvVeGAvOblVNO2vrYplTx8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Bq8Txx71YcP9gA8VjaT0fKMDzGp2VDzlyd69IyBRvUutRBDnPbnrFJpg+njbXLwR1S4xgCZbRA1TL0F0bDU8lvkc1RloC04W1scwLG+LX+ELx1hH0DiyYI066YAf0UfzsGpsBa9J+xmv+JsqDVXCzrf+WJQCEIBoW2Mj45hUTRE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DFsMWNuy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DFsMWNuy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14A49C4CEE2;
	Wed, 23 Apr 2025 15:22:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745421768;
	bh=QIVVz7h57aBIk89y8ZUm6fvVeGAvOblVNO2vrYplTx8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DFsMWNuy8/tKDm28WVz2BmNgKatvGnYNhch8kKw82cLZVWFSpviojpwmI72CTQFBb
	 B0QHDYiA8hj8SZbgamgKlzBb1xaAWVMdRF6u8p9KHfu1vNSEDpmdtKj7Vi7rsY1n1W
	 SvKJWh1ULEVNaTBMDtcOLZ63SeJZ9ZwL0d7QIwkU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kurt Borja <kuurtb@gmail.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
Subject: [PATCH 6.14 231/241] platform/x86: alienware-wmi-wmax: Extend support to more laptops
Date: Wed, 23 Apr 2025 16:44:55 +0200
Message-ID: <20250423142630.011911300@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142620.525425242@linuxfoundation.org>
References: <20250423142620.525425242@linuxfoundation.org>
User-Agent: quilt/0.68
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kurt Borja <kuurtb@gmail.com>

commit 202a861205905629c5f10ce0a8358623485e1ae9 upstream.

Extend thermal control support to:

 - Alienware Area-51m R2
 - Alienware m16 R1
 - Alienware m16 R2
 - Dell G16 7630
 - Dell G5 5505 SE

Cc: stable@vger.kernel.org
Signed-off-by: Kurt Borja <kuurtb@gmail.com>
Link: https://lore.kernel.org/r/20250411-awcc-support-v1-2-09a130ec4560@gmail.com
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/platform/x86/dell/alienware-wmi.c |   54 ++++++++++++++++++++++++++++++
 1 file changed, 54 insertions(+)

--- a/drivers/platform/x86/dell/alienware-wmi.c
+++ b/drivers/platform/x86/dell/alienware-wmi.c
@@ -216,6 +216,15 @@ static int __init dmi_matched(const stru
 static const struct dmi_system_id alienware_quirks[] __initconst = {
 	{
 		.callback = dmi_matched,
+		.ident = "Alienware Area-51m R2",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Alienware"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Alienware Area-51m R2"),
+		},
+		.driver_data = &quirk_x_series,
+	},
+	{
+		.callback = dmi_matched,
 		.ident = "Alienware ASM100",
 		.matches = {
 			DMI_MATCH(DMI_SYS_VENDOR, "Alienware"),
@@ -243,6 +252,15 @@ static const struct dmi_system_id alienw
 	},
 	{
 		.callback = dmi_matched,
+		.ident = "Alienware m16 R1",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Alienware"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Alienware m16 R1"),
+		},
+		.driver_data = &quirk_g_series,
+	},
+	{
+		.callback = dmi_matched,
 		.ident = "Alienware m16 R1 AMD",
 		.matches = {
 			DMI_MATCH(DMI_SYS_VENDOR, "Alienware"),
@@ -261,6 +279,15 @@ static const struct dmi_system_id alienw
 	},
 	{
 		.callback = dmi_matched,
+		.ident = "Alienware m16 R2",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Alienware"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Alienware m16 R2"),
+		},
+		.driver_data = &quirk_x_series,
+	},
+	{
+		.callback = dmi_matched,
 		.ident = "Alienware m18 R2",
 		.matches = {
 			DMI_MATCH(DMI_SYS_VENDOR, "Alienware"),
@@ -279,6 +306,15 @@ static const struct dmi_system_id alienw
 	},
 	{
 		.callback = dmi_matched,
+		.ident = "Alienware x15 R2",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Alienware"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Alienware x15 R2"),
+		},
+		.driver_data = &quirk_x_series,
+	},
+	{
+		.callback = dmi_matched,
 		.ident = "Alienware x17 R2",
 		.matches = {
 			DMI_MATCH(DMI_SYS_VENDOR, "Alienware"),
@@ -342,6 +378,15 @@ static const struct dmi_system_id alienw
 	},
 	{
 		.callback = dmi_matched,
+		.ident = "Dell Inc. G16 7630",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Dell G16 7630"),
+		},
+		.driver_data = &quirk_g_series,
+	},
+	{
+		.callback = dmi_matched,
 		.ident = "Dell Inc. G3 3500",
 		.matches = {
 			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
@@ -367,6 +412,15 @@ static const struct dmi_system_id alienw
 		},
 		.driver_data = &quirk_g_series,
 	},
+	{
+		.callback = dmi_matched,
+		.ident = "Dell Inc. G5 5505",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "G5 5505"),
+		},
+		.driver_data = &quirk_g_series,
+	},
 	{
 		.callback = dmi_matched,
 		.ident = "Dell Inc. Inspiron 5675",


