Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 241C01EEA3E;
	Wed, 23 Apr 2025 15:19:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745421571; cv=none; b=S5ssPPDtY2ClFobOz2OWvF1A/4NrYp8VieUBYtrLRhfgldS6Hs6KGsZ9CwT1h9f0kSfjLMmJiEnHHW8LThCQiDmmyUIBuT0mKfWIeiw4LoMlDyHDPBNLYWAUa9af/dZjPAoiqIYhuBcc5GKep3PS7Y1J+MgqJP4keljGmtV2Wsk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745421571; c=relaxed/simple;
	bh=LQ+58w9d3+EVMBXIskyvrf0SlHDp9/k82pGtZKFOqrk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RRPUcIeC6iqlAWwE0EAJeMyEpCpRDbvE6SeUvApt2NWvQHZxji1UOSNyAyfKiHAO58sY37ivbblIRVteOqYdUU6mkGB3g5K0nhju5eFXhLMolqAXWd27g+eVrrOnvbSuLV3ZtTYDSXeCC4RIP1jXF3FK8ttIXE93WI7JLa9opoE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=u/qGN7b+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="u/qGN7b+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A314EC4CEE2;
	Wed, 23 Apr 2025 15:19:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745421571;
	bh=LQ+58w9d3+EVMBXIskyvrf0SlHDp9/k82pGtZKFOqrk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=u/qGN7b+QGb7mHyzC9xNAGFr5LyA8Z+ExnsEnMbzW28wiRv6C+hqy4m2BEz19BeD4
	 sdG91SNe/3IWoKaAOhwFu80ncNMoNI4XpWgzRK8UgrTNcYeaOaZ8bb0WsOW0I8z/jA
	 7F5LazwH2dXUpE5uZZFynzYwKqxHkwWUndC3MHdY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zijun Hu <quic_zijuhu@quicinc.com>,
	"Rob Herring (Arm)" <robh@kernel.org>
Subject: [PATCH 6.1 153/291] of/irq: Fix device node refcount leakages in of_irq_count()
Date: Wed, 23 Apr 2025 16:42:22 +0200
Message-ID: <20250423142630.645719125@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142624.409452181@linuxfoundation.org>
References: <20250423142624.409452181@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zijun Hu <quic_zijuhu@quicinc.com>

commit bbf71f44aaf241d853759a71de7e7ebcdb89be3d upstream.

of_irq_count() invokes of_irq_parse_one() to count IRQs, and successful
invocation of the later will get device node @irq.np refcount, but the
former does not put the refcount before next iteration invocation, hence
causes device node refcount leakages.

Fix by putting @irq.np refcount before the next iteration invocation.

Fixes: 3da5278727a8 ("of/irq: Rework of_irq_count()")
Cc: stable@vger.kernel.org
Signed-off-by: Zijun Hu <quic_zijuhu@quicinc.com>
Link: https://lore.kernel.org/r/20250209-of_irq_fix-v2-5-93e3a2659aa7@quicinc.com
Signed-off-by: Rob Herring (Arm) <robh@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/of/irq.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/of/irq.c
+++ b/drivers/of/irq.c
@@ -503,8 +503,10 @@ int of_irq_count(struct device_node *dev
 	struct of_phandle_args irq;
 	int nr = 0;
 
-	while (of_irq_parse_one(dev, nr, &irq) == 0)
+	while (of_irq_parse_one(dev, nr, &irq) == 0) {
+		of_node_put(irq.np);
 		nr++;
+	}
 
 	return nr;
 }


