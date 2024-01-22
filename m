Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 990EF627F3;
	Tue, 23 Jan 2024 00:54:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705971267; cv=none; b=BQKJ6TUK6a6DVzmpD28Bj4ftG1geMfUdliD3v4ECOhhDGLD29FUGaEjzYT7OQ72eGbtjTJFLgLMdP8NV3nxUI2gd3l04yRONe7vJQDBEhJg2m7F/5J+68l2VKgFRPs34vK/iG3WWDzZ9/34ZFITS9yrGpYN0kdn2PoEoCsuSoxY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705971267; c=relaxed/simple;
	bh=WPLQ98KP8e4+NcfMjIsnztcUj01n2IAt9j4sYH9+6v0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=exhVHiQVIylTEvorLD/bqyOD1qTYZ/f68G8wt8/jfS2etGki4jSlQVMgTi89dCorNHSz+YqfrLxkMlHEGpNPx2Bb8v0n3kxVU8S05MC0Uc1saaKeVRVl+MQwYa88Q0/8x3Jn8hHcZQjMBqDqQii+sEu8tOBBEq2XIGL0Dod31o8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nc4xY4pm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nc4xY4pm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A71C5C433F1;
	Tue, 23 Jan 2024 00:54:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705971267;
	bh=WPLQ98KP8e4+NcfMjIsnztcUj01n2IAt9j4sYH9+6v0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nc4xY4pmzigsk9NzUGc7lLecspqjpoLpCvBqJovNyeRizMHCXZTmPR0/1iXPx99DA
	 Op/f5daKXBltgmvUsvKBsP2ySSArIB4p9gwfcZFthKs9kITcq0J+iesTOzxqeU92I4
	 B4GGKoDDT44pLkaqxvPg1FNWwlwGhBwKRcl4+Io8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Artem Chernyshev <artem.chernyshev@red-soft.ru>,
	Karan Tilak Kumar <kartilak@cisco.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 121/286] scsi: fnic: Return error if vmalloc() failed
Date: Mon, 22 Jan 2024 15:57:07 -0800
Message-ID: <20240122235736.796850784@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235732.009174833@linuxfoundation.org>
References: <20240122235732.009174833@linuxfoundation.org>
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
index 6c049360f136..56d52efc7314 100644
--- a/drivers/scsi/fnic/fnic_debugfs.c
+++ b/drivers/scsi/fnic/fnic_debugfs.c
@@ -67,9 +67,10 @@ int fnic_debugfs_init(void)
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



