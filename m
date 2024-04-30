Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 585274596D;
	Tue, 30 Apr 2024 07:59:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714463942; cv=none; b=HpcokZv3y/F1uuePbdfisrGwHMD3vjj51acTJascRc/YTs90kBNWdDO+OuOscihk+C9UlPCcSwoFrQ/CEZwpT6E8vhdBf88NW3i+NmlXOj3I4T6mUFDmmLme2WcQWGQJf2mW9qGyCo6ewa6qLGOYOniNgT6hE02pzaYvRH9UqDg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714463942; c=relaxed/simple;
	bh=cjVee33cmXLyWtOeRMRHAlVwxoPMiWkqq9XltiE42Jk=;
	h=Subject:To:Cc:From:Date:In-Reply-To:Message-ID:MIME-Version:
	 Content-Type; b=M0059TNyrxVd31cSWuvfADbVdUEW94e+Q8HvXXp7HLXpYWeEwMlLm4KzvyZNSwpxzG8wMakXXfjVTZLqhxq2yGyMhhfD1V32tJSfY8jtAlev1r6e+LlW/cUXe1FT9cms9ki7c0kf7LsDDzmfpVNd4cTB9RhsBs5dJdfvJwAj6HY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Q5qCvhnZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q5qCvhnZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6ACB2C4AF14;
	Tue, 30 Apr 2024 07:59:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714463941;
	bh=cjVee33cmXLyWtOeRMRHAlVwxoPMiWkqq9XltiE42Jk=;
	h=Subject:To:Cc:From:Date:In-Reply-To:From;
	b=Q5qCvhnZd2WoT3HSzhs8F+KmoBBEcl3duTnrMKo0YLScn/LCyrUbKJf2zKvcDKJk8
	 /uNjIj7bma6bo2KieemzJKtG0X49Qj7BwCs5KQqxmDhhcvV1pJaDjvdA6A/8ZTtiMb
	 tIjh7XYTM6SJ2phAGHWpkSgzQIgg0iCKxOcHg0wk=
Subject: Patch "Revert "loop: Remove sector_t truncation checks"" has been added to the 4.19-stable tree
To: axboe@kernel.dk,ben@decadent.org.uk,gregkh@linuxfoundation.org,hch@lst.de,maco@android.com,patches@lists.linux.dev,zhanggenjian@kylinos.cn
Cc: <stable-commits@vger.kernel.org>
From: <gregkh@linuxfoundation.org>
Date: Tue, 30 Apr 2024 09:58:59 +0200
In-Reply-To: <ZjAT5UeQ8fc7CY0w@decadent.org.uk>
Message-ID: <2024043058-impending-crispness-e921@gregkh>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-stable: commit
X-Patchwork-Hint: ignore 


This is a note to let you know that I've just added the patch titled

    Revert "loop: Remove sector_t truncation checks"

to the 4.19-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     revert-loop-remove-sector_t-truncation-checks.patch
and it can be found in the queue-4.19 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.


From ben@decadent.org.uk  Tue Apr 30 09:49:44 2024
From: Ben Hutchings <ben@decadent.org.uk>
Date: Mon, 29 Apr 2024 23:40:53 +0200
Subject: Revert "loop: Remove sector_t truncation checks"
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, Martijn Coenen <maco@android.com>, Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>, Genjian Zhang <zhanggenjian@kylinos.cn>
Message-ID: <ZjAT5UeQ8fc7CY0w@decadent.org.uk>
Content-Disposition: inline

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


Patches currently in stable-queue which might be from ben@decadent.org.uk are

queue-4.19/revert-loop-remove-sector_t-truncation-checks.patch
queue-4.19/revert-y2038-rusage-use-__kernel_old_timeval.patch
