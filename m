Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E57192D9787;
	Thu, 28 May 2026 20:26:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779999968; cv=none; b=MYGyPljstcbQa1o2P84JXh4RuaDRh8jKI+ZQ0/3XZvLSgvy4rUQB0iWCUcCwW0XVOKaL930nx3oFEUtKiU6oNEefx+E/uQ0BcLCdd+TVosnQTZWbNtW2wPfsKurAApCGB1S0Mt487maf+pe4PDypGOtzeKXwQ29x+cEXwO/ISw0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779999968; c=relaxed/simple;
	bh=EACOPkse2PgBzHOCkVsDmA6g5YMJjXYPXd5hveiID6w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d1gtCiq81LW415Gc3yW4qdZCWkoUVPMAQGPWzNxM4gjaJaehBUGcYm96EC14bm8Bj7vd0TbZiseS7T1TAxdXvi+dbBV6a+R8HSQFhDCBM2Up+EroLlKFXgKg/TEfNwV3qqOAYX4aeo26l1rR0gQskr5l0S49VbvPtzUkqw1K65c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qb8hdoZ5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qb8hdoZ5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CCF11F00A3D;
	Thu, 28 May 2026 20:26:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779999967;
	bh=s81RKmnKEfVyYz7Dq1B4BaYWuFxmdoEBSUekn2kxmsU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qb8hdoZ5MwjnUCgDsg3qa+LOSgkGc3j3TZenEHCf8H4SVxbLNqXWO+NaExgKFMBVh
	 +Z6IZXIxF+hKtlaFj4TCR6vvy717qlh/w5vlAK9SuDrEnA5oJ7izWqz7cdvu/9sZ+n
	 JxQSDNYbg8ygtI0INhnAU/RQ/zg6ZGi0PR+K1hAg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolas Escande <nico.escande@gmail.com>,
	Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
	Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 255/377] wifi: ath11k: fix error path leak in ath11k_tm_cmd_wmi_ftm()
Date: Thu, 28 May 2026 21:48:13 +0200
Message-ID: <20260528194645.756924135@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194638.371537336@linuxfoundation.org>
References: <20260528194638.371537336@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nicolas Escande <nico.escande@gmail.com>

[ Upstream commit 7320d6eb861e9913193a7801834c661381756a79 ]

This is similar to what was fixed by previous patches. We have a call
to ath11k_wmi_cmd_send() which does check the return value, but forgot
to free the related skb on error.

Fixes: b43310e44edc ("wifi: ath11k: factory test mode support")
Signed-off-by: Nicolas Escande <nico.escande@gmail.com>
Reviewed-by: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Reviewed-by: Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>
Link: https://patch.msgid.link/20260506134240.2284016-4-nico.escande@gmail.com
Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath11k/testmode.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/ath/ath11k/testmode.c b/drivers/net/wireless/ath/ath11k/testmode.c
index a9751ea2a0b73..c72eed358f6dd 100644
--- a/drivers/net/wireless/ath/ath11k/testmode.c
+++ b/drivers/net/wireless/ath/ath11k/testmode.c
@@ -457,6 +457,7 @@ static int ath11k_tm_cmd_wmi_ftm(struct ath11k *ar, struct nlattr *tb[])
 		ret = ath11k_wmi_cmd_send(wmi, skb, cmd_id);
 		if (ret) {
 			ath11k_warn(ar->ab, "failed to send wmi ftm command: %d\n", ret);
+			dev_kfree_skb(skb);
 			goto out;
 		}
 
-- 
2.53.0



