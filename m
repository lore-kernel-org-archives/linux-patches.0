Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6F11289811;
	Fri, 17 Oct 2025 15:19:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760714345; cv=none; b=UVKGFhM+8lQPpldMa4SnK2X++7d5rUEtGPWtfFAhIV3mPnNL+/PFtQDZzbgIIFk2QEZ75SCScPBkLUeew4bO18imp6PAlZrslp9X1inleYU+/fQZHAIPuiI1GKlaLoLHKUIvddBKyN9ayZyAdmts7pBitNIHEfQb/7+1kDyg5bY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760714345; c=relaxed/simple;
	bh=oS+/O6Qlndr3JyLI6Uj8mZbOUt0exAYvhfw8zyfsNfE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d7d+RWOe1ZZS8E/u5qdmux/95BIJ0Ec39vcuj194tEiNGCZnsNpvPvzADjvcUl4OdZboAxUgp73bzUP4iFgpJDC89TZcROY6bZcm5qmL6dxaxmmy0PppoqYdw9OHuwmhrnbvFRXprfb7JkanlUCTa88t7LxWETDvCESDfkR9L1k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1ymWV4Oa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1ymWV4Oa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C333C4CEE7;
	Fri, 17 Oct 2025 15:19:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760714344;
	bh=oS+/O6Qlndr3JyLI6Uj8mZbOUt0exAYvhfw8zyfsNfE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1ymWV4OaRo0ZHYHcuemiIOhblLDCyfiGRBVjqCOsd/6S9P2VbGdtllVHLCys+i31T
	 RazEo4lZEhh61h02CcwfknYCqJOmk6C6l7i5HIM3oFOGx0Fo0dk5bw012abJxgBhv9
	 JZNk0qbE8TMsMXw90EQ6xpLLY79YQqls+DKIOjVw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Devarsh Thakkar <devarsht@ti.com>,
	Jai Luthra <jai.luthra@ideasonboard.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Yemike Abhilash Chandra <y-abhilashchandra@ti.com>
Subject: [PATCH 6.12 113/277] media: ti: j721e-csi2rx: Fix source subdev link creation
Date: Fri, 17 Oct 2025 16:52:00 +0200
Message-ID: <20251017145151.252921941@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145147.138822285@linuxfoundation.org>
References: <20251017145147.138822285@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jai Luthra <jai.luthra@ideasonboard.com>

commit 3e743cd0a73246219da117ee99061aad51c4748c upstream.

We don't use OF ports and remote-endpoints to connect the CSI2RX bridge
and this device in the device tree, thus it is wrong to use
v4l2_create_fwnode_links_to_pad() to create the media graph link between
the two.

It works out on accident, as neither the source nor the sink implement
the .get_fwnode_pad() callback, and the framework helper falls back on
using the first source and sink pads to create the link between them.

Instead, manually create the media link from the first source pad of the
bridge to the first sink pad of the J721E CSI2RX.

Fixes: b4a3d877dc92 ("media: ti: Add CSI2RX support for J721E")
Cc: stable@vger.kernel.org
Reviewed-by: Devarsh Thakkar <devarsht@ti.com>
Tested-by: Yemike Abhilash Chandra <y-abhilashchandra@ti.com> (on SK-AM68)
Signed-off-by: Jai Luthra <jai.luthra@ideasonboard.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/platform/ti/j721e-csi2rx/j721e-csi2rx.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/drivers/media/platform/ti/j721e-csi2rx/j721e-csi2rx.c
+++ b/drivers/media/platform/ti/j721e-csi2rx/j721e-csi2rx.c
@@ -52,6 +52,8 @@
 #define DRAIN_TIMEOUT_MS		50
 #define DRAIN_BUFFER_SIZE		SZ_32K
 
+#define CSI2RX_BRIDGE_SOURCE_PAD	1
+
 struct ti_csi2rx_fmt {
 	u32				fourcc;	/* Four character code. */
 	u32				code;	/* Mbus code. */
@@ -426,8 +428,9 @@ static int csi_async_notifier_complete(s
 	if (ret)
 		return ret;
 
-	ret = v4l2_create_fwnode_links_to_pad(csi->source, &csi->pad,
-					      MEDIA_LNK_FL_IMMUTABLE | MEDIA_LNK_FL_ENABLED);
+	ret = media_create_pad_link(&csi->source->entity, CSI2RX_BRIDGE_SOURCE_PAD,
+				    &vdev->entity, csi->pad.index,
+				    MEDIA_LNK_FL_IMMUTABLE | MEDIA_LNK_FL_ENABLED);
 
 	if (ret) {
 		video_unregister_device(vdev);


