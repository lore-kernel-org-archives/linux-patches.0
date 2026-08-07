Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A94863B9943;
	Fri,  7 Aug 2026 15:34:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786116878; cv=none; b=JLZ7/4JXB2+PnnCyAdT5fgClwgsB+zLY9CDFSYO/Cl4SuioNd6G3NL6t9Q3fOvEPQ2ZWYwaa1PnOtCzOKPDk84+W2G1xA7VBu3uRf5tfOxX0QWaRCGWXALf0SX31vCV2hD7Lw2gMPs1q/kreSzVKeKPtKh/t+q6SzhUfXgUT9ws=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786116878; c=relaxed/simple;
	bh=r72LiJLgEs4OwFm7Y8FFwr83Jhmzt2nWGeQQUef3WFA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bQpxMuN2bmJU6U8YrLbhiMAF7cT4rpJt4KRLGjhvqpr2Vu/yLUVKAAzMINLVFovt9Qls++Yax+oo597Q2aBYd8u5g32DO8wo5oevRf4yHgSMiiHbMc1Xx1CKffDOweka8prhALe8fO4oCpRooV12jBtTvv1FKsDTneji3dIXCv4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bta9DfmQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bta9DfmQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB97B1F000E9;
	Fri,  7 Aug 2026 15:34:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786116877;
	bh=uwtwbWAsgFXciQ22zDgPDSkqyNPbkNWhWc3bcglPsx4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bta9DfmQuSw4msCP5ly+H4+a9qvoEY/VkYKqgT6ehiD1rN4QzX5CaKLr1srcOpl0Z
	 U1H9a0Mw/1TDpPlRNXJ/mYyK36wIzJYHfMg4iwot3Mz2/OeycJrhOHX4g6eKb6LmJo
	 QX0yqC8i5V+9+NA89CgKmli/6QoDmrCsuaUikfc8=
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
Subject: [PATCH 7.1 115/438] net/sched: cls_u32: validate offshift to prevent shift-out-of-bounds
Date: Fri,  7 Aug 2026 16:35:11 +0200
Message-ID: <20260807143430.446268503@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143428.008222056@linuxfoundation.org>
References: <20260807143428.008222056@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
index 8f30cc82181d9..ac98b1c2144a7 100644
--- a/net/sched/cls_u32.c
+++ b/net/sched/cls_u32.c
@@ -1107,6 +1107,13 @@ static int u32_change(struct net *net, struct sk_buff *in_skb,
 		goto erridr;
 	}
 
+	if (s->offshift >= 16) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "offshift must be less than 16");
+		err = -EINVAL;
+		goto erridr;
+	}
+
 	n = kzalloc_flex(*n, sel.keys, s->nkeys);
 	if (n == NULL) {
 		err = -ENOBUFS;
-- 
2.53.0



