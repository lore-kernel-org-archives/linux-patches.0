Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D78D63624BC;
	Sat, 12 Sep 2026 10:53:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789210423; cv=none; b=OmHBOFgy9KB4KYrtRlWsTzKhTsQA6Zyjy7GESfKvVP/ULJeM6gC3i7BzEsUHZZnCH8J03t2Z3HZPRZKhQTa6oJpU1uSuEiVN4hdhVNEE4347uShcHvHbwB1pDtdgPlPXWgu1C2uAQ9IU4PICGNIqNidgfS0TH8scDoHBs6iynvI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789210423; c=relaxed/simple;
	bh=iaq5L552424iNWfrdoYm9Yb/yrVUoIJ5bm6HI1h7tX8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SzWpsMDdY7WsgCMAWlgvADpyNYEyV9mRVVkcfP8rYRKahBbqZRXMob5b8ILm/CQnUtpMeFqBBIvWN6umENWV0xSYTNT4sk08B0iOvbAvAdg/2lDftCJX/xr44CRODQJXu7dr47+1Dl74QbOzN3UaHkOehUqigKCE1NioqdLgZNw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Psnv9UkE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Psnv9UkE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 931FD1F000FF;
	Sat, 12 Sep 2026 10:53:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789210422;
	bh=PBU1JwdGmgcacLZQmBZcZVqDcpugveJEll3mZGj17ZE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Psnv9UkErYBsvfpMEeWjNY8lSw4pMDwLvODH8XiuPb31XR8Xs2Ha+D3Ec3izCCVvO
	 LcAkOCZICgTCjeeuPoleZpdFpOweHtH+oHtGLQANHIQ//Fepc5+DO+EqtlIQat7ZfW
	 0KI9Jm3T6Ha1gt6foLVA6b/IvSluWwztLL1vN1Yc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zijun Hu <zijun.hu@oss.qualcomm.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1024/1518] Bluetooth: btintel: Fix diagnostics event detection
Date: Sat, 12 Sep 2026 08:53:13 +0200
Message-ID: <20260912065646.615746041@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zijun Hu <zijun.hu@oss.qualcomm.com>

[ Upstream commit ad0e7ac7da9a9a0095570bd6add3e27f259de104 ]

For a diagnostics VSE, diagnostics_hdr[] sits at the start of the event
payload, skb->data[2], but btintel_recv_event() wrongly guards its
memcmp with @len, which is measured from skb->data[3] for the earlier
INTEL_BOOTLOADER check.

Fix by using (@len + 1) instead, which ==
(skb->len - HCI_EVENT_HDR_SIZE) exactly.

Fixes: af395330abed ("Bluetooth: btintel: Add Intel devcoredump support")
Signed-off-by: Zijun Hu <zijun.hu@oss.qualcomm.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/btintel.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/bluetooth/btintel.c b/drivers/bluetooth/btintel.c
index 4d6b6bbb4267e..f665682c91b6b 100644
--- a/drivers/bluetooth/btintel.c
+++ b/drivers/bluetooth/btintel.c
@@ -3757,7 +3757,7 @@ int btintel_recv_event(struct hci_dev *hdev, struct sk_buff *skb)
 		/* Handle all diagnostics events separately. May still call
 		 * hci_recv_frame.
 		 */
-		if (len >= sizeof(diagnostics_hdr) &&
+		if (len + 1 >= sizeof(diagnostics_hdr) &&
 		    memcmp(&skb->data[2], diagnostics_hdr,
 			   sizeof(diagnostics_hdr)) == 0) {
 			return btintel_diagnostics(hdev, skb);
-- 
2.53.0



