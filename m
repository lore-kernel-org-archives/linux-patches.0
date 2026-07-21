Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CEC246F49C;
	Tue, 21 Jul 2026 19:59:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784663969; cv=none; b=qDq9z7TMQbEx0M3ab5n2FiBN11XL64a3riE9qVQPMWkuGBlFDwN2p8j8vG29FdSofQjE4noqpiHMLVuh/vpcHso4fE+RbdN4crS7MoEdykZ2dUN3JcMa9v6yhI1E899qkUXQzFBy8tx7LF2sRR5/L3R+8XYGAiA5GblLFWe1tVc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784663969; c=relaxed/simple;
	bh=CpkaD4QszxdAEQ6nyJPtSBsaRqHQyG7Dkb+18opMTK8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dPdR7nPGpH89tGQ20uXjQv1gVl354yTX5VcKggFxnM6K7znm15kYxx2h7loOUksgMc/BXQKO/+oe9623Nw11XZIrjSP+u/PHAft9AXwm+de/nRe3hylr3JsBuNVUDkrwTE3U1EAQOHtRI79TwFkF9IdZ1dWKhwmJ4vq4FRsyA9I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BawNt4yM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BawNt4yM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0FFF1F00A3A;
	Tue, 21 Jul 2026 19:59:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784663967;
	bh=aRadATfH3XU9BMKjN1lRX8Eg6slDqvC3dTx1R6RkxC8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BawNt4yMAJx/sKFGXuOg3Cfj3k9lYjhTsHmronr57KxATXH2bd1ad8M9qUjvkC8Dw
	 iCng0dD8ex6t1LptbATzEaoXBX1ulibywb2uBjbZOqmLFXAEyajL9eQ3tZBo7Pi/A5
	 qfFYqCaoJdv+TQj60bEQN5ElDEky0Te6Fh8pOtAk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haoxiang Li <haoxiang_li2024@163.com>,
	Daniel Wagner <dwagner@suse.de>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 6.12 1024/1276] scsi: elx: efct: Fix I/O leak on unsupported additional CDB
Date: Tue, 21 Jul 2026 17:24:27 +0200
Message-ID: <20260721152508.912124158@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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


