Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE5991F76D4;
	Tue,  3 Dec 2024 15:52:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733241161; cv=none; b=oDLCpLjqn7s7Qla/84RyRlLIbjycvd7apobe1i4yIZhbvIlLWeYunXYAqRpTeAGQvJ9xJZ5cQ1tQzf2bq/GhlL9eXF+mA8AxuE2Qjkhqbfs2vegEB5ZeEG90AEHkxIl18DHoRtRnB+YupAdDfkL/UuU13+MeKixTHPdal1rBg0k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733241161; c=relaxed/simple;
	bh=6Tj6JnKCDTzVzEzWMFSgXLJuWm6xEWyUiNVBluOBcoE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IDnSSc7Lb9TUhuFZOX2WMwZYxdrftqwXllm9iK05XB2k1KJStgDZbAGZcx6HECywO2lCW+uoGf1pQi86vOyE5sPZMC3BMmDZVdm22B541V5WbRCP/9kJ68ip+cPJ6gUlWKit1atYGwrOVwFNt3EqKUY3v7uxrp5atClAQ5kDb7k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=u1KzWnCx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="u1KzWnCx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C90CC4CECF;
	Tue,  3 Dec 2024 15:52:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733241161;
	bh=6Tj6JnKCDTzVzEzWMFSgXLJuWm6xEWyUiNVBluOBcoE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=u1KzWnCxKBvAVKWXWMHDC89orrBKPLCtCg3PIVkqM1J0Nre0w/X/UZnc5sC66C89P
	 uHyVjc2FgpuKS1J57oFdVwQ9eAzfL8/ywrREhMj6YC6FRVNFHMyqK5KJEOHWenxpqo
	 tyEGrkOEcCD1HSBkL30CGVxR5Okb5OYG9OF4txMw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zijian Zhang <zijianzhang@bytedance.com>,
	Martin KaFai Lau <martin.lau@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 312/826] bpf, sockmap: Several fixes to bpf_msg_push_data
Date: Tue,  3 Dec 2024 15:40:39 +0100
Message-ID: <20241203144755.934221080@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index fb56567c551ed..0315ebbabe728 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -2795,7 +2795,7 @@ BPF_CALL_4(bpf_msg_push_data, struct sk_msg *, msg, u32, start,
 		sk_msg_iter_var_next(i);
 	} while (i != msg->sg.end);
 
-	if (start >= offset + l)
+	if (start > offset + l)
 		return -EINVAL;
 
 	space = MAX_MSG_FRAGS - sk_msg_elem_used(msg);
@@ -2820,6 +2820,8 @@ BPF_CALL_4(bpf_msg_push_data, struct sk_msg *, msg, u32, start,
 
 		raw = page_address(page);
 
+		if (i == msg->sg.end)
+			sk_msg_iter_var_prev(i);
 		psge = sk_msg_elem(msg, i);
 		front = start - offset;
 		back = psge->length - front;
@@ -2836,7 +2838,13 @@ BPF_CALL_4(bpf_msg_push_data, struct sk_msg *, msg, u32, start,
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
 
@@ -2847,39 +2855,44 @@ BPF_CALL_4(bpf_msg_push_data, struct sk_msg *, msg, u32, start,
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



