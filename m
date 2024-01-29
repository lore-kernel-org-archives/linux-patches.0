Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B103158D76;
	Mon, 29 Jan 2024 17:09:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548170; cv=none; b=T75eXH8I40Q7tnmrPlM7bKEZsSInUZowrSqxBzVsziBolHZfFFzyO/nhaMgSmOXL65p/wNiaGBi7+S3mza2GEovKm5pwJiiipBCQSKuKFL9EF5k9aCQWO7CxeFy5OncJAxT9uk/1LITC1FB3/rlHFRSYRCjyU4H7uOZTvPbdd1w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548170; c=relaxed/simple;
	bh=2dPwPnwI+7yLNtBgKS/KTqDzS423Tuf8VYN+hJqMzIM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MCykl1bH4UFvey8pAF/GJrP5oACRLdbI+nnrcuQJuiKIc/GkFSXWzIcgK4L6Gme5tqXDFtUUoK9dP7SLWDns3l47X4IZLDWcz6p5UWx1XujWdvfFXPeFrq3q150v8UzF2XlwMILLn/SvQbY7gMFuJzQORoeukXYkUR2p2XFtKiY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GpBIP9Zy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GpBIP9Zy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 012F8C43390;
	Mon, 29 Jan 2024 17:09:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548170;
	bh=2dPwPnwI+7yLNtBgKS/KTqDzS423Tuf8VYN+hJqMzIM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GpBIP9ZyIl1W8lv05mqcwz2j+dGHSDV0HG7Zhd//Rbk5SFNbAgcFruVdhri9ZmqJ0
	 wSQdXna08lo8YS73lp1nIIrdX3KmeMwnK+1dHSTNfiNX2RWwInRyQWSwjXFSumrbZ9
	 SFnG1Oo8U84Tg3Ds5tgClxqkaTnmXSIckMbqh0xk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 214/346] xdp: reflect tail increase for MEM_TYPE_XSK_BUFF_POOL
Date: Mon, 29 Jan 2024 09:04:05 -0800
Message-ID: <20240129170022.677920456@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129170016.356158639@linuxfoundation.org>
References: <20240129170016.356158639@linuxfoundation.org>
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

From: Maciej Fijalkowski <maciej.fijalkowski@intel.com>

[ Upstream commit fbadd83a612c3b7aad2987893faca6bd24aaebb3 ]

XSK ZC Rx path calculates the size of data that will be posted to XSK Rx
queue via subtracting xdp_buff::data_end from xdp_buff::data.

In bpf_xdp_frags_increase_tail(), when underlying memory type of
xdp_rxq_info is MEM_TYPE_XSK_BUFF_POOL, add offset to data_end in tail
fragment, so that later on user space will be able to take into account
the amount of bytes added by XDP program.

Fixes: 24ea50127ecf ("xsk: support mbuf on ZC RX")
Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Link: https://lore.kernel.org/r/20240124191602.566724-10-maciej.fijalkowski@intel.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/filter.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/core/filter.c b/net/core/filter.c
index 6575288b8580..cee53838310f 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -4091,6 +4091,8 @@ static int bpf_xdp_frags_increase_tail(struct xdp_buff *xdp, int offset)
 	memset(skb_frag_address(frag) + skb_frag_size(frag), 0, offset);
 	skb_frag_size_add(frag, offset);
 	sinfo->xdp_frags_size += offset;
+	if (rxq->mem.type == MEM_TYPE_XSK_BUFF_POOL)
+		xsk_buff_get_tail(xdp)->data_end += offset;
 
 	return 0;
 }
-- 
2.43.0



