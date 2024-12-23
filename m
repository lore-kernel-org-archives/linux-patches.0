Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4998412C544;
	Mon, 23 Dec 2024 16:16:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734970590; cv=none; b=AJIcsMaQV8g6QlqqwXh4/A8zevuvaI8e7zGo3UCCaRa1QhOBWvFDYw18R+wES3GNKZxTpKnYBFgb5bCUGg3gGmvTT302q0+6zxTnMN7JQr+OJqT6IOde1xUCyHpOV/yO9y4GiAGvhqOZSse8VWsU9rHkxfeLtMJbVdRtT7y0MnQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734970590; c=relaxed/simple;
	bh=m7Ji/F3kZODuJRynJRVsgp9UyTaZY+q7488w0/jSk6U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=r2fRqq25U2zkzvBCiGxNdET9mUTQDgmzOZ/s/yjZywySzW/VAT4xPw0Fo8H61TMvdaHgW8DGps3PAaTLQiQ7sgBMoEABANlNQZX1SjVbxA4F6cutcWy8ALAUERyb3GQGvaKcWTnDbK7Pcs/JYTCOOWxyK8jgl35QbCUeOY3gDuk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wJ+gZlKe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wJ+gZlKe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABA92C4CED3;
	Mon, 23 Dec 2024 16:16:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734970590;
	bh=m7Ji/F3kZODuJRynJRVsgp9UyTaZY+q7488w0/jSk6U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wJ+gZlKe43c+zF5o4/k49tmaWmQdQSjLSWKmxiUWRT/noQKblfOKJYvZ49Xx4IJ2i
	 eEAip/8Uw8oW8ODYMG22SsSlm5MDEQxPkISPoyX/piLTLH1XrKNmGrhjCUf0WOQ0bn
	 6RPwIWeV1LX/bRh2jkPXd2AJd5EPt067TCkbq+ZY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 11/83] PCI: Introduce pci_resource_n()
Date: Mon, 23 Dec 2024 16:58:50 +0100
Message-ID: <20241223155354.072348941@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241223155353.641267612@linuxfoundation.org>
References: <20241223155353.641267612@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit 144d204df78e40e6250201e71ef7d0e42d2a13fc ]

Introduce pci_resource_n() and replace open-coded implementations of it
in pci.h.

Link: https://lore.kernel.org/r/20230330162434.35055-3-andriy.shevchenko@linux.intel.com
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Stable-dep-of: 360c400d0f56 ("p2sb: Do not scan and remove the P2SB device when it is unhidden")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/pci.h | 15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff --git a/include/linux/pci.h b/include/linux/pci.h
index 9e58e5400d78..28f91982402a 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -1996,14 +1996,13 @@ int pci_iobar_pfn(struct pci_dev *pdev, int bar, struct vm_area_struct *vma);
  * These helpers provide future and backwards compatibility
  * for accessing popular PCI BAR info
  */
-#define pci_resource_start(dev, bar)	((dev)->resource[(bar)].start)
-#define pci_resource_end(dev, bar)	((dev)->resource[(bar)].end)
-#define pci_resource_flags(dev, bar)	((dev)->resource[(bar)].flags)
-#define pci_resource_len(dev,bar) \
-	((pci_resource_end((dev), (bar)) == 0) ? 0 :	\
-							\
-	 (pci_resource_end((dev), (bar)) -		\
-	  pci_resource_start((dev), (bar)) + 1))
+#define pci_resource_n(dev, bar)	(&(dev)->resource[(bar)])
+#define pci_resource_start(dev, bar)	(pci_resource_n(dev, bar)->start)
+#define pci_resource_end(dev, bar)	(pci_resource_n(dev, bar)->end)
+#define pci_resource_flags(dev, bar)	(pci_resource_n(dev, bar)->flags)
+#define pci_resource_len(dev,bar)					\
+	(pci_resource_end((dev), (bar)) ? 				\
+	 resource_size(pci_resource_n((dev), (bar))) : 0)
 
 /*
  * Similar to the helpers above, these manipulate per-pci_dev
-- 
2.39.5



