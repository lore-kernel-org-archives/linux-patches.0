Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D876318EC7;
	Wed, 20 May 2026 16:52:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779295932; cv=none; b=utOpcvdHOOwa9tSyvwXMCQ4SJ1tx9MdrVkq6gxVNzha/AQ9ZORXyPkdqcMrWkqA78ZvTr8i5P5Ntym4q4jonKZvXgRtsTEaOo6iPYn9tRgzOEH4FuXAvstaZNMNx1ayOYr72ScIA5Kofg2iQxPNfydnLASBY76Qjxm40fCnu2bo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779295932; c=relaxed/simple;
	bh=E57E7eQjq6p5A/mBhsfBm+eVgAMXU/ugSleSArpCEr0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WcjbuTJ9g1VSEHbTCv2xrlIQnzThRz+lFyE1QRKr0ZbNwggr/3MoTS9buxfWOgX1u1DnkjrNPl5I3heyXj+hkKhRnv1AuSFKraGs2c++PgpPmzAwhbyF609IHqgbO/klGtroRs8Rnbn0xRIYBYigG8cZliQ/Q3rI8asCphPTNGw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UqFLwFc3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UqFLwFc3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D429D1F000E9;
	Wed, 20 May 2026 16:52:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779295931;
	bh=xaqbLAqkphwN4cFEsvBQrxX+IKo0oasSVEiGQBW2lLs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UqFLwFc3qv2bj5jcKewmOakzZ/xGLmIRRaFxneHSQn2hZiwddG2A2wMONAgF1rtzy
	 4srLL3y5qVtWHskhC+Sc17WW8DxG4yjnHQUQkiifRjc2EES6f93qB6ItLLsgSGL9gc
	 rJRs7OnVVyyxCoCQ9BesOewZaxVpO1PfjpJ2xKI8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sebastian Ene <sebastianene@google.com>,
	Sudeep Holla <sudeep.holla@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0567/1146] firmware: arm_ffa: Use the correct buffer size during RXTX_MAP
Date: Wed, 20 May 2026 18:13:37 +0200
Message-ID: <20260520162201.017227674@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sebastian Ene <sebastianene@google.com>

[ Upstream commit 83210251fd70d5f96bcdc8911e15f7411a6b2463 ]

Don't use the discovered buffer size from an FFA_FEATURES call directly
since we can run on a system that has the PAGE_SIZE larger than the
returned size which makes the alloc_pages_exact for the buffer to be
rounded up.

Fixes: 61824feae5c0 ("firmware: arm_ffa: Fetch the Rx/Tx buffer size using ffa_features()")
Signed-off-by: Sebastian Ene <sebastianene@google.com>
Link: https://patch.msgid.link/20260402113939.930221-1-sebastianene@google.com
Signed-off-by: Sudeep Holla <sudeep.holla@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/arm_ffa/driver.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/firmware/arm_ffa/driver.c b/drivers/firmware/arm_ffa/driver.c
index f2f94d4d533e8..eb27828482837 100644
--- a/drivers/firmware/arm_ffa/driver.c
+++ b/drivers/firmware/arm_ffa/driver.c
@@ -2078,7 +2078,7 @@ static int __init ffa_init(void)
 
 	ret = ffa_rxtx_map(virt_to_phys(drv_info->tx_buffer),
 			   virt_to_phys(drv_info->rx_buffer),
-			   rxtx_bufsz / FFA_PAGE_SIZE);
+			   PAGE_ALIGN(rxtx_bufsz) / FFA_PAGE_SIZE);
 	if (ret) {
 		pr_err("failed to register FFA RxTx buffers\n");
 		goto free_pages;
-- 
2.53.0



