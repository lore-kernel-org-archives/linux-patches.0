Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D41422CBC9;
	Thu, 12 Dec 2024 16:51:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734022271; cv=none; b=atvTmjAsiFFJ/lRgucJKZA5yf2g+ap5dAhFwSttfzzEgbS1rpK+OMdFnqwJtkCQwMxOsjNSiBs/e9mk6/7F6+Dj+mAO5+DLGrI49Tp+SH77a0xBhoiCSYJp6OWf4DSqnlbnMYvzHAMMe635x2cp/lJn2/SSuzS7rJ23TBHQGidY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734022271; c=relaxed/simple;
	bh=bQKI6urU6wmcik/flpzq8LGmisR87l/sT/UUuodbhbs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oBjzNqrjOnNj5RwXsxQm3zK+//Lqk8Z3O7Q6adyf0ruXo1WuQSJ6v7PgtCngz9KyPtESdL1wRiKmfZfrtvQtafhwGmEqdzvNZ3ZyXFYNqF2GhcaxqjYGzFM/6Uy460sROuLgf/T8qO0z+GtnOzz9F4ig/SDoeCUoQTxT/5SWEVQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=StVjnA9p; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="StVjnA9p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3341AC4CECE;
	Thu, 12 Dec 2024 16:51:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734022270;
	bh=bQKI6urU6wmcik/flpzq8LGmisR87l/sT/UUuodbhbs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=StVjnA9pg+XaIRnV8+NMSaxYaST3oPGsF3Azc9v6/CK9UgpWS3n+TefhCKMhcDN62
	 mvlIflCunSCgWO9JK4zqiGECNf0pMgbwW5Hop4cy1ks6F8CH1uTrLMkVHEntHyd0+L
	 /a/eF1wlTKAup8dxwrqbTmd4VSLA8vfqonRBsQG8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zijian Zhang <zijianzhang@bytedance.com>,
	John Fastabend <john.fastabend@gmail.com>,
	Martin KaFai Lau <martin.lau@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 195/565] bpf, sockmap: Several fixes to bpf_msg_pop_data
Date: Thu, 12 Dec 2024 15:56:30 +0100
Message-ID: <20241212144319.192295337@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144311.432886635@linuxfoundation.org>
References: <20241212144311.432886635@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zijian Zhang <zijianzhang@bytedance.com>

[ Upstream commit 5d609ba262475db450ba69b8e8a557bd768ac07a ]

Several fixes to bpf_msg_pop_data,
1. In sk_msg_shift_left, we should put_page
2. if (len == 0), return early is better
3. pop the entire sk_msg (last == msg->sg.size) should be supported
4. Fix for the value of variable "a"
5. In sk_msg_shift_left, after shifting, i has already pointed to the next
element. Addtional sk_msg_iter_var_next may result in BUG.

Fixes: 7246d8ed4dcc ("bpf: helper to pop data from messages")
Signed-off-by: Zijian Zhang <zijianzhang@bytedance.com>
Reviewed-by: John Fastabend <john.fastabend@gmail.com>
Link: https://lore.kernel.org/r/20241106222520.527076-8-zijianzhang@bytedance.com
Signed-off-by: Martin KaFai Lau <martin.lau@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/filter.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/net/core/filter.c b/net/core/filter.c
index c5d15fceee6da..8b51f57aaa251 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -2883,8 +2883,10 @@ static const struct bpf_func_proto bpf_msg_push_data_proto = {
 
 static void sk_msg_shift_left(struct sk_msg *msg, int i)
 {
+	struct scatterlist *sge = sk_msg_elem(msg, i);
 	int prev;
 
+	put_page(sg_page(sge));
 	do {
 		prev = i;
 		sk_msg_iter_var_next(i);
@@ -2921,6 +2923,9 @@ BPF_CALL_4(bpf_msg_pop_data, struct sk_msg *, msg, u32, start,
 	if (unlikely(flags))
 		return -EINVAL;
 
+	if (unlikely(len == 0))
+		return 0;
+
 	/* First find the starting scatterlist element */
 	i = msg->sg.start;
 	do {
@@ -2933,7 +2938,7 @@ BPF_CALL_4(bpf_msg_pop_data, struct sk_msg *, msg, u32, start,
 	} while (i != msg->sg.end);
 
 	/* Bounds checks: start and pop must be inside message */
-	if (start >= offset + l || last >= msg->sg.size)
+	if (start >= offset + l || last > msg->sg.size)
 		return -EINVAL;
 
 	space = MAX_MSG_FRAGS - sk_msg_elem_used(msg);
@@ -2962,12 +2967,12 @@ BPF_CALL_4(bpf_msg_pop_data, struct sk_msg *, msg, u32, start,
 	 */
 	if (start != offset) {
 		struct scatterlist *nsge, *sge = sk_msg_elem(msg, i);
-		int a = start;
+		int a = start - offset;
 		int b = sge->length - pop - a;
 
 		sk_msg_iter_var_next(i);
 
-		if (pop < sge->length - a) {
+		if (b > 0) {
 			if (space) {
 				sge->length = a;
 				sk_msg_shift_right(msg, i);
@@ -2986,7 +2991,6 @@ BPF_CALL_4(bpf_msg_pop_data, struct sk_msg *, msg, u32, start,
 				if (unlikely(!page))
 					return -ENOMEM;
 
-				sge->length = a;
 				orig = sg_page(sge);
 				from = sg_virt(sge);
 				to = page_address(page);
@@ -2996,7 +3000,7 @@ BPF_CALL_4(bpf_msg_pop_data, struct sk_msg *, msg, u32, start,
 				put_page(orig);
 			}
 			pop = 0;
-		} else if (pop >= sge->length - a) {
+		} else {
 			pop -= (sge->length - a);
 			sge->length = a;
 		}
@@ -3030,7 +3034,6 @@ BPF_CALL_4(bpf_msg_pop_data, struct sk_msg *, msg, u32, start,
 			pop -= sge->length;
 			sk_msg_shift_left(msg, i);
 		}
-		sk_msg_iter_var_next(i);
 	}
 
 	sk_mem_uncharge(msg->sk, len - pop);
-- 
2.43.0



