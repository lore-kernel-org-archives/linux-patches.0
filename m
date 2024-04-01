Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C51F3FE2D;
	Mon,  1 Apr 2024 16:07:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711987660; cv=none; b=XL5KJGjULUherIRJJEf7SOvps/xP6BHun02JLFq64dJYVNjvGYHdtbthHos028d4z8K3olj6tlIjZfDJT8HnlAE0PE9Hx3EPY7DbkPMpASs5HeanrZJr0zh+HXUcq1RzjOMz0B9nFwiKhMXEiC8CllXnyv62X9mkA3EMtX0tN58=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711987660; c=relaxed/simple;
	bh=R5kZ3J2h2q5M9lqUHJGgWWJAbOAMABD4kbCbpfOiwEw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=swkavKSNo9/IGBIX9LYd0F75bnwNzrV4SsSxt/rIMpgbLdKKZNVIzXqm8FolZ+PaISBKyvP0wdDlaQ+68C44QJkKuKFghu4+ji7dWnOdG/BH4YxdwwPJW1n12Ffpu2m8goiDVGrwVcohvcHj5dbMoFqtp+xY1QdPtY4LP+RlHv4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gfEp9ySf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gfEp9ySf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D7D6C433F1;
	Mon,  1 Apr 2024 16:07:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711987660;
	bh=R5kZ3J2h2q5M9lqUHJGgWWJAbOAMABD4kbCbpfOiwEw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gfEp9ySf+9PhXXLS+zcvP25ofmdK+uwEzCVrS27B6YuSu+pRbEwUSQOIkkiNBrQmY
	 Qu3whWAU0cnzFr3yoptKycKZkQAe613ESnxV4Qcz80MnlN8dzmD4yZTkxk7KdOxNv4
	 6xxepJMOy7lNrvZfAHUcpAZRcfsd5kgCxbHSufxU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Wetzel <Alexander@wetzel-home.de>,
	Bart Van Assche <bvanassche@acm.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 6.8 352/399] scsi: sg: Avoid sg device teardown race
Date: Mon,  1 Apr 2024 17:45:18 +0200
Message-ID: <20240401152559.680994067@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152549.131030308@linuxfoundation.org>
References: <20240401152549.131030308@linuxfoundation.org>
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
 


