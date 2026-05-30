Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08548352027;
	Sat, 30 May 2026 18:10:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780164629; cv=none; b=oiBFQPBBpATgo9sPpN5DJTIDXhAnJTfCZ0MLF5+IZXm0979j2U0KxDB/5hAlhIzBskrm1MLvP/tzvmKY4HDOGvKBOa5ONJ90loSC+Zn5BuQ8xFmMNQMBjo9omTqv+vfiUlWeukZ2c3WnA4tNJzSITz+zYUWyjE+iiu6mLU2T8iU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780164629; c=relaxed/simple;
	bh=bYpx/nsx1iJR22/L1tGtNSgtuyN1vgn3EKWGFN0R7JM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Qk+eyzOoZLZUFykPJnnikYlQgZLqMDibY4LTERMQCl9L+V5OBlrSijgajTNurnQay9lMs3gPDhok9MzX2YkBuHW2y9CqV0Eti8SmcRd7k5cJn+X0NicmgNui3KQHxolMNdx7MenM96dgmzmgD5rJbWVgd57FOtzLgDfyGW6EsKY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YMkEJ0JJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YMkEJ0JJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BC9F1F00893;
	Sat, 30 May 2026 18:10:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780164627;
	bh=W7lx938apYuxNb34ZCZ4M3x1e+sRsINYiOXsSvaBOSI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YMkEJ0JJ7TDQkBs3aUPmPplU8gcQkWe38PEFNsRYt30PKHoheuXb/kI/eHh4rKE5h
	 4Dbw1wawKEHXZA+1z4LRBQllBAYxMlm/SXT5WA+80VFUuz0K+VowkaylyN8OslbEqa
	 kPn9nypO+VjH39SPd4q7V7qilrbLaVVSyeilnuSw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Enze Li <lienze@kylinos.cn>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 611/776] scsi: sr: Add memory allocation failure handling for get_capabilities()
Date: Sat, 30 May 2026 18:05:25 +0200
Message-ID: <20260530160255.800368334@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160240.228940103@linuxfoundation.org>
References: <20260530160240.228940103@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Enze Li <lienze@kylinos.cn>

[ Upstream commit ebc95c790653508ad7e031cfb9de5d0fa39135e2 ]

The function get_capabilities() has the possibility of failing to allocate
the transfer buffer but it does not currently handle this. This may lead to
exceptions when accessing the buffer.

Add error handling when memory allocation fails.

Link: https://lore.kernel.org/r/20220427025647.298358-1-lienze@kylinos.cn
Signed-off-by: Enze Li <lienze@kylinos.cn>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Stable-dep-of: 0898a817621a ("cdrom, scsi: sr: propagate read-only status to block layer via set_disk_ro()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/sr.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/sr.c b/drivers/scsi/sr.c
index af210910dadf2..529d4169b373b 100644
--- a/drivers/scsi/sr.c
+++ b/drivers/scsi/sr.c
@@ -118,7 +118,7 @@ static int sr_open(struct cdrom_device_info *, int);
 static void sr_release(struct cdrom_device_info *);
 
 static void get_sectorsize(struct scsi_cd *);
-static void get_capabilities(struct scsi_cd *);
+static int get_capabilities(struct scsi_cd *);
 
 static unsigned int sr_check_events(struct cdrom_device_info *cdi,
 				    unsigned int clearing, int slot);
@@ -710,8 +710,9 @@ static int sr_probe(struct device *dev)
 
 	sdev->sector_size = 2048;	/* A guess, just in case */
 
-	/* FIXME: need to handle a get_capabilities failure properly ?? */
-	get_capabilities(cd);
+	error = -ENOMEM;
+	if (get_capabilities(cd))
+		goto fail_minor;
 	sr_vendor_init(cd);
 
 	set_capacity(disk, cd->capacity);
@@ -831,7 +832,7 @@ static void get_sectorsize(struct scsi_cd *cd)
 	return;
 }
 
-static void get_capabilities(struct scsi_cd *cd)
+static int get_capabilities(struct scsi_cd *cd)
 {
 	unsigned char *buffer;
 	struct scsi_mode_data data;
@@ -856,7 +857,7 @@ static void get_capabilities(struct scsi_cd *cd)
 	buffer = kmalloc(512, GFP_KERNEL);
 	if (!buffer) {
 		sr_printk(KERN_ERR, cd, "out of memory.\n");
-		return;
+		return -ENOMEM;
 	}
 
 	/* eat unit attentions */
@@ -876,7 +877,7 @@ static void get_capabilities(struct scsi_cd *cd)
 				 CDC_MRW | CDC_MRW_W | CDC_RAM);
 		kfree(buffer);
 		sr_printk(KERN_INFO, cd, "scsi-1 drive");
-		return;
+		return 0;
 	}
 
 	n = data.header_length + data.block_descriptor_length;
@@ -935,6 +936,7 @@ static void get_capabilities(struct scsi_cd *cd)
 	}
 
 	kfree(buffer);
+	return 0;
 }
 
 /*
-- 
2.53.0



