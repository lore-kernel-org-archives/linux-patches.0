Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A8E251B19D;
	Wed, 30 Sep 2026 17:24:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790789063; cv=none; b=twu8vaiAIle6eMlsHfZmYo7aWW9vR6sXpRighjFdq8diFLWnlxrzlnffrKXvgX5EhrBC5SfLoC7JePbcUJU5viYccNdB694wqywNx3BzHESNiDeb+UCIQ/dk41UdLAy4wAo486YqT04e9QCj9P0dzZvK9r+HAjwi5RHYyK+DQJw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790789063; c=relaxed/simple;
	bh=kTA+j8DSBKDqsO+JgndUN0iXAUmOtFmjGajASbXYKj8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Cmo/ConiWCjn6dMtWhrGaIAQ4YyfdlF/9BE+sZk0ZSzkmObL5HH2zE+c21tzEBCU80vMJu/IHFq/FHq99MsHUFe8zWvGZsk87nh9wVh2cI03F/jjoIhPCxG83t+b9IhYTI8f47OwAvZk4XQJoIpJaM9l+VdLeNvHhU8CrLam3IY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ru48uwBA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ru48uwBA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 823611F00898;
	Wed, 30 Sep 2026 17:24:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790789062;
	bh=7b8IdtsIwqcvEs5Xmrr1ZQRfCuYgM3e7SgIxZtFed10=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ru48uwBACGvJlBp1Wz6g+NSAuybh4OkF0Gf0YUDHgY7SBHD9h0rRv/KAc+KXKJ6fD
	 dk4maYoTqfFhV8UcQPZfiRjolSMY7nHJjUl1kr7IQTNCZycjltxom3rwSj0TDiISBx
	 4n+5yEG9LRLHHaS9/Y3Lq2gsdnY5WcYEgyAPYsrI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiang Mei <xmei5@asu.edu>,
	Weiming Shi <bestswngs@gmail.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 343/877] bpf: Skip unsettled links in link iterator
Date: Wed, 30 Sep 2026 17:20:54 +0200
Message-ID: <20260930152422.070961841@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
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

From: Weiming Shi <bestswngs@gmail.com>

[ Upstream commit 50e80e2bb5e2be8515205b9c496b9640ddefa434 ]

bpf_link_prime() inserts a link into link_idr before anon_inode_getfile()
succeeds and before bpf_link_settle() publishes the ID in link->id.
bpf_link_by_id() treats such an ID-zero link as unsettled, but the link
iterator takes a reference without this check.

If anon_inode_getfile() then fails, the creator removes the ID and frees
its still-private link directly.  The iterator is left with a dangling
reference and its next bpf_link_put() accesses freed memory.

Treat ID-zero entries as transient in bpf_link_get_curr_or_next(), just as
bpf_link_by_id() does.

  BUG: KASAN: slab-use-after-free in bpf_link_put
  Write of size 8 by task exp/384
  Call Trace:
  bpf_link_put                    kernel/bpf/syscall.c:3372
  bpf_link_seq_next               kernel/bpf/link_iter.c:33
  bpf_seq_read                    kernel/bpf/bpf_iter.c:158
  vfs_read                        fs/read_write.c:572
  ksys_read                       fs/read_write.c:716
  do_syscall_64                   arch/x86/entry/syscall_64.c:84
  entry_SYSCALL_64_after_hwframe  arch/x86/entry/entry_64.S:121
  Kernel panic - not syncing: KASAN: panic_on_warn set ...

Fixes: 9f8836127308 ("bpf: Add bpf_link iterator")
Reported-by: Xiang Mei <xmei5@asu.edu>
Signed-off-by: Weiming Shi <bestswngs@gmail.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/bpf/20260914170206.170723-2-bestswngs@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/syscall.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index 954b299f241b6..857285a48d433 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -5472,7 +5472,10 @@ struct bpf_link *bpf_link_get_curr_or_next(u32 *id)
 again:
 	link = idr_get_next(&link_idr, id);
 	if (link) {
-		link = bpf_link_inc_not_zero(link);
+		if (link->id)
+			link = bpf_link_inc_not_zero(link);
+		else
+			link = ERR_PTR(-EAGAIN);
 		if (IS_ERR(link)) {
 			(*id)++;
 			goto again;
-- 
2.53.0



