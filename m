Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F4392EAE5;
	Thu, 12 Dec 2024 15:02:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734015769; cv=none; b=LMsUdgqXdAZddXoX8ry+egvRBQFXa5Ufnzvt14VdLBxr7Jh7tDikSdkwLOr7XbtMQqalqDhLLMPf7bdbAgGAkoZHb39vgBzYuJcINF2nOS/VJMlmLxe0Y5rWkPDgNteb1BOfqR+kEBR7QOu4+SySx/msl8OzTh1W8DM+q9FY6ZE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734015769; c=relaxed/simple;
	bh=rb6AUQpmkt1nv7Tdb+vcHSU5JbVVTVCETe/xnBtS/Qc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AdkvA2PuCN9GPSIFo+REFKex8pR2r1sNHw/LWQh7Yj5b1kMJRm/Z4wpktmBrod5UMhreBPXFKFR6UI6N5sA8CIQUv3fsB9hL8bquQPgORtIiDyM72yEtg9aSi3II/6oIMhGC2qZaxtBq8vnpXUxe38cm2L6+Qq4cdgSlZONq6fo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IsN9SF5q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IsN9SF5q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFA82C4CECE;
	Thu, 12 Dec 2024 15:02:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734015769;
	bh=rb6AUQpmkt1nv7Tdb+vcHSU5JbVVTVCETe/xnBtS/Qc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IsN9SF5q/pX4wqzsRp3vwZ3ArzrJunOcmEmAzFFLirDmf5I47fjOtv/+m3trKoRgx
	 GV+dNnH6OFLnIda4+Bx2WCRP1mJPOZiy7Sfc0ZtZIhjLlPhkopCp1f/Kj5wW2syJyl
	 WKNr5WS5Yw4LRjQ+9fHnClMcIAyjN9JQlSNBi9lk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joshua Hay <joshua.a.hay@intel.com>,
	Alexander Lobakin <aleksander.lobakin@intel.com>,
	Madhu chittim <madhu.chittim@intel.com>,
	Simon Horman <horms@kernel.org>,
	Krishneil Singh <krishneil.k.singh@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 040/466] idpf: set completion tag for "empty" bufs associated with a packet
Date: Thu, 12 Dec 2024 15:53:29 +0100
Message-ID: <20241212144308.270004001@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144306.641051666@linuxfoundation.org>
References: <20241212144306.641051666@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joshua Hay <joshua.a.hay@intel.com>

[ Upstream commit 4c69c77aafe74cf755af55070584b643e5c4e4d8 ]

Commit d9028db618a6 ("idpf: convert to libeth Tx buffer completion")
inadvertently removed code that was necessary for the tx buffer cleaning
routine to iterate over all buffers associated with a packet.

When a frag is too large for a single data descriptor, it will be split
across multiple data descriptors. This means the frag will span multiple
buffers in the buffer ring in order to keep the descriptor and buffer
ring indexes aligned. The buffer entries in the ring are technically
empty and no cleaning actions need to be performed. These empty buffers
can precede other frags associated with the same packet. I.e. a single
packet on the buffer ring can look like:

	buf[0]=skb0.frag0
	buf[1]=skb0.frag1
	buf[2]=empty
	buf[3]=skb0.frag2

The cleaning routine iterates through these buffers based on a matching
completion tag. If the completion tag is not set for buf2, the loop will
end prematurely. Frag2 will be left uncleaned and next_to_clean will be
left pointing to the end of packet, which will break the cleaning logic
for subsequent cleans. This consequently leads to tx timeouts.

Assign the empty bufs the same completion tag for the packet to ensure
the cleaning routine iterates over all of the buffers associated with
the packet.

Fixes: d9028db618a6 ("idpf: convert to libeth Tx buffer completion")
Signed-off-by: Joshua Hay <joshua.a.hay@intel.com>
Acked-by: Alexander Lobakin <aleksander.lobakin@intel.com>
Reviewed-by: Madhu chittim <madhu.chittim@intel.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Tested-by: Krishneil Singh <krishneil.k.singh@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/idpf/idpf_txrx.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/intel/idpf/idpf_txrx.c b/drivers/net/ethernet/intel/idpf/idpf_txrx.c
index d4e6f0e104872..60d15b3e6e2fa 100644
--- a/drivers/net/ethernet/intel/idpf/idpf_txrx.c
+++ b/drivers/net/ethernet/intel/idpf/idpf_txrx.c
@@ -2448,6 +2448,7 @@ static void idpf_tx_splitq_map(struct idpf_tx_queue *tx_q,
 			 * rest of the packet.
 			 */
 			tx_buf->type = LIBETH_SQE_EMPTY;
+			idpf_tx_buf_compl_tag(tx_buf) = params->compl_tag;
 
 			/* Adjust the DMA offset and the remaining size of the
 			 * fragment.  On the first iteration of this loop,
-- 
2.43.0



