Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793828995;
	b=CbRi3iyjiBOnEsfPdJ0PrH3+4d1ZS/wr1mq/8mIhEnFl9DHVB+UyQQqaOydka4TgcJm9
	 r+S1MUiGFr7iRAyUx9uomkEQ6km8zy+xPJhHVoe60yObOkhDkjM7MHL8tX7k7Z93mGhEE
	 FBnm/0mP9RdCgE854Vex/gAd3FrpzTeSRgM4hQ18/yyr4nP+LMxAT1FO4gphoY1ELXpcV
	 lehDcs1CT5jAVncTmdzNrqRzr+hWLM2MgwifeV9DooWXctCSP95I8iwolVzgMvtGIeYNn
	 Llja6M1hVY0Qjlq9DSMvrzBWRJhU717p+dvrG3l9Nwh2l1Qwk1jJoa/hv0uzjCDqtgA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793828995;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=PXyd3iv0/MbnscrF1CkL3HGa2ACeb40a/Ox6/SYec/I=;
	b=oxrCBoVCLkGE/VF5UcI4BnmKdZn+06+Q0Px8PG5G7HjXodtHNYF183ooNGBa+AHZbZp+
	 16IIodYG9Vy5VzvgiXYMJV1yuoXnoj62F+4eoLVa0BojWrZmtx6NUY3be/mSm1j/89Zkh
	 AXJQv1uXkBkhZRM5FPq1IExNxlyX6lAlaW6y8mJVz7H8vyKhJWwGw5VaxY0myyN3byX0Q
	 OcH8607qQWZY8mEk5GK6qooYLRNtsqRYapKBuQiIFzDpw1ZMezw6khBNh7qIGCL5PiQY6
	 Pi6H0KdBTFlm9r5gpnvN399IpdOTR0qHQkt2veigEbhoBQrooxhXWHXwt+Plo0T0sEg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cPvD4Quo;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94B40607F294;
	Wed,  4 Nov 2026 21:49:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cPvD4Quo
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31E091F00919;
	Wed,  4 Nov 2026 21:49:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793828995;
	bh=PXyd3iv0/MbnscrF1CkL3HGa2ACeb40a/Ox6/SYec/I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cPvD4QuoeFmlmUBg2CJio97PgLLaBDcUkZ9NS4AKa3aguRg1qUvGAMJhyxsq48tqf
	 fQYwQC2WFaQQYOTY8HcvNcA7pBEjdqjHT6Rb2hANl4i5e/ee0EkTaKhUREbhs0HVS6
	 yOHkyVeEAKtzY3wAdNVDQnqB5RMIUiRizfuBwCD0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefan Metzmacher <metze@samba.org>,
	Namjae Jeon <linkinjeon@kernel.org>,
	zdi-disclosures@trendmicro.com
Subject: [PATCH 7.3 376/547] smb: smbdirect: fix buffer length underflow in RDMA transfers
Date: Wed,  4 Nov 2026 16:09:20 -0500
Message-ID: <20261104211048.984030288@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211038.406938024@linuxfoundation.org>
References: <20261104211038.406938024@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stefan Metzmacher <metze@samba.org>

commit 7193241a49c958782ba4b8df06da3734d1e317d2 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/smbdirect/rw.c |    1 -
 1 file changed, 1 deletion(-)

--- a/fs/smb/smbdirect/rw.c
+++ b/fs/smb/smbdirect/rw.c
@@ -143,7 +143,6 @@ int smbdirect_connection_rdma_xmit(struc
 		if (desc_buf_len > buf_len) {
 			desc_buf_len = buf_len;
 			desc[i].length = cpu_to_le32(desc_buf_len);
-			buf_len = 0;
 		}
 
 		credits_needed += smbdirect_connection_calc_rw_credits(sc,


