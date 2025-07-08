Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBA592E62B8;
	Tue,  8 Jul 2025 16:56:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751993809; cv=none; b=scQAwMNQh8pi2ixCDhPKu/HQKX3lOq50MaPHhDolx379SYpvZjQFRE/8n9Z11rWI6hs+YQGlO3/BDGbiGv/4mPE+hxxbWnF7n3c5YDM85SLrdHTgXoVHbiEWRs/KtY37IUOwx3gLdBAUwqoVPwpAZGeMg7CeBcjhNSaYFApYt10=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751993809; c=relaxed/simple;
	bh=tfSvzQtpB+BIdVt0bLkDVrH6QbWnkdLrhyhJzoY6w5Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WtQ5LnNsrTeWc71Qe+aDq8TlxYO1c80h+A2EHQUnAMHuE7Sivk2sraMt0Cpk09Ma38IDaVgY5FvQJzQkeyEs++xOmyCPMELhQsrkEdGQOoA9Fy5jvJUaAyLZpVI72BNmy6x4208Guj6ASqyCeuT0w+KvWrKUjYsQjVkPMKFyDN4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CdTs0/g4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CdTs0/g4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 435D9C4CEF6;
	Tue,  8 Jul 2025 16:56:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751993809;
	bh=tfSvzQtpB+BIdVt0bLkDVrH6QbWnkdLrhyhJzoY6w5Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CdTs0/g4s9YtdqltfqhoohFoaoO/8FTFnFmYD9tZRkEqKwUIXZd4c6BkLVVPEAxrX
	 mfqdUOFCqaAEjM9Yj+D/62JRKovS8g25zKrfCqfqNTVpdmNb0p/il8OKVN2C8xEzW4
	 e31vPtejh9N2vFWCC+HDmm3iR2FEdDs81BmBe20c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Kandybka <d.kandybka@gmail.com>,
	Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>,
	Ilya Dryomov <idryomov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 025/160] ceph: fix possible integer overflow in ceph_zero_objects()
Date: Tue,  8 Jul 2025 18:21:02 +0200
Message-ID: <20250708162232.209623217@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162231.503362020@linuxfoundation.org>
References: <20250708162231.503362020@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index f3fba3d27efa6..e92a10ba58b3f 100644
--- a/fs/ceph/file.c
+++ b/fs/ceph/file.c
@@ -2032,7 +2032,7 @@ static int ceph_zero_objects(struct inode *inode, loff_t offset, loff_t length)
 	s32 stripe_unit = ci->i_layout.stripe_unit;
 	s32 stripe_count = ci->i_layout.stripe_count;
 	s32 object_size = ci->i_layout.object_size;
-	u64 object_set_size = object_size * stripe_count;
+	u64 object_set_size = (u64) object_size * stripe_count;
 	u64 nearly, t;
 
 	/* round offset up to next period boundary */
-- 
2.39.5



