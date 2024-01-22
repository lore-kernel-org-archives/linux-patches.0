Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 253233984D;
	Tue, 23 Jan 2024 01:40:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705974039; cv=none; b=D+c4momeqks5Mkxh53pyFY3+hsn1WjptCDM0R1lbkAnLWSy47BLjbhjZMU4q8WN61FWuEh7R4VJAuvx3xl4KflPXurgBc3OYXNB7tflc5wGKH/lwcxnoL1A+YGPQkPiHmQTbDloyD08KpyIXouzToujm211IdJO55ekFcEmmXP8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705974039; c=relaxed/simple;
	bh=YzPTa1W9Tyn49Ia5t5aoDa3nT5zIa1EzSKMU+psOVKE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ys3mMX2/VJ8NhSK+0CPBoc6s0EcwR8Uk6tTzK1xSYixK7zM3z8W/wgzo7pjrFOjMRUVFjeuETID15NfZrCYV2uL4Rg9Jgvj4t2h7h0+aNzcLbyalt1LUDJR1v09tX3LluxuieiNnUFdo2ldafMxnTWT9XiHX9itcsuMuOqmsENg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1U9jArV9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1U9jArV9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90550C43390;
	Tue, 23 Jan 2024 01:40:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705974038;
	bh=YzPTa1W9Tyn49Ia5t5aoDa3nT5zIa1EzSKMU+psOVKE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1U9jArV9G8EZzf+vvyAXlKWK+Yhg8aCcSRkod2KltAsF5vvCwRe5lCOgap61ei7oI
	 Yc/irD8LbSW94XMWkOEkDWXKVxC61iXDMKu7EDt5VUIlSCiJPMOpYX/nKkAPtH+xpl
	 q7IVEneH7QPaTvrSaMOqkGJxcH4IP5JKSkT8TOuk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Artem Chernyshev <artem.chernyshev@red-soft.ru>,
	Karan Tilak Kumar <kartilak@cisco.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 136/374] scsi: fnic: Return error if vmalloc() failed
Date: Mon, 22 Jan 2024 15:56:32 -0800
Message-ID: <20240122235749.373479989@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235744.598274724@linuxfoundation.org>
References: <20240122235744.598274724@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Artem Chernyshev <artem.chernyshev@red-soft.ru>

[ Upstream commit f5f27a332a14f43463aa0075efa3a0c662c0f4a8 ]

In fnic_init_module() exists redundant check for return value from
fnic_debugfs_init(), because at moment it only can return zero. It make
sense to process theoretical vmalloc() failure.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Fixes: 9730ddfb123d ("scsi: fnic: remove redundant assignment of variable rc")
Signed-off-by: Artem Chernyshev <artem.chernyshev@red-soft.ru>
Link: https://lore.kernel.org/r/20231128111008.2280507-1-artem.chernyshev@red-soft.ru
Reviewed-by: Karan Tilak Kumar <kartilak@cisco.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/fnic/fnic_debugfs.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/fnic/fnic_debugfs.c b/drivers/scsi/fnic/fnic_debugfs.c
index e7326505cabb..f611e9f00a9d 100644
--- a/drivers/scsi/fnic/fnic_debugfs.c
+++ b/drivers/scsi/fnic/fnic_debugfs.c
@@ -66,9 +66,10 @@ int fnic_debugfs_init(void)
 		fc_trc_flag->fnic_trace = 2;
 		fc_trc_flag->fc_trace = 3;
 		fc_trc_flag->fc_clear = 4;
+		return 0;
 	}
 
-	return 0;
+	return -ENOMEM;
 }
 
 /*
-- 
2.43.0



