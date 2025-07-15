Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 352742E7BA7;
	Tue, 15 Jul 2025 13:31:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752586298; cv=none; b=lLndV6YMPn6BenQvbYh4thPuEutASV/8NtU0enAhKhqYn+US0kK3Tr0lVl8xGeANpjjYPGgH3E4CyhjSobTqP8+rYm5PXi1mNinaoPtY59r3eKNr13zwwTd85GtEVlxUdTKNfBcahUoa+VMuErK1TZUY54v78ZoOpqzZNePiGSU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752586298; c=relaxed/simple;
	bh=eDDOV86ZnwPV0PgRM5gnaVedB5OXWcHzDS2R+lzkrlk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qd4jOpp4W77/FswBV8PWhut7Cv3piDPjgYHLdId1NrhVXeNJIFUChYyCgpT/n3p74bsQOrkRYXAJll6XKpefPxKL0i338LT8ktv6/44czV87zgr1imx8+m3nTzSbyfPLE1JEEYycyNh74UHq9kNtDiXJy5jWu8JLcYKRkMcImKU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ihVvYqdw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ihVvYqdw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4D65C4CEE3;
	Tue, 15 Jul 2025 13:31:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752586298;
	bh=eDDOV86ZnwPV0PgRM5gnaVedB5OXWcHzDS2R+lzkrlk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ihVvYqdwmD1LBh4c19AIvrqsauvpTQwjJQi1EU7hUrqNqQWfI7cwRFIadUJyrQh4o
	 PZND0kLgLfjpRfE9AyZU+dqYe+Mf/lBsW4Qx43bHZeQp6CWtt3psgF+PXv5hjkJ0b5
	 IUwx5MiJ0Cu37yHehbH407QqX6fvgKiCvBM80Eho=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Kandybka <d.kandybka@gmail.com>,
	Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>,
	Ilya Dryomov <idryomov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 013/148] ceph: fix possible integer overflow in ceph_zero_objects()
Date: Tue, 15 Jul 2025 15:12:15 +0200
Message-ID: <20250715130800.836266870@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130800.293690950@linuxfoundation.org>
References: <20250715130800.293690950@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 83122fc5f8130..9b10de2276c6f 100644
--- a/fs/ceph/file.c
+++ b/fs/ceph/file.c
@@ -1749,7 +1749,7 @@ static int ceph_zero_objects(struct inode *inode, loff_t offset, loff_t length)
 	s32 stripe_unit = ci->i_layout.stripe_unit;
 	s32 stripe_count = ci->i_layout.stripe_count;
 	s32 object_size = ci->i_layout.object_size;
-	u64 object_set_size = object_size * stripe_count;
+	u64 object_set_size = (u64) object_size * stripe_count;
 	u64 nearly, t;
 
 	/* round offset up to next period boundary */
-- 
2.39.5



