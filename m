Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795052188;
	b=DP0ioLFYbfXga07AStEqIJvup0G6Z92APg/kG3Ohh8DIsQ5bpHZt/NweRFdjA5tjVD/j
	 OvYWn1g+0E3ZcthuKjXBdyid1o+1bMXwJPENNizd8zQQm7zrF7IFb/FHqZj95K7sM5C8a
	 YoBGhw5vbW95539jVKIMs0Ia+gXeYFCBMxfipOAE0ZdYTTK/4TlgtCS5VlNiYNA1LKmwi
	 7WKfIubRe8OybDpqn2iZAm/j4X/UkeEQXnmY6AitKlL45ZUW5rGpB/UKK/JkfpeY8cyDS
	 u6OFWRqnCRaRM4BMNjEIwGgAHqqH2uTA1n0Bq47K9XrmLs5tlsfWL58F8rluCwxS7IA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795052188;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=mpEghRKknv6eN7FcrfVGsms5VET26UJJH2LFU745HEA=;
	b=B1OeQ4CAJOEzd2NSOtMs0pczY8Udv7lAESPcsdhIjcRtzchBnOwnNfrCfsctYptq0gy9
	 f5ja4NM+TeYSZgHHUIhX9Ia+ZZ6iLuuLKZIDWYOZn+SbzZnw/hthtT1IzFlIKS+3tblqG
	 8i0LjexkcCz8sr07sGSxQ1vO8Bqk4lX0qKLU9SvxADTE6yI5uZ6GrKPKwLFTYC2XP30OX
	 eBO0AQ0aRs2Zhz8n2UmFqIZuFdkkgM2Kvf5Zd2112zmgFceaH2AjG5rHeUs+nQ4AeEz5F
	 U7cqfmt8jYPZZrFnFdGWXulN62wfK6E1NbkKbIOqNo/Na7xF3faatRULDuvAiQBdN+g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bylZUYBA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CE49606A32A;
	Thu, 19 Nov 2026 01:36:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bylZUYBA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9AE91F000C4;
	Thu, 19 Nov 2026 01:36:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795052188;
	bh=mpEghRKknv6eN7FcrfVGsms5VET26UJJH2LFU745HEA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bylZUYBAAJMmVZfQPWE7o0ACTNh3kP9IUhskmt1YJeknraBLIOG+0WpNjZ9zVFcPJ
	 h2Kq9C5289tibJIkBldBIra3usibmbT0dbs/QZznIA1MYpN+exqLdcxwpsaXJnbdrH
	 L7JK4M+GIspXihxP2DIKuJkQHhnmtINZ+oNrT7nI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefan Metzmacher <metze@samba.org>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	zdi-disclosures@trendmicro.com
Subject: [PATCH 5.15 0415/2214] smb: smbdirect: fix buffer length underflow in RDMA transfers
Date: Wed, 18 Nov 2026 15:34:51 +0100
Message-ID: <20261118150027.452802445@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stefan Metzmacher <metze@samba.org>

[ Upstream commit 7193241a49c958782ba4b8df06da3734d1e317d2 ]

When a remote buffer descriptor is larger than the remaining local
buffer, smbdirect_connection_rdma_xmit() clamps its length and sets
buf_len to zero. The common accounting code then subtracts the clamped
length from buf_len, causing it to underflow. If another descriptor
follows, the loop processes it with a wrapped remaining length and
includes memory beyond the local buffer in the RDMA transfer.

A client can trigger an out-of-bounds kernel write with an SMB WRITE
request, or an out-of-bounds kernel read with an SMB READ request, by
supplying multiple RDMA buffer descriptors with an oversized descriptor
before the last one.

Remove the premature assignment to buf_len. Subtracting the clamped length
already consumes the remaining buffer, so the next iteration stops and
only descriptors within the local buffer are used to build work requests.

Fixes: e628bf939aaf ("ksmbd: reduce descriptor size if remaining bytes is less than request size")
Cc: stable@vger.kernel.org
Reported-by: zdi-disclosures@trendmicro.com # ZDI-CAN-33549
Signed-off-by: Stefan Metzmacher <metze@samba.org>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
[ metze: in 5.15 the code is smb_direct_rdma_xmit() in
  fs/ksmbd/transport_rdma.c ]
Assisted-by: Claude:claude-opus-5-5
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ksmbd/transport_rdma.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/ksmbd/transport_rdma.c b/fs/ksmbd/transport_rdma.c
index 6ea73fe6de6c5..9986e191e7019 100644
--- a/fs/ksmbd/transport_rdma.c
+++ b/fs/ksmbd/transport_rdma.c
@@ -1361,7 +1361,6 @@ static int smb_direct_rdma_xmit(struct smb_direct_transport *t,
 		if (desc_buf_len > buf_len) {
 			desc_buf_len = buf_len;
 			desc[i].length = cpu_to_le32(desc_buf_len);
-			buf_len = 0;
 		}
 
 		credits_needed += calc_rw_credits(t, desc_buf, desc_buf_len);
-- 
2.53.0



