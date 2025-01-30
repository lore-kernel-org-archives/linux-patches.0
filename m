Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C08CB2BB15;
	Thu, 30 Jan 2025 13:59:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738245570; cv=none; b=lHruHVwyPUMCylkTFI+DxCo4Zb/k1h+bOTO3TXG3qyyo2cq1gUErfYWf65KKpEEoJirgwei41r6LneXw/NwewhEzo7WOZLW23nbra1YQpED9Ujc8s2JMt84uSDB5ZIfBSGwDfIQeyr1bJn6hT1GZ1IaR8Xg85fiHYECVkwsDDQ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738245570; c=relaxed/simple;
	bh=jyn9xzjPFJuiZSbUwGqQ9Tg7x8i8/AydsWDmB8ndemc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BHx1gfCFTqtAThRLcZVuIsGvJIa1hkUlooqWPokaoJPvzxqRRn5OLayQ6parC/T6yH17SrL3rmFpXSztA4VaMzygaKlR067lmugbbjs/WBOfvC+JO05bzyyVODbyrQDf3yvy3e4evRmQp13npBlKKs36aW5G/73DxuEt7AFc0YI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=E1zHtWr7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="E1zHtWr7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5C1FC4CED2;
	Thu, 30 Jan 2025 13:59:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738245570;
	bh=jyn9xzjPFJuiZSbUwGqQ9Tg7x8i8/AydsWDmB8ndemc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=E1zHtWr7YhDM6gW7xVo1FtEvvi99HyS0GnH5nleWcDNZ8Au7z1bFnk4mmlwNvbrqz
	 UmbKGAT9QrpQG62mdZMzrv0nHRM57FL1NN9xIBCYgwwzBlBm+6C2yUXOn5dcFZRsRZ
	 l90UOtVC0crs67EwFIb0weYCtcGlms8EgF/+SGDk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Easwar Hariharan <eahariha@linux.microsoft.com>,
	Michael Kelley <mhklinux@outlook.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 6.13 12/25] scsi: storvsc: Ratelimit warning logs to prevent VM denial of service
Date: Thu, 30 Jan 2025 14:58:58 +0100
Message-ID: <20250130133457.419384481@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250130133456.914329400@linuxfoundation.org>
References: <20250130133456.914329400@linuxfoundation.org>
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

From: Easwar Hariharan <eahariha@linux.microsoft.com>

commit d2138eab8cde61e0e6f62d0713e45202e8457d6d upstream.

If there's a persistent error in the hypervisor, the SCSI warning for
failed I/O can flood the kernel log and max out CPU utilization,
preventing troubleshooting from the VM side. Ratelimit the warning so
it doesn't DoS the VM.

Closes: https://github.com/microsoft/WSL/issues/9173
Signed-off-by: Easwar Hariharan <eahariha@linux.microsoft.com>
Link: https://lore.kernel.org/r/20250107-eahariha-ratelimit-storvsc-v1-1-7fc193d1f2b0@linux.microsoft.com
Reviewed-by: Michael Kelley <mhklinux@outlook.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/storvsc_drv.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/drivers/scsi/storvsc_drv.c
+++ b/drivers/scsi/storvsc_drv.c
@@ -171,6 +171,12 @@ do {								\
 		dev_warn(&(dev)->device, fmt, ##__VA_ARGS__);	\
 } while (0)
 
+#define storvsc_log_ratelimited(dev, level, fmt, ...)				\
+do {										\
+	if (do_logging(level))							\
+		dev_warn_ratelimited(&(dev)->device, fmt, ##__VA_ARGS__);	\
+} while (0)
+
 struct vmscsi_request {
 	u16 length;
 	u8 srb_status;
@@ -1177,7 +1183,7 @@ static void storvsc_on_io_completion(str
 		int loglevel = (stor_pkt->vm_srb.cdb[0] == TEST_UNIT_READY) ?
 			STORVSC_LOGGING_WARN : STORVSC_LOGGING_ERROR;
 
-		storvsc_log(device, loglevel,
+		storvsc_log_ratelimited(device, loglevel,
 			"tag#%d cmd 0x%x status: scsi 0x%x srb 0x%x hv 0x%x\n",
 			scsi_cmd_to_rq(request->cmd)->tag,
 			stor_pkt->vm_srb.cdb[0],


