Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 021FE4F218;
	Thu, 12 Dec 2024 17:19:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734023981; cv=none; b=m2ir0adwrs9ekPIZ/eD8yTlUehNcA++d6gmccbZAFxj5siiC12DFWOXvz/LG7NVWPsJXJA/JfGhVn+XZuf+RsgzoiZmRqWfWkoOwc19TZdY6C7fZgSZuxHI0hp2IsWhLTjZ7wT5AWiaU/cHC20xAObzOWm9+lCERJoUcFQxupiU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734023981; c=relaxed/simple;
	bh=StoWf+SU9xgNmpQT76ZrOCwfiKY1bavjMRqSyUyVl04=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lb6rqBxORDejcGKJdQPB08cAcDdboHS9iL6ukKAzTgvs7GuTChgDlDAwVENYyWEiNa2a+dJ/FiK5m6GePhJnTM+5lA0kwrNZ+84R1wBsQRsI1h3EWunOwCAL8HHjzTnPLMNaxKa5Ez7stiMv5enuU0q5hDaQgUpoXNKN7oi4SSA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=E3tCq0aC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="E3tCq0aC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B046C4CECE;
	Thu, 12 Dec 2024 17:19:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734023980;
	bh=StoWf+SU9xgNmpQT76ZrOCwfiKY1bavjMRqSyUyVl04=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=E3tCq0aCgLAsG0UsUsWL4P0Z+vvp5qMeJWr7jLn7e4NtvLLEwhHOcuakJQBaZ9I9G
	 nN6EO/Sp2eB8x1FPidxO4BqmlCOoCHxvLBqoE7K2LIusK/E7nQYDPevMaFh27t4i/s
	 3XGE/v18Vqve0bjhjfsxBo5SNjmrWqlxAyvq4Zoo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zijian Zhang <zijianzhang@bytedance.com>,
	Martin KaFai Lau <martin.lau@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 146/459] bpf, sockmap: Several fixes to bpf_msg_push_data
Date: Thu, 12 Dec 2024 15:58:04 +0100
Message-ID: <20241212144259.279063475@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144253.511169641@linuxfoundation.org>
References: <20241212144253.511169641@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zijian Zhang <zijianzhang@bytedance.com>

[ Upstream commit 15ab0548e3107665c34579ae523b2b6e7c22082a ]

Several fixes to bpf_msg_push_data,
1. test_sockmap has tests where bpf_msg_push_data is invoked to push some
data at the end of a message, but -EINVAL is returned. In this case, in
bpf_msg_push_data, after the first loop, i will be set to msg->sg.end, add
the logic to handle it.
2. In the code block of "if (start - offset)", it's possible that "i"
points to the last of sk_msg_elem. In this case, "sk_msg_iter_next(msg,
end)" might still be called twice, another invoking is in "if (!copy)"
code block, but actually only one is needed. Add the logic to handle it,
and reconstruct the code to make the logic more clear.

Fixes: 6fff607e2f14 ("bpf: sk_msg program helper bpf_msg_push_data")
Signed-off-by: Zijian Zhang <zijianzhang@bytedance.com>
Link: https://lore.kernel.org/r/20241106222520.527076-7-zijianzhang@bytedance.com
Signed-off-by: Martin KaFai Lau <martin.lau@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/filter.c | 53 +++++++++++++++++++++++++++++------------------
 1 file changed, 33 insertions(+), 20 deletions(-)

diff --git a/net/core/filter.c b/net/core/filter.c
index 99fdd8afeeda3..0ef77fb72af78 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -2774,7 +2774,7 @@ BPF_CALL_4(bpf_msg_push_data, struct sk_msg *, msg, u32, start,
 		sk_msg_iter_var_next(i);
 	} while (i != msg->sg.end);
 
-	if (start >= offset + l)
+	if (start > offset + l)
 		return -EINVAL;
 
 	space = MAX_MSG_FRAGS - sk_msg_elem_used(msg);
@@ -2799,6 +2799,8 @@ BPF_CALL_4(bpf_msg_push_data, struct sk_msg *, msg, u32, start,
 
 		raw = page_address(page);
 
+		if (i == msg->sg.end)
+			sk_msg_iter_var_prev(i);
 		psge = sk_msg_elem(msg, i);
 		front = start - offset;
 		back = psge->length - front;
@@ -2815,7 +2817,13 @@ BPF_CALL_4(bpf_msg_push_data, struct sk_msg *, msg, u32, start,
 		}
 
 		put_page(sg_page(psge));
-	} else if (start - offset) {
+		new = i;
+		goto place_new;
+	}
+
+	if (start - offset) {
+		if (i == msg->sg.end)
+			sk_msg_iter_var_prev(i);
 		psge = sk_msg_elem(msg, i);
 		rsge = sk_msg_elem_cpy(msg, i);
 
@@ -2826,39 +2834,44 @@ BPF_CALL_4(bpf_msg_push_data, struct sk_msg *, msg, u32, start,
 		sk_msg_iter_var_next(i);
 		sg_unmark_end(psge);
 		sg_unmark_end(&rsge);
-		sk_msg_iter_next(msg, end);
 	}
 
 	/* Slot(s) to place newly allocated data */
+	sk_msg_iter_next(msg, end);
 	new = i;
+	sk_msg_iter_var_next(i);
+
+	if (i == msg->sg.end) {
+		if (!rsge.length)
+			goto place_new;
+		sk_msg_iter_next(msg, end);
+		goto place_new;
+	}
 
 	/* Shift one or two slots as needed */
-	if (!copy) {
-		sge = sk_msg_elem_cpy(msg, i);
+	sge = sk_msg_elem_cpy(msg, new);
+	sg_unmark_end(&sge);
 
+	nsge = sk_msg_elem_cpy(msg, i);
+	if (rsge.length) {
 		sk_msg_iter_var_next(i);
-		sg_unmark_end(&sge);
+		nnsge = sk_msg_elem_cpy(msg, i);
 		sk_msg_iter_next(msg, end);
+	}
 
-		nsge = sk_msg_elem_cpy(msg, i);
+	while (i != msg->sg.end) {
+		msg->sg.data[i] = sge;
+		sge = nsge;
+		sk_msg_iter_var_next(i);
 		if (rsge.length) {
-			sk_msg_iter_var_next(i);
+			nsge = nnsge;
 			nnsge = sk_msg_elem_cpy(msg, i);
-		}
-
-		while (i != msg->sg.end) {
-			msg->sg.data[i] = sge;
-			sge = nsge;
-			sk_msg_iter_var_next(i);
-			if (rsge.length) {
-				nsge = nnsge;
-				nnsge = sk_msg_elem_cpy(msg, i);
-			} else {
-				nsge = sk_msg_elem_cpy(msg, i);
-			}
+		} else {
+			nsge = sk_msg_elem_cpy(msg, i);
 		}
 	}
 
+place_new:
 	/* Place newly allocated data buffer */
 	sk_mem_charge(msg->sk, len);
 	msg->sg.size += len;
-- 
2.43.0



