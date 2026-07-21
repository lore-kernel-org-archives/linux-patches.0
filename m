Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF1063C0617;
	Tue, 21 Jul 2026 21:44:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784670246; cv=none; b=jVHmi2moz7gYmdBP9b57lq0jLTGHnQz1SLYZAlovDNeHmuNwATy7zGl7vzGDUrxCJD7r6xB+s5FPMT03pMjoEloPGiigPil8J1PGLBRE9VwZgHr5X202jmBRuKUQ1UOOleEB1Zb4Ja3xxt3t7+rbeVPM5YsYbHaM7b0k6bC7RLM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784670246; c=relaxed/simple;
	bh=2syOiSPGKmGIM5nwams+I1hIo8KHGmR6L5SDWf5D9RM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rk+bYY7Xu2WBeB3Oxf3N09/zKW0vz0BSXzaYJHxpr1p6BenX3ta2hFnDw8QgDIMXkYR5agmEyaPQHb68hf4U1FLuKEkDZbdnt4puRrV3CxtpTk/AcQP0aWsnJNii8txJrG/0SIATvPWG/bfTPjPxoanM0KrMCx2QSTmxeysszt4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uhqEgzm1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uhqEgzm1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 514841F000E9;
	Tue, 21 Jul 2026 21:44:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784670245;
	bh=T4ZLZbdkYQWVdxCFA9l1itYvar0OM9LwZX42g1ZXTVE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uhqEgzm1mr6bSRUkKqv2bBqjW2ZvqK/A5Y3rh3/buMRMI/YCQU1QvH47Sv/AhE3Kk
	 sAEOe319vg0acwsBFnyhTkd4/qUes5RyhPCX3xr+0KmWy5gXuLGtb38Pa1dO74MMIv
	 C2pl6Mas2FtNakFAo3hlop3Rfp5dQi1qzhJVRIHo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haoxiang Li <haoxiang_li2024@163.com>,
	Daniel Wagner <dwagner@suse.de>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 6.1 0860/1067] scsi: elx: efct: Fix I/O leak on unsupported additional CDB
Date: Tue, 21 Jul 2026 17:24:21 +0200
Message-ID: <20260721152443.780861185@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

From: Haoxiang Li <haoxiang_li2024@163.com>

commit 9cb2d5291dbfe7bed565ead3337047dee9ed1064 upstream.

efct_dispatch_fcp_cmd() allocates an efct_io before dispatching an
unsolicited FCP command. If the command has an unsupported additional
CDB, the function returns -EIO before handing the IO to the SCSI layer.

Free the allocated IO before returning from this error path.

Fixes: f45ae6aac0a0 ("scsi: elx: efct: Unsolicited FC frame processing routines")
Cc: stable@vger.kernel.org
Signed-off-by: Haoxiang Li <haoxiang_li2024@163.com>
Reviewed-by: Daniel Wagner <dwagner@suse.de>
Link: https://patch.msgid.link/20260622075844.832871-1-haoxiang_li2024@163.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/elx/efct/efct_unsol.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/scsi/elx/efct/efct_unsol.c
+++ b/drivers/scsi/elx/efct/efct_unsol.c
@@ -385,6 +385,7 @@ efct_dispatch_fcp_cmd(struct efct_node *
 
 		if (cmnd->fc_flags & FCP_CFL_LEN_MASK) {
 			efc_log_err(efct, "Additional CDB not supported\n");
+			efct_scsi_io_free(io);
 			return -EIO;
 		}
 		/*


