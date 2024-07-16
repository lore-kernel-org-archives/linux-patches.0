Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F1171DDCE;
	Tue, 16 Jul 2024 16:05:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721145956; cv=none; b=i+QMulkob9sG0agcQxgM/bnJfp5yqsdKK0XpE2r6FdDl28eUmYQ9FVMpEY4ug5j5ibZE9NCduOc+zbR1c+ARo9QXUxSCAZ4EfKtKcRNLjV2WhTgxm860PmL1RuA6/rVbntgcVqeY4GnDHDELwzYfz1l0jnUXqUR+mIpaQrHXzNM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721145956; c=relaxed/simple;
	bh=fxGVAmq3SpKqs4Gh9jTq2uDMOmLak44cFyc42mgAW98=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rAvJpLgKkvjjTsx4bCollCjm8ZoPPtisgg63cb90ECc08ttUMQGWNfEFmVI0MuTEvCL1iMRBX5KLWK8miBCKAlQ+E3pmehEhGSgkZtic7EJk2VM9e50dFl2bT5YVzUeA/TpgN0jgVMnYdLug1+01MjrQ69VzM3kamKXMNGE5GP0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hqAAsSke; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hqAAsSke"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02866C116B1;
	Tue, 16 Jul 2024 16:05:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721145956;
	bh=fxGVAmq3SpKqs4Gh9jTq2uDMOmLak44cFyc42mgAW98=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hqAAsSkeLFfFix1uWfCjEKcyl60soxoZ0ssqs+IDTlI1C5is+qFRP2UvHC++VuAEQ
	 Gr8n7QcTjmojA9OC0VcY5fBsuNyUpE7j2ylwbJlKIenArkjA025S0fQoBzIrGj9iOq
	 ysGuv/WYYUxKOoGKMYUc6F9vbfBzoU/oBRxmN0KM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Erick Archer <erick.archer@outlook.com>,
	Xin Long <lucien.xin@gmail.com>,
	Kees Cook <keescook@chromium.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 013/144] sctp: prefer struct_size over open coded arithmetic
Date: Tue, 16 Jul 2024 17:31:22 +0200
Message-ID: <20240716152753.043188307@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240716152752.524497140@linuxfoundation.org>
References: <20240716152752.524497140@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Erick Archer <erick.archer@outlook.com>

[ Upstream commit e5c5f3596de224422561d48eba6ece5210d967b3 ]

This is an effort to get rid of all multiplications from allocation
functions in order to prevent integer overflows [1][2].

As the "ids" variable is a pointer to "struct sctp_assoc_ids" and this
structure ends in a flexible array:

struct sctp_assoc_ids {
	[...]
	sctp_assoc_t	gaids_assoc_id[];
};

the preferred way in the kernel is to use the struct_size() helper to
do the arithmetic instead of the calculation "size + size * count" in
the kmalloc() function.

Also, refactor the code adding the "ids_size" variable to avoid sizing
twice.

This way, the code is more readable and safer.

This code was detected with the help of Coccinelle, and audited and
modified manually.

Link: https://www.kernel.org/doc/html/latest/process/deprecated.html#open-coded-arithmetic-in-allocator-arguments [1]
Link: https://github.com/KSPP/linux/issues/160 [2]
Signed-off-by: Erick Archer <erick.archer@outlook.com>
Acked-by: Xin Long <lucien.xin@gmail.com>
Reviewed-by: Kees Cook <keescook@chromium.org>
Link: https://lore.kernel.org/r/PAXPR02MB724871DB78375AB06B5171C88B152@PAXPR02MB7248.eurprd02.prod.outlook.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sctp/socket.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index d9271ffb29781..967b330ffd4e3 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -7112,6 +7112,7 @@ static int sctp_getsockopt_assoc_ids(struct sock *sk, int len,
 	struct sctp_sock *sp = sctp_sk(sk);
 	struct sctp_association *asoc;
 	struct sctp_assoc_ids *ids;
+	size_t ids_size;
 	u32 num = 0;
 
 	if (sctp_style(sk, TCP))
@@ -7124,11 +7125,11 @@ static int sctp_getsockopt_assoc_ids(struct sock *sk, int len,
 		num++;
 	}
 
-	if (len < sizeof(struct sctp_assoc_ids) + sizeof(sctp_assoc_t) * num)
+	ids_size = struct_size(ids, gaids_assoc_id, num);
+	if (len < ids_size)
 		return -EINVAL;
 
-	len = sizeof(struct sctp_assoc_ids) + sizeof(sctp_assoc_t) * num;
-
+	len = ids_size;
 	ids = kmalloc(len, GFP_USER | __GFP_NOWARN);
 	if (unlikely(!ids))
 		return -ENOMEM;
-- 
2.43.0



