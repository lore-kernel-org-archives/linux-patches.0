Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B386B3C0607;
	Fri, 15 May 2026 16:07:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778861270; cv=none; b=WISdYb2kp9DD2yXmi456bnp7LCw9DMIYw5/pYhQN9gECucqWRvZODiUsWVgwUnPLDl2onGrxzBXPU6/Yqviaak7T1Rl0wnkPtPd+1t0jy6vtMIBXSHnoP6r358GdPXS0PI0RxySw9pfsoK92nZcvsaXXtiBaqy5k51oJqfj63pw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778861270; c=relaxed/simple;
	bh=WblvGXYmczRjSfAXNCQTFlON26sirCbTeQdcuisMXmE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d6TYChRKPRuAH+T0UTVsnqeCY7N232dZCw8/V/aYOrJvjIHAtync7Uw4YCEC2SnW+fOcuGy86fYmonejJeFgzAW2i/VOOCjFBHaVdTaNT+jwdMu2WwEz4RZ6kMsCzWtjg5Sm2BxUTjzGsIeypWYbNKvlRNBbjDf1YZEj9XCKfiM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pM77yMjc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pM77yMjc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17C8CC2BCB0;
	Fri, 15 May 2026 16:07:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778861270;
	bh=WblvGXYmczRjSfAXNCQTFlON26sirCbTeQdcuisMXmE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pM77yMjcihhNbp/x9OQjFMIpqfhWu8KE8sQEVKIgxH/8V2102FCSyvQqtyXVHa8f+
	 ml9rpXAGFd7EvY512D2+u9fZCfB2avLY2Iq8giLCoSEAC918K70Jp1OkarJieHJqVN
	 B0kMqq+sNdro63tuhEvwoWeTtrL0e+/bhxsCwf5w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Fedor Pchelkin <pchelkin@ispras.ru>,
	Keith Busch <kbusch@kernel.org>
Subject: [PATCH 6.6 264/474] nvme-apple: drop invalid put of admin queue reference count
Date: Fri, 15 May 2026 17:46:13 +0200
Message-ID: <20260515154720.713804044@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154715.053014143@linuxfoundation.org>
References: <20260515154715.053014143@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fedor Pchelkin <pchelkin@ispras.ru>

commit ba9d308ccd6732dd97ed8080d834a4a89e758e14 upstream.

Commit 03b3bcd319b3 ("nvme: fix admin request_queue lifetime") moved the
admin queue reference ->put call into nvme_free_ctrl() - a controller
device release callback performed for every nvme driver doing
nvme_init_ctrl().

nvme-apple sets refcount of the admin queue to 1 at allocation during the
probe function and then puts it twice now:

nvme_free_ctrl()
  blk_put_queue(ctrl->admin_q) // #1
  ->free_ctrl()
    apple_nvme_free_ctrl()
      blk_put_queue(anv->ctrl.admin_q) // #2

Note that there is a commit 941f7298c70c ("nvme-apple: remove an extra
queue reference") which intended to drop taking an extra admin queue
reference.  Looks like at that moment it accidentally fixed a refcount
leak, which existed since the driver's introduction.  There were two ->get
calls at driver's probe function and a single ->put inside
apple_nvme_free_ctrl().

However now after commit 03b3bcd319b3 ("nvme: fix admin request_queue
lifetime") the refcount is imbalanced again.  Fix it by removing extra
->put call from apple_nvme_free_ctrl().  anv->dev and ctrl->dev point to
the same device, so use ctrl->dev directly for simplification.  Compile
tested only.

Found by Linux Verification Center (linuxtesting.org).

Fixes: 03b3bcd319b3 ("nvme: fix admin request_queue lifetime")
Cc: stable@vger.kernel.org
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Fedor Pchelkin <pchelkin@ispras.ru>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/nvme/host/apple.c |    6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

--- a/drivers/nvme/host/apple.c
+++ b/drivers/nvme/host/apple.c
@@ -1208,11 +1208,7 @@ static int apple_nvme_get_address(struct
 
 static void apple_nvme_free_ctrl(struct nvme_ctrl *ctrl)
 {
-	struct apple_nvme *anv = ctrl_to_apple_nvme(ctrl);
-
-	if (anv->ctrl.admin_q)
-		blk_put_queue(anv->ctrl.admin_q);
-	put_device(anv->dev);
+	put_device(ctrl->dev);
 }
 
 static const struct nvme_ctrl_ops nvme_ctrl_ops = {


