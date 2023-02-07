Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 118403212
	for <patches@lists.linux.dev>; Tue,  7 Feb 2023 13:12:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86581C4339E;
	Tue,  7 Feb 2023 13:12:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1675775575;
	bh=vBQlF3wUTm9Jvg/vzYJMvqLV82FTX+EhwONVtgc1A8M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=J6381JkDFEKCFPMZmW5EdlKLnwYvOtTTRqJ57r7qexqGWG2tWpBhGUIf9U7gaFCGF
	 hhEJJr1YmtUumNA2jyn5KwaM5+ygr2R6XTVH9Nf1KLcj4Hd044Gsfw20IZZFVGL4sh
	 P0FxZwxSfYbs/SX2fbzebnS5xapWLTHosQVwrrM4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Helge Deller <deller@gmx.de>
Subject: [PATCH 5.15 087/120] parisc: Fix return code of pdc_iodc_print()
Date: Tue,  7 Feb 2023 13:57:38 +0100
Message-Id: <20230207125622.454249725@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230207125618.699726054@linuxfoundation.org>
References: <20230207125618.699726054@linuxfoundation.org>
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
@@ -1230,7 +1230,7 @@ static char __attribute__((aligned(64)))
  */
 int pdc_iodc_print(const unsigned char *str, unsigned count)
 {
-	unsigned int i;
+	unsigned int i, found = 0;
 	unsigned long flags;
 
 	for (i = 0; i < count;) {
@@ -1239,6 +1239,7 @@ int pdc_iodc_print(const unsigned char *
 			iodc_dbuf[i+0] = '\r';
 			iodc_dbuf[i+1] = '\n';
 			i += 2;
+			found = 1;
 			goto print;
 		default:
 			iodc_dbuf[i] = str[i];
@@ -1255,7 +1256,7 @@ print:
                     __pa(iodc_retbuf), 0, __pa(iodc_dbuf), i, 0);
         spin_unlock_irqrestore(&pdc_lock, flags);
 
-	return i;
+	return i - found;
 }
 
 #if !defined(BOOTLOADER)


