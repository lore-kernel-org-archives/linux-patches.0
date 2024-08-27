Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D287F1C7B71;
	Tue, 27 Aug 2024 15:29:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724772543; cv=none; b=Pg3GlK2DkDNhnxDHdu3sltoQuZHt0rTU0L/pctGyQcNZoYKWSUFcbBnmznL0lb5sU819QiQOzCqcLym4hR//xuVIL9mEsX3JK7hKFFvPYvZinnVd9Nm6ndI3NY+uEPo++kMZg1exLPu46ub7QSKegt7au81wb+MXxxDFXlQk+q8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724772543; c=relaxed/simple;
	bh=US9yxCtA29eySGRsx+D+axg/ZQOuLr+bdxYS7dx2JkI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RGJsbn+Gk2dd2xlQu78a6plCsCKu2D6baD4ui2gtZNfDN+wqoqeIMFDzIIwQiLn7YI12S/3MAZj4a1MQMOSIwXZZh+8ZLZ0Gf0xunItkZGFVuUVxWt0YcGIrL/533zYPwmIlmCQsmHA1mQ1nsQdwjWlJWiqovzu6FsnOzczxoHU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MXtjUl/B; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MXtjUl/B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39958C4AF15;
	Tue, 27 Aug 2024 15:29:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724772543;
	bh=US9yxCtA29eySGRsx+D+axg/ZQOuLr+bdxYS7dx2JkI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MXtjUl/BNs7QadChdfeQsULvLKB4KYqzihFNwYGyWe03BsZAl9NlfdKTXNk++9VU4
	 JjYc6df0wLOOZVdlPRvv8bnPfI5cXbNFf1RAqCLKLXaVlaqg6yRzb1ipCQ+rGfIeC+
	 c83eSfFwXUxGxF8EedOGxeIw0fSywD9Z9pcRynhw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luiz Capitulino <luizcap@redhat.com>,
	Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	Chandan Kumar Rout <chandanx.rout@intel.com>
Subject: [PATCH 6.1 247/321] ice: fix ICE_LAST_OFFSET formula
Date: Tue, 27 Aug 2024 16:39:15 +0200
Message-ID: <20240827143847.647081168@linuxfoundation.org>
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

From: Maciej Fijalkowski <maciej.fijalkowski@intel.com>

[ Upstream commit b966ad832942b5a11e002f9b5ef102b08425b84a ]

For bigger PAGE_SIZE archs, ice driver works on 3k Rx buffers.
Therefore, ICE_LAST_OFFSET should take into account ICE_RXBUF_3072, not
ICE_RXBUF_2048.

Fixes: 7237f5b0dba4 ("ice: introduce legacy Rx flag")
Suggested-by: Luiz Capitulino <luizcap@redhat.com>
Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Tested-by: Chandan Kumar Rout <chandanx.rout@intel.com> (A Contingent Worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_txrx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_txrx.c b/drivers/net/ethernet/intel/ice/ice_txrx.c
index 6ad4bdb0124e7..8577bf0ed5402 100644
--- a/drivers/net/ethernet/intel/ice/ice_txrx.c
+++ b/drivers/net/ethernet/intel/ice/ice_txrx.c
@@ -812,7 +812,7 @@ ice_can_reuse_rx_page(struct ice_rx_buf *rx_buf)
 		return false;
 #if (PAGE_SIZE >= 8192)
 #define ICE_LAST_OFFSET \
-	(SKB_WITH_OVERHEAD(PAGE_SIZE) - ICE_RXBUF_2048)
+	(SKB_WITH_OVERHEAD(PAGE_SIZE) - ICE_RXBUF_3072)
 	if (rx_buf->page_offset > ICE_LAST_OFFSET)
 		return false;
 #endif /* PAGE_SIZE >= 8192) */
-- 
2.43.0



