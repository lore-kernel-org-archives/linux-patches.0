Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795705800;
	b=rE6Twkcu89IvzK7fL1iEar1gX5b6BW1VM/eHv2v7Wa4krSIgL2Qrxc8zfhGMtDBximMv
	 aHhTrWo2EdknLFTVHAGvdXs+nPNQuFa7+zQHuBeM7cfZoqnz5dkSIiwd42DfS9pnjsQbZ
	 HuebLJpF1K1Fm9IaP4IWnn9MrGfYkuvLbIZI7oGCSO6XsIuc98Mmv/fnmlU1KpqmbeIXd
	 AqnQlpXfO+jiBikdZPKB31GTSIA5c39i2du/Z+nIsnDlANTEpby7x77w1kv00ochpRCDO
	 dtJw/k1zqTufr3NAd+LIfS+Qbp0QoZOzWaCbOs/BYvt3ardTP8Tj0dozT8c012py0VA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795705800;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=I1jqHEcEoHLZJmI1k64+Pj/a/yeZ3pAWHCd8Abf9bvA=;
	b=1KRrd0mMYxqpP5FUE574LPuRT4tXgWVMTmUIpBAaoIiTe3yFwrbbnmqqHb03VMlLn5Y+
	 GA4sT/GPK/jl/v1hhAKDxeYQyfNndgdYJ+3k9j1pC0daMUTWzBQkOLtlzUmQgaD7itTT8
	 lFNlVJgKMHZ6Qzs6IuM3CPMhVTjCarXBUe6PtOo+vfd1SGsP/EIPev/z8bUlg8wk4R4Tx
	 UDgBICzmRMhqntM89i4veviztHChQpO2xTZAvD5PpKeWixAgkRApcWlM3ONiXkJDAT5wL
	 pcFvHdpQrBJovegCvAFJxUWnMGeeMA9aaUCZw7NsnBp5HYT5MV/QjbjPEQmD2OGhg8A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="FM/3gXlp";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D44D606A329;
	Thu, 26 Nov 2026 15:10:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FM/3gXlp
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FD951F000D3;
	Thu, 26 Nov 2026 15:09:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795705799;
	bh=I1jqHEcEoHLZJmI1k64+Pj/a/yeZ3pAWHCd8Abf9bvA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FM/3gXlpEpYd3H0AxUl0syHDFnl0UpjSsKweZQeCXnUhdWYko9j46hU5MYN3J0G0e
	 Td1XZcZAYiXRkP2qN7VCt+9R+yy62d6PD8vojEzrMlY8bnYewcK9z60hTeiS1qi0R/
	 +x7Pm2gUruCQAzZwxLedFL/O7lbXWHxUqUh2bVLk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Yu Zhang <yuz08559@gmail.com>,
	Alan Stern <stern@rowland.harvard.edu>
Subject: [PATCH 5.15 274/319] usb: gadget: f_mass_storage: take filesem in nofua store to fix backing-file UAF
Date: Thu, 26 Nov 2026 15:40:42 +0100
Message-ID: <20261126144012.937731407@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126144006.732901931@linuxfoundation.org>
References: <20261126144006.732901931@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2528,8 +2528,9 @@ static ssize_t nofua_store(struct device
 			   const char *buf, size_t count)
 {
 	struct fsg_lun		*curlun = fsg_lun_from_dev(dev);
+	struct rw_semaphore	*filesem = dev_get_drvdata(dev);
 
-	return fsg_store_nofua(curlun, buf, count);
+	return fsg_store_nofua(curlun, filesem, buf, count);
 }
 
 static ssize_t file_store(struct device *dev, struct device_attribute *attr,
@@ -3095,7 +3096,10 @@ static ssize_t fsg_lun_opts_nofua_show(s
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
@@ -414,7 +414,8 @@ ssize_t fsg_store_ro(struct fsg_lun *cur
 }
 EXPORT_SYMBOL_GPL(fsg_store_ro);
 
-ssize_t fsg_store_nofua(struct fsg_lun *curlun, const char *buf, size_t count)
+ssize_t fsg_store_nofua(struct fsg_lun *curlun, struct rw_semaphore *filesem,
+			const char *buf, size_t count)
 {
 	bool		nofua;
 	int		ret;
@@ -424,8 +425,10 @@ ssize_t fsg_store_nofua(struct fsg_lun *
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


