Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0FF12343BE;
	Sat, 30 May 2026 18:46:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780166788; cv=none; b=EZ6/PmiiIw9Y6HeZiqAmWWJJ7IgnNf8F6rOCc5dc9cC36dfKIjSTwObw50kWhbxpFewGYtOBlRXNCjpb5VhbMYtwPfXiy7jDWT0nFfC57V+5kAsCiGWyYpjkORdWSlf1LjcCk83euQw80aMeGStMRemfaObLB+cX38UiFYQPjXo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780166788; c=relaxed/simple;
	bh=Vlzqe9CJBLh0ttjGZjx3DdPbF4FRuFdrHh4JVJOv6wQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V8kS6JQUD9SRxe6Qoe8MJACC1DDf8PwJe8YfKB7lXJ+6xAkAP36Emc9jFb6v6nfw9uG/jZ3O47OJlJsIXz6onZiE6TeYumhn1Zr5JBjW6ws7oa0DPL1HW/0EUA9f0/fvX3nAbos6M3X1r1BOW/RvUJ2rR3lTNtD7MUD88lD4sbU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=v7t+dKyR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v7t+dKyR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6B211F00898;
	Sat, 30 May 2026 18:46:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780166786;
	bh=ibnWn76zTF2udhAAXLek2FKgSNPVZwXKE9sCClxHFu4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=v7t+dKyRhddKFR2VJeIaGyhWqBeNsLSwQvKlaRYSMqMz+WrOG4FrEnJCh8epP0Y5x
	 8UHV9F/42TyFUTF5fCkX3CZGN1/6N9ND/hbZJInrSz4tdP2WYZoiBonM7Sem9kWZ6P
	 5LUZbOBcTvBkUpP5IuITkpzgkka4CzPMMuvkLTlM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Enze Li <lienze@kylinos.cn>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 470/589] scsi: sr: Add memory allocation failure handling for get_capabilities()
Date: Sat, 30 May 2026 18:05:51 +0200
Message-ID: <20260530160237.011390065@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160224.570625122@linuxfoundation.org>
References: <20260530160224.570625122@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 464418413ced0..62a1bf81f7e47 100644
--- a/drivers/scsi/sr.c
+++ b/drivers/scsi/sr.c
@@ -115,7 +115,7 @@ static int sr_open(struct cdrom_device_info *, int);
 static void sr_release(struct cdrom_device_info *);
 
 static void get_sectorsize(struct scsi_cd *);
-static void get_capabilities(struct scsi_cd *);
+static int get_capabilities(struct scsi_cd *);
 
 static unsigned int sr_check_events(struct cdrom_device_info *cdi,
 				    unsigned int clearing, int slot);
@@ -773,8 +773,9 @@ static int sr_probe(struct device *dev)
 
 	sdev->sector_size = 2048;	/* A guess, just in case */
 
-	/* FIXME: need to handle a get_capabilities failure properly ?? */
-	get_capabilities(cd);
+	error = -ENOMEM;
+	if (get_capabilities(cd))
+		goto fail_minor;
 	sr_vendor_init(cd);
 
 	set_capacity(disk, cd->capacity);
@@ -895,7 +896,7 @@ static void get_sectorsize(struct scsi_cd *cd)
 	return;
 }
 
-static void get_capabilities(struct scsi_cd *cd)
+static int get_capabilities(struct scsi_cd *cd)
 {
 	unsigned char *buffer;
 	struct scsi_mode_data data;
@@ -920,7 +921,7 @@ static void get_capabilities(struct scsi_cd *cd)
 	buffer = kmalloc(512, GFP_KERNEL);
 	if (!buffer) {
 		sr_printk(KERN_ERR, cd, "out of memory.\n");
-		return;
+		return -ENOMEM;
 	}
 
 	/* eat unit attentions */
@@ -940,7 +941,7 @@ static void get_capabilities(struct scsi_cd *cd)
 				 CDC_MRW | CDC_MRW_W | CDC_RAM);
 		kfree(buffer);
 		sr_printk(KERN_INFO, cd, "scsi-1 drive");
-		return;
+		return 0;
 	}
 
 	n = data.header_length + data.block_descriptor_length;
@@ -999,6 +1000,7 @@ static void get_capabilities(struct scsi_cd *cd)
 	}
 
 	kfree(buffer);
+	return 0;
 }
 
 /*
-- 
2.53.0



