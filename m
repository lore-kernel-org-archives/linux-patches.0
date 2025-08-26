Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37C541494D9;
	Tue, 26 Aug 2025 14:08:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756217314; cv=none; b=QyjQlfiIRrEcQGqw5bRIf1zsfKvBy3SSSYPZAPMz3pfVKArdBDI+i3dJSC5p5+NkgnHZz0lRnToS0uieR+juPj85HaVJjDEj0MAiq1BuBQuqr5Kki9vou22/TXbZUyT4anWPzI5LBkPYVZ3bekoOKJLbuAYvEiLiDGigKGdn+2o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756217314; c=relaxed/simple;
	bh=/aa0rD8vACv4TlthYqE+kUVjMqXNtzbFfWgfHGOsaGU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QebOcOMzVT5uf5sildF1hFGPjNuyzmHmIgNYJfd8ksEn/ORAHCAPjcSFWzj4SCCEtCSHNmObJZjmivz0gtYLOLrgJxFLGiFTnchwcRdshv61jE9hmMVFeVvsGO5tIj8cdwFfi4MSo6P4YRPt5QtiCE1CR1y01enc7y9Xjuj7VAI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FNued1ft; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FNued1ft"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4789C4CEF1;
	Tue, 26 Aug 2025 14:08:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756217314;
	bh=/aa0rD8vACv4TlthYqE+kUVjMqXNtzbFfWgfHGOsaGU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FNued1ft0KYAMCgi+6wVyIYOpk6Fr/fe769MxizYzrEwgCQFbBx9jttzDsj8+92Mh
	 JqSlMwENEkkmJ8LBvUYXvmR4h70eK7UO5qp5/4gDrrI2hgHI2ssFMJa+2eob7A5Ba+
	 /HBgfnKkyQp35yxHP1e31DFUPROznn/HUiPVUJDw=
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
Subject: [PATCH 5.10 095/523] bpf, ktls: Fix data corruption when using bpf_msg_pop_data() in ktls
Date: Tue, 26 Aug 2025 13:05:05 +0200
Message-ID: <20250826110926.889978319@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110924.562212281@linuxfoundation.org>
References: <20250826110924.562212281@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 7a448fd96f81..e519a0160668 100644
--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -825,6 +825,19 @@ static int bpf_exec_tx_verdict(struct sk_msg *msg, struct sock *sk,
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



