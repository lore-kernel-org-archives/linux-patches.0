Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E19835AC21
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:19:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302759; cv=none; b=s9plhAo1rJgumgxe5GLHwdpEGVUS6iXSDL/DGcJwLtCX2ywpDhWKDJ3xVPaNFejnhNXoDFLSQc2KGvL9EDDcoqPFsVhr7WXJ/jxtoOhdqU1n74+xpfOGkzoj4r72/MRwMPkv//PQAUiY+3I5YZcrbPp4AZMdl5EcSmjNai0iKNY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302759; c=relaxed/simple;
	bh=oq7zcYgp1/34AB0eS5Ys3skVkZ7F3ASe6ZKhwzBm1z0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QT2ZMwUdx/o+xJc6HeImBEIOs/y1m91KSZqXeIGdkYCCV6Hq0L7RmQ2JaS/f6DfNY+FbgthHgVk5hCol8ol3g5kRpMbGMx+UDYzJokVnuZd15pZvDIb6k7R69UpCpNxtqAtJrgcvs/TM9hAY1nH8AzdD+6Yd6+RVZhoMgczRZns=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ggtOGHCG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ggtOGHCG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3601C116D0;
	Sat, 28 Feb 2026 18:19:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302759;
	bh=oq7zcYgp1/34AB0eS5Ys3skVkZ7F3ASe6ZKhwzBm1z0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ggtOGHCGTR35nN/hvrYTEKl98YLlyRQELkE5Wvk4K939JeyWoUCPZVXpR7QL3DeiP
	 9pFSQ9YyL6/uME78olPAALXjcUVUa2CxPTCsJgqHqvNuw4xBMn/bro99ZcRSbekYKe
	 uZgKseyrPlaVU3OOaNiyLDrddf2zYKfwwby+TF+Hp9OlMDKjqdl/cb+mS/iXQjrDZ1
	 V00wowMifw0u5es0ASOurYc9rbJdaSyKfj99pyF12j/rtBMSsO5uOdO50Tb7Zv4wPH
	 aTb1CZJbqfpuC/odHSq7nfyxsHCxVdzsJ5uE8d08KGqiWg/ZvJJ3ZUEks6Vu3N+C6t
	 VPH0dX3Q0q0xQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Haotian Zhang <vulab@iscas.ac.cn>,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 129/147] mfd: arizona: Fix regulator resource leak on wm5102_clear_write_sequencer() failure
Date: Sat, 28 Feb 2026 13:17:17 -0500
Message-ID: <20260228181736.1605592-129-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181736.1605592-1-sashal@kernel.org>
References: <20260228181736.1605592-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Haotian Zhang <vulab@iscas.ac.cn>

[ Upstream commit 4feb753ba6e5e5bbaba868b841a2db41c21e56fa ]

The wm5102_clear_write_sequencer() helper may return an error
and just return, bypassing the cleanup sequence and causing
regulators to remain enabled, leading to a resource leak.

Change the direct return to jump to the err_reset label to
properly free the resources.

Fixes: 1c1c6bba57f5 ("mfd: wm5102: Ensure we always boot the device fully")
Signed-off-by: Haotian Zhang <vulab@iscas.ac.cn>
Reviewed-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Link: https://patch.msgid.link/20251214145804.2037-1-vulab@iscas.ac.cn
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mfd/arizona-core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mfd/arizona-core.c b/drivers/mfd/arizona-core.c
index afdc490836255..18f448fa33328 100644
--- a/drivers/mfd/arizona-core.c
+++ b/drivers/mfd/arizona-core.c
@@ -1150,7 +1150,7 @@ int arizona_dev_init(struct arizona *arizona)
 		} else if (val & 0x01) {
 			ret = wm5102_clear_write_sequencer(arizona);
 			if (ret)
-				return ret;
+				goto err_reset;
 		}
 		break;
 	default:
-- 
2.51.0

