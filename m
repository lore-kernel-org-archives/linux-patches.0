Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8092D17727;
	Mon, 27 May 2024 19:33:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716838429; cv=none; b=YLhOUCmgMTCqdF/zivUWJkaAB9Z5Y0nclqRuuF93wqG+jbYomT5C48xziJc5S75garY00imuPwYh2O9Ajzxsy2kRujMIuNI6wfHL+eED6Loa+MQxfWjNtzNgJheIkSLZeQZHwPIjkySa3hUAnhvxAScD2AcTSfqWSddfftHK+sw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716838429; c=relaxed/simple;
	bh=jYkfDHL+DZeptSTQ1QstqIpBot1Xq/2+TUhKMMN75MY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rq7Bugn047ET4cVtpM6neJ1aDbCBiYSfNSY2yrvF4nucwx95wZ9mr5SHBJlYk7k0sRuM0FC2QQd211/07cQspDJF/GyErZ9jpzPioLBj+tRb3aISpdJ/ik4SY8z3eP6cP2FMgBRxX/4LIBF+CC4WG0c8Tr9suGZFxqkIBFbLV6k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=amMFKJ1V; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="amMFKJ1V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 177D1C2BBFC;
	Mon, 27 May 2024 19:33:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716838429;
	bh=jYkfDHL+DZeptSTQ1QstqIpBot1Xq/2+TUhKMMN75MY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=amMFKJ1VdF0xWm2ex20nfm/i6X9d133Gjl5kwngKkd97XQNoZqB6FtZOHub36zDVr
	 PIKFhm3MEwu+Vvn/GEuI5YJETqaFzp+mdn+MpfP+/nV3IIgPdyT076rFF9IucXyvKH
	 OChZUrqG8qz/NKDVlS0VknIn7dHrYFKBNBbSjyus=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Changhuang Liang <changhuang.liang@starfivetech.com>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 388/493] staging: media: starfive: Remove links when unregistering devices
Date: Mon, 27 May 2024 20:56:30 +0200
Message-ID: <20240527185642.951608261@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185626.546110716@linuxfoundation.org>
References: <20240527185626.546110716@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Changhuang Liang <changhuang.liang@starfivetech.com>

[ Upstream commit 810dd605e917c716f6f83e6cd8ea23d9155d32a2 ]

Need to remove links when unregistering devices.

Fixes: ac7da4a73b10 ("media: staging: media: starfive: camss: Register devices")

Signed-off-by: Changhuang Liang <changhuang.liang@starfivetech.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/media/starfive/camss/stf-camss.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/staging/media/starfive/camss/stf-camss.c b/drivers/staging/media/starfive/camss/stf-camss.c
index a587f860101ae..323aa70fdeaf1 100644
--- a/drivers/staging/media/starfive/camss/stf-camss.c
+++ b/drivers/staging/media/starfive/camss/stf-camss.c
@@ -162,6 +162,12 @@ static int stfcamss_register_devs(struct stfcamss *stfcamss)
 
 static void stfcamss_unregister_devs(struct stfcamss *stfcamss)
 {
+	struct stf_capture *cap_yuv = &stfcamss->captures[STF_CAPTURE_YUV];
+	struct stf_isp_dev *isp_dev = &stfcamss->isp_dev;
+
+	media_entity_remove_links(&isp_dev->subdev.entity);
+	media_entity_remove_links(&cap_yuv->video.vdev.entity);
+
 	stf_isp_unregister(&stfcamss->isp_dev);
 	stf_capture_unregister(stfcamss);
 }
-- 
2.43.0



