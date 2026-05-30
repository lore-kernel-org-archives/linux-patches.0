Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2F962E92B3;
	Sat, 30 May 2026 16:58:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780160340; cv=none; b=IWSCj5GmV1Jam6urTfnEqANnINFyVi6dN23XdQfTkGdiVpkYilz9PAX3dS/8qBPL4UuJvK4/0C5QmbQ01Ixgc7WOR/yRAyfORFYVnRIGvLcX5GYKqabMxqrZ08DwUOR0VMmErRZRazTJk23rGXsXtcvXFBYiluVFQgMrfrZcINo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780160340; c=relaxed/simple;
	bh=zdTJvt4VVvFXBip6idBRbTSQLBlkjrj8r/R4bWAqDAw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bNHRReuUS8FCVMr2C9aCG6abRPDVr/fu3jEuD4WOUKoK5HiQtYhxFpp+MpxqMPbdfctEkViLqq8GcSWh3rx559uXkFoMnoTNNKXfDx82XKxmaJ/qz2IuWNdkdpMHzAtZPnXQABLTU0GIGfIzeHA3JeMEaqWK6bvi+L8sP0YGwdE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YoSBmxmF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YoSBmxmF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02A9C1F00893;
	Sat, 30 May 2026 16:58:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780160339;
	bh=VVITNZ7vdHqbhcRjETj8K5aw5043cG7TRdypecz2FC0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YoSBmxmF/vxOBlFJbSGhzF66CT1HoNkTp8cc1gNiYg9VX/iMNtLLbmipaNEQvETjV
	 IVm6MheEP8qxevPrUVg7Yug3lXPX7QUyCoAnebxWmY4i9zq/zGKYaD8fgSBxfbH31X
	 ePjYObJC5qpFB7x6uiPAWhCbed7PS+hAUR1JlH7Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Garry <john.g.garry@oracle.com>,
	Yang Xiuwei <yangxiuwei@kylinos.cn>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 6.1 268/969] scsi: sd: fix missing put_disk() when device_add(&disk_dev) fails
Date: Sat, 30 May 2026 17:56:32 +0200
Message-ID: <20260530160307.873402146@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -3607,6 +3607,7 @@ static int sd_probe(struct device *dev)
 	error = device_add(&sdkp->disk_dev);
 	if (error) {
 		put_device(&sdkp->disk_dev);
+		put_disk(gd);
 		goto out;
 	}
 


