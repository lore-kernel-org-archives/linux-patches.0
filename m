Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 208503624B0;
	Wed,  8 Apr 2026 18:39:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775673542; cv=none; b=M6ifdusMRES6dgJMKQVcuq0nfECU83F5HXsESsl0LkTUXUDcqXfJB6lYHTJXLxK2JTVPPT4zxlWoLEV8U+aW211FKNnYejRv+lUd+jRADITyQZBgSaXN9/R+x5Z3/ez71IqIJig6OiLIOKfph0aP0iiBfUltbQvnr2aF0QgOjDA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775673542; c=relaxed/simple;
	bh=VcvZyT5lYfiG6eR8yv7LUiymJFGCof/5+nK9BGXbudo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hGb/F3q/mNoYRSoPoLS6gf8MBIBR4AmbcmFUcLwk/IXTUpEA2V1WmNNiPaXrgWTLViigcpX4oLPpI+c7RzcDz4Kw6Z1hUFwqBzqH7JA/KLFnirdUqxQHT2C0NDhkjwCrgmOfVegANZ1kFuFDPXzk8Qr11YYM8Sbh2S3X2ezpg18=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=E5MSCQQq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="E5MSCQQq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AABFFC19421;
	Wed,  8 Apr 2026 18:39:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775673542;
	bh=VcvZyT5lYfiG6eR8yv7LUiymJFGCof/5+nK9BGXbudo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=E5MSCQQqw+vrwejB/hC7JAEMiYtnL4eQy6wbUtanARHtoBYPUhbLvBoHk+mq0J6SY
	 0a0A7mKlJitkpT3NrmFEF6kBbCqQmQYXAsomrVILcWlAELoctjem9Cg0oFqjXi+gDy
	 hOFdqGuoL4wkEwLzOGZK7AAl33GbvY6lR0S7a/G8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thinh Nguyen <Thinh.Nguyen@synopsys.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 272/277] scsi: target: file: Use kzalloc_flex for aio_cmd
Date: Wed,  8 Apr 2026 20:04:17 +0200
Message-ID: <20260408175944.022475855@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175933.836769063@linuxfoundation.org>
References: <20260408175933.836769063@linuxfoundation.org>
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

From: Thinh Nguyen <Thinh.Nguyen@synopsys.com>

[ Upstream commit 01f784fc9d0ab2a6dac45ee443620e517cb2a19b ]

The target_core_file doesn't initialize the aio_cmd->iocb for the
ki_write_stream. When a write command fd_execute_rw_aio() is executed,
we may get a bogus ki_write_stream value, causing unintended write
failure status when checking iocb->ki_write_stream > max_write_streams
in the block device.

Let's just use kzalloc_flex when allocating the aio_cmd and let
ki_write_stream=0 to fix this issue.

Fixes: 732f25a2895a ("fs: add a write stream field to the kiocb")
Fixes: c27683da6406 ("block: expose write streams for block device nodes")
Cc: stable@vger.kernel.org
Signed-off-by: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Link: https://patch.msgid.link/f1a2f81c62f043e31f80bb92d5f29893400c8ee2.1773450782.git.Thinh.Nguyen@synopsys.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
[ changed kmalloc() to kzalloc() ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/target/target_core_file.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/target/target_core_file.c
+++ b/drivers/target/target_core_file.c
@@ -276,7 +276,7 @@ fd_execute_rw_aio(struct se_cmd *cmd, st
 	ssize_t len = 0;
 	int ret = 0, i;
 
-	aio_cmd = kmalloc(struct_size(aio_cmd, bvecs, sgl_nents), GFP_KERNEL);
+	aio_cmd = kzalloc(struct_size(aio_cmd, bvecs, sgl_nents), GFP_KERNEL);
 	if (!aio_cmd)
 		return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
 


