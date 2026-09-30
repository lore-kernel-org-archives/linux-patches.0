Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE2313C060F;
	Wed, 30 Sep 2026 19:30:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790796656; cv=none; b=NKteZINsVMltGMUvf8iELqxl3SaLWp+/XrMSWYy4pIKsv9P6+umo6uutbmp7AJaJxpVrE+6N7a+wZhd/xI56ou7KS+7oYaGP1Z/SmsWHgwz4mwlMT01zfqxmx2kJvHpZLl+0B7wXfJpjdzj78z3GauPQ6whQUK6QWzEzf6BS5cs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790796656; c=relaxed/simple;
	bh=ySdlREK23G80kkjDtT9YhEm8CxZK+27driVAm6m5pZQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pmdeW8Dvab/azSwIttgeht6VgVaig8zF0/5BUeu6E199CYK4NO8Q4UzX9k+CsIqGjChZYrfQvXvtfNkLCU0K4w3+6rd3EFyvAMWqqXcAzrN2LfWIuXzoi/b9G+TYnCziAi5StT8G2gVzLk6aGG/Psf0BFIUL1ToVPVBQ1FK66Wk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wZTub4hs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wZTub4hs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 144261F000FF;
	Wed, 30 Sep 2026 19:30:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790796655;
	bh=SufST1glkbsoB4VVImycuuhdD81kC+/qVnkeNLMpTA8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wZTub4hsl8Fa5v3F44in1PHFyMuxbfssXEKd7Gbi71t20uGA+uBew28NMRDhn8Mq5
	 bgqSUlzdrw6J5bJL37uJeJBwaESlTpYnoqGFzZV15MZQt0d4j5nUuuwD6G76ZmMaf1
	 DbdnrGynZjdIgKLdGwENpVDRIUKwNjVyC6Vu5xjg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiang Mei <xmei5@asu.edu>,
	Weiming Shi <bestswngs@gmail.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0988/1193] bpf: Skip unsettled links in link iterator
Date: Wed, 30 Sep 2026 17:27:52 +0200
Message-ID: <20260930152456.193647124@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 163700efb5b38..1710391f386af 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -5269,7 +5269,10 @@ struct bpf_link *bpf_link_get_curr_or_next(u32 *id)
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



