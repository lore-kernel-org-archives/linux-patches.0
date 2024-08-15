Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67ECC3214;
	Thu, 15 Aug 2024 14:36:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723732584; cv=none; b=d2kzXb9nkLYO/hZ1MaPoOuus+ePmcvctRErWuHVcGW6MJIqejDBnWOOgmP7O0L2sZCPbDLZGSqyGfkTSm1HdwTw2/MldTfg/2YuJmjOR8GeSIK0aWsvE7PslWvY3rB0KX5B1gpcW3Qc7qIee83ppuHev36loQ9I8E0T/7Jj85E4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723732584; c=relaxed/simple;
	bh=h+QKlYPVM65Mg1A9nLZo+AtBE9lOcJVCcENOfslbWYM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IrLPLrJUbmCQnbeof2pTipNhxFAmqc1F14kqdf/e2aVUyTk4sx9Frxspy3cy9pO63kE3YjKscEekFiNtYD0j7YyOCzX1yc0gyZ7dBiDlZrwvr5nVG648SfIJVNJZaGFQVpx3dTEC4j0MqkFHkvzi80Tlgol6PHhHMX8JBZgb48g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vqZ2gGyg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vqZ2gGyg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9F9AC32786;
	Thu, 15 Aug 2024 14:36:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723732584;
	bh=h+QKlYPVM65Mg1A9nLZo+AtBE9lOcJVCcENOfslbWYM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vqZ2gGyg1jOdbmRZDrG64NXuoA9tjvfG85uBBHC+joA4+SxugXKDvPwPVDEn4QuMi
	 NYFy0eEcLQWkbXNpPWMSz2AoJN5AOuQLn16UsxLKddFFZ8Wj+fDQz8cdlWJTl2lF7Q
	 KqH7J8Y0ACagsNi/1RCFCmDwbUxI6OSfeK6+zg28=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zijun Hu <quic_zijuhu@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 225/352] devres: Fix memory leakage caused by driver API devm_free_percpu()
Date: Thu, 15 Aug 2024 15:24:51 +0200
Message-ID: <20240815131928.129036963@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131919.196120297@linuxfoundation.org>
References: <20240815131919.196120297@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zijun Hu <quic_zijuhu@quicinc.com>

[ Upstream commit bd50a974097bb82d52a458bd3ee39fb723129a0c ]

It will cause memory leakage when use driver API devm_free_percpu()
to free memory allocated by devm_alloc_percpu(), fixed by using
devres_release() instead of devres_destroy() within devm_free_percpu().

Fixes: ff86aae3b411 ("devres: add devm_alloc_percpu()")
Cc: stable@vger.kernel.org
Signed-off-by: Zijun Hu <quic_zijuhu@quicinc.com>
Link: https://lore.kernel.org/r/1719931914-19035-3-git-send-email-quic_zijuhu@quicinc.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/base/devres.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/base/devres.c b/drivers/base/devres.c
index a1508eeb8ebd1..8a74008c13c44 100644
--- a/drivers/base/devres.c
+++ b/drivers/base/devres.c
@@ -1230,7 +1230,11 @@ EXPORT_SYMBOL_GPL(__devm_alloc_percpu);
  */
 void devm_free_percpu(struct device *dev, void __percpu *pdata)
 {
-	WARN_ON(devres_destroy(dev, devm_percpu_release, devm_percpu_match,
+	/*
+	 * Use devres_release() to prevent memory leakage as
+	 * devm_free_pages() does.
+	 */
+	WARN_ON(devres_release(dev, devm_percpu_release, devm_percpu_match,
 			       (__force void *)pdata));
 }
 EXPORT_SYMBOL_GPL(devm_free_percpu);
-- 
2.43.0



