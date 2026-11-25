Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795626153;
	b=h0PsUcigE5vh4rUwitqgJrxll6pZu/gWVjlOCKojoj8lsD+lenQbbcLk5GhIFH+V8feB
	 EJfagshj/FLNOp/4JmrBu6RYNU5P2ZNeIs+cKDu28fvpOqoSz4Ek6wo6c1NiU3BZnCo1H
	 QBwu7cp4lhj5jtO2h/8vyCgvzW6e6vLHhiV5tpxgEH8Spx3kmKZpx8P6LEGHRBu3yJQq3
	 7om9IJpTHQnYHJoUoyqshG9xS45caszJX9gFZXMG3HZBWJHTorawD0oWqj747CD6KisjC
	 sUrU24KiPGCYWuBLs2mU88L4AZrRZIbaS/ocCfCz8KGCs3GbviQAymj+8KF3YKKByUg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795626153;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=TVCos0S4VFJgcBs+NXCKkN1GxUnV7//SUngkZR41a+8=;
	b=YrDrNVBa89gv24YxzEVWBao4oQkbXh6Qexed26rUbtjCa0BY93FYWJH5cV3iBAB4EBP1
	 d7CBrt2tSx1IxFiOj6i7sktD25QsNbpf/stm7QEvWyJutnAaRNGXicR6L6CweiIXcyNzW
	 szyQ29bjB5t6jlzd52qDSJsqHJePM/jBcmIIsSSRJl0YLbaaOdlkQqeTYci/pRuy0xdVU
	 1MRe0wHzuqPRydNZVmvDx+57NguolAYuCaMBqk38Qw0MkpDOEuNBhyI7fEx81drFgrEGi
	 LJNJ4w8pqMxYbsNE9Mg83mocPULDzp3hKk6Is/u836huKO45nSHFuAW6iNRVaLmpePA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2gpyMaks;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62CB7606A31E;
	Wed, 25 Nov 2026 17:02:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2gpyMaks
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3874A1F000C4;
	Wed, 25 Nov 2026 17:02:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795626152;
	bh=TVCos0S4VFJgcBs+NXCKkN1GxUnV7//SUngkZR41a+8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2gpyMaksKQW5X9zGXKuJs0Wx/vAgTZsdV/seOl8UeCIeNzgsWwlTWW8hc7Y12HdRN
	 Am5ufMTqXKPabi9VAtegWx2hKms2rTh6B9iywDTMyPK1v2B1e7gj68IfjFLoeQ/zNM
	 05BgUSsKdPb2GbNcOlQM0U5VCJX12It++s+e5TxI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Yu Zhang <yuz08559@gmail.com>,
	Alan Stern <stern@rowland.harvard.edu>
Subject: [PATCH 6.12 747/816] usb: gadget: f_mass_storage: take filesem in nofua store to fix backing-file UAF
Date: Wed, 25 Nov 2026 15:38:15 +0100
Message-ID: <20261125143906.466152624@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yu Zhang <yuz08559@gmail.com>

commit 450fa94d7ae9fc91c3df525f5d1322bf8fecf7b2 upstream.

fsg_store_nofua() syncs the LUN's backing file when switching from async
to sync mode:

	if (!nofua && curlun->nofua)
		fsg_lun_fsync_sub(curlun);

fsg_lun_fsync_sub() dereferences curlun->filp (vfs_fsync(filp)). Unlike
every other store that touches the backing file -- fsg_store_ro() and
fsg_store_cdrom() (down_read), fsg_store_file() (down_write) --
fsg_store_nofua() holds no filesem while doing so.

A concurrent close of the backing file runs under down_write(filesem) and
does fput(curlun->filp) in fsg_lun_close() (fsg_store_file() with an empty
path, the SCSI START_STOP eject in do_start_stop(), or forced_eject), so
it can free the file while fsg_store_nofua() is dereferencing it:

	BUG: KASAN: slab-use-after-free in vfs_fsync+0x20/0xe0
	 vfs_fsync+0x20/0xe0
	 fsg_lun_fsync_sub+0xa0/0xd0
	 fsg_store_nofua+0x138/0x160
	 configfs_write_iter+0x1a7/0x250
	 vfs_write+0x5df/0x940
	Allocated by task 3459:
	 fsg_store_file+0x150/0x1f0
	 configfs_write_iter+0x1a7/0x250
	Freed by task 3459:
	 __fput+0x456/0x6c0
	 __fput_deferred+0x10d/0x330
	 fsg_store_file+0x9e/0x1f0
	 configfs_write_iter+0x1a7/0x250

