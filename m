Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81AC93043B2;
	Wed, 28 Jan 2026 15:50:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769615451; cv=none; b=VJk28Rh2fSVishC5BvARcBEgXo9vXOskwVaEFp5ScNYzArtWg8sMZvGVz0vbP0BsZoVCEHUKhgUJQAEh+1R2sVRdvw6V5RRo0RCr8gaGlC4H0eAacUlLzzp5vyjVodBi8pCkIKihSPw7iI+Kpu0b/kE8BJJ9VX528bIE1YLE8wA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769615451; c=relaxed/simple;
	bh=GOD7g6JJilfpmTacC5mR1JJLK53pBl0ZRJZSBQlNPFI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VQDdzYpusfA/yDHd0o1GLdneezQ7DKroUfw7wjnGHJUaRomuCVVOpCd+XqWBAhw03JblohqaaFWe1Qkig8D4RE08z+5VIHeCAVEMTCl/J5UC2ZHJoc/qtFSRqOI2yVGfd5ljv4wBB1a3SbBVE3onXW2UuzCzoz98qnuEQuX+cgI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BEQKt3HF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BEQKt3HF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6F6CC4CEF1;
	Wed, 28 Jan 2026 15:50:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769615451;
	bh=GOD7g6JJilfpmTacC5mR1JJLK53pBl0ZRJZSBQlNPFI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BEQKt3HFbN8oDkb/cwGZOQgcQfYf/ad0yizDXQyqVyJeJ5lMurderBjsdnO5B78dj
	 d4ORjMHWY206+zqglt0GhtNAA7NmVeB4GTo5ZnFojnaU87aKBrqQh7yaumPs+x99cy
	 AR3vvylarW9GjzjRJscabCoPSe19aRaWRbnEUHo4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Niklas Cassel <cassel@kernel.org>,
	Wolf <wolf@yoxt.cc>,
	Damien Le Moal <dlemoal@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 014/227] ata: libata: Add cpr_log to ata_dev_print_features() early return
Date: Wed, 28 Jan 2026 16:20:59 +0100
Message-ID: <20260128145344.856392953@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260128145344.331957407@linuxfoundation.org>
References: <20260128145344.331957407@linuxfoundation.org>
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

From: Niklas Cassel <cassel@kernel.org>

[ Upstream commit a6bee5e5243ad02cae575becc4c83df66fc29573 ]

ata_dev_print_features() is supposed to return early and not print anything
if there are no features supported.

However, commit fe22e1c2f705 ("libata: support concurrent positioning
ranges log") added another feature to ata_dev_print_features() without
updating the early return conditional.

Add the missing feature to the early return conditional.

Fixes: fe22e1c2f705 ("libata: support concurrent positioning ranges log")
Signed-off-by: Niklas Cassel <cassel@kernel.org>
Tested-by: Wolf <wolf@yoxt.cc>
Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ata/libata-core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 0a21804b133a4..490cc0d628d3b 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -2872,7 +2872,7 @@ static void ata_dev_config_lpm(struct ata_device *dev)
 
 static void ata_dev_print_features(struct ata_device *dev)
 {
-	if (!(dev->flags & ATA_DFLAG_FEATURES_MASK))
+	if (!(dev->flags & ATA_DFLAG_FEATURES_MASK) && !dev->cpr_log)
 		return;
 
 	ata_dev_info(dev,
-- 
2.51.0



