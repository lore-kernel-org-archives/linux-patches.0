Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80101183CA6;
	Mon, 12 Aug 2024 16:19:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723479565; cv=none; b=VaOF3HqtO1agUKUiNbNxTtDg9TqpZ85x2UyfEOU9oPiwBsbDzwBmZImR0K77KQyI5PZBr4YUK0wkH34GPqvtN/1sYDgmLWBeJHVvnj0z9mhS1tOAUHKqb1E11ZrujodjDcIF/Sb724L0tMigDJ5f6s18HRisuqG+6Ma5g0Ueuhc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723479565; c=relaxed/simple;
	bh=ug9SzSX3CZIuZQ/kow/gTdSbIjIu1FIj+0ONbDoM9cY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E6OjcdK3n8EH9fdgAD8SEvx+dBF79yBs9w3KG/66gsmVdcd+r6Tj3R3XeVEL/rbywnaxKTg8+QZj9F5Jsarohb+Mqp8ir0qpDGBpqp+91wr1bcJROz5jKyBXhXvRIYL9rXw0ZQl4rPcgrgMQSPNrSQEbGxc76MtsC9oQGCo/N6g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qnZauUzS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qnZauUzS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07727C32782;
	Mon, 12 Aug 2024 16:19:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723479565;
	bh=ug9SzSX3CZIuZQ/kow/gTdSbIjIu1FIj+0ONbDoM9cY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qnZauUzS5O44VZf4B8XZrzasevN69ca/G2H05ObfzDetjyAy/JmnvxZTY9fXQIBZ6
	 XFgGc7tX2ekPaNxGIPIhcB2mp1kp2c5ARxh4k3arGnT+kfBMi9s53dM908L+Zus280
	 v36fyZtr2nfVZhBoqHT7HhOQ/ImrbaQRhqpulAQk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vamshi Gajjela <vamshigajjela@google.com>,
	Bart Van Assche <bvanassche@acm.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 6.6 125/189] scsi: ufs: core: Fix hba->last_dme_cmd_tstamp timestamp updating logic
Date: Mon, 12 Aug 2024 18:03:01 +0200
Message-ID: <20240812160136.958369807@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240812160132.135168257@linuxfoundation.org>
References: <20240812160132.135168257@linuxfoundation.org>
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

From: Vamshi Gajjela <vamshigajjela@google.com>

commit ab9fd06cb8f0db0854291833fc40c789e43a361f upstream.

The ufshcd_add_delay_before_dme_cmd() always introduces a delay of
MIN_DELAY_BEFORE_DME_CMDS_US between DME commands even when it's not
required. The delay is added when the UFS host controller supplies the
quirk UFSHCD_QUIRK_DELAY_BEFORE_DME_CMDS.

Fix the logic to update hba->last_dme_cmd_tstamp to ensure subsequent DME
commands have the correct delay in the range of 0 to
MIN_DELAY_BEFORE_DME_CMDS_US.

Update the timestamp at the end of the function to ensure it captures the
latest time after any necessary delay has been applied.

Signed-off-by: Vamshi Gajjela <vamshigajjela@google.com>
Link: https://lore.kernel.org/r/20240724135126.1786126-1-vamshigajjela@google.com
Fixes: cad2e03d8607 ("ufs: add support to allow non standard behaviours (quirks)")
Cc: stable@vger.kernel.org
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/ufs/core/ufshcd.c |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -3971,11 +3971,16 @@ static inline void ufshcd_add_delay_befo
 			min_sleep_time_us =
 				MIN_DELAY_BEFORE_DME_CMDS_US - delta;
 		else
-			return; /* no more delay required */
+			min_sleep_time_us = 0; /* no more delay required */
 	}
 
-	/* allow sleep for extra 50us if needed */
-	usleep_range(min_sleep_time_us, min_sleep_time_us + 50);
+	if (min_sleep_time_us > 0) {
+		/* allow sleep for extra 50us if needed */
+		usleep_range(min_sleep_time_us, min_sleep_time_us + 50);
+	}
+
+	/* update the last_dme_cmd_tstamp */
+	hba->last_dme_cmd_tstamp = ktime_get();
 }
 
 /**


