Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81F851D8DF6;
	Thu, 17 Apr 2025 18:09:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744913370; cv=none; b=L7JiKuaSy05SV7JsQuQAFq7gWMnywjHmF6mv8aTd56D/4oG2MIBhoKMQ+ozpXxfOrfuDvBhM118AfCxE0iy7hdirvYLzot6WpO4Vw3OWhlL5tmq7u432eppSi4upDeQf0da5AWeuEL735Z52ax2R/YyRyDDKFzlgnrYOXB7NYTc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744913370; c=relaxed/simple;
	bh=fxRTxWfokBHg7kvj0yGyKgWr4SY20Ix0A/EI6p5KPyo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pZBQDFe1EC8pf6wit7pUpQFC2T7szpRAAieoXia05+3umGjbQ9VNm/2qc5Wsn20h/ZEov9oes6gclt+Khj5q/UoatK5VC9SzcH9/IteerK3yinB7PsulndOmRghrzf3HTIDqXxUNg0O5NwyIvmJxCrtbytdYKL0+tfn1/4049v8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kLulRIZC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kLulRIZC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 846DAC4CEE4;
	Thu, 17 Apr 2025 18:09:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744913370;
	bh=fxRTxWfokBHg7kvj0yGyKgWr4SY20Ix0A/EI6p5KPyo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kLulRIZCo+2YfTXq31slvotNad9OSG5fJNkgy+8lO9M1/pg8p7O2P354B9BxOiV6t
	 fXdNn2B5u3n8xfdYRTl0sPB8jZHCiYIHFdRuRkibwLFh0WMmywN6fi+/w0s+H8LN/3
	 DseAWATKM8lJUAgBRimvP3A0LarIO5pEvb4L9leo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefan Berger <stefanb@linux.ibm.com>,
	Petr Vorel <pvorel@suse.cz>,
	Roberto Sassu <roberto.sassu@huawei.com>,
	Mimi Zohar <zohar@linux.ibm.com>
Subject: [PATCH 6.14 316/449] ima: limit the number of ToMToU integrity violations
Date: Thu, 17 Apr 2025 19:50:04 +0200
Message-ID: <20250417175130.832876448@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175117.964400335@linuxfoundation.org>
References: <20250417175117.964400335@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mimi Zohar <zohar@linux.ibm.com>

commit a414016218ca97140171aa3bb926b02e1f68c2cc upstream.

Each time a file in policy, that is already opened for read, is opened
for write, a Time-of-Measure-Time-of-Use (ToMToU) integrity violation
audit message is emitted and a violation record is added to the IMA
measurement list.  This occurs even if a ToMToU violation has already
been recorded.

Limit the number of ToMToU integrity violations per file open for read.

Note: The IMA_MAY_EMIT_TOMTOU atomic flag must be set from the reader
side based on policy.  This may result in a per file open for read
ToMToU violation.

Since IMA_MUST_MEASURE is only used for violations, rename the atomic
IMA_MUST_MEASURE flag to IMA_MAY_EMIT_TOMTOU.

Cc: stable@vger.kernel.org # applies cleanly up to linux-6.6
Tested-by: Stefan Berger <stefanb@linux.ibm.com>
Reviewed-by: Petr Vorel <pvorel@suse.cz>
Tested-by: Petr Vorel <pvorel@suse.cz>
Reviewed-by: Roberto Sassu <roberto.sassu@huawei.com>
Signed-off-by: Mimi Zohar <zohar@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 security/integrity/ima/ima.h      |    2 +-
 security/integrity/ima/ima_main.c |    7 ++++---
 2 files changed, 5 insertions(+), 4 deletions(-)

--- a/security/integrity/ima/ima.h
+++ b/security/integrity/ima/ima.h
@@ -181,7 +181,7 @@ struct ima_kexec_hdr {
 #define IMA_UPDATE_XATTR	1
 #define IMA_CHANGE_ATTR		2
 #define IMA_DIGSIG		3
-#define IMA_MUST_MEASURE	4
+#define IMA_MAY_EMIT_TOMTOU	4
 #define IMA_EMITTED_OPENWRITERS	5
 
 /* IMA integrity metadata associated with an inode */
--- a/security/integrity/ima/ima_main.c
+++ b/security/integrity/ima/ima_main.c
@@ -129,14 +129,15 @@ static void ima_rdwr_violation_check(str
 		if (atomic_read(&inode->i_readcount) && IS_IMA(inode)) {
 			if (!iint)
 				iint = ima_iint_find(inode);
+
 			/* IMA_MEASURE is set from reader side */
-			if (iint && test_bit(IMA_MUST_MEASURE,
-						&iint->atomic_flags))
+			if (iint && test_and_clear_bit(IMA_MAY_EMIT_TOMTOU,
+						       &iint->atomic_flags))
 				send_tomtou = true;
 		}
 	} else {
 		if (must_measure)
-			set_bit(IMA_MUST_MEASURE, &iint->atomic_flags);
+			set_bit(IMA_MAY_EMIT_TOMTOU, &iint->atomic_flags);
 
 		/* Limit number of open_writers violations */
 		if (inode_is_open_for_write(inode) && must_measure) {


