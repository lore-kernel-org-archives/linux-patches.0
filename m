Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAACB2ECE93;
	Tue, 12 Aug 2025 18:34:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755023652; cv=none; b=djmL0am++qskicJCvUm/9Qd1jVMxvUwjhjkza/aRUuZFW8zmhWU1NLuWMG7dwUuhGX88KfUdOtcTVXq63tvAv5mo6DjFLJ4xbm6PteJefejff0NNC9gWNx1RWO96cYr/c86t7DRIYYK0Gf7lhdWju7w+7sM557DICJK1H8gY8Yc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755023652; c=relaxed/simple;
	bh=gaSaahimMuVdFxdEY66Wi/vIK0b1rcGsfpmQefK/s54=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i0k+XSCEaxF/Mf/FvL7wL5oA8S/ulhHd3VCGXsMDeY8VmeREoFt2PfCrfXVLKIPj9/gIMvCiAOrbPL3ityRsyrO6WBthdRetGBTX1lLPmPc6TVzz0WXAl1xkkj8jma0m6RNX/aylLA/EXbIefHeaKCwR6qTvD+/c0wihJxt5yi8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RjPEStN/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RjPEStN/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45D49C4CEF0;
	Tue, 12 Aug 2025 18:34:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755023652;
	bh=gaSaahimMuVdFxdEY66Wi/vIK0b1rcGsfpmQefK/s54=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RjPEStN/P0xCqV9of8wW530HsW9PZmAR/jAqf6xhn/y3F/nOrO2TLOSmFnMi62jso
	 s7krpyMkb9U8ov+TdUdXvcDmnyvJKJB+0AJAS2lklOdPbXZfD85tlf2LxVTM7SB01i
	 IqnP6acCMoTUbBBOp2CKwvWIeW3yKTZtaC1bxFpk=
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
Subject: [PATCH 6.16 143/627] bpf, ktls: Fix data corruption when using bpf_msg_pop_data() in ktls
Date: Tue, 12 Aug 2025 19:27:18 +0200
Message-ID: <20250812173424.736393357@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
References: <20250812173419.303046420@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

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
index fc88e34b7f33..549d1ea01a72 100644
--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -872,6 +872,19 @@ static int bpf_exec_tx_verdict(struct sk_msg *msg, struct sock *sk,
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



