Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063368;
	b=xlJGvQfKXe1YESNk6qhmkiL9TEvcTgY/ja4ielgq05/oYMNYldQqJFT6i0Bn8bRGqggG
	 Batt1Sz0i25Ftb+W8zf1HkbhlUFOKlAl2PuoSVMl3DakvU2oJXlTP43+up+mpR7IVuL3F
	 tMVop+oourbL+o5mirTjGNpP0uy31B4IRh3GHEPyntBKZ3DdUTudjXvePcL0aj07oFTnm
	 aVOLZaa132nagBrtwGNnGY5RVruaKuVQTzeH+7yUOdIN4L2+8QwVjDUW6NNAKynAErUkT
	 c16VcUrSynafgdKRUXP8irv1DNkHzZ/V+ZDQRhoZUTmZK7QtdWMIF7ycZtuKZnVWrhQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063368;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=elIJzfjqiIwo22e01ewQQ2wZj4GND9bMWax65daebzM=;
	b=5HzIS2QPZm06PrJqCiAmXOlohlyJSbiDbPGLcFZO1lhpVyUX7rHSZPikZ+RzTDMjiups
	 xu5r+/4Mc2ItyoHAUeue9eDb6zupgWDLPsfqpB4yV8PvE/s8YRUI/bVrzoUfrDkc+SLZv
	 KpVkhoOskGr8rRG3SRv0zro92AeHCoDC7ztaqM76BGPIv0bB2BV7zFfsH+WYbLRe8xm0V
	 P7rXx35Oe+aGmlJL5K7o5jmWcStC20IGP4+jMbDRApxgmhY2VN0AIa2cGBqaBEdDraUhQ
	 Z/PatS3ug3NQj0JM9F4toDxW1iNBaxmbSWHIssb2T1hGucMbNixGp6MUCzgTxlxTW2Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GoMDv4dF;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DC15606D81A;
	Sat,  7 Nov 2026 14:56:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GoMDv4dF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B8521F0089F;
	Sat,  7 Nov 2026 14:56:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063368;
	bh=elIJzfjqiIwo22e01ewQQ2wZj4GND9bMWax65daebzM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GoMDv4dFw9lGuVg8bLO9TL5rbuKGTNHqau8Hg4OcomJgjV+aNJSxVfJfTndhoPcQk
	 TPBwwWruVHMeVo1SM/kqhIMi2hZjvzUwkz/v3NpXeJ9CnlKFpcGQDbAEXqlJNy7gk6
	 5EjAtuxhi5Q7irhqxL21ZrNALBT5rX1RlsWUICX8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	=?UTF-8?q?J=C3=A9r=C3=A9my=20Jean?= <Jeremy.Jean@oss.cyber.gouv.fr>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 518/869] nvmet: free the bvec on file namespace range errors
Date: Sat,  7 Nov 2026 08:53:20 -0500
Message-ID: <20261107134911.095684365@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jérémy Jean <Jeremy.Jean@oss.cyber.gouv.fr>

[ Upstream commit 9d820d55b3cb4859c7cf42a74dc78f6154f97398 ]

nvmet_file_execute_rw() allocates the bvec before
nvmet_file_execute_io() checks whether the request fits in the backing
file. If the request extends beyond the file, nvmet_file_execute_io()
calls nvmet_req_complete() to return an error. This skips
nvmet_file_io_done(), so the allocated memory is never freed. Repeated
requests can exhaust memory.

Use nvmet_file_io_done() to free the bvec before returning the range
error to the client.

Fixes: 50a909db36f2 ("nvmet: use IOCB_NOWAIT for file-ns buffered I/O")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Jérémy Jean <Jeremy.Jean@oss.cyber.gouv.fr>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/target/io-cmd-file.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/nvme/target/io-cmd-file.c b/drivers/nvme/target/io-cmd-file.c
index 2d068439b129c..6e14700164724 100644
--- a/drivers/nvme/target/io-cmd-file.c
+++ b/drivers/nvme/target/io-cmd-file.c
@@ -133,8 +133,8 @@ static bool nvmet_file_execute_io(struct nvmet_req *req, int ki_flags)
 
 	pos = le64_to_cpu(req->cmd->rw.slba) << req->ns->blksize_shift;
 	if (unlikely(pos + req->transfer_len > req->ns->size)) {
-		nvmet_req_complete(req, errno_to_nvme_status(req, -ENOSPC));
-		return true;
+		ret = -ENOSPC;
+		goto complete;
 	}
 
 	memset(&req->f.iocb, 0, sizeof(struct kiocb));
-- 
2.53.0



