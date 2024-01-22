Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FF4B13398C;
	Tue, 23 Jan 2024 00:21:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969302; cv=none; b=K+vrVqeuA4SjBQ08wWYOHWf9VHkEw48P2FDasSvYf96YlENVz3f0FasA6PzUyikylZrpqGGzgb2xpbJccM5VzViRFHbAZov8vSgYYNHsG+w2hIHLHxeI4ElgWzfdlSw+XVwgcsQ9ZogcM4jSuq+DMjd0NbnqpLUxuzAOIoOQw8k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969302; c=relaxed/simple;
	bh=rfEkE1D5ElLO5bG0VJGZ0dSh71pvxXN+rvAIq/IMToc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M/+RwzEfP/76aLWAl4xX+DXPsRsv81SdsfxNZBepy+lz7iqiwmfhq6KAj4zz1z9bMjKw/j/bnALalgCRjfeQzzxlKDqZsPsPOK5AvxVTk5kQiKm5woKQeOa1iutiOhCnYzySG8zNEd08dNxShejQU3+l+dP1JbubbLVAt9i7tjI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ylmHJP9t; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ylmHJP9t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36AF6C433F1;
	Tue, 23 Jan 2024 00:21:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969302;
	bh=rfEkE1D5ElLO5bG0VJGZ0dSh71pvxXN+rvAIq/IMToc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ylmHJP9tdwc6jA3PONHV6wKy8SQjaVxp0zXStFXa+nlaxW/Xn+3XE6mqvTmb2R/Mb
	 6k18J+9G76H1PhH+Fv0tZ3pwLBqx1380yzJRniJrWFH3xWh6HDK+KrtlJt/fhb3oiz
	 sBxZ6xZelv5ujiCUgEFNV3ko9s+sNWHKGspau4w0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Artem Chernyshev <artem.chernyshev@red-soft.ru>,
	Karan Tilak Kumar <kartilak@cisco.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 135/641] scsi: fnic: Return error if vmalloc() failed
Date: Mon, 22 Jan 2024 15:50:39 -0800
Message-ID: <20240122235822.275576228@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
References: <20240122235818.091081209@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

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



