Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D306B2F236B;
	Thu,  3 Jul 2025 15:12:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751555531; cv=none; b=B4PhTYvQa3P3QZuREUe90dm4uHpthAum/x98TOTY11m5B2BvqYgH/5PLa9E7OhY9a7g4J3LMcEg07nNpptZAVEwuJbNTUW1fqnYsU0BRhJQnxxn30KUQrXMhwTSwiUvCTY1aRwh6vZpPzya/m8gRPQa/lvNKYm4HqTrCQZRTeHk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751555531; c=relaxed/simple;
	bh=dn929rYNeGMp+tCRky02C3kEyIHTLDji2gqnJXChgBQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mJJCwhW+JRzBjLriPNJl4AKICQhiCD2lmOvb8qwxVZ1Kgeylun88cZOcemRo1ETHbrEWm6sLbfMKaMyHi8QuAVanDQ8NPwuXgYsIor8VzR4w0VhM5lB8BLp25Z6BIVeI5IIAEppmuWVtTiMVElohWXOlEEeUPsDkFBCMeNJ04mg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HD0RFGwk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HD0RFGwk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40FA2C4CEE3;
	Thu,  3 Jul 2025 15:12:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751555531;
	bh=dn929rYNeGMp+tCRky02C3kEyIHTLDji2gqnJXChgBQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HD0RFGwkxpEyHURYbXe5Yv4Rt5ogs7aqhtM0UWzLAQnzwvAXgI7WJoh8TgCAmepc6
	 fbmpwbVh8epESQzPdqQgis9QzfE8CtQGfxscfZH98QBSh0mqBDWMA6VzIRKkHe7mYX
	 b8XHqVza556RmvFubvdz8GzqdclYF1fI7jXESkGg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Kandybka <d.kandybka@gmail.com>,
	Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>,
	Ilya Dryomov <idryomov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 043/139] ceph: fix possible integer overflow in ceph_zero_objects()
Date: Thu,  3 Jul 2025 16:41:46 +0200
Message-ID: <20250703143942.859094855@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703143941.182414597@linuxfoundation.org>
References: <20250703143941.182414597@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index a03b11cf78872..e12657b4c3e04 100644
--- a/fs/ceph/file.c
+++ b/fs/ceph/file.c
@@ -2513,7 +2513,7 @@ static int ceph_zero_objects(struct inode *inode, loff_t offset, loff_t length)
 	s32 stripe_unit = ci->i_layout.stripe_unit;
 	s32 stripe_count = ci->i_layout.stripe_count;
 	s32 object_size = ci->i_layout.object_size;
-	u64 object_set_size = object_size * stripe_count;
+	u64 object_set_size = (u64) object_size * stripe_count;
 	u64 nearly, t;
 
 	/* round offset up to next period boundary */
-- 
2.39.5