Hold filesem for read around the fsync in fsg_store_nofua() so the backing
file cannot be closed underneath it. The lock is only needed when the
fsync actually runs, so it is taken only in that branch.

Reproduced on a mass_storage gadget over dummy_hcd by writing lun.N/nofua
(1 then 0) from one task while another task rewrites and clears lun.N/file.

Cc: stable <stable@kernel.org>
Signed-off-by: Yu Zhang <yuz08559@gmail.com>
Acked-by: Alan Stern <stern@rowland.harvard.edu>
Link: https://patch.msgid.link/20261020023050.87701-1-yuz08559@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/function/f_mass_storage.c |    8 ++++++--
 drivers/usb/gadget/function/storage_common.c |    7 +++++--
 drivers/usb/gadget/function/storage_common.h |    3 ++-
 3 files changed, 13 insertions(+), 5 deletions(-)

--- a/drivers/usb/gadget/function/f_mass_storage.c
+++ b/drivers/usb/gadget/function/f_mass_storage.c
@@ -2668,8 +2668,9 @@ static ssize_t nofua_store(struct device
 			   const char *buf, size_t count)
 {
 	struct fsg_lun		*curlun = fsg_lun_from_dev(dev);
+	struct rw_semaphore	*filesem = dev_get_drvdata(dev);
 
-	return fsg_store_nofua(curlun, buf, count);
+	return fsg_store_nofua(curlun, filesem, buf, count);
 }
 
 static ssize_t file_store(struct device *dev, struct device_attribute *attr,
@@ -3247,7 +3248,10 @@ static ssize_t fsg_lun_opts_nofua_show(s
 static ssize_t fsg_lun_opts_nofua_store(struct config_item *item,
 				       const char *page, size_t len)
 {
-	return fsg_store_nofua(to_fsg_lun_opts(item)->lun, page, len);
+	struct fsg_lun_opts *opts = to_fsg_lun_opts(item);
+	struct fsg_opts *fsg_opts = to_fsg_opts(opts->group.cg_item.ci_parent);
+
+	return fsg_store_nofua(opts->lun, &fsg_opts->common->filesem, page, len);
 }
 
 CONFIGFS_ATTR(fsg_lun_opts_, nofua);
--- a/drivers/usb/gadget/function/storage_common.c
+++ b/drivers/usb/gadget/function/storage_common.c
@@ -415,7 +415,8 @@ ssize_t fsg_store_ro(struct fsg_lun *cur
 }
 EXPORT_SYMBOL_GPL(fsg_store_ro);
 
-ssize_t fsg_store_nofua(struct fsg_lun *curlun, const char *buf, size_t count)
+ssize_t fsg_store_nofua(struct fsg_lun *curlun, struct rw_semaphore *filesem,
+			const char *buf, size_t count)
 {
 	bool		nofua;
 	int		ret;
@@ -425,8 +426,10 @@ ssize_t fsg_store_nofua(struct fsg_lun *
 		return ret;
 
 	/* Sync data when switching from async mode to sync */
-	if (!nofua && curlun->nofua)
+	if (!nofua && curlun->nofua) {
+		guard(rwsem_read)(filesem);
 		fsg_lun_fsync_sub(curlun);
+	}
 
 	curlun->nofua = nofua;
 
--- a/drivers/usb/gadget/function/storage_common.h
+++ b/drivers/usb/gadget/function/storage_common.h
@@ -210,7 +210,8 @@ ssize_t fsg_show_cdrom(struct fsg_lun *c
 ssize_t fsg_show_removable(struct fsg_lun *curlun, char *buf);
 ssize_t fsg_store_ro(struct fsg_lun *curlun, struct rw_semaphore *filesem,
 		     const char *buf, size_t count);
-ssize_t fsg_store_nofua(struct fsg_lun *curlun, const char *buf, size_t count);
+ssize_t fsg_store_nofua(struct fsg_lun *curlun, struct rw_semaphore *filesem,
+			const char *buf, size_t count);
 ssize_t fsg_store_file(struct fsg_lun *curlun, struct rw_semaphore *filesem,
 		       const char *buf, size_t count);
 ssize_t fsg_store_cdrom(struct fsg_lun *curlun, struct rw_semaphore *filesem,


