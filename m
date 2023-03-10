Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CCDC847E
	for <patches@lists.linux.dev>; Fri, 10 Mar 2023 13:53:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2BB5C433D2;
	Fri, 10 Mar 2023 13:53:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678456417;
	bh=6LmaKSZJOuNTmzf5klKXJMmFtwTgDmcdurxTOec6EqI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LIiKPvGqs5WAWZQh3muBRTU+yLyQMH9Tj7+QC7tDcsdcY9D7vVSa+Uzi6hpHHFJNf
	 p+U6rB7NfjUP3zOMTYt1Mq51ZrP3EucvPt51jDdzn1vKwAMxoEAr3fu//G//wh4jhZ
	 UdEwEf6yPuV9Xxvfr7aV4Ultx1sxnFY38HDTN1wE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heiko Carstens <heiko.carstens@de.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>
Subject: [PATCH 4.14 190/193] s390/maccess: add no DAT mode to kernel_write
Date: Fri, 10 Mar 2023 14:39:32 +0100
Message-Id: <20230310133717.387146745@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133710.926811681@linuxfoundation.org>
References: <20230310133710.926811681@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Vasily Gorbik <gor@linux.ibm.com>

commit d6df52e9996dcc2062c3d9c9123288468bb95b52 upstream.

To be able to patch kernel code before paging is initialized do plain
memcpy if DAT is off. This is required to enable early jump label
initialization.

Reviewed-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/s390/mm/maccess.c |   16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

--- a/arch/s390/mm/maccess.c
+++ b/arch/s390/mm/maccess.c
@@ -58,13 +58,19 @@ static notrace long s390_kernel_write_od
  */
 void notrace s390_kernel_write(void *dst, const void *src, size_t size)
 {
+	unsigned long flags;
 	long copied;
 
-	while (size) {
-		copied = s390_kernel_write_odd(dst, src, size);
-		dst += copied;
-		src += copied;
-		size -= copied;
+	flags = arch_local_save_flags();
+	if (!(flags & PSW_MASK_DAT)) {
+		memcpy(dst, src, size);
+	} else {
+		while (size) {
+			copied = s390_kernel_write_odd(dst, src, size);
+			dst += copied;
+			src += copied;
+			size -= copied;
+		}
 	}
 }
 


