Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3650726AC1;
	Sun,  1 Sep 2024 17:06:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725210388; cv=none; b=NM6zTzVHqAMZ0YevZaC2BJYjjL82uY0JvAyWyiBHuajk1g029j35mpKypJEy87+d4Pusp1Rb9ArV0j2LCdgrvu1bNBByjnFBXnZLOUOLxEsoOdx7XGS2jV1f9oNn+lgHu6x9GHBPRUV8wlKunakEIA3Mx4a5wfuGNaJjdEB8qsk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725210388; c=relaxed/simple;
	bh=aJiYcxqdZeTcVCYpPr3RIhQwHkaWQz8i0j+nOTmuD44=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m1u+/wryEmP5KyDHvmqjCplurYR0pAxCxKq89VkvaTMadGYmPXTqNxpEqeuBF8yDqFAp2H7rJAq9KV56qvcOYt/OzyxNhrb5YlXHvUvWi2Pjm5fUMfalVIA2lxMZ1tEYAfJM4WqWLGD1kIS5QU3KLzHqo/c5mFeyiKWbT14Ei/g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kbYIvkrt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kbYIvkrt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57D6EC4CEC4;
	Sun,  1 Sep 2024 17:06:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725210387;
	bh=aJiYcxqdZeTcVCYpPr3RIhQwHkaWQz8i0j+nOTmuD44=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kbYIvkrtS0fZDM3QBRjy8XFC8veCD4w3wV2+81W6XcmB1kENfW8M5uINqX9qFwPgY
	 MpKNMlUrzA9o1f0kE2CTFBsB5uS1iohc2gjXU94vvlldeJJtFXJcsHVgShAuxc/4Zs
	 J1xx5hNwBgPfHH2Ex80x8gsQhBBcb+13YVjAHzsg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luiz Capitulino <luizcap@redhat.com>,
	Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	Chandan Kumar Rout <chandanx.rout@intel.com>
Subject: [PATCH 5.15 143/215] ice: fix ICE_LAST_OFFSET formula
Date: Sun,  1 Sep 2024 18:17:35 +0200
Message-ID: <20240901160828.770158661@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160823.230213148@linuxfoundation.org>
References: <20240901160823.230213148@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 6ee8e0032d52c..b09d89cdb001f 100644
--- a/drivers/net/ethernet/intel/ice/ice_txrx.c
+++ b/drivers/net/ethernet/intel/ice/ice_txrx.c
@@ -765,7 +765,7 @@ ice_can_reuse_rx_page(struct ice_rx_buf *rx_buf, int rx_buf_pgcnt)
 		return false;
 #else
 #define ICE_LAST_OFFSET \
-	(SKB_WITH_OVERHEAD(PAGE_SIZE) - ICE_RXBUF_2048)
+	(SKB_WITH_OVERHEAD(PAGE_SIZE) - ICE_RXBUF_3072)
 	if (rx_buf->page_offset > ICE_LAST_OFFSET)
 		return false;
 #endif /* PAGE_SIZE < 8192) */
-- 
2.43.0



