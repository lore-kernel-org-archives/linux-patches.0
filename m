Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77556227E89;
	Mon,  2 Jun 2025 14:15:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748873740; cv=none; b=KRI7p7NngcOMA1Y/8bHptnzJs9EfeUvc4oVJocP814QHscZQQ6WGFnCFyVOhNohmF1nL7vxZIooPTPJwTHrXtxPC6u2MU2xR2GTvdvsLqfk5HDjnh0ntyyOiktLLxQnpiX5qwuhY99+iVOyigkRQKQn1xV4kdKDpWba165druoo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748873740; c=relaxed/simple;
	bh=001vTVtvNsY4xsygy0Qw8xoUJ2K/sl84uCVnjs+5aMY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MD4LOcox2HJCw/8Z+uALmd52PFjcEy6M2jGuLkBaCBQkiSY7oGfq1AKvcCTDi0trZEvnzyovDHnrFx3xkPtRyspn3PC4RWGnyNZZpYCxdkAbulPvE1h8LkHJn9cqCBph/OfiaagvPEwsQ0OTwqLdBYAxRMTiZ+jOTwiYXRDzC5g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GYkUWtWs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GYkUWtWs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D53FAC4CEEB;
	Mon,  2 Jun 2025 14:15:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748873740;
	bh=001vTVtvNsY4xsygy0Qw8xoUJ2K/sl84uCVnjs+5aMY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GYkUWtWsucwpVB0SnHBcAxGLbU5ziYG4yay5ekSFwzg/iD93R7elnZbmx9B0cS0BU
	 POlCIAk/fzAtyQ+6tioUdJFnsSXZbOM2c7rKLQEOJ+ZTYDVwMXEJSza8o36GieeMx7
	 L/QkUGiU1P3yU36/uHTS92ZDDtSao5MT20DAnznY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 234/444] media: v4l: Memset argument to 0 before calling get_mbus_config pad op
Date: Mon,  2 Jun 2025 15:44:58 +0200
Message-ID: <20250602134350.408921267@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134340.906731340@linuxfoundation.org>
References: <20250602134340.906731340@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 5f115438d0722..cb3ad72a3e54a 100644
--- a/drivers/media/v4l2-core/v4l2-subdev.c
+++ b/drivers/media/v4l2-core/v4l2-subdev.c
@@ -351,6 +351,8 @@ static int call_enum_dv_timings(struct v4l2_subdev *sd,
 static int call_get_mbus_config(struct v4l2_subdev *sd, unsigned int pad,
 				struct v4l2_mbus_config *config)
 {
+	memset(config, 0, sizeof(*config));
+
 	return check_pad(sd, pad) ? :
 	       sd->ops->pad->get_mbus_config(sd, pad, config);
 }
diff --git a/include/media/v4l2-subdev.h b/include/media/v4l2-subdev.h
index b4fcd0164048e..0740dfc6c0488 100644
--- a/include/media/v4l2-subdev.h
+++ b/include/media/v4l2-subdev.h
@@ -822,7 +822,9 @@ struct v4l2_subdev_state {
  *		     possible configuration from the remote end, likely calling
  *		     this operation as close as possible to stream on time. The
  *		     operation shall fail if the pad index it has been called on
- *		     is not valid or in case of unrecoverable failures.
+ *		     is not valid or in case of unrecoverable failures. The
+ *		     config argument has been memset to 0 just before calling
+ *		     the op.
  *
  * @set_routing: enable or disable data connection routes described in the
  *		 subdevice routing table.
-- 
2.39.5



