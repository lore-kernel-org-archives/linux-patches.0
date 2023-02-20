Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F86A63B8
	for <patches@lists.linux.dev>; Mon, 20 Feb 2023 13:38:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26DB8C433D2;
	Mon, 20 Feb 2023 13:37:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1676900280;
	bh=V0SzFyq0MH3ytVl5/P65voB+LvKwGIsuXktgN4BiHjs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ppihxhBbc8VCKBRhK1OCzdkHNJKkhoXqefa3JMllTCvHDe/Mcl+mR9konTYT8c3Ln
	 k1+HNO2iPdDdLUfEBrXM2/AFpn3j0PXOGALICB+xXKGDc9mBsLUgCQKn8Gb4mJMVgY
	 MuUaUm6EWyaR52fy4n1v2dUzi/4BYX3mGAwfsGUU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Helge Deller <deller@gmx.de>
Subject: [PATCH 4.14 19/53] parisc: Fix return code of pdc_iodc_print()
Date: Mon, 20 Feb 2023 14:35:45 +0100
Message-Id: <20230220133548.852227673@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230220133548.158615609@linuxfoundation.org>
References: <20230220133548.158615609@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Helge Deller <deller@gmx.de>

commit 5d1335dabb3c493a3d6d5b233953b6ac7b6c1ff2 upstream.

There is an off-by-one if the printed string includes a new-line
char.

Cc: stable@vger.kernel.org
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/parisc/kernel/firmware.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/arch/parisc/kernel/firmware.c
+++ b/arch/parisc/kernel/firmware.c
@@ -1197,7 +1197,7 @@ static char __attribute__((aligned(64)))
  */
 int pdc_iodc_print(const unsigned char *str, unsigned count)
 {
-	unsigned int i;
+	unsigned int i, found = 0;
 	unsigned long flags;
 
 	for (i = 0; i < count;) {
@@ -1206,6 +1206,7 @@ int pdc_iodc_print(const unsigned char *
 			iodc_dbuf[i+0] = '\r';
 			iodc_dbuf[i+1] = '\n';
 			i += 2;
+			found = 1;
 			goto print;
 		default:
 			iodc_dbuf[i] = str[i];
@@ -1222,7 +1223,7 @@ print:
                     __pa(iodc_retbuf), 0, __pa(iodc_dbuf), i, 0);
         spin_unlock_irqrestore(&pdc_lock, flags);
 
-	return i;
+	return i - found;
 }
 
 #if !defined(BOOTLOADER)


