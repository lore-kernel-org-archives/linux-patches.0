Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81BA9320CAD;
	Sat, 30 May 2026 17:51:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780163479; cv=none; b=t4hdW0ENIrqcTpOrPDk0nLwREkNJN9ZaYC7LBlm3p4DnO6Cxn2ZbCgvrS8MWIIKuQtje/olLhV1J7MsCBQM70kWRo6yMGtvZ0jlSUHaQDI5zTbaHGBqFvL22b/1kuROHJd0DqOUMJbHi9m5U3yku0xAvC2zrT3j9XMFsTOgmrGg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780163479; c=relaxed/simple;
	bh=5dSspy31LmzcEbBW7waHNnwqm4Fr0/Lm6dH7vhFH2y8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G/Tz70NQYPFEgwvxN/pCdYlT59V0zJdG5Ou4PA5ckamwS24/1OW/vt3JNXQwm7EEUzjsGS0HbJ5369Dh3hRsgVPiLHmbp1qMR6p49z965c2AOf3Myj58Fgkw5PiT7028KextI+D8R6aAKTAnXP98vcKr8D/oz4bZKOYpwC+CJCU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=V45iANe1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="V45iANe1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2F8A1F00893;
	Sat, 30 May 2026 17:51:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780163478;
	bh=gfmmLdmhyStrzR/gdPXXeyefTt8KC8/SvlqDaLumv/U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=V45iANe1IqQU2k9xOvi5QUNmiELcFKTSX/LRhUMEtMa51m7vnAOwVHPoPCF3IMy5m
	 t1Yyz3RGz8uHA2s4FSvvFaTKRN+XOfvPYvI3wu5G0I0zmvuf9pYS9rVn5Ys7RLfkPu
	 I44wxNSebARwISsss5HKiSPZiZZW+g/o/B3U1xoc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 5.15 271/776] scsi: target: configfs: Bound snprintf() return in tg_pt_gp_members_show()
Date: Sat, 30 May 2026 17:59:45 +0200
Message-ID: <20260530160247.562985595@linuxfoundation.org>
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

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

commit 772a896a56e0e3ef9424a025cec9176f9d8f4552 upstream.

target_tg_pt_gp_members_show() formats LUN paths with snprintf() into a
256-byte stack buffer, then will memcpy() cur_len bytes from that
buffer.  snprintf() returns the length the output would have had, which
can exceed the buffer size when the fabric WWN is long because iSCSI IQN
names can be up to 223 bytes.  The check at the memcpy() site only
guards the destination page write, not the source read, so memcpy() will
read past the stack buffer and copy adjacent stack contents to the sysfs
reader, which when CONFIG_FORTIFY_SOURCE is enabled, fortify_panic()
will be triggered.

Commit 27e06650a5ea ("scsi: target: target_core_configfs: Add length
check to avoid buffer overflow") added the same bound to the
target_lu_gp_members_show() but the tg_pt_gp variant was missed so
resolve that here.

Cc: Martin K. Petersen <martin.petersen@oracle.com>
Fixes: c66ac9db8d4a ("[SCSI] target: Add LIO target core v4.0.0-rc6")
Assisted-by: gregkh_clanker_t1000
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Link: https://patch.msgid.link/2026041159-garter-theft-3be0@gregkh
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/target/target_core_configfs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/target/target_core_configfs.c
+++ b/drivers/target/target_core_configfs.c
@@ -3078,7 +3078,7 @@ static ssize_t target_tg_pt_gp_members_s
 			config_item_name(&lun->lun_group.cg_item));
 		cur_len++; /* Extra byte for NULL terminator */
 
-		if ((cur_len + len) > PAGE_SIZE) {
+		if (cur_len > TG_PT_GROUP_NAME_BUF || (cur_len + len) > PAGE_SIZE) {
 			pr_warn("Ran out of lu_gp_show_attr"
 				"_members buffer\n");
 			break;


