Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 285B77482;
	Thu, 30 Jan 2025 14:30:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738247438; cv=none; b=HUHe5b5MY7WEFfvWTi851KVhs3qSkJG+bhr03wtP9ZwXZlKR1Amm4N/Cu4yZ2R07gUmfHyESwdhMCHE7AzN5L6U3EBvZEoejQ3yK7MGnZXxXKXF2PHf0XlHmdsMptWThYlKhA7n6QGnSUN9t2SC6CEfcmQbfHJRdJGeS1CH5zWc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738247438; c=relaxed/simple;
	bh=vsCby5G96XyJWYrBGurqA4CX8DfJSfiYbgXmykMESzc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uZZrzsmlPaxsEmCykiYBD23ap00/uUnW0oAxiM4e/HEHmZyXTcySyQ3k1dF3NJGHrc/X6wz16kbsAeR2ogUDupUbLlRUlvYEO2MiBrsQewW2FuTXTr6saWbjWfVBq3PLaICuLURVju0KCUmXPPEHvF9VC5B/kLuvr8lOy351f6Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XC2GyfTX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XC2GyfTX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 437C0C4CED2;
	Thu, 30 Jan 2025 14:30:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738247437;
	bh=vsCby5G96XyJWYrBGurqA4CX8DfJSfiYbgXmykMESzc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XC2GyfTXnKZht7LYpGyd641C35YM9iQb1UgokC/9r3FBAw0jdC0OqNoQLX6FdCYFI
	 NPWk/zMVmV1N/eQ7U1DcWBmVarUJ8Bp0wFUxz9Ikq7io8nNtd6Wj73WOlMFD6FqI4r
	 OEYjBd8HrC58RQmxduj8THMLE9UZwhKoKwYeY1jc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Easwar Hariharan <eahariha@linux.microsoft.com>,
	Michael Kelley <mhklinux@outlook.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 6.1 39/49] scsi: storvsc: Ratelimit warning logs to prevent VM denial of service
Date: Thu, 30 Jan 2025 15:02:15 +0100
Message-ID: <20250130140135.399344625@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250130140133.825446496@linuxfoundation.org>
References: <20250130140133.825446496@linuxfoundation.org>
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
@@ -1168,7 +1174,7 @@ static void storvsc_on_io_completion(str
 		int loglevel = (stor_pkt->vm_srb.cdb[0] == TEST_UNIT_READY) ?
 			STORVSC_LOGGING_WARN : STORVSC_LOGGING_ERROR;
 
-		storvsc_log(device, loglevel,
+		storvsc_log_ratelimited(device, loglevel,
 			"tag#%d cmd 0x%x status: scsi 0x%x srb 0x%x hv 0x%x\n",
 			scsi_cmd_to_rq(request->cmd)->tag,
 			stor_pkt->vm_srb.cdb[0],


