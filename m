Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C782A4BAA4;
	Tue, 23 Jan 2024 00:45:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705970721; cv=none; b=CYJbkm8W8eO5zAkd4YF3TTBYMvqcawNdhzTu9OBkwkclc58DI8py1ca/AzQDMuAhuI6LcJO2XjKtJgAcEI3Vi7Dddk573naKJbUYbMu/7L/TrPVolZC1Oc4wEkfdSQ2eT1isZq75og8ePgcxPJuI7LI0ukT/UzX7nz/e2j+tgjI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705970721; c=relaxed/simple;
	bh=hWCwhLuDwvdkMMhZVTee+bSk9JgH9Sd5v0jCnpgvZ/w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cda1ejOUQpSP4sXGBWdui4b32eFZvxs88IgDhB0YivnJgjDolw0xSPoY4iv9TZ9Fvtn/iS7c4Fk8lNeow8VBODu2j5XyAHuqIyOtR3tOSwkTC29ItYFV2Xw8algiIXGpBRUXHWY2me8bd2FWS9OWa0SWXEJoQv+TqNuiP2icGYo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WOcIBBK4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WOcIBBK4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61140C433C7;
	Tue, 23 Jan 2024 00:45:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705970721;
	bh=hWCwhLuDwvdkMMhZVTee+bSk9JgH9Sd5v0jCnpgvZ/w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WOcIBBK4HjPQHs2AOgqqdyuwTVvgW78lUy55uHE0IzIhsA1LZn2JUVZdxPfyZzDfe
	 XFxjELE1dxT3KH3FXG0T9aBmn/v/8olLDendy6lcKT3Y3e+lXE0ZLBa7IpJKrQXOXH
	 s957lD6UpwOHiPJw/IJ0y7Cdei1eXly/J1eZLywc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Artem Chernyshev <artem.chernyshev@red-soft.ru>,
	Karan Tilak Kumar <kartilak@cisco.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 099/417] scsi: fnic: Return error if vmalloc() failed
Date: Mon, 22 Jan 2024 15:54:27 -0800
Message-ID: <20240122235755.123605519@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235751.480367507@linuxfoundation.org>
References: <20240122235751.480367507@linuxfoundation.org>
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
index 6fedc3b7d1ab..eb895a65ea8f 100644
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



