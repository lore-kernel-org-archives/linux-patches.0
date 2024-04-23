Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15311143889;
	Tue, 23 Apr 2024 21:43:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713908591; cv=none; b=CwYUq3NmXma5buuekoAiHK6L+Ti3AiNxYtCRQoPsBmY6jP1w500T1TlPg1s2BtnaXRRl0NaY/POQfyzraTe6r36zNl0W7Z/yz+yf6dQnWjbiwmUF9/42vNmm63MgoPovcncDpbHQe4YI+K3xphp0XCzMvBktt3CA27UZL8zEmxs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713908591; c=relaxed/simple;
	bh=Zo6C0NzIp4kzncTAnAH0pcT8HxFndaZgLA9sjmN9mCw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r2I9ugHfVqpk+2h3PFOv8vAPmkVDNFctMgnFptAQnAX2QUwnLqYYUEVTAO7U/KeKQ0IxsFvuvKBt8UVn8i1mPfYhcDNsZYXWl30sVyVWNh06vRSCzUMBt6bQS02xtbY4MP9wDSOp2z/JncxdK6moIIuyD8ZcQSKuXfgVcXxk+m8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e6ZI5x1r; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e6ZI5x1r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5459C3277B;
	Tue, 23 Apr 2024 21:43:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713908590;
	bh=Zo6C0NzIp4kzncTAnAH0pcT8HxFndaZgLA9sjmN9mCw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=e6ZI5x1ruRu799lK1QErAzekoEWd0Qq5pvyOUr0SnCAov3t9G37eQKimKoYL1t4AW
	 SEhhr9z7y+2oXklF3tj2e1u0HBL6+8a/GXiAQptD4tLv4aZfTt4x/+DG6M0/LK56LJ
	 hfVJWfFWC/7KgT6I4Iut++jD8M+k4l8/AmNeWQ9E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alvin Lee <alvin.lee2@amd.com>,
	Hamza Mahfooz <hamza.mahfooz@amd.com>,
	Dillon Varone <dillon.varone@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 016/158] drm/amd/display: Do not recursively call manual trigger programming
Date: Tue, 23 Apr 2024 14:37:33 -0700
Message-ID: <20240423213856.243448160@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240423213855.696477232@linuxfoundation.org>
References: <20240423213855.696477232@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dillon Varone <dillon.varone@amd.com>

[ Upstream commit 953927587f37b731abdeabe46ad44a3b3ec67a52 ]

[WHY&HOW]
We should not be recursively calling the manual trigger programming function when
FAMS is not in use.

Cc: stable@vger.kernel.org
Reviewed-by: Alvin Lee <alvin.lee2@amd.com>
Acked-by: Hamza Mahfooz <hamza.mahfooz@amd.com>
Signed-off-by: Dillon Varone <dillon.varone@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/dcn32/dcn32_optc.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dcn32/dcn32_optc.c b/drivers/gpu/drm/amd/display/dc/dcn32/dcn32_optc.c
index e817fa4efeee5..058dee76054ea 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn32/dcn32_optc.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn32/dcn32_optc.c
@@ -236,9 +236,6 @@ static void optc32_setup_manual_trigger(struct timing_generator *optc)
 				OTG_V_TOTAL_MAX_SEL, 1,
 				OTG_FORCE_LOCK_ON_EVENT, 0,
 				OTG_SET_V_TOTAL_MIN_MASK, (1 << 1)); /* TRIGA */
-
-		// Setup manual flow control for EOF via TRIG_A
-		optc->funcs->setup_manual_trigger(optc);
 	}
 }
 
-- 
2.43.0



