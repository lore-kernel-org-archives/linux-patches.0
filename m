Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97C0935A3AD;
	Mon,  4 May 2026 14:17:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777904254; cv=none; b=lmO2L5kC8Zcs/8YlP3vVlTZX3NnvTeV8uzvSlLfjaiUWUBCWa4K7AnO9EUm7lMwPHnIUWYIgPonolsNnK9JamauGmBc6vauaJp9mPpgkOy5yLYFmB1HLUFQmN5FCK2HjDDtB9v2d+qxbnI9FqPNVSxZuvftbO6+1bd1XKZS5Qh0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777904254; c=relaxed/simple;
	bh=V+OIO53nKmsL2IdbouGC2Svu3IL1U4SyhPR97h/GQ5M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IALL0zUKQLeteCTaFdctzz8J54obqjKdKRURlUSex7vEJaLdafT7bSzlDcxlpNWpUya86zsBvOhmXWt5aJzUJn5HICTLdxUG5aztiNSQf2yRxDXmBWMibznnbF99zyf5wFOmQK3uSEmkEgKN2SMSbU2o6BSt+okSyB/pWR5k7Q4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fZD8N/8x; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fZD8N/8x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2ECD1C2BCB8;
	Mon,  4 May 2026 14:17:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777904254;
	bh=V+OIO53nKmsL2IdbouGC2Svu3IL1U4SyhPR97h/GQ5M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fZD8N/8xDWk5ILoXe4XJX2cdgJwbVkF7rr2rgqeZrJ7ou1R4cQ1qtBbtGyaf41O0e
	 s5kYvngdpOIDJ7QcKw+DIv2+tigNNod+oNDcWOGgKJsKIsR96KFFSvmLaueQMMOxhX
	 BUENbT35583LE9I0UOSKE85qZTEgcqXZnPZmReTg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Garry <john.g.garry@oracle.com>,
	Yang Xiuwei <yangxiuwei@kylinos.cn>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 6.18 244/275] scsi: sd: fix missing put_disk() when device_add(&disk_dev) fails
Date: Mon,  4 May 2026 15:53:04 +0200
Message-ID: <20260504135152.105174784@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135142.929052779@linuxfoundation.org>
References: <20260504135142.929052779@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -3979,6 +3979,7 @@ static int sd_probe(struct device *dev)
 	error = device_add(&sdkp->disk_dev);
 	if (error) {
 		put_device(&sdkp->disk_dev);
+		put_disk(gd);
 		goto out;
 	}
 


