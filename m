Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEB3D44C6F;
	Thu, 13 Jun 2024 12:01:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718280115; cv=none; b=DbomSyfGGHLpdfJ69fvEzx0lmRE6eWUzdcxebyzsdUJgeNlxrEf70eTbUC6jm7hDxVd0Z1fCVKG1iarDxi1R4aN8QMe0ER1K4wGdVleom7Wm0QzN7r0QJfpsYaQPSZyjcidsU/KPVYTH4/qcJPP1jorQR7ITfu89N69E4MlB/Z4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718280115; c=relaxed/simple;
	bh=q/5qX0pOPruupRoeLEpBUDftWeSuNQNCraRITd7Ptrs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p6bkefkJuxteeHCKaXselFtBrrY8knOCmizPwiDG81QqEGjFNOa7M5inR03FQ87uUQwXkjEOlgCac1T2MNR+IQIwfyLj+HJcXrRZ18LvwNalYaH41YLzGCaAe+nk9x9d/DQvT8o/4OFAiaZbOTHqz+O09YO+4Ut1RVsjb6YL+1k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=10BoOIEL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="10BoOIEL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 015A7C2BBFC;
	Thu, 13 Jun 2024 12:01:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718280115;
	bh=q/5qX0pOPruupRoeLEpBUDftWeSuNQNCraRITd7Ptrs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=10BoOIELRp4f5ZNAa6b8OmPMrfcgG4RdcdctZQZ8SURj2DC3HlP6Nqj9wvrzJLHr5
	 0V1DwcyU27fR/pgfHeudIvEpg1oVDtkpfAyaDEHBWG5v/RFq+xpgzwINVMlL0CJ65d
	 Q+n6nb4GktgMWIvEMooNLd3TuwQXFM/96ak5PRs4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ryosuke Yasuoka <ryasuoka@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 147/202] nfc: nci: Fix handling of zero-length payload packets in nci_rx_work()
Date: Thu, 13 Jun 2024 13:34:05 +0200
Message-ID: <20240613113233.430196383@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113227.759341286@linuxfoundation.org>
References: <20240613113227.759341286@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index ebf1b511d8e3b..58ac4c80495ef 100644
--- a/net/nfc/nci/core.c
+++ b/net/nfc/nci/core.c
@@ -1514,8 +1514,7 @@ static void nci_rx_work(struct work_struct *work)
 
 		if (!nci_valid_size(skb)) {
 			kfree_skb(skb);
-			kcov_remote_stop();
-			break;
+			continue;
 		}
 
 		/* Process frame */
-- 
2.43.0



