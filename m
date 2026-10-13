Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFCE35013B9;
	Tue, 13 Oct 2026 12:15:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791893748; cv=none; b=Bk/PIqjMpmflM6BdZdyPKvqqi0Un+qokFJF5KRi1/ZZvalLCu5rQuKOSmFXg7hzt1oDiLnlN+MJ7WPMWZ+6lvjN7maes2ZrDz6F80d4xIFWsOAP5zffXtLDqrqXLNnIcoAtFh+netzt0ML5Mr287pKyJcnT+ePgCi9RDK1Tl7Bs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791893748; c=relaxed/simple;
	bh=pf7E40EK4tHD/9qtfLGU7HiVi2Ybt7Uer61tNoODz4E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qXoE3vvR7c0rKPbkv7Lz8qkNfvpgQlAJxJcLfYb6K0dDtSakI6U0LpDjbbRfnPxY3Ddxvfcq6YgLqXRF6kwUfNjwzut3yj/7uEM1NluV+JExXfVbyli4dBof7ib7jZFdLwBgIc/2gAQ4JrKGhGGE/jT7Ld/7uqGuutjBz3voxyA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=S3WEnw3j; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S3WEnw3j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48AE21F000FF;
	Tue, 13 Oct 2026 12:15:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791893746;
	bh=YSAl/rLKn5zMdZ7o4jh1jcU/5h1uZ0Sjkp5M+sPLAgI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=S3WEnw3j+yHG7LMVUfq7slve8/0x0TzzFywEqTlGHbeFQrsKMfhhET6MnSmMyrdv6
	 toETe2OQtyD23MzRcbyQDSlrR1BwekwJvQRMBDBt7vUptSFUxU/mh5CGR0gqYo+Z9A
	 uZGARVANFtjQlwQU3/09TABpG+Ur2/yNTx4EXPXc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	AutonomousCodeSecurity@microsoft.com,
	"Cen Zhang (Microsoft)" <blbllhy@gmail.com>,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	Victor Nogueira <victor@mojatatu.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 328/621] net/sched: cls_u32: validate offshift to prevent shift-out-of-bounds
Date: Tue, 13 Oct 2026 13:35:23 +0200
Message-ID: <20261013112928.636912676@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112920.855194808@linuxfoundation.org>
References: <20261013112920.855194808@linuxfoundation.org>
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

From: Cen Zhang (Microsoft) <blbllhy@gmail.com>

[ Upstream commit aef96eead2860cbfa371e4471d4f04412213b958 ]

u32_change() copies the user-provided tc_u32_sel.offshift (unsigned char,
0-255) into the kernel knode object without bounds validation. When a
packet later hits u32_classify() with TC_U32_VAROFFSET set, it evaluates
`ntohs(offmask & *data) >> offshift` where the left operand is a 16-bit
value promoted to a 32-bit int. Any offshift >= 32 is undefined behavior
per C11 6.5.7p3, triggerable by an unprivileged user via user/network
namespaces.

UBSAN: shift-out-of-bounds in net/sched/cls_u32.c:236:43
shift exponent 32 is too large for 32-bit type int

Fix this by rejecting offshift >= 16 during filter creation in
u32_change().

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Reported-by: AutonomousCodeSecurity@microsoft.com
Link: https://lore.kernel.org/all/20260720034514.23053-1-blbllhy@gmail.com
Signed-off-by: Cen Zhang (Microsoft) <blbllhy@gmail.com>
Acked-by: Jamal Hadi Salim <jhs@mojatatu.com>
Tested-by: Jamal Hadi Salim <jhs@mojatatu.com>
Tested-by: Victor Nogueira <victor@mojatatu.com>
Link: https://patch.msgid.link/20260723044955.89471-1-blbllhy@gmail.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/cls_u32.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/net/sched/cls_u32.c b/net/sched/cls_u32.c
index e5e5533f866dc..ea021dc39fea3 100644
--- a/net/sched/cls_u32.c
+++ b/net/sched/cls_u32.c
@@ -1132,6 +1132,13 @@ static int u32_change(struct net *net, struct sk_buff *in_skb,
 		goto erridr;
 	}
 
+	if (s->offshift >= 16) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "offshift must be less than 16");
+		err = -EINVAL;
+		goto erridr;
+	}
+
 	n = kzalloc(struct_size(n, sel.keys, s->nkeys), GFP_KERNEL);
 	if (n == NULL) {
 		err = -ENOBUFS;
-- 
2.53.0



