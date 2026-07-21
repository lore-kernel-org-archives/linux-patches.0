Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01BFC46D2A4;
	Tue, 21 Jul 2026 18:37:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784659050; cv=none; b=fwwWOryN+9fKE9n7hhSVxBy+NFmOivH6FgIsm4C2VH3Y+wYjMcBQlow1ZMUP9MCBM9FUBio3LdTp2dYTZzfk0BQFxwTMrxsi7LjxdxvWED2nm1cwUR2M43Exzad7eb3t7gDzfHsJQ16EASIMTjuBLBV8E/cuR1BKX9YufpoyFFY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784659050; c=relaxed/simple;
	bh=sdxRyceteZV13wlA97TbF2mXegbpuCTChowhYgX64Cs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UmCf5gmDXqq3GIYLo8SwW7X9cWpkIhqowRbathAu9GRUnd0dsKXI46k0joQTREJSAl8vep1zOwVK1XKcpLYoagR+Wlpyqyg4DdsnGI34NQx2tlrc3U8/MNQGBpme4Bc1rK0KLap4hYf47x69IPo2h+PGtbcOLddAYcG1krE4DC4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WqlB5kXh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WqlB5kXh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67A4C1F000E9;
	Tue, 21 Jul 2026 18:37:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784659048;
	bh=rx6IVKpe1asskwvCu/ZUBuoqKi8LUraJ4CrZpAGDUE0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WqlB5kXhlxTuXYaSokNyNScKYeXCOXrjQzqCEpbkSAhoREIKC5Ent1kHA9OvdLGqs
	 rfFsOmlA1WvFgVWiHPgwtSn9KXk7iHC3Er8Chzy/9i775MHCUKP0yh7vjK+TAm9jKb
	 1qIt5NN9rgvSOtlLK4tvh/H0B1xMT+Hg1Ah6u094=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haoxiang Li <haoxiang_li2024@163.com>,
	Daniel Wagner <dwagner@suse.de>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 6.18 1373/1611] scsi: elx: efct: Fix I/O leak on unsupported additional CDB
Date: Tue, 21 Jul 2026 17:24:49 +0200
Message-ID: <20260721152546.331186317@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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


