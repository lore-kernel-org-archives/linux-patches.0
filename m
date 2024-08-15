Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 791C719F47A;
	Thu, 15 Aug 2024 13:36:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723728996; cv=none; b=icu/qrzFFKOvnjwIfOa1MFuaxtxN0OjXLfvyjPJLqzYuxhbDDxsPWbEE9/WLNJxz2FjjfAjWKvC/dWj7PgR/Yxxbcovd8MyPQI6/HpAKM5NR2gSX8th+XzJLJJHtO02SWaBRmd2lZqRwYqgnSfri9R8v6eriRuqlLYRS/xYxl+s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723728996; c=relaxed/simple;
	bh=2fYvLAwyj/WaCURXZVkgQhECR30BNgOXXXeoFkinXg4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lZhzxnjMxQI4s0cGNF5KVzjcnMIfUa1Pe7lt3saEifRIF9QLwgBELCgmVXMvL4NpLfH5tJfewbniRRStMHpRluv3rFmJU3pVZbFkgeVR37FSj/qzsbD01bn9/DvCnIBGx7NcJL1MN0t/nFwM3oWQt00WNkQS+HkXv1dSjIQsMnM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Q+VkMZxj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q+VkMZxj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA1B3C32786;
	Thu, 15 Aug 2024 13:36:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723728996;
	bh=2fYvLAwyj/WaCURXZVkgQhECR30BNgOXXXeoFkinXg4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Q+VkMZxjIOUT+97wn8UjaKGDWj3xuF9Tk1ltBodX1aCKgw6BUFq+1T9Zinq9Bvaiy
	 qkskFRWxIBqU89Se8k3QoHxP1XoKIMFxE3RpYOfyYTqSUQUSRJt4HRfE2aXbB7+rfA
	 jUiGyFhcnWnr8LZeKXYe5Mx2HcLiLwO9i8BSnDYA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vamshi Gajjela <vamshigajjela@google.com>,
	Bart Van Assche <bvanassche@acm.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 4.19 176/196] scsi: ufs: core: Fix hba->last_dme_cmd_tstamp timestamp updating logic
Date: Thu, 15 Aug 2024 15:24:53 +0200
Message-ID: <20240815131858.806932864@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131852.063866671@linuxfoundation.org>
References: <20240815131852.063866671@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
@@ -3592,11 +3592,16 @@ static inline void ufshcd_add_delay_befo
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


