Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FF8A42A9B;
	Tue, 27 May 2025 17:42:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748367729; cv=none; b=jyNnhFz//oVmNXi/eU4SQx5IkYukeTJTdkDzX8C797p+7C2dTE6ABHku6IepO+sbbtZae3EjS28Q6L+HOF9CzFpvGeEN75LteIZ17+OzwbGLnzSVvzsm4Rb6rzCylgwYK0A5FF0QQ8Aq5BFp2OEbkska57eSffwsAhrtP/tUmQk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748367729; c=relaxed/simple;
	bh=8Vcc/uc9I1RWE9PvSKsZmxMXvRHHqfsLRJatc5W8uWE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qZ9tY/nE6LH9XR48mzKiniS4DWCQBvNBccuJ6+gXVDkWCIy+qb4UP+EqqbhWdAj2PEw3Fk+RMzz9nS3/eegcH08x/bOqbirI9x+Sc6nBIfQS8e9q7zZFvVkMukqXCA3VRgrOU2i+uSOftzBrM+GC0zlgE0htXAQDhDL3oQ8DP+Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=y+APiAsc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="y+APiAsc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AD2BC4CEE9;
	Tue, 27 May 2025 17:42:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748367728;
	bh=8Vcc/uc9I1RWE9PvSKsZmxMXvRHHqfsLRJatc5W8uWE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=y+APiAscC5/6mOFOYzJSWXQp6PMJuh2EVj7t06eKg5QYPX1prEP/njPstz9V+Moc+
	 8SGn8fHyYUiN0bH1blZbC/rTbTnLUnH+ChsSQ5BOADLz1dMxzdVy4LQy+ptVrNIo6q
	 YTx2mYHY1SBQ7HIIMlmk1Fe0G6du4xKLFESVfLs4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 450/783] media: v4l: Memset argument to 0 before calling get_mbus_config pad op
Date: Tue, 27 May 2025 18:24:07 +0200
Message-ID: <20250527162531.452535547@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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
index cde1774c9098d..a3074f469b150 100644
--- a/drivers/media/v4l2-core/v4l2-subdev.c
+++ b/drivers/media/v4l2-core/v4l2-subdev.c
@@ -444,6 +444,8 @@ static int call_enum_dv_timings(struct v4l2_subdev *sd,
 static int call_get_mbus_config(struct v4l2_subdev *sd, unsigned int pad,
 				struct v4l2_mbus_config *config)
 {
+	memset(config, 0, sizeof(*config));
+
 	return check_pad(sd, pad) ? :
 	       sd->ops->pad->get_mbus_config(sd, pad, config);
 }
diff --git a/include/media/v4l2-subdev.h b/include/media/v4l2-subdev.h
index 2f2200875b038..57f2bcb4eb16c 100644
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
  * @set_routing: Enable or disable data connection routes described in the
  *		 subdevice routing table. Subdevs that implement this operation
-- 
2.39.5



