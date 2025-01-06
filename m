Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A40613AD11;
	Mon,  6 Jan 2025 15:52:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736178744; cv=none; b=p4S/4zUUwLerHDJE1HgEmTFAin7vTpIgOSStly90k+a598qaFoaqSY+AhDapru24y9vWa2hGTuuzuqXJu5prTkjcinLFpPPTH8d67uv/s7Gie8Zlwq3vLTo9O/3sNbBtu37pjQ0deN2GlPaiXyqmUIJ83D8BPyMLdAaXOQk47Ig=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736178744; c=relaxed/simple;
	bh=7pNsJ9jQsrB22bAi5fGNG90YyJBGb4jLukDe+KdoY2c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HVYK1ZqfzHXhwPzxB/yPqO3VUkaNN2fGXCZkV8PBdUtHi94UweJaBY9pO+TQVF/hNwD+YKHZIxnuc7LjHE6M7M9znWjnFeNmtZsoT601boqfeozMAh/UjmW4LObmkqjjtflOn0gb/eoCUNI5Z2GdukjmRkXLA2oeTtBTkdMz75w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1ooFDTx0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1ooFDTx0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83EDEC4CED2;
	Mon,  6 Jan 2025 15:52:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736178743;
	bh=7pNsJ9jQsrB22bAi5fGNG90YyJBGb4jLukDe+KdoY2c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1ooFDTx0WY+qHFeQNNbMYZ5MtI6guJ13fTXF3tcwh6ugVmC9L+VFZhnfPTw6K4RzC
	 bGqAV75H2/7tc8kKc8Bik5IYOPCgQ8DxgOg950N0RmXtWSEZBliBcQQI6D6bvfO9ZS
	 Cnu7VL2uWIWSdT8N3nnP0HFdNGGhLHcQsKGXNsRA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tomas Henzl <thenzl@redhat.com>,
	Chandrakanth Patil <chandrakanth.patil@broadcom.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 078/168] scsi: megaraid_sas: Fix for a potential deadlock
Date: Mon,  6 Jan 2025 16:16:26 +0100
Message-ID: <20250106151141.411548331@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151138.451846855@linuxfoundation.org>
References: <20250106151138.451846855@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index c2c247a49ce9..09bb8fe575e3 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -8922,8 +8922,11 @@ megasas_aen_polling(struct work_struct *work)
 						   (ld_target_id / MEGASAS_MAX_DEV_PER_CHANNEL),
 						   (ld_target_id - MEGASAS_MAX_DEV_PER_CHANNEL),
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



