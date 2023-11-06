Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4C03208BD
	for <patches@lists.linux.dev>; Mon,  6 Nov 2023 13:17:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="l23HbCtW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FA58C433C7;
	Mon,  6 Nov 2023 13:17:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1699276673;
	bh=2d//Qaz4p5c2+aSnbskI+4H0kdku2Q/xbfpZS82mPkY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=l23HbCtW4GXvzAyXum9xNL0cTXWZNKqfrZSa/NBYZOw/HbuGww8+heARExH4jd7az
	 zLQg1mTmISUewM5Y76bIUHsghPexRgqgcTUkk5EAyW13pFvdZwOk7ZJjLloynkGbMI
	 1L1xUTA9zVKrmt4Pa9uBVu3KAi164kQH3icIYdaw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aric Cyr <aric.cyr@amd.com>,
	Tom Chung <chiahsuan.chung@amd.com>,
	Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 60/88] drm/amd/display: Dont use fsleep for PSR exit waits
Date: Mon,  6 Nov 2023 14:03:54 +0100
Message-ID: <20231106130308.007129877@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231106130305.772449722@linuxfoundation.org>
References: <20231106130305.772449722@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>

[ Upstream commit 79df45dc4bfb13d9bd3a75338b9d9dab948be3d6 ]

[Why]
These functions can be called from high IRQ levels and the OS will hang
if it tries to use a usleep_highres or a msleep.

[How]
Replace the fsleep with a udelay.

Reviewed-by: Aric Cyr <aric.cyr@amd.com>
Acked-by: Tom Chung <chiahsuan.chung@amd.com>
Signed-off-by: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/dce/dce_dmcu.c | 3 ++-
 drivers/gpu/drm/amd/display/dc/dce/dmub_psr.c | 3 ++-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dce/dce_dmcu.c b/drivers/gpu/drm/amd/display/dc/dce/dce_dmcu.c
index 63009db8b5a72..d156eeef466f9 100644
--- a/drivers/gpu/drm/amd/display/dc/dce/dce_dmcu.c
+++ b/drivers/gpu/drm/amd/display/dc/dce/dce_dmcu.c
@@ -586,7 +586,8 @@ static void dcn10_dmcu_set_psr_enable(struct dmcu *dmcu, bool enable, bool wait)
 				if (state == PSR_STATE0)
 					break;
 			}
-			fsleep(500);
+			/* must *not* be fsleep - this can be called from high irq levels */
+			udelay(500);
 		}
 
 		/* assert if max retry hit */
diff --git a/drivers/gpu/drm/amd/display/dc/dce/dmub_psr.c b/drivers/gpu/drm/amd/display/dc/dce/dmub_psr.c
index 0f24b6fbd2201..4704c9c85ee6f 100644
--- a/drivers/gpu/drm/amd/display/dc/dce/dmub_psr.c
+++ b/drivers/gpu/drm/amd/display/dc/dce/dmub_psr.c
@@ -216,7 +216,8 @@ static void dmub_psr_enable(struct dmub_psr *dmub, bool enable, bool wait, uint8
 					break;
 			}
 
-			fsleep(500);
+			/* must *not* be fsleep - this can be called from high irq levels */
+			udelay(500);
 		}
 
 		/* assert if max retry hit */
-- 
2.42.0



