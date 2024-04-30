Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D064A12BF3E;
	Tue, 30 Apr 2024 10:44:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714473892; cv=none; b=a4oDzO2aMilZh09xYsM76FavnMPoEGVEb5IS4f7x6DQYzoBig2M1CeCapczDD3zP+MjEDyNk6GNyDjvly4FWaX35KymlBDvnaSV1V9P/rNeg6n8MIOtTQCvBRARxpgbwqgoVpThuZ6ugsE6AJhJORhEj3RiZ8qA3bpti+uDerMA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714473892; c=relaxed/simple;
	bh=opuDb0nt3FKq+On+6dhJXOYqo17MejKvNtsvV1hzJjM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l/Q2t2Yeg64DFqEBA8SVFCY+DPdC9y2gKlbr2Oupp82/dAxgmM0okqyuzecxEUdg2v55tIKfhw70xXwJN9RJZ+FHSuR4jW4Qk/a33iHrLOo6IejJxIiueDiRNQKr/qj6IUnmYO078Oeo26p8xk7jM5XHedyArPjD7eGrjqSEa10=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zXgc0Giw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zXgc0Giw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5ABFBC2BBFC;
	Tue, 30 Apr 2024 10:44:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714473892;
	bh=opuDb0nt3FKq+On+6dhJXOYqo17MejKvNtsvV1hzJjM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zXgc0GiwLnqlwoK7rw3bVd9O4bZ2KJg4C33HgFSuQAOF1Q7ya1GL+EKM99mb6Kedz
	 3SjwHeEDsp4ZUejlP4E462QVIxU+MZCKXvEQdjezRKVsGji/u2GIZtpnXc0kwtJPfo
	 DRjQks+TN0cduG+tqBQPWJRH2GRXMGzYOdwe8tHI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ben Hutchings <ben@decadent.org.uk>
Subject: [PATCH 4.19 74/77] Revert "loop: Remove sector_t truncation checks"
Date: Tue, 30 Apr 2024 12:39:53 +0200
Message-ID: <20240430103043.324611036@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103041.111219002@linuxfoundation.org>
References: <20240430103041.111219002@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ben Hutchings <ben@decadent.org.uk>

This reverts commit f92a3b0d003b9f7eb1f452598966a08802183f47, which
was commit 083a6a50783ef54256eec3499e6575237e0e3d53 upstream.  In 4.19
there is still an option to use 32-bit sector_t on 32-bit
architectures, so we need to keep checking for truncation.

Since loop_set_status() was refactored by subsequent patches, this
reintroduces its truncation check in loop_set_status_from_info()
instead.

I tested that the loop ioctl operations have the expected behaviour on
x86_64, x86_32 with CONFIG_LBDAF=y, and (the special case) x86_32 with
CONFIG_LBDAF=n.

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/block/loop.c |   19 +++++++++++++++----
 1 file changed, 15 insertions(+), 4 deletions(-)

--- a/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -243,12 +243,16 @@ static void loop_set_size(struct loop_de
 	kobject_uevent(&disk_to_dev(bdev->bd_disk)->kobj, KOBJ_CHANGE);
 }
 
-static void
+static int
 figure_loop_size(struct loop_device *lo, loff_t offset, loff_t sizelimit)
 {
 	loff_t size = get_size(offset, sizelimit, lo->lo_backing_file);
+	sector_t x = (sector_t)size;
 
+	if (unlikely((loff_t)x != size))
+		return -EFBIG;
 	loop_set_size(lo, size);
+	return 0;
 }
 
 static inline int
@@ -996,7 +1000,10 @@ static int loop_set_fd(struct loop_devic
 	    !file->f_op->write_iter)
 		lo_flags |= LO_FLAGS_READ_ONLY;
 
+	error = -EFBIG;
 	size = get_loop_size(lo, file);
+	if ((loff_t)(sector_t)size != size)
+		goto out_unlock;
 
 	error = loop_prepare_queue(lo);
 	if (error)
@@ -1246,6 +1253,7 @@ loop_set_status_from_info(struct loop_de
 	int err;
 	struct loop_func_table *xfer;
 	kuid_t uid = current_uid();
+	loff_t new_size;
 
 	if ((unsigned int) info->lo_encrypt_key_size > LO_KEY_SIZE)
 		return -EINVAL;
@@ -1273,6 +1281,11 @@ loop_set_status_from_info(struct loop_de
 	if (info->lo_offset > LLONG_MAX || info->lo_sizelimit > LLONG_MAX)
 		return -EOVERFLOW;
 
+	new_size = get_size(info->lo_offset, info->lo_sizelimit,
+			    lo->lo_backing_file);
+	if ((loff_t)(sector_t)new_size != new_size)
+		return -EFBIG;
+
 	lo->lo_offset = info->lo_offset;
 	lo->lo_sizelimit = info->lo_sizelimit;
 
@@ -1531,9 +1544,7 @@ static int loop_set_capacity(struct loop
 	if (unlikely(lo->lo_state != Lo_bound))
 		return -ENXIO;
 
-	figure_loop_size(lo, lo->lo_offset, lo->lo_sizelimit);
-
-	return 0;
+	return figure_loop_size(lo, lo->lo_offset, lo->lo_sizelimit);
 }
 
 static int loop_set_dio(struct loop_device *lo, unsigned long arg)


