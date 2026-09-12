Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C03C1F1534;
	Sat, 12 Sep 2026 08:29:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789201784; cv=none; b=dQrjkIoRQxABkwULN71eqqcGxN+RQ5CZ/1ByqhBuWFCOYPpfktjZmZ0fIJmhmVWD/wcDx/D5yYWUq8lzTAN1ypDJKXRH85ak8+SEtl4IWbvRXSGbrDNJnw6nwPmYMJL7aaqfnagYaDnLGA+3y8Xfd/aCZxxY+5hTyZsEzBGva28=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789201784; c=relaxed/simple;
	bh=LJYlNu1FUQIEDN7uN8e29aXvCICqOie6CeTGLCJqxbI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BBDiR5hUfij/1tmhETkINbSTU/YWy7E7RsJghGT5WGiGQIo3thTS6RDY771Bze9y0rYFQLuwoGWJKL7XexxM3pU9+AfiWDLTpE+3tL1LJlJQn/XfhihYt1F8MweX5j/NqshoqU5mh7kz7bWF+flzVSwuU2NTeNE3rW6MdCUEles=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EAF5MmiT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EAF5MmiT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9B421F000FF;
	Sat, 12 Sep 2026 08:29:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789201783;
	bh=nROhpUSgVT8Tj/VR+XAgKI3E9vK2KL9Ume8iBVJd2gk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EAF5MmiTd7+TyufkahgMX9nAOvzX6I9EJFn46WpJ+waK2eCDeiwN5oKwvUq5lic53
	 M0cURSTcvP1TokG1CDh3nmD1ufWO1dlgDiviOtcwKvbmWKjVkUb64tOPLIn/k1NqmQ
	 H4P6iFJ9/l5imwKuUHlv2Qqj7RYrAglffE7S5dfw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Xiuwei <yangxiuwei@kylinos.cn>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1050/1815] ublk: clear auto buf reg before updating io->buf in batch commit
Date: Sat, 12 Sep 2026 08:46:40 +0200
Message-ID: <20260912065713.666835347@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yang Xiuwei <yangxiuwei@kylinos.cn>

[ Upstream commit af0955c8f26aa0f02e534084bc9948a69c9e7ce0 ]

ublk_batch_commit_io() stored the new auto_buf into io->buf before
calling ublk_clear_auto_buf_reg(). Clear takes the unregister index
from io->buf.auto_reg, so it could drop the new slot and leave the
old registered buffer behind.

Fixes: 1e500e106d5a ("ublk: handle UBLK_U_IO_COMMIT_IO_CMDS")
Signed-off-by: Yang Xiuwei <yangxiuwei@kylinos.cn>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/ublk_drv.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/block/ublk_drv.c b/drivers/block/ublk_drv.c
index 1fc6449431910..a5b120b42e493 100644
--- a/drivers/block/ublk_drv.c
+++ b/drivers/block/ublk_drv.c
@@ -3800,11 +3800,11 @@ static int ublk_batch_commit_io(struct ublk_queue *ubq,
 	ret = ublk_batch_commit_io_check(ubq, io, &buf);
 	if (!ret) {
 		io->res = elem->result;
-		io->buf = buf;
 		req = ublk_fill_io_cmd(io, data->cmd);
 
 		if (auto_reg)
 			ublk_clear_auto_buf_reg(io, data->cmd, &buf_idx);
+		io->buf = buf;
 		compl = ublk_need_complete_req(data->ub, io);
 	}
 	ublk_io_unlock(io);
-- 
2.53.0



