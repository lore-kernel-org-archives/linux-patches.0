Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2ABA1446CB
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 22:03:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yhtArVcV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CED10C433C7;
	Wed, 15 Nov 2023 22:03:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700085826;
	bh=Zu5WmmukpgPT1LuYPvwFYJkezLN2SQ/Y+a1jbNCUdJI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yhtArVcV2cyOsjAG06hoDUDR7RNzjkHVIKfE4ngAd66RSSxa04yAhwwCJBYv8ZKs8
	 FRwvlYTFqcAB9qFIPMFsgrtuK1lWjnzuPmtqrXiLdZt13dQn50mhjBhVSMsC8dI5t3
	 fq93I7sX8rUzRJod3zuU/S84T0q9YTp8I+PFLQqg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konstantin Meskhidze <konstantin.meskhidze@huawei.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>,
	Ivanov Mikhail <ivanov.mikhail1@huawei-partners.com>
Subject: [PATCH 5.4 041/119] drm/radeon: possible buffer overflow
Date: Wed, 15 Nov 2023 17:00:31 -0500
Message-ID: <20231115220133.906240598@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115220132.607437515@linuxfoundation.org>
References: <20231115220132.607437515@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Konstantin Meskhidze <konstantin.meskhidze@huawei.com>

[ Upstream commit dd05484f99d16715a88eedfca363828ef9a4c2d4 ]

Buffer 'afmt_status' of size 6 could overflow, since index 'afmt_idx' is
checked after access.

Fixes: 5cc4e5fc293b ("drm/radeon: Cleanup HDMI audio interrupt handling for evergreen")
Co-developed-by: Ivanov Mikhail <ivanov.mikhail1@huawei-partners.com>
Signed-off-by: Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/radeon/evergreen.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/radeon/evergreen.c b/drivers/gpu/drm/radeon/evergreen.c
index 1d978a3d9c828..2156590c3d159 100644
--- a/drivers/gpu/drm/radeon/evergreen.c
+++ b/drivers/gpu/drm/radeon/evergreen.c
@@ -4819,14 +4819,15 @@ int evergreen_irq_process(struct radeon_device *rdev)
 			break;
 		case 44: /* hdmi */
 			afmt_idx = src_data;
-			if (!(afmt_status[afmt_idx] & AFMT_AZ_FORMAT_WTRIG))
-				DRM_DEBUG("IH: IH event w/o asserted irq bit?\n");
-
 			if (afmt_idx > 5) {
 				DRM_ERROR("Unhandled interrupt: %d %d\n",
 					  src_id, src_data);
 				break;
 			}
+
+			if (!(afmt_status[afmt_idx] & AFMT_AZ_FORMAT_WTRIG))
+				DRM_DEBUG("IH: IH event w/o asserted irq bit?\n");
+
 			afmt_status[afmt_idx] &= ~AFMT_AZ_FORMAT_WTRIG;
 			queue_hdmi = true;
 			DRM_DEBUG("IH: HDMI%d\n", afmt_idx + 1);
-- 
2.42.0



