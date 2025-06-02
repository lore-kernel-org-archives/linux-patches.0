Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87667221F10;
	Mon,  2 Jun 2025 14:47:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748875658; cv=none; b=p0HDES+NDWsvRh/IfsX+3v8HtedAegv4eLMMCiqBxWOsfD0nkQLR5mfEG8Z/RyB66ftrOP+2WWXY1x9rTd6qZEH8OWV/Ze0w22p8nUX5aeq+nmmZULfnt/LrQwGnOSMAPyZXOtgAJdv7OwizYtEaY3X/iyOEV/G+x/xRCp2S8ck=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748875658; c=relaxed/simple;
	bh=XXKSI4YsTKBusbXPVHpky3Y5C7chFvZw2AdvYVPVR0c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OHMituBejeSYw/X6JkOAICWZ046JrR8gUJ+i6oFFFtmdETL1LkugYrn1+IZuFkm7xZdtXJi/2uu9BZD7rhl05BndG9o6hpBFS72AYWX5DB/ML/HmECsSInXO/PCHMbhH2IB2Tey6XUvyynSqqlL9SrygwZdPFwk+ky45LZ82yG0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Q2mCEhmR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q2mCEhmR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8C9CC4CEEB;
	Mon,  2 Jun 2025 14:47:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748875658;
	bh=XXKSI4YsTKBusbXPVHpky3Y5C7chFvZw2AdvYVPVR0c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Q2mCEhmRVpQe+WWYhBCYnWlF6+fzKO8GcfsehJ9Et70LPO7CNMKJ22xmyrgpViYL0
	 0b5CDU9dShkNWnVY6WtG1sGDfFsWCpXqH6/1/MNu7TOtCo0bcmFAEN+v+YPLDOfHGP
	 gT+/XQoeFXiCWi33tUpjZkKvBT8e4bdHM6YNrZPY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 204/270] media: v4l: Memset argument to 0 before calling get_mbus_config pad op
Date: Mon,  2 Jun 2025 15:48:09 +0200
Message-ID: <20250602134315.535773508@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134307.195171844@linuxfoundation.org>
References: <20250602134307.195171844@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index fbf0dcb313c82..67d3e6511a146 100644
--- a/drivers/media/v4l2-core/v4l2-subdev.c
+++ b/drivers/media/v4l2-core/v4l2-subdev.c
@@ -312,6 +312,8 @@ static int call_enum_dv_timings(struct v4l2_subdev *sd,
 static int call_get_mbus_config(struct v4l2_subdev *sd, unsigned int pad,
 				struct v4l2_mbus_config *config)
 {
+	memset(config, 0, sizeof(*config));
+
 	return check_pad(sd, pad) ? :
 	       sd->ops->pad->get_mbus_config(sd, pad, config);
 }
diff --git a/include/media/v4l2-subdev.h b/include/media/v4l2-subdev.h
index 73150520c02d4..ffc6d122f91e5 100644
--- a/include/media/v4l2-subdev.h
+++ b/include/media/v4l2-subdev.h
@@ -676,7 +676,9 @@ struct v4l2_subdev_pad_config {
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



