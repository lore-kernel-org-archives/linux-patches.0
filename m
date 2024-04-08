Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F1007E772;
	Mon,  8 Apr 2024 13:27:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712582875; cv=none; b=jgBqRz9m1+mbqIBCwK5TiC5pMT9Nppp6JVFy8Iu96VwOlc+oHMA1hFYHU0PHtNtAERACEUjT3NJMlXgVcqiHY+BAK/6aR4nEkwdRa8rgcs9Q6APl6j7w/cu1K2y7JFud8qjIrEsrnhZCLP3QhXRn+JB2zUACLLjw/H+McbsJk7I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712582875; c=relaxed/simple;
	bh=PmTEF4Kju6V9vPMopSs1KQrQVZZGahxKZmFKYnT8UL8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Sf/q1/0/DJPl9ttntiYbkcC8THslmNS+UuOGyvwDz/TL86S2av1OivmUz1QbRLdbgGkEZUMZi3UmdaaDhqNTKqwbj2ZCIFOn/d+nyLJLe2hibLrt2Gy3L36y7JwYBs1zGT/+L+FhbZSA15FmhYvqLbnSlqPHc9TqEhzIGvDOYQ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AaHcATD7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AaHcATD7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58DB5C433C7;
	Mon,  8 Apr 2024 13:27:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712582874;
	bh=PmTEF4Kju6V9vPMopSs1KQrQVZZGahxKZmFKYnT8UL8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AaHcATD7Wkn+gDCbTaVMiaytjczL/Wy806G/UDKmS3WJLC5F5lECwYo4gYBm08nMv
	 P8J2rT1wpkH0DvmRFnK9Ci3QxNvlrDzgib9VB3hyHn1GUR8/KohNgHlwt1cvNWA49h
	 IJAm5k4IMMfxJbwKEYRVvgCcHR9Kh8m+hZmu2bz8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Wetzel <Alexander@wetzel-home.de>,
	Bart Van Assche <bvanassche@acm.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 131/252] scsi: sg: Avoid sg device teardown race
Date: Mon,  8 Apr 2024 14:57:10 +0200
Message-ID: <20240408125310.696651813@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125306.643546457@linuxfoundation.org>
References: <20240408125306.643546457@linuxfoundation.org>
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

[ Upstream commit 27f58c04a8f438078583041468ec60597841284d ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/sg.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index 0d8afffd1683b..8bd95ee1825a6 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -2208,6 +2208,7 @@ sg_remove_sfp_usercontext(struct work_struct *work)
 {
 	struct sg_fd *sfp = container_of(work, struct sg_fd, ew.work);
 	struct sg_device *sdp = sfp->parentdp;
+	struct scsi_device *device = sdp->device;
 	Sg_request *srp;
 	unsigned long iflags;
 
@@ -2233,8 +2234,9 @@ sg_remove_sfp_usercontext(struct work_struct *work)
 			"sg_remove_sfp: sfp=0x%p\n", sfp));
 	kfree(sfp);
 
-	scsi_device_put(sdp->device);
+	WARN_ON_ONCE(kref_read(&sdp->d_ref) != 1);
 	kref_put(&sdp->d_ref, sg_device_destroy);
+	scsi_device_put(device);
 	module_put(THIS_MODULE);
 }
 
-- 
2.43.0



