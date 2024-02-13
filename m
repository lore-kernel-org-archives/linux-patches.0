Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74E70AD55;
	Tue, 13 Feb 2024 17:33:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707845624; cv=none; b=MB+3FjZNj0GPSqZoqBpynJWhHJCWVQXCAXvPU662ppp82KEzOvA1lFJZNcz6Cmi5uxoUuN22nx7Fhk8rV9CC+VhdrIPN5O+IOLe4QlNIJvtq4ElbuVcQQH2HAV7n8JqnqPCWGjwUOfv911ZjJma6TRZAFb9IfYZk++Ji98JkYmQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707845624; c=relaxed/simple;
	bh=vd91lTmEgNEQLcZqteSwK7Q/h/dV7OpteUgB9SacPvo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pR80bmVTQ3RAUqjxKEXhgtgnTuq1s4afnJsISdkDCZQkGtqhf8sPw74648VFYiBMVDFrGXwR6K3mdeLss5wrWnBlJciFSebhE2k4rFlrVaRuU3iTz0djbvqO1MoeQctdeFlGFiHXgyFOEo65tqg8Gx9ww6U50Nn2xnNafc6FXW8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pJjfmNm+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pJjfmNm+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCEDEC433F1;
	Tue, 13 Feb 2024 17:33:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1707845624;
	bh=vd91lTmEgNEQLcZqteSwK7Q/h/dV7OpteUgB9SacPvo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pJjfmNm+1rVxHKJh8NPwVXzAN0moWWX/aLg0AqzeMeehWkjqi3e19qlxqfe6UnSKJ
	 /VYV94mStfXImUPgiAOnUa0OjZoQEWvfaHwQ4jyyEIIEzNPy+4ewA7zIQsya69FzQl
	 dLRpVp14kOuizgrri/I3NzI9ALCxWM5PfFLKMNyk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Li <Frank.Li@nxp.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 012/124] dmaengine: fix is_slave_direction() return false when DMA_DEV_TO_DEV
Date: Tue, 13 Feb 2024 18:20:34 +0100
Message-ID: <20240213171854.093211965@linuxfoundation.org>
X-Mailer: git-send-email 2.43.1
In-Reply-To: <20240213171853.722912593@linuxfoundation.org>
References: <20240213171853.722912593@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Frank Li <Frank.Li@nxp.com>

[ Upstream commit a22fe1d6dec7e98535b97249fdc95c2be79120bb ]

is_slave_direction() should return true when direction is DMA_DEV_TO_DEV.

Fixes: 49920bc66984 ("dmaengine: add new enum dma_transfer_direction")
Signed-off-by: Frank Li <Frank.Li@nxp.com>
Link: https://lore.kernel.org/r/20240123172842.3764529-1-Frank.Li@nxp.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/dmaengine.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/include/linux/dmaengine.h b/include/linux/dmaengine.h
index 3df70d6131c8..752dbde4cec1 100644
--- a/include/linux/dmaengine.h
+++ b/include/linux/dmaengine.h
@@ -953,7 +953,8 @@ static inline int dmaengine_slave_config(struct dma_chan *chan,
 
 static inline bool is_slave_direction(enum dma_transfer_direction direction)
 {
-	return (direction == DMA_MEM_TO_DEV) || (direction == DMA_DEV_TO_MEM);
+	return (direction == DMA_MEM_TO_DEV) || (direction == DMA_DEV_TO_MEM) ||
+	       (direction == DMA_DEV_TO_DEV);
 }
 
 static inline struct dma_async_tx_descriptor *dmaengine_prep_slave_single(
-- 
2.43.0



