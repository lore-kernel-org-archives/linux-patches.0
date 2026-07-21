Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B0F146EC8B;
	Tue, 21 Jul 2026 19:54:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784663654; cv=none; b=tXBDaSzWrl2up7krXxVObSgNJzJ4AOo8dLWQPomVTHYq2KcI1fK9YQGdUt9JcDVuJY7EsRGVOWuLJt/X1XNSWqTxH1BW6oEt9rkbADGeYjLroLErt8IzokOz9e8PPkWksMg67iOT34hqgGOqG6VMP+H8A05qzhBI1LGWphqPU5M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784663654; c=relaxed/simple;
	bh=V4AA4FMMtXV2Pd3yZqiOmgOU31sZLvqgjAoHFgC9XfI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e1e0HgibGoLlq6zhY5ekeVKwIIuwzWtIh4gyc0XETYyRecOVvTct4s5rZ26pbAztS+uK+uImvthjZ52+QEF6FW8bUrlcTqxLqlHaDKat4vuiUgzutgpAFUT8A8/eYSim99gYglwmbas3cTJTjIVLmfq/9LHG+tdQ4/Vg6GtuHGM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OKAeOfqz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OKAeOfqz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80FAF1F000E9;
	Tue, 21 Jul 2026 19:54:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784663653;
	bh=XofQQMeuyqrKGCAlqIrOkmAM251dFEtJ5LqsuMH507Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OKAeOfqzkbr43/zWin4N3sNZ2T4kjdb3PJdg1D9AwHTirVGbjUuLtnaVI5dWseYin
	 uXIGL3WwFsngtDIz9OJn7CvpYgB90ZKeDrLIt6OUBjt3R36MruHRibPtzMVxyTbRzC
	 jyaGkXogYBF90USGwDinP5OQiSFXbrY7X2zw+cM4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thorsten Blum <thorsten.blum@linux.dev>,
	Ingo Molnar <mingo@kernel.org>,
	"H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH 6.12 0877/1276] x86/boot: Validate console=uart8250 baud rate to fix early boot hang
Date: Tue, 21 Jul 2026 17:22:00 +0200
Message-ID: <20260721152505.678493445@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thorsten Blum <thorsten.blum@linux.dev>

commit ffa0aa5b625fe0bed7463ac613f8b06676ff4542 upstream.

When the baud rate is empty, 0, invalid, or overflows to 0 when stored
as an int, the system will hang during early boot because of a division
by zero in early_serial_init().

Fall back to DEFAULT_BAUD when the resulting baud rate is 0 to prevent
an early system hang.

Fixes: ce0aa5dd20e4 ("x86, setup: Make the setup code also accept console=uart8250")
Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20260713194924.126472-3-thorsten.blum@linux.dev
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/boot/early_serial_console.c |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

--- a/arch/x86/boot/early_serial_console.c
+++ b/arch/x86/boot/early_serial_console.c
@@ -117,7 +117,7 @@ static unsigned int probe_baud(int port)
 static void parse_console_uart8250(void)
 {
 	char optstr[64], *options;
-	int baud = DEFAULT_BAUD;
+	int baud;
 	int port = 0;
 
 	/*
@@ -136,10 +136,13 @@ static void parse_console_uart8250(void)
 	else
 		return;
 
-	if (options && (options[0] == ','))
-		baud = simple_strtoull(options + 1, &options, 0);
-	else
+	if (options && (options[0] == ',')) {
+		baud = simple_strtoull(options + 1, NULL, 0);
+		if (!baud)
+			baud = DEFAULT_BAUD;
+	} else {
 		baud = probe_baud(port);
+	}
 
 	if (port)
 		early_serial_init(port, baud);


