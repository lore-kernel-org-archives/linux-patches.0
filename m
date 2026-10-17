Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A3411DFDA1;
	Sat, 17 Oct 2026 17:49:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792259364; cv=none; b=L31xtEt1z+wQLpZa/o72r4TR/XlnY9+VhxlHCyiASEN+EXqD4ZlO13lUVpdcNBxEzAeDFHYlhe7DSmLiSwp7lDJLbFfz0OYZVbvm5p7hrqq+OaHXVzyRT8VDEPAG7uWcBWjnXG8m8NN7wf0ihsDDL3OP0SwbX5xZ0YyTy7D+iD0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792259364; c=relaxed/simple;
	bh=OiSUST1SWopDYQU0BDFbMa/kQZebM82tbChCxH29aFU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Pu7lTS/z+dsPdEyJ4QqCqckPE5xM9G2waMQGMFny4tNcUnJLAmvCYCoI1AZlyyMcSjsE9ef7DUlodMqk45m7eNxqKOx4L/xfhb2FHdtZ8AZnedgF+MiQcsYCqbvpIrk0RN9v3QwLS4vA3toIpZiDWNtd7y7c0HFifQH3bB+MqNw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Soc+nLHN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Soc+nLHN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 067D81F000C4;
	Sat, 17 Oct 2026 17:49:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792259363;
	bh=YHk96u3JrbxfuESmNlZrcjn+Bs8g5Kje78qiZaYwxcs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Soc+nLHNkGITnfZ1fKFdOuZmuHr1h8ev6fOurbIMokAxRPw6H9U4eHIxiq4d2hbTF
	 ybM81CGTIjfikjQqtNCLhbrdeHYEXOGtYvyT/rtuWhQ2omNxd6TYZOfse5hoIMkqja
	 E8m23EE28GK5V16Tik1haCE8PRpz6n40UHjUzNNk=
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
Subject: [PATCH 6.6 1187/1674] net/sched: cls_u32: validate offshift to prevent shift-out-of-bounds
Date: Sat, 17 Oct 2026 17:57:39 +0200
Message-ID: <20261017160501.611594880@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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
index 30e703fa22a73..4557051a7d0d0 100644
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



