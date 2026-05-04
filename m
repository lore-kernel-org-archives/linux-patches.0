Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D0CA3E025C;
	Mon,  4 May 2026 14:27:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777904825; cv=none; b=adOEMdu1TfpWyIy+ehpFH2UL9LSCjj0ZgM7h8gmTj9sQipGah4ftFQ/E0I/WUKWFliobidVbONM59nsl+R26cqfc5FvWDnGanC3290raoKOhyMPJgujEZHFkmxqFbfYn+qJSCUZxMOIfyV6jgQz/k+pnFyGkgPnJi6w96HGiT28=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777904825; c=relaxed/simple;
	bh=KiT10cga4R4caPRFhW1romCtVxT8bwemhp87iDlJhjQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Gmv0IuqSYL22RgpKjG5CEbC79WKXNxcrdPft7ExCLCc22uQhH5j86Tar8cNJa6voq1xsUkedtFIy1MiuCvnuwmdyXgfbqNokfaWjVfv2ioRNr5JC7wuUIGly3ee8oTcwApkmnohjp3MRd6ZFKWHS43V8nDRR1XNouCpYhNpC3EE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ERFcdD3I; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ERFcdD3I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3DA7C2BCB8;
	Mon,  4 May 2026 14:27:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777904825;
	bh=KiT10cga4R4caPRFhW1romCtVxT8bwemhp87iDlJhjQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ERFcdD3IUyPWRPQDanNMlyvfu4ykXghThR3z3bQg7KDr5lfIG1sLKv81nD1jViOzu
	 r3dl8dC6XZBLVVshSMRduLv4h1Em9n2XET/qKWvAYN+PEbbZWFD+pCFIlbj2azHOe3
	 nmTWvEPh90GVfsVFXFOqHLTRJslE8PfwZedkMPC4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Garry <john.g.garry@oracle.com>,
	Yang Xiuwei <yangxiuwei@kylinos.cn>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 6.12 171/215] scsi: sd: fix missing put_disk() when device_add(&disk_dev) fails
Date: Mon,  4 May 2026 15:53:10 +0200
Message-ID: <20260504135136.432955246@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135130.169210693@linuxfoundation.org>
References: <20260504135130.169210693@linuxfoundation.org>
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

From: Yang Xiuwei <yangxiuwei@kylinos.cn>

commit 1e111c4b3a726df1254670a5cc4868cedb946d37 upstream.

If device_add(&sdkp->disk_dev) fails, put_device() runs
scsi_disk_release(), which frees the scsi_disk but leaves the gendisk
referenced. The device_add_disk() error path in sd_probe() calls
put_disk(gd); call put_disk(gd) here to mirror that cleanup.

Fixes: 265dfe8ebbab ("scsi: sd: Free scsi_disk device via put_device()")
Cc: stable@vger.kernel.org
Reviewed-by: John Garry <john.g.garry@oracle.com>
Signed-off-by: Yang Xiuwei <yangxiuwei@kylinos.cn>
Link: https://patch.msgid.link/20260330014952.152776-1-yangxiuwei@kylinos.cn
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/sd.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -3982,6 +3982,7 @@ static int sd_probe(struct device *dev)
 	error = device_add(&sdkp->disk_dev);
 	if (error) {
 		put_device(&sdkp->disk_dev);
+		put_disk(gd);
 		goto out;
 	}
 


