Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37B208F74
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 20:17:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE4D4C433C8;
	Sun, 16 Jul 2023 20:17:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689538655;
	bh=TXdBClRXVvi48yJrwfyN5ghEtX7rxVGUBD6tVegiZis=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Vr7uO29YvEI9mm6Dl4mj88N5vdmDCoCTSQlTEbUK1VjEXxDVDaNYNeKb266yXHaxu
	 krCjtypX7ijHRZ8l6gUSwyAgXP+YkAtAl6RHeViVFIZqfkYU7qtmvNY9FmfNohghXV
	 ugQ2vWVRSsAhyAR9lf+nAlkbCmm1//bauSQOCwzY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@infradead.org>,
	Demi Marie Obenour <demi@invisiblethingslab.com>,
	Christoph Hellwig <hch@lst.de>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.4 527/800] block: increment diskseq on all media change events
Date: Sun, 16 Jul 2023 21:46:20 +0200
Message-ID: <20230716195001.334797800@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230716194949.099592437@linuxfoundation.org>
References: <20230716194949.099592437@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Demi Marie Obenour <demi@invisiblethingslab.com>

commit b90ecc0379eb7bbe79337b0c7289390a98752646 upstream.

Currently, associating a loop device with a different file descriptor
does not increment its diskseq.  This allows the following race
condition:

1. Program X opens a loop device
2. Program X gets the diskseq of the loop device.
3. Program X associates a file with the loop device.
4. Program X passes the loop device major, minor, and diskseq to
   something.
5. Program X exits.
6. Program Y detaches the file from the loop device.
7. Program Y attaches a different file to the loop device.
8. The opener finally gets around to opening the loop device and checks
   that the diskseq is what it expects it to be.  Even though the
   diskseq is the expected value, the result is that the opener is
   accessing the wrong file.

>From discussions with Christoph Hellwig, it appears that
disk_force_media_change() was supposed to call inc_diskseq(), but in
fact it does not.  Adding a Fixes: tag to indicate this.  Christoph's
Reported-by is because he stated that disk_force_media_change()
calls inc_diskseq(), which is what led me to discover that it should but
does not.

Reported-by: Christoph Hellwig <hch@infradead.org>
Signed-off-by: Demi Marie Obenour <demi@invisiblethingslab.com>
Fixes: e6138dc12de9 ("block: add a helper to raise a media changed event")
Cc: stable@vger.kernel.org # 5.15+
Reviewed-by: Christoph Hellwig <hch@lst.de>
Link: https://lore.kernel.org/r/20230607170837.1559-1-demi@invisiblethingslab.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 block/disk-events.c |    1 +
 1 file changed, 1 insertion(+)

--- a/block/disk-events.c
+++ b/block/disk-events.c
@@ -307,6 +307,7 @@ bool disk_force_media_change(struct gend
 	if (!(events & DISK_EVENT_MEDIA_CHANGE))
 		return false;
 
+	inc_diskseq(disk);
 	if (__invalidate_device(disk->part0, true))
 		pr_warn("VFS: busy inodes on changed media %s\n",
 			disk->disk_name);


