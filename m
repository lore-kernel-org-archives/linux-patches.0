Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 506FD222D77;
	Thu, 12 Dec 2024 16:18:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734020307; cv=none; b=jjaluL7hRCzhGNIRc3g9xxaqLgqfzN2o/qH2BdMWUevAe2+IBvVL2maOFjDnvfjHAeI1qwD04PyPqxfTi86Rlx8pOtxFmxnL+G6IVHU9RPNb8wUh2S9yU1o+QD6ckyZiOAKWOsyTRZMGe6pY4LCUPsx/SdFwHOD3xRJdkbQ903U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734020307; c=relaxed/simple;
	bh=PSkCgKzxusmctlZPddKH+LZeYB6YO/itmmeTNY5wRUw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IWylI9jEw+9sLUdV7Tjuvcya0YKKZswtIdWWBcSQxU/mb8sfxXJ1mZU+l+nLB75JSGKbWlw1MmE596ps2z8Q0i7olVEjUCsVDGHsOS7Gm9PhKRvqudrsC0SvbGHwzFan5lDrdK71JmeCDKwm0eajgZtMJDjcCRsR0N43Ac6Ekd0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dLuCi66k; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dLuCi66k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 899FDC4CECE;
	Thu, 12 Dec 2024 16:18:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734020307;
	bh=PSkCgKzxusmctlZPddKH+LZeYB6YO/itmmeTNY5wRUw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dLuCi66ktzi+PST7svwvKK4ulxk9AjV01bcK+DOxbNRsNq3B62n29x1hjcXQpQu6f
	 sQI3vzGelaf9ujpup0FC3fXmTBlZX6VFA3nI5B5kpX66c3YMvP1UyQzm85dqt9DIjo
	 gXe/J5dlaArB3hx3puQr/sekYYvBC3REybteVC6k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhihao Cheng <chengzhihao1@huawei.com>,
	Richard Weinberger <richard@nod.at>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 434/772] ubifs: Correct the total block count by deducting journal reservation
Date: Thu, 12 Dec 2024 15:56:19 +0100
Message-ID: <20241212144407.864553059@linuxfoundation.org>
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

From: Zhihao Cheng <chengzhihao1@huawei.com>

[ Upstream commit 84a2bee9c49769310efa19601157ef50a1df1267 ]

Since commit e874dcde1cbf ("ubifs: Reserve one leb for each journal
head while doing budget"), available space is calulated by deducting
reservation for all journal heads. However, the total block count (
which is only used by statfs) is not updated yet, which will cause
the wrong displaying for used space(total - available).
Fix it by deducting reservation for all journal heads from total
block count.

Fixes: e874dcde1cbf ("ubifs: Reserve one leb for each journal head while doing budget")
Signed-off-by: Zhihao Cheng <chengzhihao1@huawei.com>
Signed-off-by: Richard Weinberger <richard@nod.at>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ubifs/super.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/ubifs/super.c b/fs/ubifs/super.c
index 32cb147597960..d4c3948a7f863 100644
--- a/fs/ubifs/super.c
+++ b/fs/ubifs/super.c
@@ -777,10 +777,10 @@ static void init_constants_master(struct ubifs_info *c)
 	 * necessary to report something for the 'statfs()' call.
 	 *
 	 * Subtract the LEB reserved for GC, the LEB which is reserved for
-	 * deletions, minimum LEBs for the index, and assume only one journal
-	 * head is available.
+	 * deletions, minimum LEBs for the index, the LEBs which are reserved
+	 * for each journal head.
 	 */
-	tmp64 = c->main_lebs - 1 - 1 - MIN_INDEX_LEBS - c->jhead_cnt + 1;
+	tmp64 = c->main_lebs - 1 - 1 - MIN_INDEX_LEBS - c->jhead_cnt;
 	tmp64 *= (long long)c->leb_size - c->leb_overhead;
 	tmp64 = ubifs_reported_space(c, tmp64);
 	c->block_cnt = tmp64 >> UBIFS_BLOCK_SHIFT;
-- 
2.43.0



