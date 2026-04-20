Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B5B733C187;
	Mon, 20 Apr 2026 16:08:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776701302; cv=none; b=RAkYeh5DqdBij4/dkL9MOcj9yASPHJ92uIbT9JHOUvR3ehfJ9F1guTevOa6DM+p9GcgzveEi7ztRULGRwoi9e6jqswfhkuRfJd94zUwm994lfFZ9FjBLOmgicNwnUeOETyzNe8FrFA7SjNBgGwGYiqx77HzXYEHlLqEfM+viKAY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776701302; c=relaxed/simple;
	bh=Jrm7zKTCTq9ZWOTqeJ0VWVg10sUZSTIaVSzLptDYZL0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=sxfxE77e3i5s3700rFFFbSIWOUVFt86Z8v1rnE0zOfOJe0is0Y4DI31ZQQsQrnMNvZURzzBT+0ow7I8wqWYU67GlrOjmQT93DOERBm/5tjrnM0Aye1qyd1/Xx7TKQDD7eFTLg+SqxhRSoM9r+fkzt4DQMFP97ik/+eKACWIfhSE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=B0fK5zSI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="B0fK5zSI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B01DFC19425;
	Mon, 20 Apr 2026 16:08:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776701302;
	bh=Jrm7zKTCTq9ZWOTqeJ0VWVg10sUZSTIaVSzLptDYZL0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=B0fK5zSINO7T5P3WyiBKwVCTc0NYd1qa1fHNOdRCIFTDF0sNX7s6Hf89M3rqFxaSv
	 koTAQZ7SGTNl4Fu9NDY6VMPb8EWlF8oY7PZuMn7BY/Vl4EkSkc03IKygy5JjcCilD2
	 lZSpf54mi7y94JR1G0xVhq/U2ckrOZaelzbaPWyM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@kernel.org>,
	Stanislav Fomichev <sdf@fomichev.me>,
	Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 061/162] xsk: tighten UMEM headroom validation to account for tailroom and min frame
Date: Mon, 20 Apr 2026 17:41:33 +0200
Message-ID: <20260420153929.247170202@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420153927.006696811@linuxfoundation.org>
References: <20260420153927.006696811@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Maciej Fijalkowski <maciej.fijalkowski@intel.com>

[ Upstream commit a315e022a72d95ef5f1d4e58e903cb492b0ad931 ]

The current headroom validation in xdp_umem_reg() could leave us with
insufficient space dedicated to even receive minimum-sized ethernet
frame. Furthermore if multi-buffer would come to play then
skb_shared_info stored at the end of XSK frame would be corrupted.

HW typically works with 128-aligned sizes so let us provide this value
as bare minimum.

Multi-buffer setting is known later in the configuration process so
besides accounting for 128 bytes, let us also take care of tailroom space
upfront.

Reviewed-by: Björn Töpel <bjorn@kernel.org>
Acked-by: Stanislav Fomichev <sdf@fomichev.me>
Fixes: 99e3a236dd43 ("xsk: Add missing check on user supplied headroom size")
Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Link: https://patch.msgid.link/20260402154958.562179-2-maciej.fijalkowski@intel.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/xdp/xdp_umem.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/xdp/xdp_umem.c b/net/xdp/xdp_umem.c
index 9f76ca591d54f..9ec7bd948acc7 100644
--- a/net/xdp/xdp_umem.c
+++ b/net/xdp/xdp_umem.c
@@ -202,7 +202,8 @@ static int xdp_umem_reg(struct xdp_umem *umem, struct xdp_umem_reg *mr)
 	if (!unaligned_chunks && chunks_rem)
 		return -EINVAL;
 
-	if (headroom >= chunk_size - XDP_PACKET_HEADROOM)
+	if (headroom > chunk_size - XDP_PACKET_HEADROOM -
+		       SKB_DATA_ALIGN(sizeof(struct skb_shared_info)) - 128)
 		return -EINVAL;
 
 	if (mr->flags & XDP_UMEM_TX_METADATA_LEN) {
-- 
2.53.0



