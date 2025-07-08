Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17225289E2C;
	Tue,  8 Jul 2025 16:39:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751992756; cv=none; b=gkFcH1rZHgNqMRz42j1gmzBvlzpyUelyh6P6DLcssHUZtMppLaf7KR1i3vg60f+5jf0Of2S/IzNVX8uwXNLHJ/S7r375zx/2W/emp06oNjv8HyoB2UijzWoXvE8d1KargT2hMiAKPmlFddl/nedqXPQY66h8eNOT0LszhSs+03I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751992756; c=relaxed/simple;
	bh=mF5nWFaXI8mLA0dEi+Z5AWKOrphV3mkXFePeieqpa94=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bSz/OTdJss1kdkO5OaZNo3WbHj2RxL61oNPlTIp1U0qLriZmgTKOhNNsxdak4D169i5qLoSRe1NhuuW036C/OZii2npd/dCsKAgYISM0s5Q+BBfuJm4cGyZciz7HLnj26X9dUiIZMhNNlGH2Atbn5wAYJCD/xpmsdTdEfHBB4/4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x+P0547i; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x+P0547i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 910F6C4CEED;
	Tue,  8 Jul 2025 16:39:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751992756;
	bh=mF5nWFaXI8mLA0dEi+Z5AWKOrphV3mkXFePeieqpa94=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=x+P0547iF3HonaED6hWofgCZOzuB5XMizyf02U1mAcNzcHYuTc4fGdAPYYNF5+IGO
	 c+RRfW4spI+c3E/SnYLXAbwqWfsK7XUZNCbkgC7tk7YAcxUEA7hBvlSEsZf7May83m
	 XaOmYsFUksAiVnXr3Xqm+It71csjFmj1FNQf1lw0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	jackysliu <1972843537@qq.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 039/232] scsi: sd: Fix VPD page 0xb7 length check
Date: Tue,  8 Jul 2025 18:20:35 +0200
Message-ID: <20250708162242.452693560@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162241.426806072@linuxfoundation.org>
References: <20250708162241.426806072@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: jackysliu <1972843537@qq.com>

[ Upstream commit 8889676cd62161896f1d861ce294adc29c4f2cb5 ]

sd_read_block_limits_ext() currently assumes that vpd->len excludes the
size of the page header. However, vpd->len describes the size of the entire
VPD page, therefore the sanity check is incorrect.

In practice this is not really a problem since we don't attach VPD
pages unless they actually report data trailing the header. But fix
the length check regardless.

This issue was identified by Wukong-Agent (formerly Tencent Woodpecker), a
code security AI agent, through static code analysis.

[mkp: rewrote patch description]

Signed-off-by: jackysliu <1972843537@qq.com>
Link: https://lore.kernel.org/r/tencent_ADA5210D1317EEB6CD7F3DE9FE9DA4591D05@qq.com
Fixes: 96b171d6dba6 ("scsi: core: Query the Block Limits Extension VPD page")
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/sd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 8947dab132d78..86dde3e7debba 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -3388,7 +3388,7 @@ static void sd_read_block_limits_ext(struct scsi_disk *sdkp)
 
 	rcu_read_lock();
 	vpd = rcu_dereference(sdkp->device->vpd_pgb7);
-	if (vpd && vpd->len >= 2)
+	if (vpd && vpd->len >= 6)
 		sdkp->rscs = vpd->data[5] & 1;
 	rcu_read_unlock();
 }
-- 
2.39.5



