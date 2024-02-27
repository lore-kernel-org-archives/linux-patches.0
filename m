Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C5F52F2D;
	Tue, 27 Feb 2024 13:42:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709041347; cv=none; b=jGQ0/72eMqGsMUImC7JqkN0PHXEBMitln20uR/s84ZxT6mBzf4NOXjM38SU1TlPqwOvHCxgKcJUQrSl37eeFAWlpioQTIiQV0vsJyJhit1gjSpoMKZWVK8PVO22jb9/EW8Tf7Ofsk0JD77QTHLZ8ikIlcSZfnzDIga92+fVcD4A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709041347; c=relaxed/simple;
	bh=md1G/vCaW8j0pCAnbPH3cedRLYvLiBtiRj5yXrvPohw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GpOm78rrgNYFKHdSChTzUO7B3ifd3RBL5vZmv7RwoAsMp8Cc2aPkuhtKu/eDhn+sKoj7uogQ5Vhn7RyVmPR/T/egwF4Ty34fr5impujLl0p5CI4wKxw/sF2fH07iOgbxcoNLOYLohd2HOyFQLmoBL/LUXOjT9O3r0vjCKpdBZjQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kk1lHIGk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kk1lHIGk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BFE4C433C7;
	Tue, 27 Feb 2024 13:42:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709041347;
	bh=md1G/vCaW8j0pCAnbPH3cedRLYvLiBtiRj5yXrvPohw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kk1lHIGkWBvTz8cpvEbp7H1EQ3p5kKK+BN7qIlDrpVs25YHvJ6De9Uj01ISQOaOgx
	 g+XXe5yDuKh5nuK5ddWaaJ8N4ZP9ZPBaLG5++Lyn2xytJDN+1Z0rPTiJtb6Tj1OiWh
	 KZ7qyR/9QqaiNceAuKMQAZzyb7hWBqk9677gmi5U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Pearson <mpearson-lenovo@squebb.ca>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Hans de Goede <hdegoede@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 277/334] platform/x86: think-lmi: Fix password opcode ordering for workstations
Date: Tue, 27 Feb 2024 14:22:15 +0100
Message-ID: <20240227131639.930126707@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131630.636392135@linuxfoundation.org>
References: <20240227131630.636392135@linuxfoundation.org>
User-Agent: quilt/0.67
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mark Pearson <mpearson-lenovo@squebb.ca>

[ Upstream commit 6f7d0f5fd8e440c3446560100ac4ff9a55eec340 ]

The Lenovo workstations require the password opcode to be run before
the attribute value is changed (if Admin password is enabled).

Tested on some Thinkpads to confirm they are OK with this order too.

Signed-off-by: Mark Pearson <mpearson-lenovo@squebb.ca>
Fixes: 640a5fa50a42 ("platform/x86: think-lmi: Opcode support")
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Link: https://lore.kernel.org/r/20240209152359.528919-1-mpearson-lenovo@squebb.ca
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/think-lmi.c | 20 +++++++++++---------
 1 file changed, 11 insertions(+), 9 deletions(-)

diff --git a/drivers/platform/x86/think-lmi.c b/drivers/platform/x86/think-lmi.c
index 3a396b763c496..ce3e08815a8e6 100644
--- a/drivers/platform/x86/think-lmi.c
+++ b/drivers/platform/x86/think-lmi.c
@@ -1009,7 +1009,16 @@ static ssize_t current_value_store(struct kobject *kobj,
 		 * Note - this sets the variable and then the password as separate
 		 * WMI calls. Function tlmi_save_bios_settings will error if the
 		 * password is incorrect.
+		 * Workstation's require the opcode to be set before changing the
+		 * attribute.
 		 */
+		if (tlmi_priv.pwd_admin->valid && tlmi_priv.pwd_admin->password[0]) {
+			ret = tlmi_opcode_setting("WmiOpcodePasswordAdmin",
+						  tlmi_priv.pwd_admin->password);
+			if (ret)
+				goto out;
+		}
+
 		set_str = kasprintf(GFP_KERNEL, "%s,%s;", setting->display_name,
 				    new_setting);
 		if (!set_str) {
@@ -1021,17 +1030,10 @@ static ssize_t current_value_store(struct kobject *kobj,
 		if (ret)
 			goto out;
 
-		if (tlmi_priv.save_mode == TLMI_SAVE_BULK) {
+		if (tlmi_priv.save_mode == TLMI_SAVE_BULK)
 			tlmi_priv.save_required = true;
-		} else {
-			if (tlmi_priv.pwd_admin->valid && tlmi_priv.pwd_admin->password[0]) {
-				ret = tlmi_opcode_setting("WmiOpcodePasswordAdmin",
-							  tlmi_priv.pwd_admin->password);
-				if (ret)
-					goto out;
-			}
+		else
 			ret = tlmi_save_bios_settings("");
-		}
 	} else { /* old non-opcode based authentication method (deprecated) */
 		if (tlmi_priv.pwd_admin->valid && tlmi_priv.pwd_admin->password[0]) {
 			auth_str = kasprintf(GFP_KERNEL, "%s,%s,%s;",
-- 
2.43.0



