Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83DC619DF92;
	Thu, 15 Aug 2024 14:24:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723731868; cv=none; b=tYVJr8Yf8tB/YUrVvD0VgLmd3kfUG0YkmwZPUGgogIKJcTapd58aUO29vg7W7qLyFLdlYtBrXAAZsB5Iv/7UfDzE+Eu8GrvM1RDoejLhFlc1VRB5mxFISdOkP1ibc+WE/PyVhl8zKI1YovQzJ3LRhxgmEkfTKLwk19aN5EYf5U4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723731868; c=relaxed/simple;
	bh=LYxkG2VigY3qyqM585hwEsK5mXxzcAAV481J/wUK+OQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A0Fheq/K5jMVHwHFRRgbfsUC2J8Wde2VtvxZzCmO1M6ugCwhas8ATQGFL3k39M4m2ilEoxgA66iVWYPO1S41xLXZ9o+ozsKs4Y1SmMNP/GkHgT2TLm7SXldNlOIWjkiNc8ii8GHCdchwVSROLlSLV9BZinX5cr6s/9wGAcqNDRA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EY8qy+JX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EY8qy+JX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0D2EC32786;
	Thu, 15 Aug 2024 14:24:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723731868;
	bh=LYxkG2VigY3qyqM585hwEsK5mXxzcAAV481J/wUK+OQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EY8qy+JXmuBFKZ3RfIGeDEB8SxJpzSDdn0ogsRJOgBMjzmpPtSOBZNa9KYOQlkRge
	 lM0lQmd91tO/SnnL6f/V9gTke+BEJw7Qy6pYkQq6bx3Lhk+u2+z0UGxi8uDYTHZwWV
	 FFUHYtmbJsz4RU/ThqM59GgFiBUC8PGpcAadcAA0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vamshi Gajjela <vamshigajjela@google.com>,
	Bart Van Assche <bvanassche@acm.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 5.4 234/259] scsi: ufs: core: Fix hba->last_dme_cmd_tstamp timestamp updating logic
Date: Thu, 15 Aug 2024 15:26:07 +0200
Message-ID: <20240815131911.812783832@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131902.779125794@linuxfoundation.org>
References: <20240815131902.779125794@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
 drivers/scsi/ufs/ufshcd.c |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -3569,11 +3569,16 @@ static inline void ufshcd_add_delay_befo
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


