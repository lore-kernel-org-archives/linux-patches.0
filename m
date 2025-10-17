Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF5CC330B28;
	Fri, 17 Oct 2025 15:41:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760715712; cv=none; b=MzhFjk+OMkSldb4ExzoYKK3oqsBpWlGOG6JxUSHouP5YdcZUH3HgJqPFyMa4RZV857vOnxbUrxFNK1iFpi7fd7141HqVVVczw8ByUYBU7FRO/YoK5am2z6/0oaFxvIOwvSVw7QyFKxS3jc5BIFMRHtvLRQKIRgac98+UQhuqoeA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760715712; c=relaxed/simple;
	bh=FOB8WNjNSa+EuvG3WCa2O37V0/jRFqESFi5+bYzb0SQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QL5OcdnffVWcT5iwKFzxS67Drm1XpodFZpJXZkS/bKX8tlsDNIFx8dPdsl4rNxrPTymO5zIShQWqZEVLQiOol2kewXIlKKt9MR0O8DXdLNoJArwGpi3ATqPI9610oSrwy50e1abNWb2TAGvM1eJbg2yo4Mc323dSioTxVMigQWs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HlGyzCgC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HlGyzCgC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56AD0C4CEE7;
	Fri, 17 Oct 2025 15:41:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760715712;
	bh=FOB8WNjNSa+EuvG3WCa2O37V0/jRFqESFi5+bYzb0SQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HlGyzCgCq2+Du/c1UdZGCeZawc5xyqHawM9lR15Ms3DlEyDJCrCaBr17BuA3qXWa2
	 ZtIi3XD58xnQVgjtI+fO805We09jmd4uASpevJWkf6h20w4D9YRU/izSzuOzABDmZu
	 ceb8N1WzOkVXcU5rZTOq/Alz/PPsBqI95o5eeYmQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heiko Carstens <hca@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Juergen Christ <jchrist@linux.ibm.com>
Subject: [PATCH 6.17 304/371] s390/cio/ioasm: Fix __xsch() condition code handling
Date: Fri, 17 Oct 2025 16:54:39 +0200
Message-ID: <20251017145213.075877307@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145201.780251198@linuxfoundation.org>
References: <20251017145201.780251198@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Heiko Carstens <hca@linux.ibm.com>

commit f0edc8f113a39d1c9f8cf83e865c32b0668d80e0 upstream.

For the __xsch() inline assembly the conversion to flag output macros is
incomplete. Only the conditional shift of the return value was added, while
the required changes to the inline assembly itself are missing.

If compiled with GCC versions before 14.2 this leads to a double shift of
the cc output operand and therefore the returned value of __xsch() is
incorrectly always zero, instead of the expected condition code.

Fixes: e200565d434b ("s390/cio/ioasm: Convert to use flag output macros")
Cc: stable@vger.kernel.org
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Acked-by: Alexander Gordeev <agordeev@linux.ibm.com>
Reviewed-by: Juergen Christ <jchrist@linux.ibm.com>
Signed-off-by: Alexander Gordeev <agordeev@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/s390/cio/ioasm.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/s390/cio/ioasm.c b/drivers/s390/cio/ioasm.c
index a540045b64a6..8b06b234e110 100644
--- a/drivers/s390/cio/ioasm.c
+++ b/drivers/s390/cio/ioasm.c
@@ -253,11 +253,10 @@ static inline int __xsch(struct subchannel_id schid)
 	asm volatile(
 		"	lgr	1,%[r1]\n"
 		"	xsch\n"
-		"	ipm	%[cc]\n"
-		"	srl	%[cc],28\n"
-		: [cc] "=&d" (ccode)
+		CC_IPM(cc)
+		: CC_OUT(cc, ccode)
 		: [r1] "d" (r1)
-		: "cc", "1");
+		: CC_CLOBBER_LIST("1"));
 	return CC_TRANSFORM(ccode);
 }
 
-- 
2.51.0



