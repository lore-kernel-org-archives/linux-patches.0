Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795032361;
	b=TYk4FiRtOXLEN4TZG8ysGJzPotJVV9SrQb3t0XzpUthpvd4SrtjwG7FDQVcbpUN3i853
	 O5kPSArRik6bjLcCnvbS5ng5RzPHid8Mfsl6f8yLQEPtmeIfj5IMkAWycVTBbKfaO9gZP
	 CUbqfx5qTVH5kC9z4r4Uu7cCFdDlPkWc8IDjcRNK7ubTfdFE7NHdq6P/T+uTQ4WgelRGH
	 EGX2UFsW8mKFLw7kl8zuUGrd7hu9joPK/7Wpar9x74U8sqqcZB+xwOJbJiTgB+JNcAIrw
	 xR7X2nZ8n7Bku/eZa+6oEbSbj5c6yO0pXOk9VCiMzPc85hYfH5d4qhQWat71qAg4LRw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795032361;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=22Hoc6jRQoV6uv9WJIUAuMaNAsCEA14Gc4DCLIAblyY=;
	b=CFp41fKqN7uF0bWIAcD7rCtYVKY4Y+rhZNZeBmglXxTnXCzh/12KuthpWEht8OwnzB0b
	 w6WZXmjDfkJR1x2vY2Hf+WStAGODuNGW09UxGdn4bigR633btcE+VH9m5KXZIRdZoiGZa
	 /MZvIwpxcVZgDmGYY1LsjXyGS17KItN7d13/jGPqnl9ZLGC+BfuJhaeIXTkMvRE9b/vIm
	 kpqvTCLbZ0LNpDxAoGYPlrnk/u9BxjerPGuBOaTq9WF9HputVfH3KVRiYuhcwmFjN1xj+
	 GQsHnGz4lguCBUBg4BXrCffwm9dfUVHddshQdVCjCsTl8+Dfcfnz3WJTs0BnVMKyCRg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RBSL1N6q;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0CFE606A320;
	Wed, 18 Nov 2026 20:06:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RBSL1N6q
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1554C1F000C4;
	Wed, 18 Nov 2026 20:06:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795032361;
	bh=22Hoc6jRQoV6uv9WJIUAuMaNAsCEA14Gc4DCLIAblyY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RBSL1N6quawBnwlyjRyQeFxj0HC/2TuMp47uVMgCRCsVn26D24gjqQ9YgVMdcjxMy
	 YV9uaoSkXpT+3+qJodzXR1f8cc8hCoE/YDdlKh0mXy5viDZY5y4TtlDKzzXn5r9BbL
	 mx0GGNhgoaCl9NGz2afTrLrS4lJ1rmqiYHmO+wa4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1386/1756] bpf: Use memmove() to store bytes in an xdp_buff
Date: Wed, 18 Nov 2026 15:58:33 +0100
Message-ID: <20261118150104.348862140@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexei Starovoitov <ast@kernel.org>

[ Upstream commit ab08863c58b1a96ff8378e373cb3d277cbe65b68 ]

bpf_dynptr_write() to the dynptr of an xdp_buff ends in
bpf_xdp_store_bytes(). The source can be a slice of the same xdp_buff which
overlaps the destination, and the helper itself takes such a slice as well.
memcpy() then reads bytes which it has overwritten already. On x86 with
FSRM

  p = bpf_dynptr_slice_rdwr(&ptr, 0, NULL, 64);
  bpf_dynptr_write(&ptr, 8, p, 64, 0);

repeats the first 8 bytes of the packet instead of moving 64.

A write that crosses from the linear part into a fragment is copied piece
by piece, where the first piece can overwrite what the second one has yet
to read. That is not dealt with here.

Fixes: 2012c867c800 ("bpf: verifier: Accept dynptr mem as mem in helpers")
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Link: https://patch.msgid.link/20261017230950.802052-16-alexei.starovoitov@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/filter.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/core/filter.c b/net/core/filter.c
index f8a1c78d46fd4..16ac1c7a842d4 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -4189,7 +4189,8 @@ BPF_CALL_4(bpf_xdp_store_bytes, struct xdp_buff *, xdp, u32, offset,
 	if (!ptr)
 		bpf_xdp_copy_buf(xdp, offset, buf, len, true);
 	else
-		memcpy(ptr, buf, len);
+		/* through a dynptr the source may be an overlapping slice */
+		memmove(ptr, buf, len);
 
 	return 0;
 }
-- 
2.53.0



