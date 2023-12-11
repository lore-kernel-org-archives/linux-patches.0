Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4DB4321B8;
	Mon, 11 Dec 2023 18:55:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="E+HF4rqM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4AAA4C433C7;
	Mon, 11 Dec 2023 18:55:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702320915;
	bh=5dFeOSxTOlnR2KaUo9fB/GuEi+haEUwOsUD0mHn03s8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=E+HF4rqMWbDBus8iCbNvEhHAThlqkqTY4HwtIfQ4A72WjnN7vS35tjE0VABUuZNVv
	 j4n5Fl3Vi3F/kotRY8Q8kMpU3osn/+1s/+ssCwrRroKsjECMUCsRwq47kmqer0fj/z
	 EoUqMIFKyEff4fKAtZ4JHfJIaJ0Vef0l/mxVKes0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Fastabend <john.fastabend@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 043/141] bpf: sockmap, updating the sg structure should also update curr
Date: Mon, 11 Dec 2023 19:21:42 +0100
Message-ID: <20231211182028.393835510@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231211182026.503492284@linuxfoundation.org>
References: <20231211182026.503492284@linuxfoundation.org>
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

From: John Fastabend <john.fastabend@gmail.com>

[ Upstream commit bb9aefde5bbaf6c168c77ba635c155b4980c2287 ]

Curr pointer should be updated when the sg structure is shifted.

Fixes: 7246d8ed4dcce ("bpf: helper to pop data from messages")
Signed-off-by: John Fastabend <john.fastabend@gmail.com>
Link: https://lore.kernel.org/r/20231206232706.374377-3-john.fastabend@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/filter.c | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/net/core/filter.c b/net/core/filter.c
index 76432aa3b717c..0f5faa876fd12 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -2576,6 +2576,22 @@ BPF_CALL_2(bpf_msg_cork_bytes, struct sk_msg *, msg, u32, bytes)
 	return 0;
 }
 
+static void sk_msg_reset_curr(struct sk_msg *msg)
+{
+	u32 i = msg->sg.start;
+	u32 len = 0;
+
+	do {
+		len += sk_msg_elem(msg, i)->length;
+		sk_msg_iter_var_next(i);
+		if (len >= msg->sg.size)
+			break;
+	} while (i != msg->sg.end);
+
+	msg->sg.curr = i;
+	msg->sg.copybreak = 0;
+}
+
 static const struct bpf_func_proto bpf_msg_cork_bytes_proto = {
 	.func           = bpf_msg_cork_bytes,
 	.gpl_only       = false,
@@ -2695,6 +2711,7 @@ BPF_CALL_4(bpf_msg_pull_data, struct sk_msg *, msg, u32, start,
 		      msg->sg.end - shift + NR_MSG_FRAG_IDS :
 		      msg->sg.end - shift;
 out:
+	sk_msg_reset_curr(msg);
 	msg->data = sg_virt(&msg->sg.data[first_sge]) + start - offset;
 	msg->data_end = msg->data + bytes;
 	return 0;
@@ -2831,6 +2848,7 @@ BPF_CALL_4(bpf_msg_push_data, struct sk_msg *, msg, u32, start,
 		msg->sg.data[new] = rsge;
 	}
 
+	sk_msg_reset_curr(msg);
 	sk_msg_compute_data_pointers(msg);
 	return 0;
 }
@@ -2999,6 +3017,7 @@ BPF_CALL_4(bpf_msg_pop_data, struct sk_msg *, msg, u32, start,
 
 	sk_mem_uncharge(msg->sk, len - pop);
 	msg->sg.size -= (len - pop);
+	sk_msg_reset_curr(msg);
 	sk_msg_compute_data_pointers(msg);
 	return 0;
 }
-- 
2.42.0



