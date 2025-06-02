Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A806B239E6B;
	Mon,  2 Jun 2025 14:59:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748876356; cv=none; b=BX/aN5ZZvmMiCo2zSRmG0cdQStv5rZGeCPLDF7iO/4czWK17mYpwBePTQ1MdwHexHARFx8cfJC/MFpsbXDt/KVL1m2gaqwBi2kOo1HFwDtfLZn8uXytKBYY/4rPf7V5g0b4zN9aEU++xYcADmKtM8GHACAsNTtxnOkacLC9C/5Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748876356; c=relaxed/simple;
	bh=cnTpDVKZfSSjS5P5BzGwJMnWy0Fy4HJbpd9+Tz8BtTo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ktwCpUCm+0CYUTBsMySRRJ49zILhnFQjH5ibEmmCIUXspkTln7+8jpCN6inXTNu6+wzSZCX13KO42qWoTsSR+lZyubAAYg4BVHWncUyUSXBllERRq7zmxh2lwxp0aYkotiQvJ6w4heTh9FwE842KjLgC17OPiP8kF2ZnnA6Pe+0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jHdcEqcf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jHdcEqcf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A332EC4CEEB;
	Mon,  2 Jun 2025 14:59:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748876354;
	bh=cnTpDVKZfSSjS5P5BzGwJMnWy0Fy4HJbpd9+Tz8BtTo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jHdcEqcfWTzmzsBgQDDWOEx0WjedEx2BxlaTH8xZd3KkZOwErQ85PIE06EdXsD/XM
	 wbJyRyXHUPyCKGNhLOGwclDfI7N0XJDAyOB1CX5gkF30KtSIG7L7uqxEqd+6bl66DK
	 MSyS7I7Nybeid6YhBZciP/ROYcZ7+iI2EyqdvlcM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 120/207] media: v4l: Memset argument to 0 before calling get_mbus_config pad op
Date: Mon,  2 Jun 2025 15:48:12 +0200
Message-ID: <20250602134303.419675295@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134258.769974467@linuxfoundation.org>
References: <20250602134258.769974467@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sakari Ailus <sakari.ailus@linux.intel.com>

[ Upstream commit 91d6a99acfa5ce9f95ede775074b80f7193bd717 ]

Memset the config argument to get_mbus_config V4L2 sub-device pad
operation to zero before calling the operation. This ensures the callers
don't need to bother with it nor the implementations need to set all
fields that may not be relevant to them.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Reviewed-by: Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>
Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/v4l2-core/v4l2-subdev.c | 2 ++
 include/media/v4l2-subdev.h           | 4 +++-
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/media/v4l2-core/v4l2-subdev.c b/drivers/media/v4l2-core/v4l2-subdev.c
index 5d27a27cc2f24..6f2267625c7ea 100644
--- a/drivers/media/v4l2-core/v4l2-subdev.c
+++ b/drivers/media/v4l2-core/v4l2-subdev.c
@@ -314,6 +314,8 @@ static int call_enum_dv_timings(struct v4l2_subdev *sd,
 static int call_get_mbus_config(struct v4l2_subdev *sd, unsigned int pad,
 				struct v4l2_mbus_config *config)
 {
+	memset(config, 0, sizeof(*config));
+
 	return check_pad(sd, pad) ? :
 	       sd->ops->pad->get_mbus_config(sd, pad, config);
 }
diff --git a/include/media/v4l2-subdev.h b/include/media/v4l2-subdev.h
index 9a476f902c425..262b5e5cebc4c 100644
--- a/include/media/v4l2-subdev.h
+++ b/include/media/v4l2-subdev.h
@@ -714,7 +714,9 @@ struct v4l2_subdev_state {
  *		     possible configuration from the remote end, likely calling
  *		     this operation as close as possible to stream on time. The
  *		     operation shall fail if the pad index it has been called on
- *		     is not valid or in case of unrecoverable failures.
+ *		     is not valid or in case of unrecoverable failures. The
+ *		     config argument has been memset to 0 just before calling
+ *		     the op.
  *
  * @set_mbus_config: set the media bus configuration of a remote sub-device.
  *		     This operations is intended to allow, in combination with
-- 
2.39.5



