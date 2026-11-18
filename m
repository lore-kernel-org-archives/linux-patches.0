Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795033912;
	b=udKQRqSulmYCk6jD8BZkzRHsYGN2biGiezXQkBNfqUFgY+ZBRqintGzIb2XApoORbFSy
	 WQrFTmNGCUQDAvv78G9ZLkoaBkAAqWGfnp/jK+o9ZhCF+HrNapJ7OYK8DUojKWdBeqsTc
	 hA6ffc1+muX40781H+qqNpR+z2D+7bhmLTxDo5XXPVfllsGSZisyXdfWhW2qzyaxkhEjG
	 a6DXF/j5jyREp03MgFgVVlN8OC7vlD3xnsvMMzzJhtDxg5zRhqVYEeVGAXPolm/okbhwu
	 KEYzmZdkI0eHIIgg3LiY3h/g4EZbqnWtf1qQ+8TnC9xHuOupRVbYUALBaHf++pTEZyQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795033912;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=na3nJ4cdQarmE9JAlwdgssMXnI7o/Fp9GttoupYT53c=;
	b=tu/AGIKbhjgpsCimusm+vAwDtc57VLmI0bP0pXt3KkkFc/6fit5xN7MI3mk4Ju+APr7t
	 CX1Cp/7SHHquDrkPEi3HNT3YkJSM1qVcKxEzxR4xpvSygouqUgmg7aeA3ux8aFX+2nG8f
	 Ugk2WKNBrgnvY8VfWxq6huJRvkztEKWyyhKP9gMakJkY5N2KU55GeyryTmjbZ+XJpdfBb
	 1go/qT6L7XBeHJMQiE3JdjylOJqKFqFCTJEzWCwC0SNpxmsC0UXP31MABphzm6pJsxVr9
	 JZw/XlZfSNjtzBI4vXwKPvkvosj1pkw03Uwp5EJ6hHjVMEixGg5Hcqkv0W2iHZ8azLg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=I7O1aHdf;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18268606A31C;
	Wed, 18 Nov 2026 20:31:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=I7O1aHdf
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70C391F000C4;
	Wed, 18 Nov 2026 20:31:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795033912;
	bh=na3nJ4cdQarmE9JAlwdgssMXnI7o/Fp9GttoupYT53c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=I7O1aHdfa7prq/UBO7+gDHODvw/Gs6yiOOlgZYQpKKjqSq2HA2fwGVVsD0e8RoS73
	 K19iuKlb/nuvI3TF7rin/agWEhfcDyTDbVc45FGswWr381174GtwWooTpNHaLOM8bC
	 /ukOPy/kzJsmxosjZbfF4MqdueaSl06bvpt9RIXg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Kara <jack@suse.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0183/3318] udf: Fix bh leak for unallocated space entries
Date: Wed, 18 Nov 2026 15:13:25 +0100
Message-ID: <20261118150320.222913825@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 7e41dcc6c10d5..908c3d8e57cf4 100644
--- a/fs/udf/inode.c
+++ b/fs/udf/inode.c
@@ -1493,6 +1493,7 @@ static int udf_read_inode(struct inode *inode, bool hidden_inode)
 		memcpy(iinfo->i_data,
 		       bh->b_data + sizeof(struct unallocSpaceEntry),
 		       bs - sizeof(struct unallocSpaceEntry));
+		brelse(bh);
 		return 0;
 	}
 
-- 
2.53.0



