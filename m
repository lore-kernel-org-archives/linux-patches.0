Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73FD411710
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 15:20:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA83BC433C8;
	Mon, 11 Sep 2023 15:20:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694445623;
	bh=e3j76ZCMCaKrj+P8XJo1lfwvrRisVnhWNm6Dpej6KpQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QGJ0UlBJ5d7cvaBsj51J7w64+YfQA+nX4zdCHyF5isv1gCjnYT3xuHYsN6cc35T/6
	 M8Fk8gstv3wXsGTuZ9PhF3yJqmZCncLxK0fLF57vUgexGi1OFtCuDTbhB71+F3Xeq3
	 ey58JNlm9hi8DfuVHjwr9lJw8LfEgPtL7QR3rryc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	Ming Qian <ming.qian@nxp.com>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 413/600] media: amphion: ensure the bitops dont cross boundaries
Date: Mon, 11 Sep 2023 15:47:26 +0200
Message-ID: <20230911134645.865064469@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134633.619970489@linuxfoundation.org>
References: <20230911134633.619970489@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ming Qian <ming.qian@nxp.com>

[ Upstream commit 5bd28eae48589694ff4e5badb03bf75dae695b3f ]

the supported_instance_count determine the instance index range,
it shouldn't exceed the bits number of instance_mask,
otherwise the bitops of instance_mask may cross boundaries

Fixes: 9f599f351e86 ("media: amphion: add vpu core driver")
Reviewed-by: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Signed-off-by: Ming Qian <ming.qian@nxp.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/amphion/vpu_core.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/media/platform/amphion/vpu_core.c b/drivers/media/platform/amphion/vpu_core.c
index be80410682681..9add73b9b45f9 100644
--- a/drivers/media/platform/amphion/vpu_core.c
+++ b/drivers/media/platform/amphion/vpu_core.c
@@ -88,6 +88,8 @@ static int vpu_core_boot_done(struct vpu_core *core)
 
 		core->supported_instance_count = min(core->supported_instance_count, count);
 	}
+	if (core->supported_instance_count >= BITS_PER_TYPE(core->instance_mask))
+		core->supported_instance_count = BITS_PER_TYPE(core->instance_mask);
 	core->fw_version = fw_version;
 	vpu_core_set_state(core, VPU_CORE_ACTIVE);
 
-- 
2.40.1



