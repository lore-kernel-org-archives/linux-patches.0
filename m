Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0D7B80C1D;
	Mon, 15 Apr 2024 14:29:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713191359; cv=none; b=lJNM4kI6/uAxhTRx0IUlQE97I9Ep8YHIBdhZc0WUXmNmotNZm+EHGJHOkS4InI/88X3Z/dla60wnwxry0lDmNQEV9MUPHqkfwatHZco5lQ7JbfaaaGRUO/3pLiMbNgFEED68ePDL1lc1uWBYw33kPJF+WwdwYDaaaTB0q38xj/8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713191359; c=relaxed/simple;
	bh=R5kZ3J2h2q5M9lqUHJGgWWJAbOAMABD4kbCbpfOiwEw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a7K6QSWR/gG323CDz5jkiBNeeFAoLYqK9YIt1qZBDid2EmKucbJot5s8lNzU7dNv7bdX9bbVVlCERATryxkNjvvdRD3VJy6tZsj8aygCmW6Q26o1D9nLdBPLx4LdBvaAzZPbvkfwpBRVm4cR8I1B4zkBDXt2S8NJElVJ+KbmBxs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=I33KvoXN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="I33KvoXN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30C73C113CC;
	Mon, 15 Apr 2024 14:29:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713191359;
	bh=R5kZ3J2h2q5M9lqUHJGgWWJAbOAMABD4kbCbpfOiwEw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=I33KvoXN00h6SzfOVaF1mXDE7ru1ymzgAy7cd/QuzmjTrGDJz5uTcqEXLtm6e/4T9
	 Wn0IInZ9cyuuWQAmiLbYrKQgtPzLmjJBm1VePq4oB3Y8uNcdVboft2hI87d7A3yLfg
	 DN3A/Mo0Poa6z158PDoZ4+dJaNQsQpSgo+0Ipgkg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Wetzel <Alexander@wetzel-home.de>,
	Bart Van Assche <bvanassche@acm.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 6.8 116/172] scsi: sg: Avoid sg device teardown race
Date: Mon, 15 Apr 2024 16:20:15 +0200
Message-ID: <20240415142003.914821460@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240415141959.976094777@linuxfoundation.org>
References: <20240415141959.976094777@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2207,6 +2207,7 @@ sg_remove_sfp_usercontext(struct work_st
 {
 	struct sg_fd *sfp = container_of(work, struct sg_fd, ew.work);
 	struct sg_device *sdp = sfp->parentdp;
+	struct scsi_device *device = sdp->device;
 	Sg_request *srp;
 	unsigned long iflags;
 
@@ -2232,8 +2233,9 @@ sg_remove_sfp_usercontext(struct work_st
 			"sg_remove_sfp: sfp=0x%p\n", sfp));
 	kfree(sfp);
 
-	scsi_device_put(sdp->device);
+	WARN_ON_ONCE(kref_read(&sdp->d_ref) != 1);
 	kref_put(&sdp->d_ref, sg_device_destroy);
+	scsi_device_put(device);
 	module_put(THIS_MODULE);
 }
 


