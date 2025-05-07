Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DFA01FF5EC;
	Wed,  7 May 2025 18:52:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746643944; cv=none; b=PXsl/WS7GjjJwJXS+YJ4vvbM7A/Tn2yBWQlq6YJuJHAnArSjNosKziV/rXH67No2CEbX25BzMUowQon0VRpmL5LkyqpzqewOe4V7OEXbY5nRqs//Mzy7XAAvuD4CkiwC7hUIx9/wPxx6uZqDHH9Zofg9gwvEIW+Im+pb0N7YFtc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746643944; c=relaxed/simple;
	bh=Rn7w+AWFR12QbpFoANpQU9mr6d63Do8ymlefkiBBSto=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LvPG2FTN0rBHTuN/SRYTkfoVjze81tafI8K5aAzqHU/LqGoll4MgMov1QFIEgjd9cjlahvP1Iqp0E3Cz52USOp/b7OMTbm+otlyPzJnxT2jbHycrEXNE5//P3+TuOhLuFgHMUcJTlLHPSIlywo4qCrEJHOkos2srtYvw2+gzJwI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pfP3B52S; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pfP3B52S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48DF7C4CEE2;
	Wed,  7 May 2025 18:52:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1746643943;
	bh=Rn7w+AWFR12QbpFoANpQU9mr6d63Do8ymlefkiBBSto=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pfP3B52SDlmBkzRj3j8tsIK7tT6jBiAclFGSZbzewbO61llOLymifsUuB8FQidvqe
	 XxuHlyzubDYEBKJBVX9EcX4HDbPIolLV12urvHQhXKY2owulcNexaOflrhN//V4She
	 mhHVI+psNUROqM9weH62ezHLK1bXmArEWUWTCQeY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eryk Kubanski <e.kubanski@partner.samsung.com>,
	Magnus Karlsson <magnus.karlsson@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 068/183] xsk: Fix offset calculation in unaligned mode
Date: Wed,  7 May 2025 20:38:33 +0200
Message-ID: <20250507183827.444135255@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250507183824.682671926@linuxfoundation.org>
References: <20250507183824.682671926@linuxfoundation.org>
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

From: e.kubanski <e.kubanski@partner.samsung.com>

[ Upstream commit bf20af07909925ec0ae6cd4f3b7be0279dfa8768 ]

Bring back previous offset calculation behaviour
in AF_XDP unaligned umem mode.

In unaligned mode, upper 16 bits should contain
data offset, lower 48 bits should contain
only specific chunk location without offset.

Remove pool->headroom duplication into 48bit address.

Signed-off-by: Eryk Kubanski <e.kubanski@partner.samsung.com>
Fixes: bea14124bacb ("xsk: Get rid of xdp_buff_xsk::orig_addr")
Acked-by: Magnus Karlsson <magnus.karlsson@intel.com>
Link: https://patch.msgid.link/20250416112925.7501-1-e.kubanski@partner.samsung.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/xsk_buff_pool.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/net/xsk_buff_pool.h b/include/net/xsk_buff_pool.h
index 7f0a75d6563d8..b3699a8488444 100644
--- a/include/net/xsk_buff_pool.h
+++ b/include/net/xsk_buff_pool.h
@@ -232,8 +232,8 @@ static inline u64 xp_get_handle(struct xdp_buff_xsk *xskb,
 		return orig_addr;
 
 	offset = xskb->xdp.data - xskb->xdp.data_hard_start;
-	orig_addr -= offset;
 	offset += pool->headroom;
+	orig_addr -= offset;
 	return orig_addr + (offset << XSK_UNALIGNED_BUF_OFFSET_SHIFT);
 }
 
-- 
2.39.5



