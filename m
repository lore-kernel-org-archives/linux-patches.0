Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABD9734C124;
	Fri, 31 Oct 2025 14:06:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761919608; cv=none; b=ehQIuWANre0SVfthLPTzLiLrwCRJW+HUahQPeI2+LUPyc+e8oOX9cf0058rr8P3/Q37KShEnAUBT+TtBcyZrQzqO4FvbYe+vsIeqyjUDeUuGjP+3o7FnK8cLBwB94qBwZaXNhNaD3JUq4pNtrqaoCHeD+zXHsOfsIG6XqgabtXM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761919608; c=relaxed/simple;
	bh=lDkmpmRVXTo9zPR7XC7tK+fRSLPd5vEQOQz/pr0NSSo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JPx/zdC7frQvC0dY/hU2rFZPyRGKTQ3WPqKpFAa8TbKJrh/wxKbDNAISMHfP5u2F09pSFVk7FcdLT2hIHrEaz0rXInTRHB606G4K039PIKdgCPair4uUK7rR0HdRjsC1QaHtw+ePvJGviuglVjO5qAQMoYfQGI4G5I6aCXboR6M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Z5Y5CZyA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z5Y5CZyA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BAD8C4CEE7;
	Fri, 31 Oct 2025 14:06:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761919608;
	bh=lDkmpmRVXTo9zPR7XC7tK+fRSLPd5vEQOQz/pr0NSSo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Z5Y5CZyA+ImRw3skV/Iys8iEfsJXJwGxEe/zHq42Qet0LRy9EKCtLDwd/gYG/EWoV
	 8sU6ALMuu+cmsKgUPvzTU3Y57xJFyHVVN+YFFLkPYBhslg1uVbgr69XeBa9sU8kRON
	 kgDjb7lcT4jIATpv47mC6HqXAXl4kgTSYYriBDjw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 08/35] genirq/manage: Add buslock back in to __disable_irq_nosync()
Date: Fri, 31 Oct 2025 15:01:16 +0100
Message-ID: <20251031140043.760415689@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251031140043.564670400@linuxfoundation.org>
References: <20251031140043.564670400@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Charles Keepax <ckeepax@opensource.cirrus.com>

[ Upstream commit 56363e25f79fe83e63039c5595b8cd9814173d37 ]

The locking was changed from a buslock to a plain lock, but the patch
description states there was no functional change. Assuming this was
accidental so reverting to using the buslock.

Fixes: 1b7444446724 ("genirq/manage: Rework __disable_irq_nosync()")
Signed-off-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Link: https://patch.msgid.link/20251023154901.1333755-3-ckeepax@opensource.cirrus.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/irq/manage.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index c94837382037e..7d68fb5dc2428 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -659,7 +659,7 @@ void __disable_irq(struct irq_desc *desc)
 
 static int __disable_irq_nosync(unsigned int irq)
 {
-	scoped_irqdesc_get_and_lock(irq, IRQ_GET_DESC_CHECK_GLOBAL) {
+	scoped_irqdesc_get_and_buslock(irq, IRQ_GET_DESC_CHECK_GLOBAL) {
 		__disable_irq(scoped_irqdesc);
 		return 0;
 	}
-- 
2.51.0



