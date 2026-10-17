Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0163639F18A;
	Sat, 17 Oct 2026 16:29:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792254596; cv=none; b=dJGSZavjZYkj2RGTq4SUPRR8Xh1C113hx7vOrFr+YvdsuiZAOD9XKc0yInmVcF59XXt9nZKLkNxFhUM6za4PwWoARc9tkYRDRb5kvfZcVvI3OIh2YK7P1uQGfIez3ttrX2lzugxcFDHu91ayUhDDUYeyjvMUCiP3VBkWRBmIDkY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792254596; c=relaxed/simple;
	bh=7Vusbn/8V69/4qWrfspTXvKJs/BPiQt7f8bH27BV8zo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=os8XybKeEoVaCQQh+TSbycwfqzHp8TGAfNzoufhpuKUGhjKIWZynLr15rwSaIBZzRxNxdfWgoLWIV19FaFI+q9ohlxag5lxXYpvH2uTsprr37EOGAEVJH0lQM5FwBdnqUL/RSOprr/GOCyXBB3Yb6MEf7rh1+TdiXl9T1lxPofI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wTfOXJ7A; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wTfOXJ7A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25FEB1F000C4;
	Sat, 17 Oct 2026 16:29:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792254594;
	bh=PrQpQzYkYiJsiF71PnenVr2/yGb2HmXPCamRXOwDhhY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wTfOXJ7A/M8hJdRLcjt8khv+EF0bSjLCJ7+TnPlyROvSVoa/LTUUmXGrxuQ3/gAJo
	 JX8cDYd5qVRknM1qv03Tj+KYM/ZmpobaNpM4WR0FUDHadhtQGe9KcSHEo/uYvOn0IQ
	 JCTvv99zUVankyeZCcKk1DMqQWLvrYxaMRNN7vAU=
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
Subject: [PATCH 6.12 498/869] net/sched: cls_u32: validate offshift to prevent shift-out-of-bounds
Date: Sat, 17 Oct 2026 17:55:39 +0200
Message-ID: <20261017160049.878160401@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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



