Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31A66DDC1;
	Tue, 27 Aug 2024 14:46:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724769986; cv=none; b=AvZY1f8MOPxBYCZw8UpHWoDXY7G2B/HcHPKcfEijHcPmZEEP2+i0O8lPY/890oiboaVao1Dc0aGRVr8/sRMPyQLo3Yy6JHT3jH7AVId4e97/iGO7VGp9eAEGYA/UTDaiQhhcg5tr0nE5etwEsZBfrJZNBdWHJxkyl8gY65f48ko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724769986; c=relaxed/simple;
	bh=ZLqRsvN2LSvR08mcItj9ttMDQznzCodKCQUNRVzSgWI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u2j9LNGzCJwz6kr47BugpYCddNn2flwsyMALIyM/vAf3u14lIQ5PGTjsVwtuLqi9dLtuTJAgRm/7vpLvqQpVIFknQ9WF8vNCXUQVW/nErDzyiG00huf5mWzjlN8DH9ovLGvHJaf/lWlcPnzwH2oLluM8deXid8W17C+bbrqQEak=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EFao1fNH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EFao1fNH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89855C6106D;
	Tue, 27 Aug 2024 14:46:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724769986;
	bh=ZLqRsvN2LSvR08mcItj9ttMDQznzCodKCQUNRVzSgWI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EFao1fNHtgRADTiB5VkjyJCRKhopsSSYfRLbufEpbJEwCfJP9VaOeNZJk7PNah3TR
	 0dI2LSHY4uN2KGdyqeIuP8FRmAvY1pvhYXASBCswzvJMgkhbBeILW15EXaY+0UBgM+
	 DYfnMuAY6Nld6NY3mPPh2JL5KlCW7DK7fwOCzSYE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Simon Horman <horms@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 094/341] net: ethernet: mtk_wed: check update_wo_rx_stats in mtk_wed_update_rx_stats()
Date: Tue, 27 Aug 2024 16:35:25 +0200
Message-ID: <20240827143846.982982312@linuxfoundation.org>
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

From: Lorenzo Bianconi <lorenzo@kernel.org>

[ Upstream commit 486e6ca6b48d68d7fefc99e15cc1865e2210d893 ]

Check if update_wo_rx_stats function pointer is properly set in
mtk_wed_update_rx_stats routine before accessing it.

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://lore.kernel.org/r/b0d233386e059bccb59f18f69afb79a7806e5ded.1694507226.git.lorenzo@kernel.org
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mediatek/mtk_wed_mcu.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/mediatek/mtk_wed_mcu.c b/drivers/net/ethernet/mediatek/mtk_wed_mcu.c
index 071ed3dea860d..72bcdaed12a94 100644
--- a/drivers/net/ethernet/mediatek/mtk_wed_mcu.c
+++ b/drivers/net/ethernet/mediatek/mtk_wed_mcu.c
@@ -68,6 +68,9 @@ mtk_wed_update_rx_stats(struct mtk_wed_device *wed, struct sk_buff *skb)
 	struct mtk_wed_wo_rx_stats *stats;
 	int i;
 
+	if (!wed->wlan.update_wo_rx_stats)
+		return;
+
 	if (count * sizeof(*stats) > skb->len - sizeof(u32))
 		return;
 
-- 
2.43.0



