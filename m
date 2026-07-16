Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D7A142377B;
	Thu, 16 Jul 2026 13:50:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784209819; cv=none; b=V2OwZX9/EpqMNEWagxgkF0jx9SuQhq279mPsVrAQBcEAZ79syBzaYjMsnUvkjuq0+OTRxKYxiHwju5aA/V/cbcNH7ZV/ojFAR+Qi4/9jE2qTzW5crbkECm3xrYncjlhrPJw7tiUE4aIkPXPuPty/V4VK+LejTwGu6EnYxTIlqGY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784209819; c=relaxed/simple;
	bh=F6YvW+D1n4pVR5jTy+V/+O9PUPna9HYPOWDL1gif55I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iHOnKvOMbGdeoS4FM4cLHDrpzBOj/xYgY1nH+kiEdp1Sx9IstuqrA73T3F4VELVgFVGrnNivPIH7+yyA1YL83YqEYCF6/BWu2jndMZhQWrhPQahvrxpInK1OxHuhBxi099bAnDnT2Z++k3AqSB40Nry4pLuRA/4g2wZIoeDi+x0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BpSlivlH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BpSlivlH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 811EB1F000E9;
	Thu, 16 Jul 2026 13:50:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784209818;
	bh=Vp8ybjbVXkPseYtIpsDjgVjlwneVMYDQjoTYOIZ5TvE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BpSlivlHD5iAtRo+9kPF/NmO0tdVrCMlYoAFSN3GZTNgHd2OPMrobX8nGZzhjxxMR
	 66Piz6Hb1EETq0QWOzkBsHBj20/5g9EWI22RtAT2ukrVsn5Pgeab7jd8pdjAT0ZK4N
	 /sG9ehDMKL6zECnsQYHIcuE2d48fahPyAoDNcudE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Andy Yan <andyshrk@163.com>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>
Subject: [PATCH 7.1 330/518] usb: typec: tcpm: Fix VDM type for Enter Mode commands
Date: Thu, 16 Jul 2026 15:29:58 +0200
Message-ID: <20260716133055.031363528@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133047.772246337@linuxfoundation.org>
References: <20260716133047.772246337@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andy Yan <andyshrk@163.com>

commit 9cff680e47632b7723cb19f9c5e63669063c3417 upstream.

VDO() second parameter is VDM type (bit 15): 1 for SVDM, 0 for UVDM.
Using 'vdo ? 2 : 1' corrupts SVID low bit when vdo is non-NULL
(2 << 15 = BIT(16)). Enter Mode is always SVDM, hardcode to 1.

Fixes: 8face9aa57c8 ("usb: typec: Add parameter for the VDO to typec_altmode_enter()")
Cc: stable <stable@kernel.org>
Signed-off-by: Andy Yan <andyshrk@163.com>
Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Link: https://patch.msgid.link/20260604105059.18750-1-andyshrk@163.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/typec/tcpm/tcpm.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/usb/typec/tcpm/tcpm.c
+++ b/drivers/usb/typec/tcpm/tcpm.c
@@ -3088,7 +3088,7 @@ static int tcpm_altmode_enter(struct typ
 	if (svdm_version < 0)
 		return svdm_version;
 
-	header = VDO(altmode->svid, vdo ? 2 : 1, svdm_version, CMD_ENTER_MODE);
+	header = VDO(altmode->svid, 1, svdm_version, CMD_ENTER_MODE);
 	header |= VDO_OPOS(altmode->mode);
 
 	return tcpm_queue_vdm_unlocked(port, header, vdo, vdo ? 1 : 0, TCPC_TX_SOP);
@@ -3136,7 +3136,7 @@ static int tcpm_cable_altmode_enter(stru
 	if (svdm_version < 0)
 		return svdm_version;
 
-	header = VDO(altmode->svid, vdo ? 2 : 1, svdm_version, CMD_ENTER_MODE);
+	header = VDO(altmode->svid, 1, svdm_version, CMD_ENTER_MODE);
 	header |= VDO_OPOS(altmode->mode);
 
 	return tcpm_queue_vdm_unlocked(port, header, vdo, vdo ? 1 : 0, TCPC_TX_SOP_PRIME);


