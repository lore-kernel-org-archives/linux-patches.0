Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3088660268;
	Tue, 23 Jan 2024 01:51:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705974686; cv=none; b=IsS0gBhBtKbtwlTA+AW14wSFg5DofYjUMIDrEFo5p3bb4NiDFHNrGOHHmB8VYjzb6RA7K0V0Jd9Ij702qzj1J0I5DIgeEbRY1UoJ7Z+5npYHifEN1oYmUr/UO3fv8kZ/IDdc4ZjAr282j2ax19EvZp//TMCasYZxGbYxmwvwl7s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705974686; c=relaxed/simple;
	bh=ECZpO4FV5Ds4PPDAegsz8K2ScNxhvP+E47kWBH38IkU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UaCO1aLvij4EvypDKSYduG1AOzA4cY0kOEumacmnMtJZzHL87CjROWCzLjqAPg82AFwj0NDBEXpwmvYQxIMkPWAtT+paUlT3rPDNawaVYsAAf+5pzWCDtsnNipPqN03xnMYqy6d5tAdLfKuRi4SF6iRl5quVBxcCjIl3zfxDrVU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eCE2Uc6Z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eCE2Uc6Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F2D4C433F1;
	Tue, 23 Jan 2024 01:51:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705974685;
	bh=ECZpO4FV5Ds4PPDAegsz8K2ScNxhvP+E47kWBH38IkU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eCE2Uc6ZsXjDNQZ3DQya0hp1xjlw/HLI1cYjDaXrp/e820iqVF66dAI1Gy+DHJf9L
	 NW8ruAx8aIPRVcssUxk56b5Ooo0vRoYH0r5gSHE58jO2hk6rcNw6EkBOM2anMrcNeM
	 8sfWFb5i9uSCHwA6ZtFzWIydIlfvZqQyy4os610Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Artem Chernyshev <artem.chernyshev@red-soft.ru>,
	Karan Tilak Kumar <kartilak@cisco.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 123/583] scsi: fnic: Return error if vmalloc() failed
Date: Mon, 22 Jan 2024 15:52:54 -0800
Message-ID: <20240122235815.902129864@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235812.238724226@linuxfoundation.org>
References: <20240122235812.238724226@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index c4d9ed0d7d75..2619a2d4f5f1 100644
--- a/drivers/scsi/fnic/fnic_debugfs.c
+++ b/drivers/scsi/fnic/fnic_debugfs.c
@@ -52,9 +52,10 @@ int fnic_debugfs_init(void)
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



