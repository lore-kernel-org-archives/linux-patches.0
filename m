Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793215643;
	b=DGoIwuksB7yxh1lGV9D0axOJ25GVxuj9SXSF9mWeUO6W2JDiirkQnrYMSeg6wWFO3SeW
	 c+DAWrWTayW66ASQawgGIRta+ImMzO+uw8KgYTwnQBsIcc/kF4e/Z70WNXTS3eB/zktmG
	 YsSwpetOT9lYVI74c3xR9Q2wURGOBSLamwLPIfoTy4++xOuw3pVx3zGWJiK0Qnx4sVdS/
	 0+hLCWRyLlqvN2ebI0ZyrjRUwIipF01YkN6K4RF3m6AtL4iaaRJmAUY6Ij+/0u5bhsbVV
	 sZyhDzu4lbXk3u3bBmdvNjBPFwbfe/tYJYr6zRL/SKsudRqBbg3mieb7LsHInQmF+zQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793215643;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=azR/bW8FR/M4aItmA61wI7416rfelepDNChdryV6fTQ=;
	b=Tp01n00SKvQsOAg6Nkz9sPLUZzE/vl3eJfnU7c4tQihmfjKlTzokwRcPJMbckymzNTcN
	 pUf2gf1g6ua0yCO1qM3HCQ4SxUzYUBEtr/txXseIqYSmMa8foUwtBEnTJm9zX264dx/yi
	 BWZP5YSBKrCrG4EcF6I+jEBYOpR2sjAxFckFic54VKBnaSE4d+AUtwQsi310DFDHQjJOy
	 m85dO5H6tXykU4URqjUzpdoXaHceb/jkMSKSEdJoq5ZFYrxg7HSz2Ji6INliq5Z5tSetN
	 wB907txzQkyriuC0X5Zg8xl8vqsmt8rdiCUq2AraNYKjTzwlygPKLlx5jLTrxngNIcA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=E88GXNai;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A9E4606A31F;
	Wed, 28 Oct 2026 19:27:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=E88GXNai
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF1C51F01825;
	Wed, 28 Oct 2026 19:27:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793215643;
	bh=azR/bW8FR/M4aItmA61wI7416rfelepDNChdryV6fTQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=E88GXNai5zKArkHkcwBU7Kw9MyR2uGWUweKTOLj+h3tVTooPqb4jhCCZBWwm7c32x
	 IrLeKKZ1vjGZT0o1bLm03MMN7YhAv7wJiyLXOX8Z54yYz7OE0198at6rZHTff28Kr7
	 J3qAlkMXrNrhd0w4Q8VNWl4bxWEOFFlWkncVb0XQ=
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
Subject: [PATCH 6.1 1283/1887] net/sched: cls_u32: validate offshift to prevent shift-out-of-bounds
Date: Wed, 28 Oct 2026 17:56:19 +0100
Message-ID: <20261028170528.623742610@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 276ee95f65010..d1f2d194d2267 100644
--- a/net/sched/cls_u32.c
+++ b/net/sched/cls_u32.c
@@ -1128,6 +1128,13 @@ static int u32_change(struct net *net, struct sk_buff *in_skb,
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



