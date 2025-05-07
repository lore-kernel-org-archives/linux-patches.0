Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12AFA2116E9;
	Wed,  7 May 2025 18:55:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746644110; cv=none; b=SG6en32t33UT7uV0iGenekxjCsB3eVkMIEphkCQpnFvxl6693Y/k5OuVMfy1hEowAlGQd82tJvQjF5tZ/xZbO1Ez61wcm5KhTGmZ9nUnvKtYwpCNLI96rhQFSH/YpmHjMyGmETLBVEZqgc5wZzFQuidL2oztq9aZrmtjLCNky8k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746644110; c=relaxed/simple;
	bh=hNzQ9dUvU14472P2YmL2BCKZSvIBkEs7HACpWQ3CHaQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qLsDCoeOYryU2BI6oyktMPhnpFpY5xbWepLf1CgfoJgoxSxvj2OodBjfPYny9b1xqFw0jKGAn1dLMm0MaunA/+1/7u+StrM2L3C9j6g6NWAOIMwr/z90jfeZSXinLYQMbS6IxWEHa1y2/ObTdOS4rSmNQYS0d6NNpbZrgcQDh4U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=v64zKon0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v64zKon0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99D60C4CEE2;
	Wed,  7 May 2025 18:55:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1746644109;
	bh=hNzQ9dUvU14472P2YmL2BCKZSvIBkEs7HACpWQ3CHaQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=v64zKon0TcVS3faLCy6YweJq+ZrlIjLW/zx4wjuPPYWI5/jwPgsuAALl269UpLBDc
	 n0v9tsxQ1NilhMr1ypXCzctjFJEYpnG3R/CWBYYkw03vcbXqadCmVocAglOZQ0f1ua
	 +F59nTJukDKxe0zNLJ0ATgvy4FLPSb3VwnnCFQDc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kalesh AP <kalesh-anakkur.purayil@broadcom.com>,
	Pavan Chebbi <pavan.chebbi@broadcom.com>,
	Somnath Kotur <somnath.kotur@broadcom.com>,
	Michael Chan <michael.chan@broadcom.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 123/183] bnxt_en: Add missing skb_mark_for_recycle() in bnxt_rx_vlan()
Date: Wed,  7 May 2025 20:39:28 +0200
Message-ID: <20250507183829.804981829@linuxfoundation.org>
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

From: Somnath Kotur <somnath.kotur@broadcom.com>

[ Upstream commit a63db07e4ecd45b027718168faf7d798bb47bf58 ]

If bnxt_rx_vlan() fails because the VLAN protocol ID is invalid,
the SKB is freed but we're missing the call to recycle it.  This
may cause the warning:

"page_pool_release_retry() stalled pool shutdown"

Add the missing skb_mark_for_recycle() in bnxt_rx_vlan().

Fixes: 86b05508f775 ("bnxt_en: Use the unified RX page pool buffers for XDP and non-XDP")
Reviewed-by: Kalesh AP <kalesh-anakkur.purayil@broadcom.com>
Reviewed-by: Pavan Chebbi <pavan.chebbi@broadcom.com>
Signed-off-by: Somnath Kotur <somnath.kotur@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index da837866c02f8..174bb33432d13 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -2011,6 +2011,7 @@ static struct sk_buff *bnxt_rx_vlan(struct sk_buff *skb, u8 cmp_type,
 	}
 	return skb;
 vlan_err:
+	skb_mark_for_recycle(skb);
 	dev_kfree_skb(skb);
 	return NULL;
 }
-- 
2.39.5



