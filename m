Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C37391D8DF6;
	Thu, 17 Apr 2025 18:00:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744912818; cv=none; b=Q5wb7BVPS6oaNX4/OuR7ll1FO/Uplh7VsUHSSczBO/RbffWsRPIwYpTHSYZPaSP0YSaCogsO+ltFVo81G+7gfr/tavJpuF6/q1c4MCVr/IX77+agGZkgdeqnENzSxTSEf595+sBOl2aZnCsmseRPevZf8Fmwonm/Stvqbpjk0OQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744912818; c=relaxed/simple;
	bh=g7Cu8F3k8AWSK+a0ox5Wl6Wb2BkaE7UMe8G7jO7k+WU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PAG/dIs15+xY+CA63XEWFiJ69FGub9ODubONOXbhKG3eGodYI3KZFNdIDktnbT55igiGKSSmjd82KwRI3pK0rY1KD7ZMeJGAK6C+LQDlTdGkIrUSPBBVvS2LzVeUWOa+GNYq49UObMpEeBAtxixy+RBRL7b8KuhdbBpL283RjzM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Oy0QTtCR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Oy0QTtCR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E1B6C4CEE4;
	Thu, 17 Apr 2025 18:00:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744912818;
	bh=g7Cu8F3k8AWSK+a0ox5Wl6Wb2BkaE7UMe8G7jO7k+WU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Oy0QTtCRfQvJbxz1M7vrdNlNHfDk2DcDsNskspI2uHM7e98oV8WgtUYG3jdtP/YJu
	 S5K09Yew+XdJC64grzehDW48rMtlELvCFRGwBCCQlVs+rJGMKK0uIVET66AMHC0mZ6
	 yfE3NQFGXQQO7bAxXSUV9foeNvVpt/yB2jddHFNc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jakub Kicinski <kuba@kernel.org>,
	Mina Almasry <almasrymina@google.com>,
	Pavel Begunkov <asml.silence@gmail.com>,
	David Wei <dw@davidwei.uk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 104/449] net: page_pool: dont cast mp param to devmem
Date: Thu, 17 Apr 2025 19:46:32 +0200
Message-ID: <20250417175122.147815356@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175117.964400335@linuxfoundation.org>
References: <20250417175117.964400335@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pavel Begunkov <asml.silence@gmail.com>

[ Upstream commit 8d522566ae9cb3f0609ddb2a6ce3f4f39988043c ]

page_pool_check_memory_provider() is a generic path and shouldn't assume
anything about the actual type of the memory provider argument. It's
fine while devmem is the only provider, but cast away the devmem
specific binding types to avoid confusion.

Reviewed-by: Jakub Kicinski <kuba@kernel.org>
Reviewed-by: Mina Almasry <almasrymina@google.com>
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: David Wei <dw@davidwei.uk>
Link: https://patch.msgid.link/20250204215622.695511-2-dw@davidwei.uk
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/page_pool_user.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/core/page_pool_user.c b/net/core/page_pool_user.c
index 6677e0c2e2565..d5e214c30c310 100644
--- a/net/core/page_pool_user.c
+++ b/net/core/page_pool_user.c
@@ -356,7 +356,7 @@ void page_pool_unlist(struct page_pool *pool)
 int page_pool_check_memory_provider(struct net_device *dev,
 				    struct netdev_rx_queue *rxq)
 {
-	struct net_devmem_dmabuf_binding *binding = rxq->mp_params.mp_priv;
+	void *binding = rxq->mp_params.mp_priv;
 	struct page_pool *pool;
 	struct hlist_node *n;
 
-- 
2.39.5



