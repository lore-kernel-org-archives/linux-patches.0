Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12B5230568A;
	Fri, 15 May 2026 16:02:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778860929; cv=none; b=Kaz9N0oY9B+qDOqWTqVFGGTygZgokKthMifbvRa5kpHzZwDk52HGlDn1EKGDIxrB5ueZ6HNqX0PIOB+PUSnI7hcT9v4ZWVagYbMyFGcVIthEChCWCVswLIWSnQQ1gCPG2eociZQmmQt8rZ9jKxOHaQ9r/fO5q9EO35ef1/vcQSA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778860929; c=relaxed/simple;
	bh=9BvwSi/rzvHggpuM937P64kCQoF/i4nA5Ooxi3nArHU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dSGLN3zUTCBXfpLttUSnxAm3z0QZWoaT+wCImb1CRUY9j5eazeOEsXXvhUcZfrp99r5WyjjTBq9nTL8hC9VwRcQ0fb8sNxwyyd5y7prhzkkbN4G6UlJJk+eHdlBgZp4PIQ+KgJOFl5KXCcM1vWpdmkAmQVUPTpVVeUcQO0ZwrG0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ohq7QSwT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ohq7QSwT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C0ADC2BCB0;
	Fri, 15 May 2026 16:02:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778860929;
	bh=9BvwSi/rzvHggpuM937P64kCQoF/i4nA5Ooxi3nArHU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ohq7QSwTPe0x5g+vKDBY5ETwzuZQUkFW+sEz6NbMFjaSf4hAa03qO5ZlaqzQQZdbk
	 Tk/XRLK8EJqAhaK6ZMF9KQKQmGAJNBr4PMpA9tFH41HU8mQwAJ+HeTtH+Wi+WElMi1
	 EJWh0aJsiGIkPBYcaYUJb97TxbrQfI18bUpF7hZc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Garry <john.g.garry@oracle.com>,
	Yang Xiuwei <yangxiuwei@kylinos.cn>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 6.6 133/474] scsi: sd: fix missing put_disk() when device_add(&disk_dev) fails
Date: Fri, 15 May 2026 17:44:02 +0200
Message-ID: <20260515154717.910388360@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154715.053014143@linuxfoundation.org>
References: <20260515154715.053014143@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -3727,6 +3727,7 @@ static int sd_probe(struct device *dev)
 	error = device_add(&sdkp->disk_dev);
 	if (error) {
 		put_device(&sdkp->disk_dev);
+		put_disk(gd);
 		goto out;
 	}
 


