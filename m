Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829650;
	b=mh41Pe7FhvEqJg/FLbUC7XAZkdhxkzXKy2nd/JhimGhoTyIU4jCMy9Wxs7XhDvxHYKMu
	 0NvFuBCueeMEB8pD3GEbnsZ9i/jR+zh1WWUmQvOKkh9j4C6Me4rRmPf42TmnygtaQJrhl
	 5Snb/837OfyVYZ2805iluIzaOq6QzfDTtP3HRoXZBaQUFq9itfr1FRexo/Ixg2sgU5lUd
	 bTtNA6AZKsY8P2g9FHUsofX9VU6XtvaqPnUByF6xh/sK4nGhOGgO4BvX7lMTEG38OVZnw
	 0E3bIlua0xhLaeEYoOd6G0utxgxsj+cHjuj8ewuy+bUGDrzdT4nCj4osYuZQZ4XZNHA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829650;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=VbKQ2flqpk8wYI001zHLlNws3erU7m+UO/z94dN4mRQ=;
	b=tF0l9K4ZXTnrTD+SRLbaAbblWIsX87qbJz5XMmDzTJ0IiK7u0l3i9nJPMwgUIfERJV81
	 ZL1mpffkha9FEVKseuuFwfdymeO75HOtspgs9RmIR+sRVvrYzYbCPQn1s9MJNQae8yne3
	 VsEXwS0C0zy2vkbi+4iE0fv5Y97HR7/TWfvYWIAF43FRmqgAZYqKU+8bxkJCNjMAvr7u/
	 zy1LlkC3AKjqAcsqXwiJHnL8scazfXJDRlvfL3R9EgkCFm8UbHh6ucSTpN3j5SSFBYEgv
	 jtZcpHuvZfbs+A6Gofz1zqXaYEJNuGHsCI+1D+N0eJTcY+N1YER1yu+lPju3N6Kaxrg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hdqPUppT;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F753606AC2E;
	Wed,  4 Nov 2026 22:00:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hdqPUppT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1986B1F00919;
	Wed,  4 Nov 2026 22:00:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829650;
	bh=VbKQ2flqpk8wYI001zHLlNws3erU7m+UO/z94dN4mRQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hdqPUppTsx+bAG/Bzt94BSpY67y1p7AhDeQ8e2HwP5Hqm5fZ5nxADxeBRsB5PmRlR
	 7hMZAz6/2KbhC0HdDD4Qw9Cp1tynb55YZ5bM2NuRy88bQRl5GRvattqX9oPa7emZAT
	 6zIiyMzoCXNloljTPGp5YmghL7GaIdRF8qBTpCqY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Kara <jack@suse.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0256/1005] udf: Fix bh leak for unallocated space entries
Date: Wed,  4 Nov 2026 15:59:49 -0500
Message-ID: <20261104211051.037507280@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

From: Jan Kara <jack@suse.cz>

[ Upstream commit d95094d4c0a62ea17b8a7c6399b42381b8a55bc0 ]

When processing unallocated space entries we didn't properly release the
inode bh. Fix it.

Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/udf/inode.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/udf/inode.c b/fs/udf/inode.c
index 6a0c66d706295..84b1a0b7b28d2 100644
--- a/fs/udf/inode.c
+++ b/fs/udf/inode.c
@@ -1495,6 +1495,7 @@ static int udf_read_inode(struct inode *inode, bool hidden_inode)
 		memcpy(iinfo->i_data,
 		       bh->b_data + sizeof(struct unallocSpaceEntry),
 		       bs - sizeof(struct unallocSpaceEntry));
+		brelse(bh);
 		return 0;
 	}
 
-- 
2.53.0



