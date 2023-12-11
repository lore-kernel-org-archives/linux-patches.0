Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F26A5101A;
	Mon, 11 Dec 2023 18:29:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JJBQyXTE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02890C433C7;
	Mon, 11 Dec 2023 18:29:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702319348;
	bh=n0fOCiAskv/Y13yPCXVakOJ4PbV1AWLEAauiqCYQ6w0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JJBQyXTE5onjT2LPuOsN7HkXklGSj0BCxg6Fob679qwAHkSvsJeT5r20nfT2P1bQ4
	 sb97vIz99Lm3ugU5SFXGJAXsX5MuUmlNJLGhPSVF+ckR9qUcfy+D7A9faiftyNcTLk
	 ZsWjfMN4gCB/1GQ+JtmiV5GrTsqqVogb+QOcKcjE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Fastabend <john.fastabend@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 070/244] bpf: sockmap, updating the sg structure should also update curr
Date: Mon, 11 Dec 2023 19:19:23 +0100
Message-ID: <20231211182048.945821010@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231211182045.784881756@linuxfoundation.org>
References: <20231211182045.784881756@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index b149a165c405c..90fe3e7543833 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -2591,6 +2591,22 @@ BPF_CALL_2(bpf_msg_cork_bytes, struct sk_msg *, msg, u32, bytes)
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
@@ -2710,6 +2726,7 @@ BPF_CALL_4(bpf_msg_pull_data, struct sk_msg *, msg, u32, start,
 		      msg->sg.end - shift + NR_MSG_FRAG_IDS :
 		      msg->sg.end - shift;
 out:
+	sk_msg_reset_curr(msg);
 	msg->data = sg_virt(&msg->sg.data[first_sge]) + start - offset;
 	msg->data_end = msg->data + bytes;
 	return 0;
@@ -2846,6 +2863,7 @@ BPF_CALL_4(bpf_msg_push_data, struct sk_msg *, msg, u32, start,
 		msg->sg.data[new] = rsge;
 	}
 
+	sk_msg_reset_curr(msg);
 	sk_msg_compute_data_pointers(msg);
 	return 0;
 }
@@ -3014,6 +3032,7 @@ BPF_CALL_4(bpf_msg_pop_data, struct sk_msg *, msg, u32, start,
 
 	sk_mem_uncharge(msg->sk, len - pop);
 	msg->sg.size -= (len - pop);
+	sk_msg_reset_curr(msg);
 	sk_msg_compute_data_pointers(msg);
 	return 0;
 }
-- 
2.42.0



