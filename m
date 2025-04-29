Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D754C148;
	Tue, 29 Apr 2025 17:46:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745948778; cv=none; b=ZbZMjsCDl0tFGkZ/KBkO8hSmjF5+BWKYQVvG7oGlBOmTOc9/lajgPFcbIWXUN1zQSleUebGUhHStpT+K4frmzdjJDRwBr2nTwlTLJQTNkdKGa8hkGcSAlZgHOLnrQh02IYIu6NFG7MFyNsyPhonm5X/YxemLabpKPUxJQzGCFpw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745948778; c=relaxed/simple;
	bh=hn2TWJkQ8UI6hDMFWSL1bZCJx0tnRd+tNpegwCB03lU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fo14QZicJrdudFVIHwuCYF4C6TOCBjfEIUIipYWQT1bzTsW0gQ/efxLRtTI8y7OjQy9cCp3BxSYqkz7Rr3YX9RBDAOSE+njy8FBUYew05JIdcosirxSPMNdzWlksDp6iroMENkp5vKV2JT2rgUJrfmeeAzFcJoMG2C1dXqcWITU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=inwn/BcP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="inwn/BcP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31AAAC4CEE9;
	Tue, 29 Apr 2025 17:46:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745948778;
	bh=hn2TWJkQ8UI6hDMFWSL1bZCJx0tnRd+tNpegwCB03lU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=inwn/BcPyYRaZY+c2+81mMrvfXBsasYpERtpLqklK3aBbfqfe2vT9+xJUmm3/MW9y
	 cz9tkeKOp87sp/IUIrsCy9rJf0ogBF3SSfB88ybD132QrS/YvPGyQegK03rzr4sZe2
	 UReUPAVZ5ydn6T52Dno+GPBvWTpKu4nh0FcEEmYU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zijun Hu <quic_zijuhu@quicinc.com>,
	"Rob Herring (Arm)" <robh@kernel.org>
Subject: [PATCH 5.15 109/373] of/irq: Fix device node refcount leakages in of_irq_count()
Date: Tue, 29 Apr 2025 18:39:46 +0200
Message-ID: <20250429161127.656120046@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161123.119104857@linuxfoundation.org>
References: <20250429161123.119104857@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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


