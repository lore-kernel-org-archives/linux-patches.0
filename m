Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 281E0194A45;
	Thu,  5 Sep 2024 09:51:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725529866; cv=none; b=smIwCVSuLPwv0l8Gy29cV4MiKqX3ABoaq/uOzVxT9mlzJ5ta+vQw776pogTTn9R+n7aGCb9JAM9od2+nJkwH+6zR9g22cT9Id0KHpdPb22QAWNSt858K50qTmYJkDWihaiYJsjCYhkQVprAIkhnx7TeVloVLOYqAX52RbRxkTpA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725529866; c=relaxed/simple;
	bh=XaUCuh/vXbuH4AbV5XVy+yygCm9nPJGx2VYm3wEE5cM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZK70lZwXWPlvuoP4DCMpRzPcSw22bWHkwjamQb7KGBCpTOSToyZAIG7XPUNy+ZWfSRW18ywyYfNTRQUX5yP+iakcZqgcpSBF4gVPCi6cn7yjO/7Pqk/9YYRCp7FHbm1JGFhqMov/JOP4nsBlaAgOwn5GCAvTzmviTPBSna9PsLQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SKrGGY7z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SKrGGY7z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 550B2C4CEC3;
	Thu,  5 Sep 2024 09:51:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725529865;
	bh=XaUCuh/vXbuH4AbV5XVy+yygCm9nPJGx2VYm3wEE5cM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SKrGGY7zu6KfuqBgy6jeM3NgKzBkMq+xMBjgAZEufzAc35AW5OayblG66qi7dP0jz
	 AQnmGaXrn7ov0j2TCXb/8gZEkYDc8EbQHLS0uNGiCv9bD6CxganarRyP8Bu/3lLk+6
	 eA/DyaPG0zs7F4AEjk8JjnCuuZ3khxEMxws8BYE8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>,
	Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 167/184] drm/amd/display: Dont use fsleep for PSR exit waits on dmub replay
Date: Thu,  5 Sep 2024 11:41:20 +0200
Message-ID: <20240905093738.858560409@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240905093732.239411633@linuxfoundation.org>
References: <20240905093732.239411633@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>

[ Upstream commit b5236da757adc75d7e52c69bdc233d29249a0d0c ]

[Why]
These functions can be called from high IRQ levels and the OS will hang
if it tries to use a usleep_highres or a msleep.

[How]
Replace the flseep with a udelay for dmub_replay_enable.

Reviewed-by: Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>
Signed-off-by: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/dce/dmub_replay.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dce/dmub_replay.c b/drivers/gpu/drm/amd/display/dc/dce/dmub_replay.c
index 09cf54586fd5..424669632b3b 100644
--- a/drivers/gpu/drm/amd/display/dc/dce/dmub_replay.c
+++ b/drivers/gpu/drm/amd/display/dc/dce/dmub_replay.c
@@ -102,7 +102,8 @@ static void dmub_replay_enable(struct dmub_replay *dmub, bool enable, bool wait,
 					break;
 			}
 
-			fsleep(500);
+			/* must *not* be fsleep - this can be called from high irq levels */
+			udelay(500);
 		}
 
 		/* assert if max retry hit */
-- 
2.43.0



