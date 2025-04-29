Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F61C21883E;
	Tue, 29 Apr 2025 17:14:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745946860; cv=none; b=g5Yqei4HcrEXmkJHeC0KASzG305E+9+PkmAHbszZK5DdRbwqEwUjqvpHCNzBHzGulj3g3plx6Rb2FFgwqA0ldziKgWChNzP2yeTgbFvjtm9m+WFwfA4RSY8xRSpRgbJ921OjRDnXtPewPXbJbahYWkPuCV9wyrxQpq+ZXHIDeR8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745946860; c=relaxed/simple;
	bh=yDlJv2bsZ75TXkLTlUFdcTHoB5QZ2b7u7FS/oY4BXso=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t0JDR2jGsMKFXaVIrgst/fiEM5oSq3fXYmB9vRypPxNrhvQqV/WbibZAnvfFc4LNB/cDvOT7rTeDZHYiN5J0QBHuU5pJ0logUmRkFHnczJ6UQBu9E5qVW5aCJCDEdNG6N2A6GiGXcG1FW+yBgU5cu8dFq4ibdn7mkwO07oXqAek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VSxQSD+u; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VSxQSD+u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5693C4CEE3;
	Tue, 29 Apr 2025 17:14:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745946860;
	bh=yDlJv2bsZ75TXkLTlUFdcTHoB5QZ2b7u7FS/oY4BXso=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VSxQSD+utDxFGqinaTB3Jki4Xd/CxGMP/4iHWD6MPuJJJkX4Rcl9SsZ7+DZ3JguRb
	 Pcz3KOCXd7UBr5yeqBrrbx4m6tleIFhjpiJArLNoJf0H1v9UFzMg2q5/wqoFk76Q1D
	 Z2ain0aHJOQE3WcU5TMbR3VkZFCVj8aSiTAU/vY4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zijun Hu <quic_zijuhu@quicinc.com>,
	"Rob Herring (Arm)" <robh@kernel.org>
Subject: [PATCH 5.10 092/286] of/irq: Fix device node refcount leakages in of_irq_count()
Date: Tue, 29 Apr 2025 18:39:56 +0200
Message-ID: <20250429161111.639731065@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161107.848008295@linuxfoundation.org>
References: <20250429161107.848008295@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -443,8 +443,10 @@ int of_irq_count(struct device_node *dev
 	struct of_phandle_args irq;
 	int nr = 0;
 
-	while (of_irq_parse_one(dev, nr, &irq) == 0)
+	while (of_irq_parse_one(dev, nr, &irq) == 0) {
+		of_node_put(irq.np);
 		nr++;
+	}
 
 	return nr;
 }


