Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5890F439F6F;
	Mon, 17 Aug 2026 13:41:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786974095; cv=none; b=Dvtg9B+DIH2UtCCfbCLZpOqwoI1PCNusuH59DdCFU7GYQXcXcUUVVwjYWeyEmGoyNZUJBr0GIdlFsgjPbUWIYPSB63co3GKHMUs6hQ8cUSCyHgdzAZMCqI8Pctjd30ULAx3GJtg0ZfA7ontAWQ0o26TAoP3rL3k/ivuqBjfsJwE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786974095; c=relaxed/simple;
	bh=T/GfSnULoswIn7+moinlXW1fLdVMTEnqpGvx4KXFsuE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MA8G2JC3YGzDuiy6EiDgBhDoHwSxGrh5pxjGRmKZqNF+GAmv6VRk4pkkHg2OJJ2kzVKCCooXIruvIW/f4tDbN/OXbQj36MteyfXLgj4YBDR+V6EybzcCBhOwsKrKjsEbIDNGrG64fFjC8JSDJzs9bpqQQmX6QGIqMbxSOcLxFrg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1I/GkVod; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1I/GkVod"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76A231F00A3A;
	Mon, 17 Aug 2026 13:41:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786974092;
	bh=h8dVp2D8s60wRdnm+Fy1p39LFXm8of/ZRFmD2xe+JuI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1I/GkVodc98EIlKNS36VisWZwaYKrUsWjwkExxmi3fVnRvwul5fZU4x39g6VHSnei
	 OPz9X3kUARrzN4l6R+edmbOLP6+avGItuRLNljRITYqcaEKoN1CW7Xly/z47IVZFyk
	 AWM+gU/+BUuriLF8lmuC6XCyrF9kqL0HEkn6xM3Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jijie Shao <shaojijie@huawei.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 036/271] net: hns3: fix speed configuration residue after driver reload
Date: Mon, 17 Aug 2026 15:29:21 +0200
Message-ID: <20260817132538.231565258@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132536.752504388@linuxfoundation.org>
References: <20260817132536.752504388@linuxfoundation.org>
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

From: Jijie Shao <shaojijie@huawei.com>

[ Upstream commit 3860d8748af315bfee6fe669fddc1fc17d3214db ]

After setting a 100G optical port to 40G via ethtool and reloading
the driver, the port remains at 40G instead of reverting to the
firmware default speed of 100G.

The commit referenced in Fixes: added two overwrites in
hclge_init_ae_dev() for non-copper media, so that optical ports
connected to forced-mode remotes inherit the firmware-preset
autoneg and speed instead of the hardcoded defaults:

  req_autoneg = mac.autoneg
  req_speed   = mac.speed         (when autoneg disabled)

The autoneg overwrite keeps existing behavior:
hclge_set_autoneg_speed_dup() already uses mac.autoneg (not
req_autoneg) since it was introduced, so autoneg inheritance from
firmware was already in place. This part is kept.

The speed overwrite, however, introduces the residue: mac.speed
reflects whatever was last programmed into the MAC, and after unload
firmware does not restore the MAC speed to the flash default. So if
the user changed speed via ethtool in a prior load, mac.speed still
carries that value on reload and req_speed inherits it.

Fix by dropping the req_speed overwrite only. req_speed keeps the
firmware default value set in hclge_configure() (cfg.default_speed),
so a reload reverts the speed to default, matching the expectation
that a driver reload resets link configuration.

Trade-off: on optical ports whose firmware default speed does not
match a forced-mode remote, reload now drops the link and the user
must re-apply ethtool configuration. This is acceptable: a driver
reload is expected to reset link configuration, not to inherit
runtime state from before unload. The autoneg inheritance is left
in place as established behavior; changing it is out of scope for
this patch and would itself be a user-perceivable behavior change.

Fixes: d9d349c4e8a0 ("net: hns3: differentiate autoneg default values between copper and fiber")
Signed-off-by: Jijie Shao <shaojijie@huawei.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20260724093036.426631-1-shaojijie@huawei.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index 2a6e4d17452c4..13c20a8ca3b0f 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -11926,12 +11926,8 @@ static int hclge_init_ae_dev(struct hnae3_ae_dev *ae_dev)
 	if (ret)
 		goto err_ptp_uninit;
 
-	if (hdev->hw.mac.media_type != HNAE3_MEDIA_TYPE_COPPER) {
+	if (hdev->hw.mac.media_type != HNAE3_MEDIA_TYPE_COPPER)
 		hdev->hw.mac.req_autoneg = hdev->hw.mac.autoneg;
-		if (hdev->hw.mac.autoneg == AUTONEG_DISABLE &&
-		    hdev->hw.mac.speed != SPEED_UNKNOWN)
-			hdev->hw.mac.req_speed = hdev->hw.mac.speed;
-	}
 
 	ret = hclge_set_autoneg_speed_dup(hdev);
 	if (ret) {
-- 
2.53.0



