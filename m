Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B7E51BE23E;
	Wed, 19 Feb 2025 08:34:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739954078; cv=none; b=biSdsPAbH0iwu1cQo9ZhTQK6CQLxwD99Q6dd7dYLAtjw9MpWmgUD34wqr60kJeOfeSy7migz4gWSeFxDKqFSCOIfNv5a+qAfNJ//T0ImxkdcqhCKMkXegaL/jrBOxZ/mDzPaZkVViGEUVv+PnhTo/hWTgYu22kCoctziWOGomcw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739954078; c=relaxed/simple;
	bh=YBVqgzpbnIAlypPbqZcDHmJwE7wxJ19SR2nW6XiOaaY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D4gISDJ+kOOCtCQjatqt+FxkFhjvbev5i8EB49yZSbN1lomZOivxOyFH3Z3VqMmGyG+9lP3QY2NEHUWH7pJ4vLnyiSHS2MAieAwLEJZJ0xgYhra07JxI7ectlCLb8EnSlc/G4F+qBzjfQebfQuOKv8aD9ZSOQs3UmBpitbhxnN8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MKFnlCX0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MKFnlCX0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDF3FC4CED1;
	Wed, 19 Feb 2025 08:34:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739954078;
	bh=YBVqgzpbnIAlypPbqZcDHmJwE7wxJ19SR2nW6XiOaaY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MKFnlCX0ZRuQOqc3iiQzdHd/TH5AD3t3h3mkGBKVO/AOuFWTwwwDi9dBzxo6w8pI3
	 st0qMqSPjFRqEA1hYmdwN60W6lw35MnKInh9gf6WtDTmwCea1eqrHQiL9388uwGtp+
	 iuI9AnsYz/MKYRXHwamjk8q8felbvML+LfiW1jCM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guixin Liu <kanie@linux.alibaba.com>,
	Avri Altman <avri.altman@wdc.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 089/274] scsi: ufs: bsg: Set bsg_queue to NULL after removal
Date: Wed, 19 Feb 2025 09:25:43 +0100
Message-ID: <20250219082613.106029029@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082609.533585153@linuxfoundation.org>
References: <20250219082609.533585153@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guixin Liu <kanie@linux.alibaba.com>

[ Upstream commit 1e95c798d8a7f70965f0f88d4657b682ff0ec75f ]

Currently, this does not cause any issues, but I believe it is necessary to
set bsg_queue to NULL after removing it to prevent potential use-after-free
(UAF) access.

Signed-off-by: Guixin Liu <kanie@linux.alibaba.com>
Link: https://lore.kernel.org/r/20241218014214.64533-3-kanie@linux.alibaba.com
Reviewed-by: Avri Altman <avri.altman@wdc.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ufs/core/ufs_bsg.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/ufs/core/ufs_bsg.c b/drivers/ufs/core/ufs_bsg.c
index 58023f735c195..8d4ad0a3f2cf0 100644
--- a/drivers/ufs/core/ufs_bsg.c
+++ b/drivers/ufs/core/ufs_bsg.c
@@ -216,6 +216,7 @@ void ufs_bsg_remove(struct ufs_hba *hba)
 		return;
 
 	bsg_remove_queue(hba->bsg_queue);
+	hba->bsg_queue = NULL;
 
 	device_del(bsg_dev);
 	put_device(bsg_dev);
-- 
2.39.5



