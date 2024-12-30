Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFE8F15E8B;
	Mon, 30 Dec 2024 15:45:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735573556; cv=none; b=P5LWez/r4q+OTYgP71q3sdkWBGdMzuOEZafyICmrjPLrthoqSSuMre9/Q1+47HtKeN7uWbzEXgwEZSZZTxiVfCK5VY/mJb6KBC+EqNNbH4Sg+yOAHptNrnyFjetqxSdYTvBcVW+q1izntLT9I6v2tMbiSL5vj/H7mJ0IqgnpzMs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735573556; c=relaxed/simple;
	bh=eg6TmomTXTRQge00MzE25/th0+9Ct1WBmYZPR0nz2EE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AwGjKfSogK9evqIcL76d5YZ+n0umTsg5tIhth4xU6rYZ4KllW0TxTNOXSjflnZQX0hyUQCbKwMynnOv5qBi89vDBQh03gTEGqzxzASAlE7gzaRQipkhCJQxSiWrdJ6Jt5X/5vQuj8K2YzzS5v6p/eb1zbXk47DXjOYisrraos+w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uWOvnVsu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uWOvnVsu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38FCFC4CED0;
	Mon, 30 Dec 2024 15:45:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1735573556;
	bh=eg6TmomTXTRQge00MzE25/th0+9Ct1WBmYZPR0nz2EE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uWOvnVsuXF6WuiRPPD+0MQ8GgvcKDsObNCL37IPwJsKrE0ejtIE6Lkt6Ij8RU6aoy
	 WWmEy5Zsr3+OFh01sqbSqED31zMi5vnai0kbUL82IarLe15nEGfSzduo7Dblx80kqb
	 hCBuuMQ2EvKJwaem3Lw5hLtIt9QuEehAgPL0hFBo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tomas Henzl <thenzl@redhat.com>,
	Chandrakanth Patil <chandrakanth.patil@broadcom.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 29/60] scsi: megaraid_sas: Fix for a potential deadlock
Date: Mon, 30 Dec 2024 16:42:39 +0100
Message-ID: <20241230154208.390700801@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241230154207.276570972@linuxfoundation.org>
References: <20241230154207.276570972@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tomas Henzl <thenzl@redhat.com>

[ Upstream commit 50740f4dc78b41dec7c8e39772619d5ba841ddd7 ]

This fixes a 'possible circular locking dependency detected' warning
      CPU0                    CPU1
      ----                    ----
 lock(&instance->reset_mutex);
                              lock(&shost->scan_mutex);
                              lock(&instance->reset_mutex);
 lock(&shost->scan_mutex);

Fix this by temporarily releasing the reset_mutex.

Signed-off-by: Tomas Henzl <thenzl@redhat.com>
Link: https://lore.kernel.org/r/20240923174833.45345-1-thenzl@redhat.com
Acked-by: Chandrakanth Patil <chandrakanth.patil@broadcom.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/megaraid/megaraid_sas_base.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index 37208bc08c66..f4b32ce45ce0 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -8905,8 +8905,11 @@ megasas_aen_polling(struct work_struct *work)
 						   (ld_target_id / MEGASAS_MAX_DEV_PER_CHANNEL),
 						   (ld_target_id % MEGASAS_MAX_DEV_PER_CHANNEL),
 						   0);
-			if (sdev1)
+			if (sdev1) {
+				mutex_unlock(&instance->reset_mutex);
 				megasas_remove_scsi_device(sdev1);
+				mutex_lock(&instance->reset_mutex);
+			}
 
 			event_type = SCAN_VD_CHANNEL;
 			break;
-- 
2.39.5



