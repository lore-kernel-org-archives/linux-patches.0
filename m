Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DB56415F36;
	Sat, 12 Sep 2026 08:42:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789202537; cv=none; b=jX/UX02zn0f8lzHf1qnSpql5tTjmn0r0IQozBCT9MZBC/NGahpAeDjzjbe4wD43kbOkRTxuOafBxYzzXjG6srBv22U0n06X+EnGA4Ti50MEg1G3nvQ+b2X69X5lixoiClPAf5yo3Z/cWiPWbpZT/nI+ZZMvgQsJTBEDzECKm5Jo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789202537; c=relaxed/simple;
	bh=bU9yNdrG7BxGZ7dGz5IElApqAb0tlBcmZscf5jnOX+0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gEyYTI9HJsHIilsnPyawgnxZhEqHi016bHUin7PXxbbSDJUE6NvlCft1DTS4SmE+fix856ZoC6JoLhTLkcAZa+BGycZPniGwsItibaTVkBIXc1skmbKMoY0/2XR9VHQFWPEp8QbuMKrnpM3EZI9IigBX3sGT9IOa29ceMil0GB0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ma25/hrK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ma25/hrK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92DFD1F000FF;
	Sat, 12 Sep 2026 08:42:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789202535;
	bh=XhZxMZUj8gtiMHmoPE41GUkKJK4szinw538cPLtzdvQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ma25/hrKkkJNFBZEqgDi266dWPz3OPGWsDdojlleUIfwdKWpT8iRS02TqBYHrDs44
	 pQcdgmRobnLqbQFfixV3Wp9gvp+9G/0NyRi1d/EWnZLy23sFtGstWeIOMGRsQGY/xt
	 riC+2XtUfbmcjbtOYAHOjVMqqyblwgDos/8z1Ysc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damien Le Moal <dlemoal@kernel.org>,
	Yang Xiuwei <yangxiuwei@kylinos.cn>,
	Bart Van Assche <bvanassche@acm.org>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1222/1815] scsi: sd: Fix sd_done() sense handling condition
Date: Sat, 12 Sep 2026 08:49:32 +0200
Message-ID: <20260912065717.696741402@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yang Xiuwei <yangxiuwei@kylinos.cn>

[ Upstream commit a640d4546b11be5709a82bdc63d7dafd8ddc6c9e ]

Only enter the sense_key switch when the command returned CHECK
CONDITION with valid, non-deferred sense. The old condition let deferred
or invalid sense fall through and mis-handle the I/O.

Fixes: 03aba2f79594 ("[SCSI] sd/scsi_lib simplify sd_rw_intr and scsi_io_completion")
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Signed-off-by: Yang Xiuwei <yangxiuwei@kylinos.cn>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Link: https://patch.msgid.link/20260707030333.22245-4-yangxiuwei@kylinos.cn
Signed-off-by: Martin K. Petersen (Oracle) <mkp@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/sd.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 8fed1cda9ac8c..a1b21ea14e549 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -2419,8 +2419,8 @@ static int sd_done(struct scsi_cmnd *SCpnt)
 	}
 	sdkp->medium_access_timed_out = 0;
 
-	if (!scsi_status_is_check_condition(result) &&
-	    (!sense_valid || sense_deferred))
+	if (!scsi_status_is_check_condition(result) ||
+	    !sense_valid || sense_deferred)
 		goto out;
 
 	switch (sshdr.sense_key) {
-- 
2.53.0



