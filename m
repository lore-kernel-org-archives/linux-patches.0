Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 543272FD7DE;
	Tue, 26 Aug 2025 11:21:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756207313; cv=none; b=TGcAzm9Ub5BNY3ecZCXGWBSN6kUOhmklG2j3pEmx4ioArJBVon6AcsyIJnngR9OhH4A6kStmz3bMN6Rixuvad0dkScKxeUb3NeiRPNkEyYEkWl10mWoPd5GaITCWo6BrwfYJfszo6K6YuwE7l0V7KwUMAUaIv3ox46vT+jI1yy8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756207313; c=relaxed/simple;
	bh=DrmfzGLNWD5neFK87rMv2KULR2gD/QaytsF11i0Jf0Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qiMzMjiazL1gsO/28+Ky03+GR9VRp71loigaPHMA+gz70gipcmBaHsEgkCJvjm4cXfW6KPn41dMKfp8MKGUpE0eXVLqQmdjUYnWXdtxxBjj3Wg0XRlZpSHhM9aUIynCtR9Z53bfCrDrXd5zFz/IjLqe6rhYy38YHtqwct9kD34A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aHWfRYM7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aHWfRYM7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D98E8C4CEF1;
	Tue, 26 Aug 2025 11:21:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756207313;
	bh=DrmfzGLNWD5neFK87rMv2KULR2gD/QaytsF11i0Jf0Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aHWfRYM79A3tI7wSFxOIG0bJIcIh60lZYITsc1sfGtUJfc+zW1ZSEaMhqezx3o7y6
	 HKjG29KzWrdtVBZxR+QOSN5g94bzOKB6Zsv3MezKUncSbm4f3tp4mPDsrJltS1xmkS
	 XgavL8dxm2jX7FjlvuHpkGYrHJt9A9uzAqb6OoSQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 6.16 133/457] media: ipu6: isys: Use correct pads for xlate_streams()
Date: Tue, 26 Aug 2025 13:06:57 +0200
Message-ID: <20250826110940.660005102@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110937.289866482@linuxfoundation.org>
References: <20250826110937.289866482@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sakari Ailus <sakari.ailus@linux.intel.com>

commit ff49672a28f3a856717f09d61380e524e243121f upstream.

The pad argument to v4l2_subdev_state_xlate_streams() is incorrect, static
pad number is used for the source pad even though the pad number is
dependent on the stream. Fix it.

Fixes: 3a5c59ad926b ("media: ipu6: Rework CSI-2 sub-device streaming control")
Cc: stable@vger.kernel.org
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/pci/intel/ipu6/ipu6-isys-csi2.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/drivers/media/pci/intel/ipu6/ipu6-isys-csi2.c
+++ b/drivers/media/pci/intel/ipu6/ipu6-isys-csi2.c
@@ -354,9 +354,9 @@ static int ipu6_isys_csi2_enable_streams
 	remote_pad = media_pad_remote_pad_first(&sd->entity.pads[CSI2_PAD_SINK]);
 	remote_sd = media_entity_to_v4l2_subdev(remote_pad->entity);
 
-	sink_streams = v4l2_subdev_state_xlate_streams(state, CSI2_PAD_SRC,
-						       CSI2_PAD_SINK,
-						       &streams_mask);
+	sink_streams =
+		v4l2_subdev_state_xlate_streams(state, pad, CSI2_PAD_SINK,
+						&streams_mask);
 
 	ret = ipu6_isys_csi2_calc_timing(csi2, &timing, CSI2_ACCINV);
 	if (ret)
@@ -384,9 +384,9 @@ static int ipu6_isys_csi2_disable_stream
 	struct media_pad *remote_pad;
 	u64 sink_streams;
 
-	sink_streams = v4l2_subdev_state_xlate_streams(state, CSI2_PAD_SRC,
-						       CSI2_PAD_SINK,
-						       &streams_mask);
+	sink_streams =
+		v4l2_subdev_state_xlate_streams(state, pad, CSI2_PAD_SINK,
+						&streams_mask);
 
 	remote_pad = media_pad_remote_pad_first(&sd->entity.pads[CSI2_PAD_SINK]);
 	remote_sd = media_entity_to_v4l2_subdev(remote_pad->entity);


