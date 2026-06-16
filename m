Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB5283D8105;
	Tue, 16 Jun 2026 18:22:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781634153; cv=none; b=N00rBlQLPa8nVPPU4TuDVNfxZs5SJjda2ARf6Xkha+B8Lo1NSMCPrOotQi02uGGE8K1zyraw5BVGeGuYVFV9pCIA6wb0XiUgzv7G8ociGyZ0XkFHYBG2+mZ4VKTTTs8c7pBNTA085YQopmyOfC/rgFA7LhKeT3/4YB/me0SViOw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781634153; c=relaxed/simple;
	bh=A48O8uOXfF/He1aI6Cs88fWZZVWH1FxLpO3YGRxKItE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SKx76PsDAWeT+dVmlL8r2l2LX2BfPqfFhsRqigEwWbcV5035VwkpwGd2XDvsdi6qLElptwD0IrD7CCEgmHtE/jTpcNY+XJhcLK0tACIuyMijTRyGckMsfyf50rzZs1+5fcPAO0jjd5kVnGFhTCTGCfgomhmEl3LEyWVqBfLP86g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=f3rhasL6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="f3rhasL6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A0CF1F000E9;
	Tue, 16 Jun 2026 18:22:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781634152;
	bh=nCuWDyiGdigfemAx8hjE59THoIUnCvaEXdcIGFUFxEM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=f3rhasL6AJeqHXxboW0Dh3W0d4i5Tr073dwzibOwJFkj5Aab0RQr8iuf8euD7mNcN
	 bfWn9Al9Yv6NtX0A5M/dQbKgybePTutrAp5RCARG2unWLRHK0/WHsmTE2qV0rX92I2
	 oq4bX1WFTd39wGycc87Fx34q35B/SrSV19VYRdyE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tristan Madani <tristan@talencesecurity.com>,
	Fernando Fernandez Mancera <fmancera@suse.de>,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 5.15 201/411] netfilter: nft_tunnel: fix use-after-free on object destroy
Date: Tue, 16 Jun 2026 20:27:19 +0530
Message-ID: <20260616145111.409077117@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145100.376842714@linuxfoundation.org>
References: <20260616145100.376842714@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tristan Madani <tristan@talencesecurity.com>

commit c32b26aaa2f9216520a38b3f4bfeec846eb3eb8a upstream.

nft_tunnel_obj_destroy() calls metadata_dst_free() which directly
kfree()s the metadata_dst, ignoring the dst_entry refcount. Packets
that took a reference via dst_hold() in nft_tunnel_obj_eval() and
are still queued (e.g. in a netem qdisc) are left with a dangling
pointer. When these packets are eventually dequeued, dst_release()
operates on freed memory.

Replace metadata_dst_free() with dst_release() so the metadata_dst
is freed only after all references are dropped. The dst subsystem
already handles metadata_dst cleanup in dst_destroy() when
DST_METADATA is set.

Fixes: af308b94a2a4 ("netfilter: nf_tables: add tunnel support")
Cc: stable@vger.kernel.org
Signed-off-by: Tristan Madani <tristan@talencesecurity.com>
Reviewed-by: Fernando Fernandez Mancera <fmancera@suse.de>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/netfilter/nft_tunnel.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/netfilter/nft_tunnel.c
+++ b/net/netfilter/nft_tunnel.c
@@ -669,7 +669,7 @@ static void nft_tunnel_obj_destroy(const
 {
 	struct nft_tunnel_obj *priv = nft_obj_data(obj);
 
-	metadata_dst_free(priv->md);
+	dst_release(&priv->md->dst);
 }
 
 static struct nft_object_type nft_tunnel_obj_type;


