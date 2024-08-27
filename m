Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E3BC1E487;
	Tue, 27 Aug 2024 14:57:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724770650; cv=none; b=gTESZ/P5wtcrbnj5fNx/dgmmqBdiKypItjMvjQ4JkAakIrU9yMjcCOsdt6AtPsJiUbGXeglXegfadBouFeSdNtzO2cXLGGOioDULluCnn2TKC/SdxbKw/zY3UiHiilNZNKUZjERgV5P2Id6t3iSpzZB9smTpJJuAlClq2jZxxi4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724770650; c=relaxed/simple;
	bh=zVeqEwykI/B0OvqHDlsCsQKe5Luo7bKVKe73+fpNXWo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m3I6OF/eV7UIoA2Wz13DirDeT6OJ09ljMSB0gGVizisu7WwTBFIqYTMaL3Lgefs6T8nx/S8Skg7RC3/eBCtAAcR7G7xHDk6G5U4stossQgCzAhRF9RInxcPSmDqw4/S1waNVDL0G2+bZS+oE92XkRumcHN1B6svfDalJKSeaq34=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=arU3EZNo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="arU3EZNo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB760C61040;
	Tue, 27 Aug 2024 14:57:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724770650;
	bh=zVeqEwykI/B0OvqHDlsCsQKe5Luo7bKVKe73+fpNXWo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=arU3EZNoNd2CQQrT4/zeLHeRieZu4e/Ys5pAip+8Ey+gIz+YXfeABaQzlMmjzLlTm
	 XkWExXCqCHezobZ0DPbEtPOSRhK/gu7pJ+XUni+5F1dmWQzfgyA+f/5zAXVjNZ4HUV
	 cV9mt/ch+GeeAKn8dAzIxeK3WJmLXrZU0XOXfOio=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luiz Capitulino <luizcap@redhat.com>,
	Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	Chandan Kumar Rout <chandanx.rout@intel.com>
Subject: [PATCH 6.6 261/341] ice: fix ICE_LAST_OFFSET formula
Date: Tue, 27 Aug 2024 16:38:12 +0200
Message-ID: <20240827143853.336647451@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143843.399359062@linuxfoundation.org>
References: <20240827143843.399359062@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 8e53195df2b1c..55faa8384bcfe 100644
--- a/drivers/net/ethernet/intel/ice/ice_txrx.c
+++ b/drivers/net/ethernet/intel/ice/ice_txrx.c
@@ -839,7 +839,7 @@ ice_can_reuse_rx_page(struct ice_rx_buf *rx_buf)
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



