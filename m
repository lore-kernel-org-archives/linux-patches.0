Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 509051ABECE;
	Thu, 15 Aug 2024 14:41:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723732864; cv=none; b=ew99s8qjEH2XIWIKEYZaZCqXJfbqyacauoGslOGwmHzf7WSWulyPqlsa2C9mVBuNFxJtDBswWdnIy5vjYlQjDWpX6Pj/o2ct5n9/TuXC3Ylxm7vI+NezvEaD3qok6CwLciCWMG+FTfe7eWqdKU1zPsX/UlO2UdJcU71I1YxZMZo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723732864; c=relaxed/simple;
	bh=rl/U4shPjxJcavho36bC6HcWeO2Rxn4cwEAqOeRVHMc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C9J+JvY9vawUFo1w7aXgreTvXu/NTUZyS3666QOu+u83miokdx5Mwe6Aypskj1VPztjXIvCY0jeyGwx1olFTs0XJ7oJEjLbR3Cv3foqdXUneapLIyYoRUSoPdylXsSr1YkVDpnqeQDJAmpy17FtHHn3jy3TvqnJbBzn2RbWpqYA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IYEvxTXV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IYEvxTXV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA319C4AF17;
	Thu, 15 Aug 2024 14:41:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723732864;
	bh=rl/U4shPjxJcavho36bC6HcWeO2Rxn4cwEAqOeRVHMc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IYEvxTXVEo39LTjrvuHBtrSlTSJJcoXwgU0AAScUnWTA9ngeIdF5HZw1p1crMIVpc
	 7Bq8snzqbB7nQIQm8z0NUBNKy0fW2e9WF2pdmAND3x+Nbp0kTCRRy9pwxSXJQjReB+
	 QI5d2tOHFWLJ4mQ2LMqY6/tcJ+82R1F419aIbjto=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vamshi Gajjela <vamshigajjela@google.com>,
	Bart Van Assche <bvanassche@acm.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 5.10 309/352] scsi: ufs: core: Fix hba->last_dme_cmd_tstamp timestamp updating logic
Date: Thu, 15 Aug 2024 15:26:15 +0200
Message-ID: <20240815131931.400745548@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131919.196120297@linuxfoundation.org>
References: <20240815131919.196120297@linuxfoundation.org>
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
@@ -3653,11 +3653,16 @@ static inline void ufshcd_add_delay_befo
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


