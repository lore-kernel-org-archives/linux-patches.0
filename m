Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36B1743C06B;
	Tue, 21 Jul 2026 21:39:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784669977; cv=none; b=SJZWeYAg9pvvoEgDb7cceKmfbwSDmx5dBQ7EDvZeliu/pVAeuX4RRr37N3nKVr67Ky74F2JBschMCt18lMWMdqYTXfqu8V+RrVnTuiuiHrQXfU0T0r5iUilFF06lWlr3p0nAWoLaD8n5pNBwfs3y78HUu5buOt5L07aOd0LVuaE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784669977; c=relaxed/simple;
	bh=NlHlPsnmBKCP5yYlqMEKGL7AtoqwNhhXsuMWvRxumQs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uUrclYGC6cb3EnkAN8GWs2iu/z9inpaSOmFLv8JRZb2jw6C5/rUCaP4sbIeqOUClfvUHTbmf+jrl4JCSgjoTlfPhoNknGx2WPim+nT7xqYqIldlNzh0tLUfzXmVorGBBjBYRzwjeKZP9KjdKiFhOyv4OdIzVW9P60FaQEaEB2eM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ImCRwCAM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ImCRwCAM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D3671F000E9;
	Tue, 21 Jul 2026 21:39:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784669976;
	bh=6x43ghtTmO1rT1biFbXQbnWm++W2wn7Nwlk9BDWXEcs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ImCRwCAMHej1xhxYHNPOQdGQO1yt30qtb32WinuXJORrglZmP6SILIzXwYZfPVfRn
	 3ooLtsF5WGCEwBl37Tte2aHub8zjgGjV+s3xsqHCMMUizcqr93UfKSk6LY3uMh0UYk
	 XHCtMa+BK5iDS8kh3+m1ufIKCJ4Sq4hczKsS7Xgg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thorsten Blum <thorsten.blum@linux.dev>,
	Ingo Molnar <mingo@kernel.org>,
	"H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH 6.1 0759/1067] x86/boot: Validate console=uart8250 baud rate to fix early boot hang
Date: Tue, 21 Jul 2026 17:22:40 +0200
Message-ID: <20260721152441.549103516@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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


