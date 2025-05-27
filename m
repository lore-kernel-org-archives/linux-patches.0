Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAD973C01;
	Tue, 27 May 2025 17:36:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748367392; cv=none; b=jYHFOKZ96VVOOhJD4hxshbW/lr0UeXh6d8ibENV1j5yAjj95ZHXpNG8IW8fh/j2U7W3awg2K1wpyz3S+QovjRAFvM49/qfEQdYurFbH3jrf90A8bphI3qJFM8evWOST5wziw512U3DVnVs0NP5NgDrUHK06EL51UWUgmK0lb9YQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748367392; c=relaxed/simple;
	bh=gVFYw8x2d1WgQjDXTqo6dOqW/0ZT5ELNPck07e6t7/M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Wz+LaqMH2vAlFp8efph8FzbNqF1SuiC2XK7WaaNbEvkCeMp2H/9b/3YRCutuGyPnag+QYRg8k8EOH2tr9deubu3naszhc3ZGyapm3v1z0DKFeOK1ewFLOGeDvwvNC5hzueoEUa8e6H7hObpvQjz/WF8VJIS/S/tu0ErazQucCzI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wD2+xRmi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wD2+xRmi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F8B4C4CEE9;
	Tue, 27 May 2025 17:36:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748367391;
	bh=gVFYw8x2d1WgQjDXTqo6dOqW/0ZT5ELNPck07e6t7/M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wD2+xRmi4vlNPmlmUvieTvD1AGb8D6POstdY9h0Kvd1gDjS265hewVcWvf+7udoDk
	 O4qvLfKoKIpvYaGpaafs3ZSA2ebJvzSHnOhnS7sRKfAQIpMuucvdgEel9eeQItLrox
	 cl2fqPukjuAu+LqiXJGODGi/TCeJAILDd3TEJKzI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Kai=20M=C3=A4kisara?= <Kai.Makisara@kolumbus.fi>,
	John Meneghini <jmeneghi@redhat.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 372/783] scsi: scsi_debug: First fixes for tapes
Date: Tue, 27 May 2025 18:22:49 +0200
Message-ID: <20250527162528.236935042@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kai Mäkisara <Kai.Makisara@kolumbus.fi>

[ Upstream commit f69da85d5d5cc5b7dfb963a6c6c1ac0dd9002341 ]

Patch includes the following:

 - Enable MODE SENSE/SELECT without actual page (to read/write only the
   Block Descriptor)

 - Store the density code and block size in the Block Descriptor (only
   short version for tapes)

 - Fix REWIND not to use the wrong page filling function

Signed-off-by: Kai Mäkisara <Kai.Makisara@kolumbus.fi>
Link: https://lore.kernel.org/r/20250213092636.2510-2-Kai.Makisara@kolumbus.fi
Reviewed-by: John Meneghini <jmeneghi@redhat.com>
Tested-by: John Meneghini <jmeneghi@redhat.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/scsi_debug.c | 55 ++++++++++++++++++++++++++++++++++-----
 1 file changed, 49 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 5ceaa4665e5df..4da0c259390b5 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -173,6 +173,10 @@ static const char *sdebug_version_date = "20210520";
 #define DEF_ZBC_MAX_OPEN_ZONES	8
 #define DEF_ZBC_NR_CONV_ZONES	1
 
+/* Default parameters for tape drives */
+#define TAPE_DEF_DENSITY  0x0
+#define TAPE_DEF_BLKSIZE  0
+
 #define SDEBUG_LUN_0_VAL 0
 
 /* bit mask values for sdebug_opts */
