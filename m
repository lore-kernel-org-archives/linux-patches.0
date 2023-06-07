Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5058934CC3
	for <patches@lists.linux.dev>; Wed,  7 Jun 2023 20:44:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C47C9C433D2;
	Wed,  7 Jun 2023 20:43:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1686170640;
	bh=i+z53TWJk40cu7KVEGwfln1kPQX+XtUYvQiEwjPukBg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Je9LFfHcdLzfr/1cs8dqHHnQY/68MypyJWGB9Q38M92CR7HPj6KG+RinPaoZ3Ws+3
	 nshaT+i2gchKpd61uazsg0G1P3NBpzOtcFC3cr1JiSW4M0Jy2gKqX5DkrHI7modRok
	 3b5qgAUdi6cLEyFfUhS322iGCje6sFC2pWtNhVGY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Randy Dunlap <rdunlap@infradead.org>,
	Bart Van Assche <bvanassche@acm.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 6.1 162/225] scsi: stex: Fix gcc 13 warnings
Date: Wed,  7 Jun 2023 22:15:55 +0200
Message-ID: <20230607200919.698931398@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230607200913.334991024@linuxfoundation.org>
References: <20230607200913.334991024@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Bart Van Assche <bvanassche@acm.org>

commit 6d074ce231772c66e648a61f6bd2245e7129d1f5 upstream.

gcc 13 may assign another type to enumeration constants than gcc 12. Split
the large enum at the top of source file stex.c such that the type of the
constants used in time expressions is changed back to the same type chosen
by gcc 12. This patch suppresses compiler warnings like this one:

In file included from ./include/linux/bitops.h:7,
                 from ./include/linux/kernel.h:22,
                 from drivers/scsi/stex.c:13:
drivers/scsi/stex.c: In function ‘stex_common_handshake’:
./include/linux/typecheck.h:12:25: error: comparison of distinct pointer types lacks a cast [-Werror]
   12 |         (void)(&__dummy == &__dummy2); \
      |                         ^~
./include/linux/jiffies.h:106:10: note: in expansion of macro ‘typecheck’
  106 |          typecheck(unsigned long, b) && \
      |          ^~~~~~~~~
drivers/scsi/stex.c:1035:29: note: in expansion of macro ‘time_after’
 1035 |                         if (time_after(jiffies, before + MU_MAX_DELAY * HZ)) {
      |                             ^~~~~~~~~~

See also https://gcc.gnu.org/bugzilla/show_bug.cgi?id=107405.

Cc: stable@vger.kernel.org
Acked-by: Randy Dunlap <rdunlap@infradead.org>
Tested-by: Randy Dunlap <rdunlap@infradead.org> # build-tested
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Link: https://lore.kernel.org/r/20230529195034.3077-1-bvanassche@acm.org
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/stex.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/scsi/stex.c
+++ b/drivers/scsi/stex.c
@@ -109,7 +109,9 @@ enum {
 	TASK_ATTRIBUTE_HEADOFQUEUE		= 0x1,
 	TASK_ATTRIBUTE_ORDERED			= 0x2,
 	TASK_ATTRIBUTE_ACA			= 0x4,
+};
 
+enum {
 	SS_STS_NORMAL				= 0x80000000,
 	SS_STS_DONE				= 0x40000000,
 	SS_STS_HANDSHAKE			= 0x20000000,
@@ -121,7 +123,9 @@ enum {
 	SS_I2H_REQUEST_RESET			= 0x2000,
 
 	SS_MU_OPERATIONAL			= 0x80000000,
+};
 
+enum {
 	STEX_CDB_LENGTH				= 16,
 	STATUS_VAR_LEN				= 128,
 


