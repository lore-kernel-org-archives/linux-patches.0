Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E668F348895
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:17:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302622; cv=none; b=gdguwWijrPbjlnW5OnB1XCec2DRpYZ87F3ly0LnYpWM43KG26DBhKs0e+cPYs/9cy21+8u5YMLra6VP03ETJRKmrWwGskU9l/iWCXhewUewCr69fUmd5/rSHCnDSQXqh0ryo54/GhWRuoJfUyII4iR5e4S6Dscyl+LxUFaSacaU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302622; c=relaxed/simple;
	bh=Rni0zafWb8LDJk+UNnd+Cy7NUhLGO9L2PbRcTVBXUyA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UeR/QsCdAI2DzE5VU1bzJMxgcCJgfJfCms5YzRdvx4/0vMTfQG/F38zGlzm+U8XMHqtF6SQ5GZdwUfRwBaqG04PE2dfSP+RoUmgPNAeLYK/u2GOs3Iv5wiEwq9VxHFBrK1tTO1/FCFkPvM8SbpzOHHJYGrjpOv+07tbgdeQjr+g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TT9ne80w; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TT9ne80w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3ED0EC19423;
	Sat, 28 Feb 2026 18:17:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302621;
	bh=Rni0zafWb8LDJk+UNnd+Cy7NUhLGO9L2PbRcTVBXUyA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TT9ne80woxtdjnvSvdDxU3jzFiwK7udftJy77bLVUnowULwja6jlauURe2Xy/4U8U
	 ALf77KYyv4Bd1DZD+i6ZRst5d3W1bT0gGqpGO446EAh7lww0jpdYKJU6rTdEWj06Kk
	 uXd2Ugj7SdtzIUURTm5Fdv/AeqXWzhAefQUrMq63/KIdd1NiSRbSJQ7oibgghxR1e4
	 imBpxzyjc3RyKvikLYraNV79LGj6hX7Hut62eLGB+euqVPDv7D95PWJcoL98iG7koR
	 ArcKJ4YT2XvofA/2vJfYWWI3UZd7XtS3i2dhE4/uFuKv2xEoU8+5UXMKOezinaXazU
	 2doufvjZ8XXGQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Haotian Zhang <vulab@iscas.ac.cn>,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 140/164] mfd: arizona: Fix regulator resource leak on wm5102_clear_write_sequencer() failure
Date: Sat, 28 Feb 2026 13:14:39 -0500
Message-ID: <20260228181505.1600663-140-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181505.1600663-1-sashal@kernel.org>
References: <20260228181505.1600663-1-sashal@kernel.org>
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
index 5c8317bd4d98b..6ec50eb1544c0 100644
--- a/drivers/mfd/arizona-core.c
+++ b/drivers/mfd/arizona-core.c
@@ -1119,7 +1119,7 @@ int arizona_dev_init(struct arizona *arizona)
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

