Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DAB3341AA6;
	Tue, 26 Aug 2025 14:32:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756218741; cv=none; b=qtn4O26ZPQaEIm9ENVjYS6ohn1ZI4uIGDV0R1oZbSYkGH3mav1QM7NMx0+Mh9lDJ/qHKn9aGwYDgFeMPlAMrs4Nn7r/DjNQFsmwUaSV/71/D8jLtKnM0DrqBQKu3X9dT743vzFmpm1cDS0GcZHTd8HeGxl4SWjE4xNE3TcMPxTo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756218741; c=relaxed/simple;
	bh=p8XYr+QV1YT/eIxGLuD2niH/9XEnLeM2veMnJhikC9k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RKwuOVOJmRf02HqeCA8KTkfzOaBAMB50B6z0NquJrk6RhDWYhSr9nNa33pN+VGi4xc4a4W45ZMGDA+rnKeLyTR8xkDbuwX4U4i23DiGPvimHCEWF0jbULSg4s+hTId1mK2DRPVMAhisZr64vlpdEk6d+fa3rEesbWKB40jToAm4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2ELLZBvw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2ELLZBvw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 222DFC113CF;
	Tue, 26 Aug 2025 14:32:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756218741;
	bh=p8XYr+QV1YT/eIxGLuD2niH/9XEnLeM2veMnJhikC9k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2ELLZBvwvtMZvLSVtG6wIa7sSzzgs/G+KCijem2ux4IkTVLJM98w1Jz7GddXbm1ah
	 bZHN0IQZWU3DPoblIu6k+hq/8sWkTd8ycpuXPHqiViShcv2sXDvS+//D3wOdy/WwtH
	 Cr//iUEY8wX9ILzTkOwzVudYplz3C9pn+ZBRfj/U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cong Wang <xiyou.wangcong@gmail.com>,
	Jiayuan Chen <jiayuan.chen@linux.dev>,
	Daniel Borkmann <daniel@iogearbox.net>,
	John Fastabend <john.fastabend@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 084/403] bpf, ktls: Fix data corruption when using bpf_msg_pop_data() in ktls
Date: Tue, 26 Aug 2025 13:06:50 +0200
Message-ID: <20250826110908.979930225@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110905.607690791@linuxfoundation.org>
References: <20250826110905.607690791@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiayuan Chen <jiayuan.chen@linux.dev>

[ Upstream commit 178f6a5c8cb3b6be1602de0964cd440243f493c9 ]

When sending plaintext data, we initially calculated the corresponding
ciphertext length. However, if we later reduced the plaintext data length
via socket policy, we failed to recalculate the ciphertext length.

This results in transmitting buffers containing uninitialized data during
ciphertext transmission.

This causes uninitialized bytes to be appended after a complete
"Application Data" packet, leading to errors on the receiving end when
parsing TLS record.

Fixes: d3b18ad31f93 ("tls: add bpf support to sk_msg handling")
Reported-by: Cong Wang <xiyou.wangcong@gmail.com>
Signed-off-by: Jiayuan Chen <jiayuan.chen@linux.dev>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Reviewed-by: John Fastabend <john.fastabend@gmail.com>
Acked-by: Jakub Kicinski <kuba@kernel.org>
Link: https://lore.kernel.org/bpf/20250609020910.397930-2-jiayuan.chen@linux.dev
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/tls/tls_sw.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/net/tls/tls_sw.c b/net/tls/tls_sw.c
index 432bce329392..8dabbbf52168 100644
--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -822,6 +822,19 @@ static int bpf_exec_tx_verdict(struct sk_msg *msg, struct sock *sk,
 		delta = msg->sg.size;
 		psock->eval = sk_psock_msg_verdict(sk, psock, msg);
 		delta -= msg->sg.size;
+
+		if ((s32)delta > 0) {
+			/* It indicates that we executed bpf_msg_pop_data(),
+			 * causing the plaintext data size to decrease.
+			 * Therefore the encrypted data size also needs to
+			 * correspondingly decrease. We only need to subtract
+			 * delta to calculate the new ciphertext length since
+			 * ktls does not support block encryption.
+			 */
+			struct sk_msg *enc = &ctx->open_rec->msg_encrypted;
+
+			sk_msg_trim(sk, enc, enc->sg.size - delta);
+		}
 	}
 	if (msg->cork_bytes && msg->cork_bytes > msg->sg.size &&
 	    !enospc && !full_record) {
-- 
2.39.5



