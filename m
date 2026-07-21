Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C813B43F8AD;
	Tue, 21 Jul 2026 22:22:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784672553; cv=none; b=iAkrjK0V4WkdQmAUZDady7jhp6xaxkAeFIWqWEga28UPmZDLkDv2N2mKMYWKWM7mGlihpFSyEKSVBVA70h2qTILYDa3StTqBCWdLdb/MUnsJv6UdVoR7dCH4g0PnqxvStHtTFzzEOzACihMdHRNVAuvNuQk0jaYGeZCJSg7bJ6Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784672553; c=relaxed/simple;
	bh=qyBlfN0Qxbbz9WmZ2QY9dIrzMTcVQNjcHkBgVrlcAS0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=drWJzVSwQ3hU5S46AnCL4balFR7xfNjF33GfWvhxFifNYfZH7oLKjBkp/rR9cnrfsOGi+zRLRpTQnrlD2IwkjWxdLApIbgg8jcEZbdFnzSa6HKt9c150UAkQh+kb1e7E6ne2nk3fFqsMjR+h7EDXbcQ4K84+zjHGQ1LAxFBzdjY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IXX62lp5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IXX62lp5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 399FB1F000E9;
	Tue, 21 Jul 2026 22:22:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784672552;
	bh=+BTpKZGyIW0x0N74dl3WOYhftv2k2F9K75VaCXx0jJk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IXX62lp5zl8FrPZ+97vRwi0dLsmEDtp7DjzXRuNOaRwScanrrMlfB8qcyRl5tymSp
	 wFd/lw3k/PtMW44CnXgU77FuDHWzeChM/674/jjmGbZ4THoyGzmEi/sCk6Jz8UE7Zd
	 JrE6wb1jP8ppv6UH43gWycDrQCIVK4SARbOs6Ip0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haoxiang Li <haoxiang_li2024@163.com>,
	Daniel Wagner <dwagner@suse.de>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 5.15 667/843] scsi: elx: efct: Fix I/O leak on unsupported additional CDB
Date: Tue, 21 Jul 2026 17:25:02 +0200
Message-ID: <20260721152421.064802867@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
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


