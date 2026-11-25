Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795623065;
	b=AAsu7oxGV4YdGX/0prbuKPe+SsGjcSOE/01lsl+EBno/SvM9+xkKFZjKpxA99DNHruIC
	 LxUDmUWW4kKnXbVgP2CnBt+p76rxc31LANE4zJxYlCZAkCMLPSVlNgKwPfjdFsF275vTH
	 hFIrczCYTKhHhaVOJGIeYrPCOIiNreejM6Xb8li4Tt6uxDOQBGTvcl6l4rlVC2ToUkWnW
	 tP+KN6Inc9D0JQO5aSZiSexuWMx50FyVLi9NMez63uqQXyrYA6aSj4Vo1wY+6wpsCYwyo
	 o/M3F5Fi/jiDAJ2fPTs0RE7pwfW0JaaXPiiMUUvluipfCy4PQuMKPGejCiH+sV9Q4+A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795623065;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=MBVn1X7n+lr4FEjpIhpMsCJjiOGBhpUWYTYpKqi7uCk=;
	b=w4YXzWfox1tHJJvcBFQzVglG9x06uPsIen/JitXfm1zpBoJVwgBrJnQ7VTDmF5dIWe/E
	 Nx3teLX4AfxCH2JFhsO+9hEX7c4JSuNR0sJWwer3LIAn++1ksbo4UUX0JfgxPhCcFXuAR
	 7cUb4MQfaupDt7TnWXXpivbjSnRHdSF/f8As7iR6EwaoGKE4B6xzsgoZrNtvTTL7zwGvV
	 UfXFuC8vAyH7XOy2HKhfrDCSpxwj0uWZ+InKE92d9P7qA2vffhpLJRpYjXhDnLoY9BbmC
	 +ldrma7h71LplJNGZFn7UBIoK4Cr8RzGsDVXpIdJ7KJk6zdXxhTG8p+W7AM2NW2Hrqw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=THWmAG7X;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2B38606A321;
	Wed, 25 Nov 2026 16:11:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=THWmAG7X
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FF111F000C6;
	Wed, 25 Nov 2026 16:11:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795623065;
	bh=MBVn1X7n+lr4FEjpIhpMsCJjiOGBhpUWYTYpKqi7uCk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=THWmAG7XwvyXPpGhbOBdBu+ExeqJ4GM8KAYwDWxl86H7bWcfLaxdzZtjpVa6uH8uh
	 AHh0tXxFjuRtndyVVtcbWgK1JPov6P5rFE+9tXko0A0b0YNRBK1v1yP0fqIwaiSVa/
	 5Ux+WYZq4lS3BPHLhwHIY/D+JDlc5e3T23F9J83w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Kyle Zeng <kylebot@openai.com>,
	Allison Henderson <achender@kernel.org>,
	Dave Miller <davem@davem-thinkpadp1gen8.ibmlond.csb>
Subject: [PATCH 6.18 694/990] net/rds: Do not unpin a page after a failed atomic pin
Date: Wed, 25 Nov 2026 15:34:21 +0100
Message-ID: <20261125143838.343991400@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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


