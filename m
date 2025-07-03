Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB28E2EE99E;
	Thu,  3 Jul 2025 14:46:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751554019; cv=none; b=rQCxWG/+lho8qvHnOH19XCnDJvyLVHDnhviVI7spmi+3gOpAmSPHtDLiteETMnCKNZbqoGiIjXnWwRcP1Ga6w3wlyDmWZMcyMM9okZ1WyTfMbPYLLrQSuzRvywlPCBvhGQ46/vBk++41RlRk7D4p2UjSDXJ7b1E9mTgBqO/9fAU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751554019; c=relaxed/simple;
	bh=LLXx2bQupd72OfHytIJqUH437oke1EuAZAHSWmonRX4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dozfpDMwX75k6VjZ2EqND750CehAlyqE0IP+wsTNFEZg9do3s40FcWjaof0zegmgKj2WXL5+/Ydkq9vKyzLavuuas1XTGFM8bNmpPu5FVhk25TahwGKHPOJIca5SkRlPYFWVXhwhH/iRSncOfHVLLTwgkpKhz+4R5QPfgb6e6KY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=m7C67WGZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="m7C67WGZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BA9FC4CEE3;
	Thu,  3 Jul 2025 14:46:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751554019;
	bh=LLXx2bQupd72OfHytIJqUH437oke1EuAZAHSWmonRX4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m7C67WGZTctNWoR5JKJh2gxdRU9AEWBEMWbUz6BmOIg52hJajlLLhJt6FVMHRlGu2
	 g9+P3nYvuFe0ZuUmRPm1RZKN30/olHKq+sIJtA4E/p4ReRjyWksHp8LObfajzQj8nw
	 Tjl3+yNTtKW2wP15fY7H4NylgkUIlTtztiYaBVDY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Kandybka <d.kandybka@gmail.com>,
	Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>,
	Ilya Dryomov <idryomov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 054/218] ceph: fix possible integer overflow in ceph_zero_objects()
Date: Thu,  3 Jul 2025 16:40:02 +0200
Message-ID: <20250703143958.095810671@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703143955.956569535@linuxfoundation.org>
References: <20250703143955.956569535@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Kandybka <d.kandybka@gmail.com>

[ Upstream commit 0abd87942e0c93964e93224836944712feba1d91 ]

In 'ceph_zero_objects', promote 'object_size' to 'u64' to avoid possible
integer overflow.

Compile tested only.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Signed-off-by: Dmitry Kandybka <d.kandybka@gmail.com>
Reviewed-by: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ceph/file.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ceph/file.c b/fs/ceph/file.c
index 851d70200c6b8..a7254cab44cc2 100644
--- a/fs/ceph/file.c
+++ b/fs/ceph/file.c
@@ -2616,7 +2616,7 @@ static int ceph_zero_objects(struct inode *inode, loff_t offset, loff_t length)
 	s32 stripe_unit = ci->i_layout.stripe_unit;
 	s32 stripe_count = ci->i_layout.stripe_count;
 	s32 object_size = ci->i_layout.object_size;
-	u64 object_set_size = object_size * stripe_count;
+	u64 object_set_size = (u64) object_size * stripe_count;
 	u64 nearly, t;
 
 	/* round offset up to next period boundary */
-- 
2.39.5



