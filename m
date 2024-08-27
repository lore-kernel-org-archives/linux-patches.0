Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40C8719F485;
	Tue, 27 Aug 2024 15:26:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724772383; cv=none; b=QY20oO9MAA//qSAchIQiJm2EM5WJP+0MKINVODmVlUuOY3dh7skyJmEIafSdjksTfvVrji28Ze1bI3fSyBfljJMB0gC1i0FnX7L6+UmMjdKPw8XiJEkrfiUwwbYFXW9Prtr+wNvcVoTQLoqymcXIdtg6Bw9ZQ09cPmj6iBovQO4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724772383; c=relaxed/simple;
	bh=gI6ru+9ElY2t0hk5kJYLq/yatyvlnf/wDho2KV2P1G8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZdA0m0SImtpetUbLmLQVy7hawwKeODSEj7XBJw/mWtHdtJMxK355cXVgJrTC2PKHSNNOrcKphctNrwo2B2cCkc3imAgbooykXaJyuRBuzI8G/qUCIznRl2WypAkSs/q/XeWg9VMIXYmld4EYKv2oOvLCAGDPBLv2jMF547+D214=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=t+DUvNcd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="t+DUvNcd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6592C61071;
	Tue, 27 Aug 2024 15:26:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724772383;
	bh=gI6ru+9ElY2t0hk5kJYLq/yatyvlnf/wDho2KV2P1G8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=t+DUvNcdiRz12sCV8Yry0TTvOuQVZ5OdXziYKRmsra/mwtw6JwrUyTQuJ8jDu2WI2
	 G7pzro7JPJ9CGKoB46RBPG2Dai75wFADfLHCiuBBLA4pbZcc1U7oYC8/+vKEmNArKv
	 3cT/b8hbxiapuy/9EA6AMifkHHjy4g2RcH3z7kxA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Alexandra Winter <wintera@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 197/321] s390/iucv: fix receive buffer virtual vs physical address confusion
Date: Tue, 27 Aug 2024 16:38:25 +0200
Message-ID: <20240827143845.729755614@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143838.192435816@linuxfoundation.org>
References: <20240827143838.192435816@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexander Gordeev <agordeev@linux.ibm.com>

[ Upstream commit 4e8477aeb46dfe74e829c06ea588dd00ba20c8cc ]

Fix IUCV_IPBUFLST-type buffers virtual vs physical address confusion.
This does not fix a bug since virtual and physical address spaces are
currently the same.

Signed-off-by: Alexander Gordeev <agordeev@linux.ibm.com>
Reviewed-by: Alexandra Winter <wintera@linux.ibm.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/iucv/iucv.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/net/iucv/iucv.c b/net/iucv/iucv.c
index db41eb2d977f2..038e1ba9aec27 100644
--- a/net/iucv/iucv.c
+++ b/net/iucv/iucv.c
@@ -1090,8 +1090,7 @@ static int iucv_message_receive_iprmdata(struct iucv_path *path,
 		size = (size < 8) ? size : 8;
 		for (array = buffer; size > 0; array++) {
 			copy = min_t(size_t, size, array->length);
-			memcpy((u8 *)(addr_t) array->address,
-				rmmsg, copy);
+			memcpy(phys_to_virt(array->address), rmmsg, copy);
 			rmmsg += copy;
 			size -= copy;
 		}
-- 
2.43.0



