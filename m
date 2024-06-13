Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC3936AFAE;
	Thu, 13 Jun 2024 11:42:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718278964; cv=none; b=QSRTmGYCRYy6Zz4cr80gRvxaan3Orrqj1z65PYeGNUQVwE79ARg7Na4Oh0c3gSsZpTD2jzDo316fKI9ZhK7Hh47IXhMwvC0C8ASr6aPTmKtcnfdpge42cVyK3YGbg9tXYoHT39M5+i82gf1amKXlcb7WlMftbMsKpMiTB+Pavao=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718278964; c=relaxed/simple;
	bh=CNFlmrTwjE3XR/92VwgbxDZ29OPs6eo/K1cv2S639CU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aD9kNc1X63dyp0LOlvPydN1iUzVZy0tykN1gp8xvZ9YqrsiK/fOIIpxTpLXSWFsEMGkyT6I8RESJeNPa+WfnIQkV7YLTsjxMnXD2b23N5im9DCcc00k1QIA3noitwW2IRgrPFggt3r+AnMC5YpPp5oEOvSLzIslpHpHM4RTCuuk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XfhVQ7by; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XfhVQ7by"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B084C2BBFC;
	Thu, 13 Jun 2024 11:42:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718278964;
	bh=CNFlmrTwjE3XR/92VwgbxDZ29OPs6eo/K1cv2S639CU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XfhVQ7byZjnitmQkSOaekzzB1PIAU6Me1oq0XxR4XJHiDcqIMrsGApq5p8qsQLQs2
	 qvbztjFInL7EdhCP2SploITnZPUtcNsckfLdSVIdbtexGXjg+kBuDctbOhW2xZXihJ
	 LOVe4RPWGzNRdfaZhhQsBJdHsGUzTElnrapvfEXc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ryosuke Yasuoka <ryasuoka@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 130/213] nfc: nci: Fix handling of zero-length payload packets in nci_rx_work()
Date: Thu, 13 Jun 2024 13:32:58 +0200
Message-ID: <20240613113233.012665381@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113227.969123070@linuxfoundation.org>
References: <20240613113227.969123070@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ryosuke Yasuoka <ryasuoka@redhat.com>

[ Upstream commit 6671e352497ca4bb07a96c48e03907065ff77d8a ]

When nci_rx_work() receives a zero-length payload packet, it should not
discard the packet and exit the loop. Instead, it should continue
processing subsequent packets.

Fixes: d24b03535e5e ("nfc: nci: Fix uninit-value in nci_dev_up and nci_ntf_packet")
Signed-off-by: Ryosuke Yasuoka <ryasuoka@redhat.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Link: https://lore.kernel.org/r/20240521153444.535399-1-ryasuoka@redhat.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/nfc/nci/core.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/net/nfc/nci/core.c b/net/nfc/nci/core.c
index 0e6bca80265ae..c29d7aee63bd5 100644
--- a/net/nfc/nci/core.c
+++ b/net/nfc/nci/core.c
@@ -1526,8 +1526,7 @@ static void nci_rx_work(struct work_struct *work)
 
 		if (!nci_valid_size(skb)) {
 			kfree_skb(skb);
-			kcov_remote_stop();
-			break;
+			continue;
 		}
 
 		/* Process frame */
-- 
2.43.0



