Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795705399;
	b=SppGlyAWllCMPRd4f2mGPIfE8at41QR8iH+p0LByharFAYR4JITHnRtS1q0UBwzn8DkY
	 4F+G9oSLv8z6ZC3AQA84uibspGgEnbU9zrw5gZxEOQS/qz0/uDXwy6H8esn+E+LL0neyp
	 s4RzP/JxPPKZTggtvPqg8sjKXOZ5GffQe1yf3q01xIHmnvGDZSkdJtwFL0GZxd51xlDZz
	 JStxJeiG27GuWxkKMhGn6eBrn4j/rX6p7kmtQsuFYtNNCG2zjEoIioUR94FuJBsyOxRKO
	 KGKZViFMb5/k+rijVY8+rKu8qJghZKeBA7FsJtWgRIyR3pCHsatdQLzZm5N8ULZcM4g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795705399;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=WsyAmkl3Lcuq6/BfEfysTSkBUtKM0IgiQ3Q8z+HDyHs=;
	b=MG/qxHzETpEFKd3X1bOGvN4oukGnzTZZY68hHxvtPNgFm13bjgSUFogksjICzYCCfD27
	 IRVcSIKekCuNbiP0ivfubyKCOmzGT5SOYNlfxBSdAPbptCbA+MkARuqNKc8cTNB0nsKHE
	 PSE7LproVIJS17QgaFlugM/0m8pDZJUPMGA6VzON8E+T6rQcYdRjykePI/mXGSVLdtGUf
	 pHyTuJHQhYH2aGQPECV4ScVD5H9zR/5RKBIGtHAhBysmJG7j0hvfprhx2ShkqyaFnA82h
	 TwpbGqoO+6ZGz1zrcDPKE4p3jlC2eHozlqsQQHEVe5+DdHJRBGJ3ZYN6xGFiHa225/w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xUYDT5cC;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EA6D606A31C;
	Thu, 26 Nov 2026 15:03:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xUYDT5cC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 559551F000C4;
	Thu, 26 Nov 2026 15:03:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795705398;
	bh=WsyAmkl3Lcuq6/BfEfysTSkBUtKM0IgiQ3Q8z+HDyHs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xUYDT5cCqpaoslCodLIK0H8Qun2khS+Qt2fIk757OW+T6p4jaq/yJiNDodHgFjXml
	 3BItnqpAiysiqvTAq8V3eBmkvSLIYPv7u0pnuRoka6CBgrWtfJmLAoBGcUAMsr0GeA
	 e5dytHaNNfx9S7TlPaC8KvSuQWYVpha54wowN/pg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Kyle Zeng <kylebot@openai.com>,
	Allison Henderson <achender@kernel.org>,
	Dave Miller <davem@davem-thinkpadp1gen8.ibmlond.csb>
Subject: [PATCH 5.15 186/319] net/rds: Do not unpin a page after a failed atomic pin
Date: Thu, 26 Nov 2026 15:39:14 +0100
Message-ID: <20261126144010.944435614@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126144006.732901931@linuxfoundation.org>
References: <20261126144006.732901931@linuxfoundation.org>
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

From: Kyle Zeng <kylebot@openai.com>

commit 8d5ce4751fad9499ea408163af7f410f18a85782 upstream.

rds_cmsg_atomic() assumes that a non-NULL output from rds_pin_pages()
represents a pin that it owns. However, pin_user_pages_fast() can roll
back a fast-GUP pin after racing fork() and then fail in the slow path,
for example after a concurrent mprotect(PROT_NONE). The output slot can
still contain the already-unpinned page.

The common error path calls unpin_user_page() on that stale pointer.
This can consume another subsystem's pin and allow the page to be freed
while it is still in use. A local unprivileged reproducer triggers a
KASAN use-after-free write through an io_uring registered buffer.

Clear page when rds_pin_pages() does not return one. The error path
continues to release the page on errors after a successful pin, and
successful requests retain their existing ownership and behavior. All
four RDS atomic ancillary operations share this path.

The issue was found by an LLM.

Fixes: 15133f6e67d8 ("RDS: Implement atomic operations")
Cc: stable@kernel.org
Signed-off-by: Kyle Zeng <kylebot@openai.com>
Reviewed-by: Allison Henderson <achender@kernel.org>
Signed-off-by: Dave Miller <davem@davem-thinkpadp1gen8.ibmlond.csb>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/rds/rdma.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/net/rds/rdma.c
+++ b/net/rds/rdma.c
@@ -960,8 +960,11 @@ int rds_cmsg_atomic(struct rds_sock *rs,
 	}
 
 	ret = rds_pin_pages(args->local_addr, 1, &page, 1);
-	if (ret != 1)
+	if (ret != 1) {
+		/* A failed pin can leave a stale page pointer. */
+		page = NULL;
 		goto err;
+	}
 	ret = 0;
 
 	sg_set_page(rm->atomic.op_sg, page, 8, offset_in_page(args->local_addr));


