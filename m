Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F39F31DA4D;
	Tue, 16 Jul 2024 15:49:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721144969; cv=none; b=NMlvHaNZLbhE0e/DSOgrUE1N3cNveGRjA5mTUkxh9ZwPWipQKUwHKf6gIZ7avB/uMQZ5HJudtIkj8rgUOEbsjCjGSM3qwx4BgtRvrXQZkYHZ4uai19Ldpvy6Coc+tFe5wz5Nd+c2k3Jl3mVndf9lA3SIaJMjAnSaIZXBeQGVqUk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721144969; c=relaxed/simple;
	bh=sWjf2/v4pXpdiTQyTMTpliBF/PySGcE5z2l6tglekJk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ESH/nK1b2BTy+EDQm2BlT9FNeZkLzeeaz/E/h1+x1TdDH8wCUe7XiY7FtkRUJAAQDSDwsgRzw+0YWknLrrKX8wJumayoG600qsFr1/5fWlNGiooATa/gmcgex3uaoy9CQiS52/FmLK7R/2b/Aqq5U3bPeBC31LO+tzbNkrbv6B0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uP3nc7/R; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uP3nc7/R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CBFEC116B1;
	Tue, 16 Jul 2024 15:49:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721144968;
	bh=sWjf2/v4pXpdiTQyTMTpliBF/PySGcE5z2l6tglekJk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uP3nc7/Rl8Wncu02megkyEZnPlRMxNCQz6gOgspdKsizrbiVuXpIoXE8k73sIwInx
	 id51Vmxdo/b+/F5mAPgAk/52HJ537g6nybSHhffTFwVSOviyIkugORakTBsv6lKAe6
	 pKaTUyXXVye2ZVuDjbr8mQmF57odt0kg6KHW+8wk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hugh Dickins <hughd@google.com>,
	Sagi Grimberg <sagi@grimberg.me>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 027/143] net: fix rc7s __skb_datagram_iter()
Date: Tue, 16 Jul 2024 17:30:23 +0200
Message-ID: <20240716152757.032549650@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240716152755.980289992@linuxfoundation.org>
References: <20240716152755.980289992@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

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
index cb72923acc21c..99abfafb0b439 100644
--- a/net/core/datagram.c
+++ b/net/core/datagram.c
@@ -442,11 +442,12 @@ static int __skb_datagram_iter(const struct sk_buff *skb, int offset,
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



