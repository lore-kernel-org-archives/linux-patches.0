Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C46083D75D3;
	Wed, 20 May 2026 17:40:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779298841; cv=none; b=GFeAuM9nd4JTI+5qeiJOm92XURuO2As4KHj1bMwc+bOBFqKXyRdCWpraTZ5meActzXeOHJZ1DY9JKWG8Z7f60m8f49Vzcwkn9Ypsp5pcW0bAuTkJo6m0hfwpfq8LkYkmvTLkcabAaxPX7g+qiOvgSR1mY/PYkeVggGcXs1b1nRM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779298841; c=relaxed/simple;
	bh=KZYSBstMKhA87VyYdWa+V/dFL0GGldR7Ys1jBLMQeCg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PFJbg1S5aUKg0Ul1d/UPvSBLCvz8xxqSkloXmWT6d2NEkfuXhD6tkWRhL3cFTVm+KxKNfZUIP4zhvdJQgD9Zs3+0O+lWv7Mg4mrCzGBALHWxA5voxz73yzj/WeNhbjL7WVXVN2ydnQFmx6HXFFrSDwnq2YnhEr844hYvULHypOs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wwTi8hWw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wwTi8hWw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3488C1F000E9;
	Wed, 20 May 2026 17:40:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779298840;
	bh=qrVr00rXn/bHc4i6bFV1uhNZR2pCNN2rrHWkqHJYzNQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wwTi8hWwPuq6j8NbrDnztxM+hPXzX1D94aGGUAkUSLyV9w4Mip/IRfxvJvETWZ9BR
	 yoYR2H2Gqv3ZZhxgiknW/w1TKXXTTZDFAm3HdWwYFMyKP0S2uQYk7/JOURV7E5Ddxv
	 AW4UJ9cJr4qkH8GMaCtvIkFw6U1AwhLNiG5PRGh0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuhao Jiang <danisjiang@gmail.com>,
	Junrui Luo <moonafterrain@outlook.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 563/957] scsi: target: core: Fix integer overflow in UNMAP bounds check
Date: Wed, 20 May 2026 18:17:26 +0200
Message-ID: <20260520162146.740230142@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Junrui Luo <moonafterrain@outlook.com>

[ Upstream commit 2bf2d65f76697820dbc4227d13866293576dd90a ]

sbc_execute_unmap() checks LBA + range does not exceed the device capacity,
but does not guard against LBA + range wrapping around on 64-bit overflow.

Add an overflow check matching the pattern already used for WRITE_SAME in
the same file.

Fixes: 86d7182985d2 ("target: Add sbc_execute_unmap() helper")
Reported-by: Yuhao Jiang <danisjiang@gmail.com>
Signed-off-by: Junrui Luo <moonafterrain@outlook.com>
Link: https://patch.msgid.link/SYBPR01MB7881593C61AD52C69FBDB0BDAF7CA@SYBPR01MB7881.ausprd01.prod.outlook.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/target/target_core_sbc.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/target/target_core_sbc.c b/drivers/target/target_core_sbc.c
index fe8beb7dbab12..4c828a3ac18c7 100644
--- a/drivers/target/target_core_sbc.c
+++ b/drivers/target/target_core_sbc.c
@@ -1136,7 +1136,8 @@ sbc_execute_unmap(struct se_cmd *cmd)
 			goto err;
 		}
 
-		if (lba + range > dev->transport->get_blocks(dev) + 1) {
+		if (lba + range < lba ||
+		    lba + range > dev->transport->get_blocks(dev) + 1) {
 			ret = TCM_ADDRESS_OUT_OF_RANGE;
 			goto err;
 		}
-- 
2.53.0



