Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793215046;
	b=hDQbFPyFkBVmAw+PnuNNJcDSksVfM8LiEw2LJhgFulB3W0B7GnahC1qMqQ8xs/ka0AjZ
	 6yTXZecziwCqDgnEHmrfoUX1oCZFicv+L3GyQGC4qdUZKT+RWIJcpFIA6RRtSEIe8q1JU
	 qlYX18dfrWR6JiZxOg+M64LbpgRYv0uZMnf1HMvn3LLLEOeEERXi2AM7em2R44RF+z18Q
	 uSJprZG5hW2aokEdcVq83S9tN/AKVIXjaWnN5FtEHEXa0QMriHbfSuej4Mk0Q2k0r7tlx
	 8gZnKrBX0bKJ3DAeU06/8Lv8zEdQBQCmTNhawhcxc8Q/SSeiGqRFy9C8+qnFK/yEe6w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793215046;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=n80MuJ8uSS65IWpRCfbg4XyPv4ttLBZL/4RegcNs0tk=;
	b=HLaHRY5sqMCmjEiykTLvbkoOTVbMBSHiwo0W7kilhdMR6pyQZC4jowTvvyvlz+6QNno5
	 W6AHF7t/C8d3Iu4P9xZjb1aYxJrl1BKd3GeFp4tFpxB5IdMolUA1mk6yCI2cuSyJ44i+t
	 J03L5vl1JM/5pwyHKC0VtyJgDAFJmOCPUXI5nNT1Aqun8BfqntyrN/AAHoicZ4erI9sxM
	 Uv3OoUuV3Th4DdP/WnvhsBaquQLt2Kuj4p/1zQ4cAw8cNpBGr0lJEahdo2pzfRUqG23IH
	 8SdZ+QFbvwrm9K10WFbCio169Qsm3+6COOrXoKt/wXa3SZUboqARPbgLIpRRbfvsaqA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=seEud+5U;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF256606A31A;
	Wed, 28 Oct 2026 19:17:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=seEud+5U
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C7581F01825;
	Wed, 28 Oct 2026 19:17:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793215045;
	bh=n80MuJ8uSS65IWpRCfbg4XyPv4ttLBZL/4RegcNs0tk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=seEud+5Uptm5+ykp9O9PNTyObpQYY45WAqld0tsmZYNSmRpGNB5bBRVQql+OE5V4l
	 bZZqaURHRC0FflsYYdMuKgj9B2qDLF4s7sZ6UOArJQiP0GjgaQ4kfWTR8qIcTME16r
	 Hv3N25UDKoISg3YA0s2ktHcqkxeCQkTIoM8+rNiM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Raphael Zimmer <raphael.zimmer@tu-ilmenau.de>,
	Ilya Dryomov <idryomov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1072/1887] libceph: Fix potential out-of-bounds access in __ceph_x_decrypt()
Date: Wed, 28 Oct 2026 17:52:48 +0100
Message-ID: <20261028170523.806464108@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Raphael Zimmer <raphael.zimmer@tu-ilmenau.de>

[ Upstream commit 821365487aa58d06bda65c676ba215d506ba9768 ]

In __ceph_x_decrypt(), a part of the buffer p is interpreted as a
ceph_x_encrypt_header, and the magic field of this struct is accessed.
This happens without any guarantee that the buffer is large enough to
hold this struct. The function parameter ciphertext_len represents the
length of the ciphertext to decrypt and is guaranteed to be at most the
remaining size of the allocated buffer p. However, this value is not
necessarily greater than sizeof(ceph_x_encrypt_header). E.g., a message
frame of type FRAME_TAG_AUTH_REPLY_MORE, that is just as long to hold
the ciphertext at its end with a ciphertext_len of 8 or less, can
trigger an out-of-bounds memory access when accessing hdr->magic.

This patch fixes the issue by adding a check to ensure that the
decrypted plaintext in the buffer is large enough to represent at least
the ceph_x_encrypt_header.

Cc: stable@vger.kernel.org
Signed-off-by: Raphael Zimmer <raphael.zimmer@tu-ilmenau.de>
Reviewed-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ceph/auth_x.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/net/ceph/auth_x.c b/net/ceph/auth_x.c
index c83559f015e46..f805a813308fd 100644
--- a/net/ceph/auth_x.c
+++ b/net/ceph/auth_x.c
@@ -86,6 +86,11 @@ static int __ceph_x_decrypt(struct ceph_crypto_key *secret, void *p,
 	if (ret)
 		return ret;
 
+	if (plaintext_len < sizeof(*hdr)) {
+		pr_err("%s plaintext too small %d\n", __func__, plaintext_len);
+		return -EINVAL;
+	}
+
 	if (le64_to_cpu(hdr->magic) != CEPHX_ENC_MAGIC) {
 		pr_err("%s bad magic\n", __func__);
 		return -EINVAL;
-- 
2.53.0



