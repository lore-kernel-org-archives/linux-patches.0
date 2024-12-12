Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 832D9216E3B;
	Thu, 12 Dec 2024 16:24:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734020664; cv=none; b=HhvjAbRHyAVlKKgdedM/8kSEgJK0QpDCFDZvP1b23XaQ9JKsbM/iaOsKqaOppPdzkAM3XU0bmq6AF/D7V99xe/d08VIRkvecL6Cy7JZ7XohIoo9GCMbaoVywxBx4U1omeF25wXXITO0yXq4VMmXkoioUOoYVnxPcI2RZne4y48g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734020664; c=relaxed/simple;
	bh=aQWegm5Y0DpLP/xmOv30Nbb2aXnhQZ180OLVS8v72bg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F912dofPCZHvE/fNTP7xm/2PPKC8C9nBRPeql5d0Xd5I6gOVL1jBG9qN2buNmZdEfxvXPjpf17udodvEqk1aYveSbS+HL/2uXXod53566dl/grTENjP7N8bQVJ30cnwDS4XZKup98yLcUbwvLVP3t/bBoNglGoX6J62EUvP8Vb0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RkToWMO5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RkToWMO5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCC6EC4CECE;
	Thu, 12 Dec 2024 16:24:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734020664;
	bh=aQWegm5Y0DpLP/xmOv30Nbb2aXnhQZ180OLVS8v72bg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RkToWMO5RJxpQgCvv+skvzADYRyVZJtJq1bx7KIxDc8kPZlgOexDcV5ZoApsj+NMV
	 k3hi1bkhaj6gEmxErfGx5AtgmOJCHadGwgULqHmvOaoxqQzRpnsin3bvsMNsExram3
	 woP8cA064FANDlcM64ug05/647Bhy6r7tqwK+HXw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ajay Kaher <ajay.kaher@broadcom.com>,
	Richard Cochran <richardcochran@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 528/772] ptp: Add error handling for adjfine callback in ptp_clock_adjtime
Date: Thu, 12 Dec 2024 15:57:53 +0100
Message-ID: <20241212144411.778055912@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
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

From: Ajay Kaher <ajay.kaher@broadcom.com>

[ Upstream commit 98337d7c87577ded71114f6976edb70a163e27bc ]

ptp_clock_adjtime sets ptp->dialed_frequency even when adjfine
callback returns an error. This causes subsequent reads to return
an incorrect value.

Fix this by adding error check before ptp->dialed_frequency is set.

Fixes: 39a8cbd9ca05 ("ptp: remember the adjusted frequency")
Signed-off-by: Ajay Kaher <ajay.kaher@broadcom.com>
Acked-by: Richard Cochran <richardcochran@gmail.com>
Link: https://patch.msgid.link/20241125105954.1509971-1-ajay.kaher@broadcom.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ptp/ptp_clock.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/ptp/ptp_clock.c b/drivers/ptp/ptp_clock.c
index 3c3e4fbefebaf..389599bd13bbe 100644
--- a/drivers/ptp/ptp_clock.c
+++ b/drivers/ptp/ptp_clock.c
@@ -136,7 +136,8 @@ static int ptp_clock_adjtime(struct posix_clock *pc, struct __kernel_timex *tx)
 			err = ops->adjfine(ops, tx->freq);
 		else
 			err = ops->adjfreq(ops, ppb);
-		ptp->dialed_frequency = tx->freq;
+		if (!err)
+			ptp->dialed_frequency = tx->freq;
 	} else if (tx->modes & ADJ_OFFSET) {
 		if (ops->adjphase) {
 			s32 offset = tx->offset;
-- 
2.43.0



