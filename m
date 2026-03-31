Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F4D53E8C50;
	Tue, 31 Mar 2026 16:50:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774975816; cv=none; b=CSsvWqRxyevQfo1YazRdz7iUPoGexXdeg1Bg90cMbtjFHpdz5Y6IgLi/LO0IlLSXCVZS4to/bklYXvQCke0/MSNe2jJW3cP/nbAtxwY4PtsgPipBXBCxXRKR0epluniznbrNtgFdKQgV2NQccbiaxwlsBCMkggRBiHcgbkdCHYg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774975816; c=relaxed/simple;
	bh=Z0VkR3/1egvW2hGgD/GeIwvL6PfeCQd8uwnR7ugnksE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q75aaJzHZNoCE5Y227oPGE0eNwCj0Abccj5lUt4NDUCCmjs+M35WSs7GUXY241lT++rAaa3z3NNZ/5RP5B7rCEOrMrN+O6NpN4mLa/NyaTfcW27lMWTMNAcQRWnz+VgSw1IHwzEEVURBgyb6RoCm5QTJGLXKqffsAEmAzSvoSE0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d7eDtUvG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d7eDtUvG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC130C19423;
	Tue, 31 Mar 2026 16:50:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774975816;
	bh=Z0VkR3/1egvW2hGgD/GeIwvL6PfeCQd8uwnR7ugnksE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d7eDtUvGBSmFFCrS5hv5MUAx5goZUd8+TtQetvDe4reqHJ3tdg8MYLEmCNSpGQrrO
	 oV8TIkEX8VaG0kFIRyNenx372vrkrOa9OfsovWAgKRW+OnNlrYHATnw0cQeL5NY4Z9
	 u22FChYOsW6ZpBbJcjsH/z6auGfmJxLtacK3kcDc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qi Tang <tpluszz77@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 070/244] net/smc: fix double-free of smc_spd_priv when tee() duplicates splice pipe buffer
Date: Tue, 31 Mar 2026 18:20:20 +0200
Message-ID: <20260331161744.273123544@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161741.651718120@linuxfoundation.org>
References: <20260331161741.651718120@linuxfoundation.org>
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

From: Qi Tang <tpluszz77@gmail.com>

[ Upstream commit 24dd586bb4cbba1889a50abe74143817a095c1c9 ]

smc_rx_splice() allocates one smc_spd_priv per pipe_buffer and stores
the pointer in pipe_buffer.private.  The pipe_buf_operations for these
buffers used .get = generic_pipe_buf_get, which only increments the page
reference count when tee(2) duplicates a pipe buffer.  The smc_spd_priv
pointer itself was not handled, so after tee() both the original and the
cloned pipe_buffer share the same smc_spd_priv *.

When both pipes are subsequently released, smc_rx_pipe_buf_release() is
called twice against the same object:

  1st call: kfree(priv)  sock_put(sk)  smc_rx_update_cons()  [correct]
  2nd call: kfree(priv)  sock_put(sk)  smc_rx_update_cons()  [UAF]

KASAN reports a slab-use-after-free in smc_rx_pipe_buf_release(), which
then escalates to a NULL-pointer dereference and kernel panic via
smc_rx_update_consumer() when it chases the freed priv->smc pointer:

  BUG: KASAN: slab-use-after-free in smc_rx_pipe_buf_release+0x78/0x2a0
  Read of size 8 at addr ffff888004a45740 by task smc_splice_tee_/74
  Call Trace:
   <TASK>
   dump_stack_lvl+0x53/0x70
   print_report+0xce/0x650
   kasan_report+0xc6/0x100
   smc_rx_pipe_buf_release+0x78/0x2a0
   free_pipe_info+0xd4/0x130
   pipe_release+0x142/0x160
   __fput+0x1c6/0x490
   __x64_sys_close+0x4f/0x90
   do_syscall_64+0xa6/0x1a0
   entry_SYSCALL_64_after_hwframe+0x77/0x7f
   </TASK>

  BUG: kernel NULL pointer dereference, address: 0000000000000020
  RIP: 0010:smc_rx_update_consumer+0x8d/0x350
  Call Trace:
   <TASK>
   smc_rx_pipe_buf_release+0x121/0x2a0
   free_pipe_info+0xd4/0x130
   pipe_release+0x142/0x160
   __fput+0x1c6/0x490
   __x64_sys_close+0x4f/0x90
   do_syscall_64+0xa6/0x1a0
   entry_SYSCALL_64_after_hwframe+0x77/0x7f
   </TASK>
  Kernel panic - not syncing: Fatal exception

Beyond the memory-safety problem, duplicating an SMC splice buffer is
semantically questionable: smc_rx_update_cons() would advance the
consumer cursor twice for the same data, corrupting receive-window
accounting.  A refcount on smc_spd_priv could fix the double-free, but
the cursor-accounting issue would still need to be addressed separately.

The .get callback is invoked by both tee(2) and splice_pipe_to_pipe()
for partial transfers; both will now return -EFAULT.  Users who need
to duplicate SMC socket data must use a copy-based read path.

Fixes: 9014db202cb7 ("smc: add support for splice()")
Signed-off-by: Qi Tang <tpluszz77@gmail.com>
Link: https://patch.msgid.link/20260318064847.23341-1-tpluszz77@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/smc/smc_rx.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/net/smc/smc_rx.c b/net/smc/smc_rx.c
index 79047721df511..e7a6c2602e786 100644
--- a/net/smc/smc_rx.c
+++ b/net/smc/smc_rx.c
@@ -135,9 +135,16 @@ static void smc_rx_pipe_buf_release(struct pipe_inode_info *pipe,
 	sock_put(sk);
 }
 
+static bool smc_rx_pipe_buf_get(struct pipe_inode_info *pipe,
+				struct pipe_buffer *buf)
+{
+	/* smc_spd_priv in buf->private is not shareable; disallow cloning. */
+	return false;
+}
+
 static const struct pipe_buf_operations smc_pipe_ops = {
 	.release = smc_rx_pipe_buf_release,
-	.get = generic_pipe_buf_get
+	.get	 = smc_rx_pipe_buf_get,
 };
 
 static void smc_rx_spd_release(struct splice_pipe_desc *spd,
-- 
2.51.0



