Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27E9E3D523F;
	Wed,  8 Apr 2026 19:01:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775674879; cv=none; b=E34WCFXUnvI8SonKdeuaGrURd6ObkBpTtXLpQX/t84nmliNoOZvSoP2oUT7hyofimlaIBmATRpGnv8gHK9qqdkUHwnqysiW2S3CAhwwVWkLiX/D0+hFWuiS49hYSyon4JEn7zhOc899EdbX8Ip7Io0dcPF3uyyj5ywd9QER4GIs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775674879; c=relaxed/simple;
	bh=/oJ7yGeOn1gooRz9lTmUVNxWjDqIqdKGROiDH70Ds+4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WktTK81zfyJ7fKVfpX9JRGKVIXhlx8BgTU/oZPkjsZkgABSaseSfniQ/TFcri5SvtSSoprntEyL5grw3ChI6TI3J4MNULRr54WfV4sXVWeYiPWQYDIV1Rq3XS+7/ssVB3tKRsWl0Nk28ggu2x0r1MvCyt/IIc96AGNKWkTPSeRw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vti8XD+M; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vti8XD+M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B11D8C19425;
	Wed,  8 Apr 2026 19:01:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775674879;
	bh=/oJ7yGeOn1gooRz9lTmUVNxWjDqIqdKGROiDH70Ds+4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vti8XD+MQeF5DMSAWcHZMxTR5NRClA6xIYsGz1FduRyyTx5Du6SS5SDN8sHZJ2ZO5
	 UaTcx0pCzGSFsn1ItK2K6QOFIoF7DrD/DDp61wyNn/HvOgUnqgRHcpehUwBIpcUozq
	 kUV2j9n2fykBvoIS7l9OXchZ+xZj1+L2Un6YrWoo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Juefei Pu <tomapufckgml@gmail.com>,
	Xin Liu <dstsmallbird@foxmail.com>,
	Yifan Wu <yifanwucs@gmail.com>,
	Yuan Tan <yuantan098@gmail.com>,
	Phil Sutter <phil@nwl.cc>,
	Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 6.19 268/311] netfilter: ipset: drop logically empty buckets in mtype_del
Date: Wed,  8 Apr 2026 20:04:28 +0200
Message-ID: <20260408175949.390037732@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175939.393281918@linuxfoundation.org>
References: <20260408175939.393281918@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yifan Wu <yifanwucs@gmail.com>

commit 9862ef9ab0a116c6dca98842aab7de13a252ae02 upstream.

mtype_del() counts empty slots below n->pos in k, but it only drops the
bucket when both n->pos and k are zero. This misses buckets whose live
entries have all been removed while n->pos still points past deleted slots.

Treat a bucket as empty when all positions below n->pos are unused and
release it directly instead of shrinking it further.

Fixes: 8af1c6fbd923 ("netfilter: ipset: Fix forceadd evaluation path")
Cc: stable@vger.kernel.org
Reported-by: Juefei Pu <tomapufckgml@gmail.com>
Reported-by: Xin Liu <dstsmallbird@foxmail.com>
Signed-off-by: Yifan Wu <yifanwucs@gmail.com>
Co-developed-by: Yuan Tan <yuantan098@gmail.com>
Signed-off-by: Yuan Tan <yuantan098@gmail.com>
Reviewed-by: Phil Sutter <phil@nwl.cc>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/netfilter/ipset/ip_set_hash_gen.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/netfilter/ipset/ip_set_hash_gen.h
+++ b/net/netfilter/ipset/ip_set_hash_gen.h
@@ -1099,7 +1099,7 @@ mtype_del(struct ip_set *set, void *valu
 			if (!test_bit(i, n->used))
 				k++;
 		}
-		if (n->pos == 0 && k == 0) {
+		if (k == n->pos) {
 			t->hregion[r].ext_size -= ext_size(n->size, dsize);
 			rcu_assign_pointer(hbucket(t, key), NULL);
 			kfree_rcu(n, rcu);


