Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B8722119;
	Mon, 15 Apr 2024 14:37:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713191836; cv=none; b=YT5EsNWfC/bige8p8O848TqxvnEHI0XZhZkaXgEw4hUMpA+yGuD9nz6+K9D+C8SsHTqLgFIQx6shPxQSWgFTYViY6Ot/HuJTxq8VtI3OiNblxgSOlAXgWGjjVlDWc651WDI7YlbOAX9HmHFTNTusMTtJMuezAjsSfdjTXFaSDh4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713191836; c=relaxed/simple;
	bh=Sod/+TmoCvGok3nwSYxxrJ2duYj3BhJamXfJU8OmIJY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gs8l4D0FTX/36W/+hQt6ElreXxCQ7dBNGfmZm3fUOUSSH6etfm2H9MzxjQLih2pFcBJTrJ/98/wYM+8O6/epI0oHKn5STkBEclJaONhYhoNC6z3+gx7DW6goa1wyixwS0K5bUIIF8RSxab5LBK8dfIHjbyyHgwMhEM9hBJzk5o8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mtXItRx/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mtXItRx/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4D03C113CC;
	Mon, 15 Apr 2024 14:37:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713191836;
	bh=Sod/+TmoCvGok3nwSYxxrJ2duYj3BhJamXfJU8OmIJY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mtXItRx/RMF1jiliRvPVVAILqt/yR6wVgDqZoyeIxEN5/sY1PuV47tTq7K5xb1Jei
	 FRhZ+P6L5qnGTlW+gSggQHBXk3zeobA8heRe5zJHIRI7+yK7hlDwBB9/0E/D9QgUif
	 bFYkkbhP09cuBEef7A2Ul0UbFWt+wFeNpeS2b3+Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Wetzel <Alexander@wetzel-home.de>,
	Bart Van Assche <bvanassche@acm.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 6.6 085/122] scsi: sg: Avoid sg device teardown race
Date: Mon, 15 Apr 2024 16:20:50 +0200
Message-ID: <20240415141955.927421106@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240415141953.365222063@linuxfoundation.org>
References: <20240415141953.365222063@linuxfoundation.org>
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

From: Alexander Wetzel <Alexander@wetzel-home.de>

commit 27f58c04a8f438078583041468ec60597841284d upstream.

sg_remove_sfp_usercontext() must not use sg_device_destroy() after calling
scsi_device_put().

sg_device_destroy() is accessing the parent scsi_device request_queue which
will already be set to NULL when the preceding call to scsi_device_put()
removed the last reference to the parent scsi_device.

The resulting NULL pointer exception will then crash the kernel.

Link: https://lore.kernel.org/r/20240305150509.23896-1-Alexander@wetzel-home.de
Fixes: db59133e9279 ("scsi: sg: fix blktrace debugfs entries leakage")
Cc: stable@vger.kernel.org
Signed-off-by: Alexander Wetzel <Alexander@wetzel-home.de>
Link: https://lore.kernel.org/r/20240320213032.18221-1-Alexander@wetzel-home.de
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/sg.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -2208,6 +2208,7 @@ sg_remove_sfp_usercontext(struct work_st
 {
 	struct sg_fd *sfp = container_of(work, struct sg_fd, ew.work);
 	struct sg_device *sdp = sfp->parentdp;
+	struct scsi_device *device = sdp->device;
 	Sg_request *srp;
 	unsigned long iflags;
 
@@ -2233,8 +2234,9 @@ sg_remove_sfp_usercontext(struct work_st
 			"sg_remove_sfp: sfp=0x%p\n", sfp));
 	kfree(sfp);
 
-	scsi_device_put(sdp->device);
+	WARN_ON_ONCE(kref_read(&sdp->d_ref) != 1);
 	kref_put(&sdp->d_ref, sg_device_destroy);
+	scsi_device_put(device);
 	module_put(THIS_MODULE);
 }
 


