Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E5346AC2;
	Tue,  5 Dec 2023 03:22:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nZAh6UYT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81D96C433C7;
	Tue,  5 Dec 2023 03:22:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1701746578;
	bh=1pAiB+LGTsjTMfc/x6eZQcvPl8PyfhaB6g6jzJ8h0eI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nZAh6UYT0MzZic9/+abcXPo24nmNkSJZTHWFUCUkyeaT8GAtVpcTfAw5D/1EFjrFg
	 qatrEeNuZiAgA+wBULSNo1lupb3Mc36ijOvXVgJ5aP+WaZnYeM8KX/lt4JADSHTgot
	 JWtRmyzWs+xDNMZUS2FeO0tQFfDVt4z4LUBoONQ0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 077/134] media: v4l2-subdev: Fix a 64bit bug
Date: Tue,  5 Dec 2023 12:15:49 +0900
Message-ID: <20231205031540.367805187@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231205031535.163661217@linuxfoundation.org>
References: <20231205031535.163661217@linuxfoundation.org>
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

From: Dan Carpenter <dan.carpenter@linaro.org>

[ Upstream commit 5d33213fac5929a2e7766c88d78779fd443b0fe8 ]

The problem is this line here from subdev_do_ioctl().

        client_cap->capabilities &= ~V4L2_SUBDEV_CLIENT_CAP_STREAMS;

The "client_cap->capabilities" variable is a u64.  The AND operation
is supposed to clear out the V4L2_SUBDEV_CLIENT_CAP_STREAMS flag.  But
because it's a 32 bit variable it accidentally clears out the high 32
bits as well.

Currently we only use the first bit and none of the upper bits so this
doesn't affect runtime behavior.

Fixes: f57fa2959244 ("media: v4l2-subdev: Add new ioctl for client capabilities")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Reviewed-by: Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/uapi/linux/v4l2-subdev.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/uapi/linux/v4l2-subdev.h b/include/uapi/linux/v4l2-subdev.h
index 4a195b68f28f6..b383c2fe0cf35 100644
--- a/include/uapi/linux/v4l2-subdev.h
+++ b/include/uapi/linux/v4l2-subdev.h
@@ -239,7 +239,7 @@ struct v4l2_subdev_routing {
  * set (which is the default), the 'stream' fields will be forced to 0 by the
  * kernel.
  */
- #define V4L2_SUBDEV_CLIENT_CAP_STREAMS		(1U << 0)
+ #define V4L2_SUBDEV_CLIENT_CAP_STREAMS		(1ULL << 0)
 
 /**
  * struct v4l2_subdev_client_capability - Capabilities of the client accessing
-- 
2.42.0



