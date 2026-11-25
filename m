Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795619521;
	b=ooAUZ5HG5pmhwuMRiyJQyug5H3RLK5CA7dnLC6B5ofVXHTeJvCdzJpdNz6OwuXySMd9v
	 LJwAcgvIMcguPDkJHxo+aByzp3VeNz8zEw/387oMsiPu/cd8SMQ9T7Lj/1zSWWkVwZf9s
	 fN0HpEiPWKw+UadEx7VVy0nzuXi8p7+c7aYk5H+kWjPj8iksIZWlojwREemWa5BaqLSee
	 2898XNmg9ggKl2lTAWPT5ptpdtkTraOyXbmaU1V03/7oIGfmAfZlWuVns7H/BbghBZnYW
	 ca/PRXy0wyhu1fAY/+0IhpVIgjiSlCeZQkhQYcP8W10qGn1dYX/ZWsmIlo6eoS+E0FA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795619521;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=eMS2Ac51hV6NZpevgwdJCeNhMyafB6PqaRCaF9zsf6Q=;
	b=oNUxlJXt7yj2lIGsRIicTfLi9edHvRfmSETI85pK2xvW2MB2nIcAY9LEy+SRFxBUmwDB
	 iP73zQf/9ez3vTOxDnvseD47pX/j49+BY8panrp05oDhhYuq6EJpydzR/SKW1sDvefFSF
	 tAzyTUFGkF6xUzGBThrHGt3G9gsBlXlTS+8D/QL/MRs4PsGuN5XfNld11MzJ6BHEWn8uN
	 MFWVwBTIyPBhx9vdmm5cebiwvIQEQxjLjEsGOp/LAN2x/QXEvlH/2wE4JcJdWVcq2b2kY
	 tFn5wHJIv31bZQoDVNJSwEtgT95jQoWA6+LDthJaP9FWlAtsmuf+bzx8WUxqTHkevZQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AmEGYcfa;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9714C606A323;
	Wed, 25 Nov 2026 15:12:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AmEGYcfa
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1A6E1F000C6;
	Wed, 25 Nov 2026 15:12:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795619521;
	bh=eMS2Ac51hV6NZpevgwdJCeNhMyafB6PqaRCaF9zsf6Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AmEGYcfa1EjNJu/6tRhUgIanceRQyvE+P30K9otzdVyOUSKfoAwfTc7Ry4Kr8f7v2
	 en9TYrMSOVzzBowuaYsSbG4/c/thiHUxG4owpo03lN5zZfLFB9Cc3D/cwyqzBeic97
	 msze5Kq2aeyxcgxIoSWOndu7U14MPMtrUIO80Q3o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Kyle Zeng <kylebot@openai.com>,
	Allison Henderson <achender@kernel.org>,
	Dave Miller <davem@davem-thinkpadp1gen8.ibmlond.csb>
Subject: [PATCH 7.3 0623/1005] net/rds: Do not unpin a page after a failed atomic pin
Date: Wed, 25 Nov 2026 15:32:41 +0100
Message-ID: <20261125143836.341538792@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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
@@ -957,8 +957,11 @@ int rds_cmsg_atomic(struct rds_sock *rs,
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


