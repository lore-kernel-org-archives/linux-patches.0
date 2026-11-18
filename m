Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795048177;
	b=fFTWx4zgQUFDXP2BQONL48FOb49iM56T++NMSd+Jkyst4Har7ZNnChEYEzzifk/Y4UIc
	 9G95dQP8KIaCcdxvErw3Sa3TJkboVO7HQf+p35PiWVFNpnCZUuEh+JsSE3Kww42uIj0o6
	 dkjZIMGZiQtFoS3f4j6jjkTFMPeMhVgwFvN7uk8BfO7kr/8FyuVMQaUNYU/GHX/A4NrnX
	 AsSeCvok9jY9t4W2y5e1/CvdJvk9tadmOo2uabvdLKDcLzrvbPnEWVrQG7dsrM/5jgh7A
	 qFmNe4oz/f6MIJttxY02jRTK0qKRtsvjCxTsPpJf0u2fAqa/9a95ubfDyW//C0sELgA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795048177;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=wGQD5FdUpOM8HUQvtKW0DiO5Rpp9pC4mCwSRYLGRSvc=;
	b=vuvO7Yl8wqNtwJGiDUpYD/Hblrc6TJ/+lfI78eBI6+XCmqpHif8Hhq36uSY5OKX1pKC/
	 CZLW040ds24VwjTWEboMr1t/JoJX1Tf0HQyt8LBdtGSueiQzo9L6Ued0MIAJOr6uQyYUW
	 /cEpcfdC1BB3xg6BJYBP2mk1LbhFwuP17FXX4bYWBCC5VlfcXdVxH5BgCXhJlI5LEQ+Ka
	 dPN+R9FY0vyI/AU98/SAFEb5H08nEg5lE7LXY5b3m4kGK1d/gOZ7veIs2Q8791IzeBCHw
	 mRIcCTW+AOAvjVj3nv+FfGCclRQX7eMvYOyFpy2tdPjkoq3yvM3CLQ5ySoxqnmP747Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yosa1mFn;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9B1A606A325;
	Thu, 19 Nov 2026 00:29:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yosa1mFn
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4709E1F000C4;
	Thu, 19 Nov 2026 00:29:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795048176;
	bh=wGQD5FdUpOM8HUQvtKW0DiO5Rpp9pC4mCwSRYLGRSvc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yosa1mFnH6FMfMgWqKUNcafHMW8wQqI2RMpwIvwRQG+WXAXuJ1/UdYf0VmQF/jXo1
	 ZGmGBlfgYK3DwB9y/EURpU6kcGQoZYL2EMPq5rEU10AzQzF02fhMRXRJu8UupTtL3g
	 XzSaEJ4dL1vbUMnmbeEm9thG5p4f/LRmnB+Ie9l0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chandrakanth Patil <chandrakanth.patil@broadcom.com>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1862/2857] scsi: mpi3mr: Fix buffer overflow in the BSG target device map
Date: Wed, 18 Nov 2026 15:48:16 +0100
Message-ID: <20261118150308.280006631@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chandrakanth Patil <chandrakanth.patil@broadcom.com>

[ Upstream commit 203b3072e7aa10d98b3f2b766693ea925cfc571d ]

The size of the target device map buffer is held in a u16 while the number
of devices it is derived from is not bounded to fit. With enough devices
the size wraps, a short buffer is allocated, and the loop that fills it
writes past the end.

Do the calculation in size_t.

Fixes: fb428a2005fc ("scsi: mpi3mr: Fix issues in mpi3mr_get_all_tgt_info()")
Signed-off-by: Chandrakanth Patil <chandrakanth.patil@broadcom.com>
Link: https://patch.msgid.link/20260825210411.301535-14-chandrakanth.patil@broadcom.com
Signed-off-by: Martin K. Petersen (Oracle) <mkp@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/mpi3mr/mpi3mr_app.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr_app.c b/drivers/scsi/mpi3mr/mpi3mr_app.c
index 4d856e1a58028..29c91d6353e30 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_app.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_app.c
@@ -309,7 +309,8 @@ static long mpi3mr_bsg_pel_enable(struct mpi3mr_ioc *mrioc,
 static long mpi3mr_get_all_tgt_info(struct mpi3mr_ioc *mrioc,
 	struct bsg_job *job)
 {
-	u16 num_devices = 0, i = 0, size;
+	u16 num_devices = 0, i = 0;
+	size_t size;
 	unsigned long flags;
 	struct mpi3mr_tgt_dev *tgtdev;
 	struct mpi3mr_device_map_info *devmap_info = NULL;
@@ -335,8 +336,8 @@ static long mpi3mr_get_all_tgt_info(struct mpi3mr_ioc *mrioc,
 		return 0;
 	}
 
-	kern_entrylen = num_devices * sizeof(*devmap_info);
-	size = sizeof(u64) + kern_entrylen;
+	kern_entrylen = (uint32_t)num_devices * sizeof(*devmap_info);
+	size = sizeof(u64) + (size_t)kern_entrylen;
 	alltgt_info = kzalloc(size, GFP_KERNEL);
 	if (!alltgt_info)
 		return -ENOMEM;
-- 
2.53.0



