Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEAAD1E7C25;
	Thu, 30 Jan 2025 14:28:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738247338; cv=none; b=c/P2wIXuEwAtObfmiClw+b+CstLM1hMH4Q/ma1NuwhmnFpZ1is+NVr/Yd38g/n/AtV6QVoQcM6WvfbaFOA1oKXxMFNwt1zzQ86UX/O8ynbzOgUbbIKj+42g6agsxnBSP+JyXLeuSjAgoLhsHe3iHfMaumwxDuoPKBfBRPIWZCRk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738247338; c=relaxed/simple;
	bh=KkDBkU867hfjRFaaL/yv6ckqriE79re8mKGYXU7lJOw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CwfIc8M0Vs65DSYly5T+Ioc8p5yr/FcBYQmyIbnLz9JufkaeJVcjUTJ2+ZOnW4Zi1tcP4gv0Sd8rsXoKJCJX3QXXKWpb/LYBU1jS8eijfCiTiCHIIMWHN6Nz4B70u38BwWx5MRPdUWUUb4gkiia3xuJHeRNtpJGWlW8umtj8Zb8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rlob1Esh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rlob1Esh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C816CC4CED2;
	Thu, 30 Jan 2025 14:28:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738247338;
	bh=KkDBkU867hfjRFaaL/yv6ckqriE79re8mKGYXU7lJOw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rlob1Esh2GI2Gtcextb2WgHoNNudFntS7vGFw8sgEQoqJpt+XuzkG+QTn9ChaaroJ
	 cNSUgedIiCAoLaSNHnHbZJba7DI68Yj/hzzxOD9NyRPPPdQ/sbc4wcTENqEMC3HWrD
	 d1cj9RKbgn4uSwBG4P9RFZ1/Im+UolXBtSjUsM4Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Easwar Hariharan <eahariha@linux.microsoft.com>,
	Michael Kelley <mhklinux@outlook.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 5.15 17/24] scsi: storvsc: Ratelimit warning logs to prevent VM denial of service
Date: Thu, 30 Jan 2025 15:02:09 +0100
Message-ID: <20250130140127.984987563@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250130140127.295114276@linuxfoundation.org>
References: <20250130140127.295114276@linuxfoundation.org>
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
@@ -189,6 +189,12 @@ struct vmscsi_win8_extension {
 	u32 queue_sort_ey;
 } __packed;
 
+#define storvsc_log_ratelimited(dev, level, fmt, ...)				\
+do {										\
+	if (do_logging(level))							\
+		dev_warn_ratelimited(&(dev)->device, fmt, ##__VA_ARGS__);	\
+} while (0)
+
 struct vmscsi_request {
 	u16 length;
 	u8 srb_status;
@@ -1231,7 +1237,7 @@ static void storvsc_on_io_completion(str
 		int loglevel = (stor_pkt->vm_srb.cdb[0] == TEST_UNIT_READY) ?
 			STORVSC_LOGGING_WARN : STORVSC_LOGGING_ERROR;
 
-		storvsc_log(device, loglevel,
+		storvsc_log_ratelimited(device, loglevel,
 			"tag#%d cmd 0x%x status: scsi 0x%x srb 0x%x hv 0x%x\n",
 			scsi_cmd_to_rq(request->cmd)->tag,
 			stor_pkt->vm_srb.cdb[0],


