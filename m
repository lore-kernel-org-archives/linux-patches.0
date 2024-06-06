Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F2261A1885;
	Thu,  6 Jun 2024 14:22:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683722; cv=none; b=Rl5PHSlYCYZKOcMhTXVWCVcP0pu2C702FkyjnDC/LdHNLONnjF03kLHMwtKTPfxIg4GjA2Y8ifOXYyBo3U5gy8s+njR1b1RbuZ7Uba4MlZuTPXdTVLc+NqXTvTx5V1MSZBmA7YenEeK551nsCvYf8bl/gzMGJHwRkEWoogqvIyo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683722; c=relaxed/simple;
	bh=SNyMhUBllmjX//CYwBHp78eHQ4yhW5KXyZkk0H9zqss=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uM9P7fXUmV92VQuzOrFK1ZoeSXIHUWozlRBxTiBHg6q20u3gH4WyXXLppu4VP0kueV4WY2OTaD71L4+b0ROT8qZC3h8ok99gGrslEYYcCl0jBhcizibr3P3bA7tpnrZukG+snyulXrU8pLfHBy4wtcCsOG7Bih6HWR8UFUbMkBY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SekPs4nC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SekPs4nC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56725C2BD10;
	Thu,  6 Jun 2024 14:22:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683722;
	bh=SNyMhUBllmjX//CYwBHp78eHQ4yhW5KXyZkk0H9zqss=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SekPs4nCSlDLrnao3NqTGCnSVLsHID6ay7fDvN+cpFPVUbEK1y7sV0iEufreSB3jI
	 poXBUvhPBtOBtzpS/9i/kJpJ+E3+4fn+M5zqlrNNkzc6WhpPsVPAMsGqqQ4DZpeP2S
	 9IqtHFgAfFVouTRicvZd/Fe7DA8kXJrZza1Q4oG4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ryosuke Yasuoka <ryasuoka@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 666/744] nfc: nci: Fix handling of zero-length payload packets in nci_rx_work()
Date: Thu,  6 Jun 2024 16:05:38 +0200
Message-ID: <20240606131753.831535983@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
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
index f350c5fb992ec..c4d2932c59032 100644
--- a/net/nfc/nci/core.c
+++ b/net/nfc/nci/core.c
@@ -1531,8 +1531,7 @@ static void nci_rx_work(struct work_struct *work)
 
 		if (!nci_valid_size(skb)) {
 			kfree_skb(skb);
-			kcov_remote_stop();
-			break;
+			continue;
 		}
 
 		/* Process frame */
-- 
2.43.0