@@ -363,6 +367,10 @@ struct sdebug_dev_info {
 	ktime_t create_ts;	/* time since bootup that this device was created */
 	struct sdeb_zone_state *zstate;
 
+	/* For tapes */
+	unsigned int tape_blksize;
+	unsigned int tape_density;
+
 	struct dentry *debugfs_entry;
 	struct spinlock list_lock;
 	struct list_head inject_err_list;
@@ -773,7 +781,7 @@ static const struct opcode_info_t opcode_info_arr[SDEB_I_LAST_ELEM_P1 + 1] = {
 /* 20 */
 	{0, 0x1e, 0, 0, NULL, NULL, /* ALLOW REMOVAL */
 	    {6,  0, 0, 0, 0x3, 0xc7, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0} },
-	{0, 0x1, 0, 0, resp_start_stop, NULL, /* REWIND ?? */
+	{0, 0x1, 0, 0, NULL, NULL, /* REWIND ?? */
 	    {6,  0x1, 0, 0, 0, 0xc7, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0} },
 	{0, 0, 0, F_INV_OP | FF_RESPOND, NULL, NULL, /* ATA_PT */
 	    {0,  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0} },
@@ -2742,7 +2750,7 @@ static int resp_mode_sense(struct scsi_cmnd *scp,
 	unsigned char *ap;
 	unsigned char *arr __free(kfree);
 	unsigned char *cmd = scp->cmnd;
-	bool dbd, llbaa, msense_6, is_disk, is_zbc;
+	bool dbd, llbaa, msense_6, is_disk, is_zbc, is_tape;
 
 	arr = kzalloc(SDEBUG_MAX_MSENSE_SZ, GFP_ATOMIC);
 	if (!arr)
@@ -2755,7 +2763,8 @@ static int resp_mode_sense(struct scsi_cmnd *scp,
 	llbaa = msense_6 ? false : !!(cmd[1] & 0x10);
 	is_disk = (sdebug_ptype == TYPE_DISK);
 	is_zbc = devip->zoned;
-	if ((is_disk || is_zbc) && !dbd)
+	is_tape = (sdebug_ptype == TYPE_TAPE);
+	if ((is_disk || is_zbc || is_tape) && !dbd)
 		bd_len = llbaa ? 16 : 8;
 	else
 		bd_len = 0;
@@ -2793,15 +2802,25 @@ static int resp_mode_sense(struct scsi_cmnd *scp,
 			put_unaligned_be32(0xffffffff, ap + 0);
 		else
 			put_unaligned_be32(sdebug_capacity, ap + 0);
-		put_unaligned_be16(sdebug_sector_size, ap + 6);
+		if (is_tape) {
+			ap[0] = devip->tape_density;
+			put_unaligned_be16(devip->tape_blksize, ap + 6);
+		} else
+			put_unaligned_be16(sdebug_sector_size, ap + 6);
 		offset += bd_len;
 		ap = arr + offset;
 	} else if (16 == bd_len) {
+		if (is_tape) {
+			mk_sense_invalid_fld(scp, SDEB_IN_DATA, 1, 4);
+			return check_condition_result;
+		}
 		put_unaligned_be64((u64)sdebug_capacity, ap + 0);
 		put_unaligned_be32(sdebug_sector_size, ap + 12);
 		offset += bd_len;
 		ap = arr + offset;
 	}
+	if (cmd[2] == 0)
+		goto only_bd; /* Only block descriptor requested */
 
 	/*
 	 * N.B. If len>0 before resp_*_pg() call, then form of that call should be:
@@ -2902,6 +2921,7 @@ static int resp_mode_sense(struct scsi_cmnd *scp,
 	default:
 		goto bad_pcode;
 	}
+only_bd:
 	if (msense_6)
 		arr[0] = offset - 1;
 	else
@@ -2945,8 +2965,27 @@ static int resp_mode_select(struct scsi_cmnd *scp,
 			    __func__, param_len, res);
 	md_len = mselect6 ? (arr[0] + 1) : (get_unaligned_be16(arr + 0) + 2);
 	bd_len = mselect6 ? arr[3] : get_unaligned_be16(arr + 6);
-	off = bd_len + (mselect6 ? 4 : 8);
-	if (md_len > 2 || off >= res) {
+	off = (mselect6 ? 4 : 8);
+	if (sdebug_ptype == TYPE_TAPE) {
+		int blksize;
+
+		if (bd_len != 8) {
+			mk_sense_invalid_fld(scp, SDEB_IN_DATA,
+					mselect6 ? 3 : 6, -1);
+			return check_condition_result;
+		}
+		blksize = get_unaligned_be16(arr + off + 6);
+		if ((blksize % 4) != 0) {
+			mk_sense_invalid_fld(scp, SDEB_IN_DATA, off + 6, -1);
+			return check_condition_result;
+		}
+		devip->tape_density = arr[off];
+		devip->tape_blksize = blksize;
+	}
+	off += bd_len;
+	if (off >= res)
+		return 0; /* No page written, just descriptors */
+	if (md_len > 2) {
 		mk_sense_invalid_fld(scp, SDEB_IN_DATA, 0, -1);
 		return check_condition_result;
 	}
@@ -5835,6 +5874,10 @@ static struct sdebug_dev_info *sdebug_device_create(
 		} else {
 			devip->zoned = false;
 		}
+		if (sdebug_ptype == TYPE_TAPE) {
+			devip->tape_density = TAPE_DEF_DENSITY;
+			devip->tape_blksize = TAPE_DEF_BLKSIZE;
+		}
 		devip->create_ts = ktime_get_boottime();
 		atomic_set(&devip->stopped, (sdeb_tur_ms_to_ready > 0 ? 2 : 0));
 		spin_lock_init(&devip->list_lock);
-- 
2.39.5



