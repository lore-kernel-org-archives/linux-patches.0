Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B06B230DEA9;
	Wed,  3 Dec 2025 15:33:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764776008; cv=none; b=kP9n+qyrtfWfKnPE6LgDREudAJeox2MVJoQaN2IvCBHdjKDLm02Ga60c28T7emJGfEDMP6K/GWVsx5LT6tAiAZZ2Nkv/ImClLv9Z9SeDbjEFTv5nFQCAqV6Ei5cL0+0fahKmH4bINO91tJcgh27RSZi2iNtK5yWZvP+fGcxwGgE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764776008; c=relaxed/simple;
	bh=Sbh/F/TnncdyEIBJwbhSJjj0mpr8wXeipw4HTi1cQ60=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fYUq8CcZGD3D2gFzOnZ1OiY/oiSZPPTNIMSxXxruiEaFSezZ5VZKHAEGAOUWjRmlB8r65piokUBG7W6U682jNRuDqgTyTbEekfARariKKLFbX+iVNumxF9QM6Dl512RiFFrY96IximH++LkeeJJbptLT0JKJJM4bkfGgvMohhBs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2Yw8lDpZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2Yw8lDpZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09164C4CEF5;
	Wed,  3 Dec 2025 15:33:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764776008;
	bh=Sbh/F/TnncdyEIBJwbhSJjj0mpr8wXeipw4HTi1cQ60=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2Yw8lDpZRYmgHt7jWfzfXWyqZsb5FmdwU7jkkZ/4R/JjYuT9TWi2Ku1Ai/PCVbu1W
	 y+2h6xvV21L8lHM5G6JREABBSl17bau29qjfbDYdwUdWy86CqxqIc0mlm/KNxEf1+9
	 lv2TA1Ua2reyeSdB9HV/LD4Jw4qx8S6/7JLo6kdk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sumit Garg <sumit.garg@oss.qualcomm.com>,
	Amirreza Zarrabi <amirreza.zarrabi@oss.qualcomm.com>,
	Jens Wiklander <jens.wiklander@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 053/300] tee: allow a driver to allocate a tee_device without a pool
Date: Wed,  3 Dec 2025 16:24:17 +0100
Message-ID: <20251203152402.586156364@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152400.447697997@linuxfoundation.org>
References: <20251203152400.447697997@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Amirreza Zarrabi <amirreza.zarrabi@oss.qualcomm.com>

[ Upstream commit 6dbcd5a9ab6cb6644e7d728521da1c9035ec7235 ]

A TEE driver doesn't always need to provide a pool if it doesn't
support memory sharing ioctls and can allocate memory for TEE
messages in another way. Although this is mentioned in the
documentation for tee_device_alloc(), it is not handled correctly.

Reviewed-by: Sumit Garg <sumit.garg@oss.qualcomm.com>
Signed-off-by: Amirreza Zarrabi <amirreza.zarrabi@oss.qualcomm.com>
Signed-off-by: Jens Wiklander <jens.wiklander@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tee/tee_core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/tee/tee_core.c b/drivers/tee/tee_core.c
index e6de0e80b793e..7f205464a0c7a 100644
--- a/drivers/tee/tee_core.c
+++ b/drivers/tee/tee_core.c
@@ -894,7 +894,7 @@ struct tee_device *tee_device_alloc(const struct tee_desc *teedesc,
 
 	if (!teedesc || !teedesc->name || !teedesc->ops ||
 	    !teedesc->ops->get_version || !teedesc->ops->open ||
-	    !teedesc->ops->release || !pool)
+	    !teedesc->ops->release)
 		return ERR_PTR(-EINVAL);
 
 	teedev = kzalloc(sizeof(*teedev), GFP_KERNEL);
-- 
2.51.0



