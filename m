Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB29C34B19F;
	Wed,  8 Apr 2026 18:51:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775674270; cv=none; b=NsilKwxTsAf/kRe7P5pLfcb7Pr9LXWHV76/X/g0OHtA4bbU7m5Gsp9MTyNDXpoD3s1isP/4XIlN1FaaWOUa/nJRVtxqUdF4bAl62fCAscRVy78ua0gGuwvxNqYr66UOPM9uaNUhh1q3/2zBjLDj4ZnWQVNUjN7vA7kxBRIaZbyw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775674270; c=relaxed/simple;
	bh=nH0XVTqeSA57cor7xfy10mY6wsMko0aqPQNESwqDQyo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WHG2NWjj644Nnfi1cHUq4YbDe8tvmLr5neIyiejKXzui+dLD9g9vhzbfKPjAnR15mmvYKG4VQQBmjp4iwVXj6xWlHbqv+L6nziv2l+00a3iQgb0hKWJTjRiSQjI6gaQbJqzhx1xrd0bwIyQphTkvpJzw5LqpCFU7qK8m1jrpgv0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=j5CY2tRn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j5CY2tRn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1920CC19421;
	Wed,  8 Apr 2026 18:51:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775674270;
	bh=nH0XVTqeSA57cor7xfy10mY6wsMko0aqPQNESwqDQyo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=j5CY2tRnU852yX+9O1Lh20N16rACRk6s5T4yQII5t7yfkzps3Za4f12EZ6uWhNF7n
	 sUqMDGQQeYJAk3v8Z7DAPYyiULTDGzwZEPc72h6EcRYiKElddP7o2bfKV2PWFG7Nu2
	 1eY3d/WShMQ5ub9cgzFaZscj/yDyGcvCwRAYyOTg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thinh Nguyen <Thinh.Nguyen@synopsys.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 004/311] scsi: target: file: Use kzalloc_flex for aio_cmd
Date: Wed,  8 Apr 2026 20:00:04 +0200
Message-ID: <20260408175939.567077822@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175939.393281918@linuxfoundation.org>
References: <20260408175939.393281918@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

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
 


