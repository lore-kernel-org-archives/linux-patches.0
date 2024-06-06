Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AF371990B7;
	Thu,  6 Jun 2024 14:18:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683538; cv=none; b=F50yzNklCSsPYo1s/Om8N2larBbObU+MddSK1rv6lPQC7hZt9G6lprvoUb+1zcCKvY1n8pls0MVVkgw+ECRrzEPTYOPllAO8tP7GFKqmXyxOelCiy+7czLlkMVSoNP6g9Ozsu159MlyGGovs+qDRXIJz1bwuB3flKPRMYyayXfw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683538; c=relaxed/simple;
	bh=aiHRkJPqOrFFPVbjGrNX769v/TR445z2v6UGdcJyOIw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VntCNgiPgumfzQxGhkhtdtVLRD1Xv9pPavREjLI+TITNDGnTwJqYukOzIOLfJM3q9jHv2JB8YyWNHDAGSb+44M1EjOkl7IiOGljgLjvbs1PR8GnXQEjawz23h0AUT7NSbV0BMR1tZNDq0ccNA4f133rI6Qp0mIZtUEbvcIXO+DE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1Px7K2Qw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1Px7K2Qw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 197B1C2BD10;
	Thu,  6 Jun 2024 14:18:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683538;
	bh=aiHRkJPqOrFFPVbjGrNX769v/TR445z2v6UGdcJyOIw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1Px7K2Qw3olcgxIvZm3KUYxu6Z6rqdEC6YaaYDGkY4ar4Zi0f4CW6upI+GWVvb3t9
	 NrwIdSLdWF2NP0NSRvUpbto0g8PYwgI+1OHD9gNcoMoyZlC9MeX6/f4pbtol5UW8aj
	 iucezY+gN7rz9BAt0Yp4cZC8uLMHyQnP47jpzvzI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ryosuke Yasuoka <ryasuoka@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 428/473] nfc: nci: Fix handling of zero-length payload packets in nci_rx_work()
Date: Thu,  6 Jun 2024 16:05:57 +0200
Message-ID: <20240606131713.904116813@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131659.786180261@linuxfoundation.org>
References: <20240606131659.786180261@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index e4933246cd3ad..6196bb512dfc1 100644
--- a/net/nfc/nci/core.c
+++ b/net/nfc/nci/core.c
@@ -1527,8 +1527,7 @@ static void nci_rx_work(struct work_struct *work)
 
 		if (!nci_valid_size(skb)) {
 			kfree_skb(skb);
-			kcov_remote_stop();
-			break;
+			continue;
 		}
 
 		/* Process frame */
-- 
2.43.0



