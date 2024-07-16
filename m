Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0F401DDCE;
	Tue, 16 Jul 2024 16:01:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721145687; cv=none; b=tIoPle0pnWCgnh9WnZ3AT+UQUIPtXcRbthOPI/JDobnWGaPVxfedCkgvP9T8MdQyr07Nemd3muvrmNiUSFI8IIv23ohrlGVQVajazqzkSvgnk5a5xsTdoLzQlKDBX7YCL80/50lHlAoOd20z0WCTMRufAI6EfFEnf0T15wcOTGM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721145687; c=relaxed/simple;
	bh=dbltCaQKgTysJQDe1/JGNiNh2Wfzn7aZaGxE6ln0VzY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=efAiYc5FcfwIzE/HADhKyvZA4iIIuVIXS2V7rR4M7/XKAmL/3QUtCgOpCSnl23zAMjZTVDLaVesRpLT4uaUXiF733lJ/ogURJjizDDe571/gaTnwAeo7CGcvr3J1leJI43p5uD8S1t8/pmxEKC0KHsDuGHa7EaIQq6tixe8D7QQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yqKv1+fJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yqKv1+fJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 341CBC116B1;
	Tue, 16 Jul 2024 16:01:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721145687;
	bh=dbltCaQKgTysJQDe1/JGNiNh2Wfzn7aZaGxE6ln0VzY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yqKv1+fJMXUfJgFDcvt1UaeGFqN/xjo0OTlTa6DeruOvy9G75zPPKdd5iEGH8Cz5c
	 4KtL+wQL8fw4NFJRh940035BWTGcoPiM43FnYATorzsMUbxD0+f/aE2ZQDqnelLidU
	 /57LRDQpp9d/tXp0/5pRzpnZIsrtHJUDrlgng4j0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hugh Dickins <hughd@google.com>,
	Sagi Grimberg <sagi@grimberg.me>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 023/121] net: fix rc7s __skb_datagram_iter()
Date: Tue, 16 Jul 2024 17:31:25 +0200
Message-ID: <20240716152752.214473024@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240716152751.312512071@linuxfoundation.org>
References: <20240716152751.312512071@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hugh Dickins <hughd@google.com>

[ Upstream commit f153831097b4435f963e385304cc0f1acba1c657 ]

X would not start in my old 32-bit partition (and the "n"-handling looks
just as wrong on 64-bit, but for whatever reason did not show up there):
"n" must be accumulated over all pages before it's added to "offset" and
compared with "copy", immediately after the skb_frag_foreach_page() loop.

Fixes: d2d30a376d9c ("net: allow skb_datagram_iter to be called from any context")
Signed-off-by: Hugh Dickins <hughd@google.com>
Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
Link: https://patch.msgid.link/fef352e8-b89a-da51-f8ce-04bc39ee6481@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/datagram.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/core/datagram.c b/net/core/datagram.c
index e49aaf2d48b80..ef4e9e423d393 100644
--- a/net/core/datagram.c
+++ b/net/core/datagram.c
@@ -441,11 +441,12 @@ static int __skb_datagram_iter(const struct sk_buff *skb, int offset,
 			if (copy > len)
 				copy = len;
 
+			n = 0;
 			skb_frag_foreach_page(frag,
 					      skb_frag_off(frag) + offset - start,
 					      copy, p, p_off, p_len, copied) {
 				vaddr = kmap_local_page(p);
-				n = INDIRECT_CALL_1(cb, simple_copy_to_iter,
+				n += INDIRECT_CALL_1(cb, simple_copy_to_iter,
 					vaddr + p_off, p_len, data, to);
 				kunmap_local(vaddr);
 			}
-- 
2.43.0



