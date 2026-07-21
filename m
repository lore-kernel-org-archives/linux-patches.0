Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 421A746EC8A;
	Tue, 21 Jul 2026 18:38:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784659111; cv=none; b=ULhp3YDTQTT5goTYagIMX0dt4gvLUkNnokH/EzrmBFhXV0Kxy7/YnwVKQgx9W1x32QDCAPvqJQEmRq5vqOoyeuSOIGkNOZy6X5G7LstNfjKnWMdgk+KcxV/nD282DeTo6CrOXCkND5LgvXMDRnJ+m6sCChj3Sjr/+2Yk4QHWLuw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784659111; c=relaxed/simple;
	bh=cw1NCQcWpiKBml7MhGRCNbshYBaesHtI2OBhtUbD5DA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JfsqSOn17DYHZpcrplCIQVuEFFuC/Is5h2HIUWeU6pjOpQN4bFXpZd9etIc8u3mrF/5kdNnrLUwGTFKVw9/10xKYi2/iejHAZxhC516EBt8csmLFOP5kmWJz4A2Ksj1dDkGpEHrPz+gNEUeS7oRJUA94FUhixgoPPoVbLvF+N/I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Oy1Tsi7U; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Oy1Tsi7U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F5E71F00AC4;
	Tue, 21 Jul 2026 18:38:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784659109;
	bh=ETuuHXN/851qGp10ODLMlMAaLYdeh0p9x6TyTjTkP1Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Oy1Tsi7U/iK8OxUuhMR8Sk4y3CFQf5+wnRwmsePawV2oSTLUiWZHAJI2cBERQR80I
	 nrLIc1N2g9wJSgeRyJMX7gJ+5vG4u+yiqeoHa02/YvsMLQodXb5Zat0JlW7KBo+ajE
	 96hT5sCSvPU56kq/LO7zWeJD5TbKzAdEBWt7cxCU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yitang Yang <yi1tang.yang@gmail.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.18 1343/1611] block: fix IORING_URING_CMD_REISSUE flags check in blkdev_uring_cmd
Date: Tue, 21 Jul 2026 17:24:19 +0200
Message-ID: <20260721152545.661997761@linuxfoundation.org>
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

From: Yitang Yang <yi1tang.yang@gmail.com>

commit 4f919141be38ea2b1314e3a531b7b998eb64e8bc upstream.

blkdev_uring_cmd() checks IORING_URING_CMD_REISSUE to determine whether
this is the first issue. However, this flag lives in cmd->flags instead
of issue_flags.

Coincidentally, IO_URING_F_NONBLOCK shares bit 31 with
IORING_URING_CMD_REISSUE. As a result, the SQE read was never performed,
bic->len remained zero, and every BLOCK_URING_CMD_DISCARD failed with
-EINVAL.

Fix it by checking cmd->flags as intended.

Cc: stable@vger.kernel.org
Fixes: 212ec34e4e72 ("block: only read from sqe on initial invocation of blkdev_uring_cmd")
Signed-off-by: Yitang Yang <yi1tang.yang@gmail.com>
Link: https://patch.msgid.link/20260616155129.406057-1-yi1tang.yang@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 block/ioctl.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/block/ioctl.c
+++ b/block/ioctl.c
@@ -857,7 +857,7 @@ int blkdev_uring_cmd(struct io_uring_cmd
 	u32 cmd_op = cmd->cmd_op;
 
 	/* Read what we need from the SQE on the first issue */
-	if (!(issue_flags & IORING_URING_CMD_REISSUE)) {
+	if (!(cmd->flags & IORING_URING_CMD_REISSUE)) {
 		const struct io_uring_sqe *sqe = cmd->sqe;
 
 		if (unlikely(sqe->ioprio || sqe->__pad1 || sqe->len ||


