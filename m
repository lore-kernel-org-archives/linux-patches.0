Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1ED521CAA86;
	Wed, 19 Feb 2025 08:48:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739954910; cv=none; b=dykyR17rrw/hEJBtYJ3HS5wzjB4kTdUuFICIgEuhIXppnZHJ2T7GWEVqGKX0P3bZuIgn9TzFpkBbIcBpTjDhm6n8boZJSsdiheP6YXFmGoTHF6hU9sS0Ii9MKAV6amkAdNOfm2mvOMFaup44WkpHmMPIT43imOxKYViKxD77E34=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739954910; c=relaxed/simple;
	bh=RKkvQNL3XvRWfCXQqvUeqgv5STTHE9wwg0qERcGaP2s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jv8+zjgs25xhNXY7GDl7kPVjUdn3sZ8fAvvzc7LIwlTswoJkNbLq6sk3ht0uUFKPGu7zhH6Txz/YW+8z/TMCxqxv7UMRxs42l/Sf9+Vpnh1An1DaBW+vt9r1EoqDyumUjgVXB+TR7qE3mHqoBF5yZKz68RSosY6drxHXywclTAY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XeBk+FyX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XeBk+FyX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9689AC4CED1;
	Wed, 19 Feb 2025 08:48:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739954910;
	bh=RKkvQNL3XvRWfCXQqvUeqgv5STTHE9wwg0qERcGaP2s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XeBk+FyXBmNsyDlsoVSzIGIkAeSsFLetDXw8X5JTDA38wGqxmJiyw6yAZupbwnnUb
	 zmu+I3acIk8B5sHzswV0rKN0b3Ip2u3VOGeraLW9O/nW+qsAFst1nTTkuwjHJ4E+tz
	 W4g1Y8jKAPelLFlug7UJ8kHPOHGW8QAgxgdPh2Bc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guixin Liu <kanie@linux.alibaba.com>,
	Avri Altman <avri.altman@wdc.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 074/230] scsi: ufs: bsg: Set bsg_queue to NULL after removal
Date: Wed, 19 Feb 2025 09:26:31 +0100
Message-ID: <20250219082604.601772152@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082601.683263930@linuxfoundation.org>
References: <20250219082601.683263930@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



