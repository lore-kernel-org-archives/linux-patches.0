Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76CBD3EFFB8;
	Wed, 20 May 2026 18:26:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779301600; cv=none; b=QBDjkd2gOBuUmydXf+W4ml0EatD8oBuFEzX1emclTtDp/VTM9rUguBq3QvYbpHhTWuPyMS+0QQVUm+lrhtOujDpt8guFKiLAFBHPwGVg6qE0LOxF7olfywKVCetRbXwkKuofnNZKy/JfTcvSti5kOy+mqkyv7oMpZVpGTddeYuA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779301600; c=relaxed/simple;
	bh=pLDUmm77ck6BfBomRaqG3Yzc0lCZjJk0NEskjkHyUXo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R4/IaNfpHzD88b/NK/9qYSUI5wSiWfGQv+xwnbi1xqxapRqPnfZOTobsvpeJ66iEEbd5xKwnFVERBdA2SYsdimJIywPeCVotWE5092hSN7iYSMwmc59gADHzxzeihMFSQUuNhakh2Pc+J2qtnsSlLenxo8ytH6qHHXpubefvjPE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1jM67Lds; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1jM67Lds"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD3BC1F000E9;
	Wed, 20 May 2026 18:26:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779301599;
	bh=ZWO8C5VwOCsAxKlCzFSVV81irTwVnJ5UvaURehN6CE8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1jM67Lds0GRjDCLXamaNVXRArWDZI32VYwvNfR9YIGR8/h5rFEXf4CDbp10a/3bTm
	 84oECcMjhlAYM4W/m95KHDJJs0SmfhpyrkfnAb05xvVbDZeKSyd32SomxiFypAE7ZO
	 NwUjS/reiYUego7MZOX6Ud82LTnTyvu88/vehy20=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	skhawaja@google.com,
	Mina Almasry <almasrymina@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 609/666] page_pool: fix incorrect mp_ops error handling
Date: Wed, 20 May 2026 18:23:40 +0200
Message-ID: <20260520162124.470691485@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162111.222830634@linuxfoundation.org>
References: <20260520162111.222830634@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mina Almasry <almasrymina@google.com>

[ Upstream commit abadf0ff63be488dc502ecfc9f622929a21b7117 ]

Minor fix to the memory provider error handling, we should be jumping to
free_ptr_ring in this error case rather than returning directly.

Found by code-inspection.

Cc: skhawaja@google.com

Fixes: b400f4b87430 ("page_pool: Set `dma_sync` to false for devmem memory provider")
Signed-off-by: Mina Almasry <almasrymina@google.com>
Reviewed-by: Samiullah Khawaja <skhawaja@google.com>
Link: https://patch.msgid.link/20250821030349.705244-1-almasrymina@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/page_pool.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/core/page_pool.c b/net/core/page_pool.c
index 9c569a0371656..97ad4cc87be81 100644
--- a/net/core/page_pool.c
+++ b/net/core/page_pool.c
@@ -285,8 +285,10 @@ static int page_pool_init(struct page_pool *pool,
 	}
 
 	if (pool->mp_ops) {
-		if (!pool->dma_map || !pool->dma_sync)
-			return -EOPNOTSUPP;
+		if (!pool->dma_map || !pool->dma_sync) {
+			err = -EOPNOTSUPP;
+			goto free_ptr_ring;
+		}
 
 		if (WARN_ON(!is_kernel_rodata((unsigned long)pool->mp_ops))) {
 			err = -EFAULT;
-- 
2.53.0



