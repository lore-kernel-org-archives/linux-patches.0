Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793828922;
	b=OvdYom6BJOCAy2Y1BWPd5/E27D2ufInIMbPb8Pawner7bGxhrWo4SHmgXZj/J4vZd63u
	 a897qpfcCIHm6xzHeYl8+K/2oaYyy0UbuePg8sahAuYpaRxSWF6F2H6IhmwxgxoBQKXaN
	 kkYGpXTofjeYnFaLxmkyHy7LyxZHqf1eSOchuS0JryC+MKQMf2TvJZFxorAhKttbopltw
	 TbNbmsJnHlqKnK369SxyEsTEmJq9gF+yrEa+v8bj7YEV9N+3ysk7ItpPTGKnj+nbFODuJ
	 BSLsYq9IQAy9+m6uoeHMGiMBraMIOlYe6DeTGb35WK2mlZHO50+K6awcdMN/q9iR7MQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793828922;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=q1ldLUFjLZaDqvQIRM6sHMHyJn9OfT2YfiQY+SUSIcc=;
	b=BiJjtnEOl2tjoO0LuqCcy+w8vthZtOyaE3RnU6Z87Xe0BR9nMYvxH/ablsresOj52DmW
	 SxUp8F0rmoe1kbQZA4I6TKD02Kaic9ojayh6v8WZMQZLjSHPJE4I4heh7yYtrfS6EniI7
	 xKxtmiRkPXNtJ7Qig+/hnd0x90aFHWPrE8cqslS65YUe0vuL2vG/Shze/JYnCNp8ZbJxB
	 v5Uy+gTr++5ig5zDE5uAxsLE5Z+/yz/B37NrjOkuAlUuRXsQef3xGEZe6sLyHrr0KLzM0
	 sDA/gClFNo8INncbDFAw3WpOtKt4N7zDSJqQTamB4sWMH599bev189HzfFh5iBTMNPA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oQTDZB91;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C8DC606EEBE;
	Wed,  4 Nov 2026 21:48:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oQTDZB91
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E5A11F000C1;
	Wed,  4 Nov 2026 21:48:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793828922;
	bh=q1ldLUFjLZaDqvQIRM6sHMHyJn9OfT2YfiQY+SUSIcc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oQTDZB919KOEdXbTtQESXT4fnAvGEG2G8U4HZm/e1BInsedJM4WJSk9S51YKJb7e+
	 BVsEnysDPC98l/crgYXxm8KODNJ8SrHgzQ6zYpKk8AwBJDjlbfDkoBr7SfATJHm44n
	 ULwq0jFOBOi6HTJXnSgE60nRmXCMr/BnAsSNDL4I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 7.3 328/547] xfs: mark overfull dabtree node blocks as corrupt
Date: Wed,  4 Nov 2026 16:08:32 -0500
Message-ID: <20261104211047.547915724@linuxfoundation.org>
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

From: Darrick J. Wong <djwong@kernel.org>

commit f61c91a2e5994fa81141d6c06dadae1fed206018 upstream.

LOLLM observes that we need to range-check the dabtree node record count
before using it to index an array.  Fix that.

Cc: stable@vger.kernel.org # v4.15
Fixes: 7c4a07a424c18d ("xfs: scrub directory/attribute btrees")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/scrub/dabtree.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/fs/xfs/scrub/dabtree.c
+++ b/fs/xfs/scrub/dabtree.c
@@ -451,6 +451,10 @@ xchk_da_btree_block(
 		node = blk->bp->b_addr;
 		xfs_da3_node_hdr_from_disk(ip->i_mount, &nodehdr, node);
 		btree = nodehdr.btree;
+		if (nodehdr.count > dargs->geo->node_ents) {
+			xchk_da_set_corrupt(ds, level);
+			goto out_freebp;
+		}
 		*pmaxrecs = nodehdr.count;
 		blk->hashval = be32_to_cpu(btree[*pmaxrecs - 1].hashval);
 		if (level == 0) {


