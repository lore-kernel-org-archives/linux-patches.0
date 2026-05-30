Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 068F639989B;
	Sat, 30 May 2026 18:31:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780165867; cv=none; b=ghSQlsCHk7H02YAz8BShs6GlZ30Y+Sf2O2byA0kCm9Pi2iS4REUPcTAKo1BRjcD2DqcU4YEkhot3ph/YxLq+3i6VedDHEk3WzBbgeXPAVnZMqoHeXReF/RPGsbc8hyj0lAWeyFMApjEWN1TKK64ThPP/lQ2OOPQusJepHWoKVNU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780165867; c=relaxed/simple;
	bh=Z8KRuH9M7iPLx5r4Ef+hPIRBoUWCJph6dnW1gzyZSIc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iP3Gk4Xygwv8qdUPka2dYc97FOEcHfnetSMhT7/B4RxNRa7k3ogSBrvMScZ0cMHCXk5e88tSwPW1yEFLcyDlD8mUBz3yn2nr/XabHh6OVhWvmLeUAT4ntsrucrm3hzdQWtgxCAd69Xqbss9K944SCZ0L2xBk45nErlLA61A3jt4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zushqdgn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zushqdgn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E14041F00898;
	Sat, 30 May 2026 18:31:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780165865;
	bh=LqAAMTuw3VNVC+OyPZEwT09cRdU1feVgRRqFtye/5vU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zushqdgnnZ6PtiYkPgQHFjxwxnX7cmnSsfwWt8Kcfgrt14+2AMiJVdGnvgIBnh5eu
	 CQtQ1a7NwAFecSIPGDPNZEbDof1nXtAYCt7cUNP/oVQ+AEJZp1MT1Kk+8XyixHf+W/
	 uHt8bV1tp7rZGpl6Ano8zn5DbYJ1RADrEEjJsg7A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 5.10 204/589] scsi: target: configfs: Bound snprintf() return in tg_pt_gp_members_show()
Date: Sat, 30 May 2026 18:01:25 +0200
Message-ID: <20260530160230.297935380@linuxfoundation.org>
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
@@ -3043,7 +3043,7 @@ static ssize_t target_tg_pt_gp_members_s
 			config_item_name(&lun->lun_group.cg_item));
 		cur_len++; /* Extra byte for NULL terminator */
 
-		if ((cur_len + len) > PAGE_SIZE) {
+		if (cur_len > TG_PT_GROUP_NAME_BUF || (cur_len + len) > PAGE_SIZE) {
 			pr_warn("Ran out of lu_gp_show_attr"
 				"_members buffer\n");
 			break;


