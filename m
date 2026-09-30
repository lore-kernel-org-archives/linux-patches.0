Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BF2E5221C3;
	Wed, 30 Sep 2026 18:31:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790793108; cv=none; b=Is0LcqW4oyvR+HmJYkEj3IJrKyfElMNpA6f50HjT+1SY8Wnqi/iqC0pRnONTxWUEBWNDpLZ+jY8vuAnM8kxV794FRkIMcg6bd0E0XXU+HGaqb7od7SKvtDcJDwWRI5+rHIu+kCM1k+lT5DYgLx+vA/CTsix42ffT2oHvfy6adQk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790793108; c=relaxed/simple;
	bh=ueGFMNSP7iXffoNHfnnk7GpMzaDrZz7mTEPx9ljm6h0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kjRIQWJEl1igx1KxJHLFeDkOGo5j2aFEW8V/wZjBAuKB8PGkHXOrltS4VvFm87wd1J34VH2hAplRzRIRX12QSbti9Pe0bC/v6Rqel9ULJ1TfS292AiAhCKlvMxj6SDFSuW/9SPHp+Yz2qKbNXEwB3HIQgrtjwKRQJzi1KBxa2No=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jVeyQlJH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jVeyQlJH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A99951F000FF;
	Wed, 30 Sep 2026 18:31:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790793107;
	bh=ljSctgWiH4KAhanLaQ5hh7Q+z2zSI/2Gywh1AtDnuCE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jVeyQlJHbIHkWSsUfehE75YrvfjLaEYbEdfpo2c8nON4zfVAJSzt1cOlRKgfCHNSa
	 jzKz5h9a7byFoRRtgneA3Kj2EpFMGKdV3aFtwnfXKBZwa/X62GRPUHXE0HToTNOP8q
	 ntQs8iuz+QxeYZU2qvj4fYHrZisE0LRY8+VKUP68=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bernard Ladenthin <bernard.ladenthin@gmail.com>,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 139/395] net/sched: fix potential stack infoleak in em_text_dump()
Date: Wed, 30 Sep 2026 17:26:41 +0200
Message-ID: <20260930152343.659896710@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152340.591469096@linuxfoundation.org>
References: <20260930152340.591469096@linuxfoundation.org>
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

From: Bernard Ladenthin <bernard.ladenthin@gmail.com>

[ Upstream commit 9c572a83037a7dcd653ba3a9cc468c16b857d0c9 ]

em_text_dump() allocates struct tcf_em_text on the stack without zeroing
it.  strscpy() writes the algorithm name and a NUL terminator into
conf.algo[], leaving the remaining bytes uninitialised.  nla_put_nohdr()
then copies the full struct to the netlink response.

KMSAN on Linux 7.2-rc6 reports two kernel-infoleak splats from this path,
one triggered via "tc filter show" and one via a raw RTM_GETTFILTER dump:

  BUG: KMSAN: kernel-infoleak in _copy_to_iter+0x1c9/0x2620
    nla_put_nohdr+0x83/0x130
    em_text_dump+0x291/0x550
  Local variable conf created at: em_text_dump+0x5d/0x550
  Bytes 168-179 of 199 are uninitialized

I am not certain whether this constitutes a real security problem in
practice: the test was conducted in a controlled KMSAN environment and
the leaked stack bytes may or may not carry sensitive data on actual
production kernels.  I am reporting it because KMSAN flagged it as a
kernel-infoleak and the fix is straightforward.  I can provide a
userspace reproducer on request.

The original code used strncpy() which zero-pads to the destination size.
Commit b04202d6065c ("net/sched: replace strncpy with strscpy") replaced
it with strscpy(), which does not pad, creating this condition.
Zero-initialising the struct closes it.

Fixes: b04202d6065c ("net/sched: replace strncpy with strscpy")
Link: https://lore.kernel.org/netdev/20250327143733.187438-1-richard120310@gmail.com/
Assisted-by: Claude:claude-sonnet-4-6 [KMSAN]
Signed-off-by: Bernard Ladenthin <bernard.ladenthin@gmail.com>
Acked-by: Jamal Hadi Salim <jhs@mojatatu.com>
Link: https://patch.msgid.link/20260918133953.12494-1-bernard.ladenthin@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/em_text.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/sched/em_text.c b/net/sched/em_text.c
index 692e2be1793e9..8052c55b2f4d0 100644
--- a/net/sched/em_text.c
+++ b/net/sched/em_text.c
@@ -113,7 +113,7 @@ static void em_text_destroy(struct tcf_ematch *m)
 static int em_text_dump(struct sk_buff *skb, struct tcf_ematch *m)
 {
 	struct text_match *tm = EM_TEXT_PRIV(m);
-	struct tcf_em_text conf;
+	struct tcf_em_text conf = {};
 
 	strscpy(conf.algo, tm->config->ops->name);
 	conf.from_offset = tm->from_offset;
-- 
2.53.0



