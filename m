Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 242EE1ADFFE;
	Tue, 26 Aug 2025 13:32:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756215131; cv=none; b=YHXGUH8h8Z9FE+qauQd/+ERG8m8R7LjIn1UcqFRlRyXgjKL7UJUoBp+0fjzh/ugSqsMtU8Zdqo2oJFOYpOJ4RpOloDoLpu0MzP0M5XVeMfCE9HNYz0jeN7YT7jcdjy+1L9xUCZkI7qd/KdKkz4nl8xmLwVvQ89g6308c/STJvQE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756215131; c=relaxed/simple;
	bh=HST3dFwaVGGEfKnMf8gjIfDuAqb8G1id2JEZEK1c8tA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e/2COGUle4N7CWJkgDvE8gw4cKiQyRgAjQXCSBfBQTwE941uRUMlZaA9z2If1TPdO5Wlee/02GygI0iBLrfnTN6u3UuZOqKpghk+CrwNNf3P/th7oXmwgAMN5Bobc50TGeTH2xYxIYknxyou+UobjaAaS64LjQMXzB+Dgj0U3cA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=U9mdNY2Z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="U9mdNY2Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB2ADC4CEF1;
	Tue, 26 Aug 2025 13:32:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756215131;
	bh=HST3dFwaVGGEfKnMf8gjIfDuAqb8G1id2JEZEK1c8tA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=U9mdNY2Zh9FF6kcfteL/yWNBE6PdDVGQSvskJXpF0RPkQ15TmjvzF4Y+Fo/CuXrs7
	 L5MeLu/O3A6NxXjZthPUMq9JiBiOrxvZi6CEBHgKSlzce+tdBMNrj97CpkJ1e6woGS
	 QXRaPSpsCglvGaDiavrLydEcQYEoj14vCDAUGMmk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Peter Oberparleiter <oberpar@linux.ibm.com>
Subject: [PATCH 6.1 399/482] s390/sclp: Fix SCCB present check
Date: Tue, 26 Aug 2025 13:10:52 +0200
Message-ID: <20250826110940.685106417@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110930.769259449@linuxfoundation.org>
References: <20250826110930.769259449@linuxfoundation.org>
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

From: Peter Oberparleiter <oberpar@linux.ibm.com>

commit 430fa71027b6ac9bb0ce5532b8d0676777d4219a upstream.

Tracing code called by the SCLP interrupt handler contains early exits
if the SCCB address associated with an interrupt is NULL. This check is
performed after physical to virtual address translation.

If the kernel identity mapping does not start at address zero, the
resulting virtual address is never zero, so that the NULL checks won't
work. Subsequently this may result in incorrect accesses to the first
page of the identity mapping.

Fix this by introducing a function that handles the NULL case before
address translation.

Fixes: ada1da31ce34 ("s390/sclp: sort out physical vs virtual pointers usage")
Cc: stable@vger.kernel.org
Reviewed-by: Alexander Gordeev <agordeev@linux.ibm.com>
Signed-off-by: Peter Oberparleiter <oberpar@linux.ibm.com>
Signed-off-by: Alexander Gordeev <agordeev@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/s390/char/sclp.c |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

--- a/drivers/s390/char/sclp.c
+++ b/drivers/s390/char/sclp.c
@@ -76,6 +76,13 @@ unsigned long sclp_console_full;
 /* The currently active SCLP command word. */
 static sclp_cmdw_t active_cmd;
 
+static inline struct sccb_header *sclpint_to_sccb(u32 sccb_int)
+{
+	if (sccb_int)
+		return __va(sccb_int);
+	return NULL;
+}
+
 static inline void sclp_trace(int prio, char *id, u32 a, u64 b, bool err)
 {
 	struct sclp_trace_entry e;
@@ -625,7 +632,7 @@ __sclp_find_req(u32 sccb)
 
 static bool ok_response(u32 sccb_int, sclp_cmdw_t cmd)
 {
-	struct sccb_header *sccb = (struct sccb_header *)__va(sccb_int);
+	struct sccb_header *sccb = sclpint_to_sccb(sccb_int);
 	struct evbuf_header *evbuf;
 	u16 response;
 
@@ -664,7 +671,7 @@ static void sclp_interrupt_handler(struc
 
 	/* INT: Interrupt received (a=intparm, b=cmd) */
 	sclp_trace_sccb(0, "INT", param32, active_cmd, active_cmd,
-			(struct sccb_header *)__va(finished_sccb),
+			sclpint_to_sccb(finished_sccb),
 			!ok_response(finished_sccb, active_cmd));
 
 	if (finished_sccb) {


