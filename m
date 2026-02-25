Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF9334369A;
	Wed, 25 Feb 2026 01:26:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771982818; cv=none; b=KvjyC//vRFOLqFWLCJe0yVNv8a3edOi/8mSk2tOSh3PPmPiuQUfs0AZoDplP7frf7wgzGCFcyie+k8cdu11rT14dNot28ivlqUN1wmbasbZEzzFhS9DIRhkqwFYgFYRuoCg8pyodeIXRqkEkFsMCbVDb5Qtid+Ru4vQdyX+ioFA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771982818; c=relaxed/simple;
	bh=WbSayXlnwo92uEVBXVwTz9KVb+2trXFDtt0xRo7uGgI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CWKMbttWc0UEQXNlybPiQZf3ityojEWR6Q8VWH2SK7iyZ6MVzzWBX2WxuxhYlNnluQBcU1z4TBOHvxaMcRKUFu/S/OlemG4WvZ2+pWLrFDFj049m254AwrqtDFALWfGbT1FQBv5kGFvP23HCnq0kKAt2eAyS1uOAqhRbX0sKugw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=It/pYQwi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="It/pYQwi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55759C116D0;
	Wed, 25 Feb 2026 01:26:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771982818;
	bh=WbSayXlnwo92uEVBXVwTz9KVb+2trXFDtt0xRo7uGgI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=It/pYQwiIYPrHL6uTc7H+L2oaQFE0d5prn0mbHcB2H/eq5Oo/MbGXOBQH09iUWXEn
	 KaEPlJn2H3mb1Cn6eYbtR6J10cPMECmUQoEU2S+1V8QMFDZgpLh9bVw5uMv5apiXx9
	 t6g8BN8HZvvMjK6luqPj7brCKQCN6SHIQDHu0PSY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ferry Meng <mengferry@linux.alibaba.com>,
	Gao Xiang <hsiangkao@linux.alibaba.com>,
	Chao Yu <chao@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 014/781] erofs: Use %pe format specifier for error pointers
Date: Tue, 24 Feb 2026 17:12:03 -0800
Message-ID: <20260225012400.051822242@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
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

From: Ferry Meng <mengferry@linux.alibaba.com>

[ Upstream commit 19bfef0178c64a6281a44687380b082e69215e06 ]

%pe will print a symbolic error name (e.g,. -ENOMEM), opposed to the
raw errno (e.g,. -12) produced by PTR_ERR().

Signed-off-by: Ferry Meng <mengferry@linux.alibaba.com>
Reviewed-by: Gao Xiang <hsiangkao@linux.alibaba.com>
Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>
Stable-dep-of: 9aa64b62a73c ("erofs: avoid noisy messages for transient -ENOMEM")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/erofs/zdata.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/erofs/zdata.c b/fs/erofs/zdata.c
index 3d31f7840ca04..70e1597dec8a6 100644
--- a/fs/erofs/zdata.c
+++ b/fs/erofs/zdata.c
@@ -1324,8 +1324,8 @@ static int z_erofs_decompress_pcluster(struct z_erofs_backend *be, bool eio)
 						GFP_NOWAIT | __GFP_NORETRY
 				 }, be->pagepool);
 		if (IS_ERR(reason)) {
-			erofs_err(be->sb, "failed to decompress (%s) %ld @ pa %llu size %u => %u",
-				  alg->name, PTR_ERR(reason), pcl->pos,
+			erofs_err(be->sb, "failed to decompress (%s) %pe @ pa %llu size %u => %u",
+				  alg->name, reason, pcl->pos,
 				  pcl->pclustersize, pcl->length);
 			err = PTR_ERR(reason);
 		} else if (unlikely(reason)) {
-- 
2.51.0



