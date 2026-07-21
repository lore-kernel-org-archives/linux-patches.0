Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02834439904;
	Tue, 21 Jul 2026 20:59:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784667559; cv=none; b=TzhB19XPPVjpEkkOYEWt9nZDeTV720CK04rAQhdcGo0gjWkCaR5kJjhdb/sZPCZXYoNT/YXxH7F/j68u2gD2SrSx07Q95KJ0GKbqZ/wrSqn8DCwX8u4QTGqGhUg5Rnz9HXs2bCSN+r+4ojq4HlGvJqR38gSHdO8Yjm5k8uGJA4E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784667559; c=relaxed/simple;
	bh=EUQkxIDHb2QUNfIF+Wka+Gw2/NokcBRsoPIEEPHkwPA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=evLFLJLWAXgbxVpmaFBu9aACT2ct57Il+A4Omkaz+whO3v3BbyQX/9pFrztAA/PPmYyeLwH3O59aGjRXZwtw8hh9i5gujEb4+DVB7jyNv3+ZtEjETANvdYk9tugOUOIdetze5HXcYvI1i2fTyMIYMzqdDfEbqWwxWmYJtY+c7YA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vo3JS741; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vo3JS741"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28CC91F000E9;
	Tue, 21 Jul 2026 20:59:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784667556;
	bh=tKvC//l0yB0QM6g3SaeuUbx1ZUBDW1rTLexlwMsn+qo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vo3JS741tmAXXtGgPUOZf3WjPMYnsAMvO83q09AXQt2NfllBR6mkiviT39BaX1fJH
	 f4AnC1Y9wr8EA6/QPafEIHJmXKZMb946vZaU7egqCiTxLVM4vijdbPk6M2iLHvKTF0
	 hCGmI0bPi+oQrwbXx3EZN+Mek00U0bI0KksMcuts=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haoxiang Li <haoxiang_li2024@163.com>,
	Daniel Wagner <dwagner@suse.de>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 6.6 1064/1266] scsi: elx: efct: Fix I/O leak on unsupported additional CDB
Date: Tue, 21 Jul 2026 17:25:01 +0200
Message-ID: <20260721152505.631370231@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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


