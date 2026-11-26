Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795705353;
	b=2DTUGsh6m+55V1ts7O4l36ogGP7AlIVuNJDjhVtL1q9QbgFS8rPrazeVUUqw0CuXf7EW
	 Rlf4ppR0lwr1ABFcdAnNWoQoeRPFaPi+Jd4NxbmiFy85dtmRelCyyf1r316ge/7v3cXS9
	 sf6Y4+7ADi8bpj6VIlzJYqaUfHxbT+OY6qrPnQ4mn3APg9TBh4SPNaws7nvctck6IGKmC
	 ad195bHNNjZVTEcNcLIiMiVMhZFZYl/RI4HmLi/k25rDxFslDd3aZ02YW8BvBcxWlocVB
	 2OZPxOv3N8kDpZiw3iTkKK5JX4DRtgOFk1WbvWOjk8F/G4LZ8JCFdLGSl3sJFbohSLQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795705353;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=OCSY5OpdmzX4Ki15cesGuj0+2UGMzoAHNQ3E4yh17DU=;
	b=KHK7DNgO//VDWPMK8p1Xy/TVxNM1AsJNFD2cug2EZv6xt3F+jsWn6K1Lk6Tlv0ug388t
	 GvQ6s46Lxcupo4EPEW+b2Z4gvZ7csKa1N5zqAUZM4bpCxw9N7JnBX/YgcNGPkYz0/oc2y
	 hfbk2pCQ1tuEXFY8tkz0uDx2ctFeGtim6kH4G67+NWWF9trnqXoYhXp2YoXBeIqGpQWwI
	 4nkg/ZHFB5jm3KZtcJDbdjOHnnzoL1eXdaeDc1r+XKSr5nAx5vPzV37V3oGqUelDk75Mf
	 sOPx5WpnyW1IrpU9aFhUpaSjHnY2w5kdZnKfzwb7zrGMu02F15E5RIS91jYP+aCJPeQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oNLsM3X7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA222606A323;
	Thu, 26 Nov 2026 15:02:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oNLsM3X7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF60A1F000C0;
	Thu, 26 Nov 2026 15:02:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795705352;
	bh=OCSY5OpdmzX4Ki15cesGuj0+2UGMzoAHNQ3E4yh17DU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oNLsM3X7hHPqaS+Pu/CWJJRaeItRNjfje1DtZGThJGbqkPCjQiRU7fQhagT4lWdN3
	 bOljoc+yNpV97jYYTS2OtFc4oLdWgzABrzdYVcDhsTqZPm6AQuqXSWW50b7aJylwlt
	 7T4Na4L6m5y4u3B9caxH7J/2toJjAcPQ+OrEQ6TI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Beulich <jbeulich@suse.com>,
	Juergen Gross <jgross@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 167/319] Xen/gnttab: improve error handling in gnttab_dma_{alloc,free}_pages()
Date: Thu, 26 Nov 2026 15:38:55 +0100
Message-ID: <20261126144010.516326070@linuxfoundation.org>
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

From: Jan Beulich <jbeulich@suse.com>

[ Upstream commit 2b66f2cc753243a6adb3e9a5c038b0fc59ba7ec9 ]

Both decrease-reservation and populate-physmap can succeed partially. For
the former this may be pretty unlikely, but clearly the latter can hit
both out-of-memory conditions in the hypervisor or denial because of the
allocation exceeding the domain's allowance (there's no interaction with
the balloon driver here either).

In gnttab_dma_free_pages() we simply can't give back to the system what
hasn't been re-filled with backing memory. For gnttab_dma_alloc_pages()
both parts of the overall region need dealing with differently.

While no present caller of gnttab_dma_free_pages() checks its return
value, also don't use -EFAULT there: It really is an out-of-memory
condition. (In gnttab_dma_alloc_pages() -EFAULT doesn't look quite right
either, but I couldn't think of a clearly better error code there.)

Fixes: 9bdc7304f536 ("xen/grant-table: Allow allocating buffers suitable for DMA")
Signed-off-by: Jan Beulich <jbeulich@suse.com>
Reviewed-by: Jan Beulich <jbeulich@suse.com>
Signed-off-by: Juergen Gross <jgross@suse.com>
Message-ID: <20261110095605.369848-3-jgross@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/xen/grant-table.c | 25 ++++++++++++++++++++++++-
 1 file changed, 24 insertions(+), 1 deletion(-)

diff --git a/drivers/xen/grant-table.c b/drivers/xen/grant-table.c
index 241940762bea7..2b50ee6fa236e 100644
--- a/drivers/xen/grant-table.c
+++ b/drivers/xen/grant-table.c
@@ -1014,6 +1014,24 @@ int gnttab_dma_alloc_pages(struct gnttab_dma_alloc_args *args)
 	ret = xenmem_reservation_decrease(args->nr_pages, args->frames);
 	if (ret != args->nr_pages) {
 		pr_debug("Failed to decrease reservation for DMA buffer\n");
+		if (ret >= 0) {
+			/* Free the part where decrease didn't work. */
+			size_t done = ret << PAGE_SHIFT;
+
+			if (args->coherent)
+				dma_free_coherent(args->dev, size - done,
+						  args->vaddr + done,
+						  args->dev_bus_addr + done);
+			else
+				dma_free_wc(args->dev, size - done,
+					    args->vaddr + done,
+					    args->dev_bus_addr + done);
+
+			if (!ret) /* Nothing else to do? */
+				return -EFAULT;
+
+			args->nr_pages = ret;
+		}
 		ret = -EFAULT;
 		goto fail;
 	}
@@ -1047,7 +1065,12 @@ int gnttab_dma_free_pages(struct gnttab_dma_alloc_args *args)
 	ret = xenmem_reservation_increase(args->nr_pages, args->frames);
 	if (ret != args->nr_pages) {
 		pr_debug("Failed to increase reservation for DMA buffer\n");
-		ret = -EFAULT;
+		/* Can only free what has been re-filled. */
+		if (!ret)
+			return -ENOMEM;
+		if (ret > 0)
+			args->nr_pages = ret;
+		ret = -ENOMEM;
 	} else {
 		ret = 0;
 	}
-- 
2.53.0



