Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7878812D1F1;
	Mon, 23 Dec 2024 16:05:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734969920; cv=none; b=H1rOFZbfoC4l0Uczh5h8qZnRWuL3EcgQE61B2jKbr72cyU9YSNWXMmVyguz+81HgwZ3mCpA6Mb5M6nF+MRUYgJaWbTl52Aj7dhZIPaSj7n6bEaVoIAr1YEW7Lz3MzShMmJ3d+UCEs9BeQfXGyzjP0c9rlcaVw+NXPonUjUk5Yjk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734969920; c=relaxed/simple;
	bh=jilrfThkiWKeO/nHX6uhQf7bcdaqJ2VwDg3itSA3ORE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WDVSkQ0T8DB5jR5ZYpg1k4UfJBQ7srdp0bx4KB0+ngnai5P/wuvuy8h+Co65FkSLRt5TZuqSNaiyU1kLBe3kMU3R2Ae9Cl81tu9ZYNMp1+TO5GBXoBNOOWapk8sN37Z2qLAYSy3mXTvndRaSdlyEq/edm66uvUPp7z7BM4cA3aU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=adOLRZsY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="adOLRZsY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBE59C4CED3;
	Mon, 23 Dec 2024 16:05:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734969920;
	bh=jilrfThkiWKeO/nHX6uhQf7bcdaqJ2VwDg3itSA3ORE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=adOLRZsY1ohALSWmEwWFVlpBod7elGnzwYuK4F+NJASEyZlRB2LesS8rzBvKg/J8P
	 2DBr6WxnS9pKKEmKeMttFJ3N40LRXqmqBZWRMkTTfuf3fxhgMu6tsaI8/1wuM+45dE
	 /wAcatqMpb2uIylw7OpDDkOR4Vg3IwP9od23bL3A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"T.J. Mercier" <tjmercier@google.com>,
	Tvrtko Ursulin <tvrtko.ursulin@igalia.com>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 092/160] dma-buf: Fix __dma_buf_debugfs_list_del argument for !CONFIG_DEBUG_FS
Date: Mon, 23 Dec 2024 16:58:23 +0100
Message-ID: <20241223155412.245133937@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241223155408.598780301@linuxfoundation.org>
References: <20241223155408.598780301@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: T.J. Mercier <tjmercier@google.com>

[ Upstream commit 0cff90dec63da908fb16d9ea2872ebbcd2d18e6a ]

The arguments for __dma_buf_debugfs_list_del do not match for both the
CONFIG_DEBUG_FS case and the !CONFIG_DEBUG_FS case. The !CONFIG_DEBUG_FS
case should take a struct dma_buf *, but it's currently struct file *.
This can lead to the build error:

error: passing argument 1 of ‘__dma_buf_debugfs_list_del’ from
incompatible pointer type [-Werror=incompatible-pointer-types]

dma-buf.c:63:53: note: expected ‘struct file *’ but argument is of
type ‘struct dma_buf *’
   63 | static void __dma_buf_debugfs_list_del(struct file *file)

Fixes: bfc7bc539392 ("dma-buf: Do not build debugfs related code when !CONFIG_DEBUG_FS")
Signed-off-by: T.J. Mercier <tjmercier@google.com>
Reviewed-by: Tvrtko Ursulin <tvrtko.ursulin@igalia.com>
Signed-off-by: Sumit Semwal <sumit.semwal@linaro.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20241117170326.1971113-1-tjmercier@google.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma-buf/dma-buf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/dma-buf/dma-buf.c b/drivers/dma-buf/dma-buf.c
index 8892bc701a66..afb8c1c50107 100644
--- a/drivers/dma-buf/dma-buf.c
+++ b/drivers/dma-buf/dma-buf.c
@@ -60,7 +60,7 @@ static void __dma_buf_debugfs_list_add(struct dma_buf *dmabuf)
 {
 }
 
-static void __dma_buf_debugfs_list_del(struct file *file)
+static void __dma_buf_debugfs_list_del(struct dma_buf *dmabuf)
 {
 }
 #endif
-- 
2.39.5



