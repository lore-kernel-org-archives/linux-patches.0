Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D81C393DD1;
	Tue, 26 Aug 2025 11:40:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756208415; cv=none; b=lWT0Nsk0E5wGfHk5CtGjBkvWKJRNSGkce6742XrHuIQZHWlYpRifB4ovnpCnnfENzPRl1t/TC9hk/c2iOG9mZRdyztkwH+QB/zfDmJYf5AFHyuYRfMAad8SZTrmi7yOwKZAPOxQlzf91MbxjCN56wRGn3rOT1CkFXtsRxnratDA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756208415; c=relaxed/simple;
	bh=bWAnAXfEDWa7l1d56u5HtxITqnu4soxigcoYy5DngKU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mqASQO6eZzZZwXsVUgANQfou7Gpd9IZY53PKmz2txN5OP6coeuyexsSiwX6Pbpyssj24PDy7a1K6rLBOochbW/xrzo8mbko5a2OcfM47j/xPdXumJVb1Qe1EupPLgnu8tRER+l5dGyOioxdOny0resJaRbAUeiINAwkTWADbJ+0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=R3P/Y7MG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="R3P/Y7MG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8727C4CEF1;
	Tue, 26 Aug 2025 11:40:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756208415;
	bh=bWAnAXfEDWa7l1d56u5HtxITqnu4soxigcoYy5DngKU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=R3P/Y7MG+UtV3Q2ZdSirS86IfVhg/0dLYBpBvexO5FNxicdy2rWcjJt8NYPx5WRfg
	 YJTbYzLmiyPJ2kEw/zvaCZz7owh0rH+YCJcNvhiEDgsvNrt6zXlQoybcvmyPeY8M3r
	 VfSfEaHuKql4eKWoEQPsF1+mq2SS18TxqHT27Z9A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 6.12 101/322] media: ipu6: isys: Use correct pads for xlate_streams()
Date: Tue, 26 Aug 2025 13:08:36 +0200
Message-ID: <20250826110918.204054789@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110915.169062587@linuxfoundation.org>
References: <20250826110915.169062587@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -360,9 +360,9 @@ static int ipu6_isys_csi2_enable_streams
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
@@ -390,9 +390,9 @@ static int ipu6_isys_csi2_disable_stream
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


