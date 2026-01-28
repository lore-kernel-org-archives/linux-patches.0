Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE46830E0D6;
	Wed, 28 Jan 2026 15:43:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769614986; cv=none; b=iTg6hOubMWGz6oVavUAE3QBdMMIsSycs6atrZs9yD82WdXRVO4e/RlyWYCt8K4kjize9nbjhcNQudS05KwtjSM6c7w9j0dLQj6sLUO1PypVXJ04h1c8ICXmbCSoH7zc4eaTuCJlDX+o8pts3ggFzF+fzEIF/7Y5yp/Unbw578go=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769614986; c=relaxed/simple;
	bh=EOixVpeE+RsakAkpdpjpryhTBVE/oo5/E+k1ESd9AV8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bPFMu+eHwOmOBxfiiYyBw2Y7DzaQo/UosZG70yuJzls2YlZ1pXpk+VWmY3toieU8FVNCvHYy/HwSm5p7y621DIjcSCi+8z28TQjXVwHpAare2MKr6JKxGxB+14myb9hjdQF60vuAC29KSN/V9q8bX6UHz814yp2UqiuEQTpcEt8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gvVj3KeR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gvVj3KeR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5EBAC4CEF7;
	Wed, 28 Jan 2026 15:43:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769614986;
	bh=EOixVpeE+RsakAkpdpjpryhTBVE/oo5/E+k1ESd9AV8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gvVj3KeREcp8m/hqOY7Csf5Vu2WrVA/15LFGdy8rH57fgbNZfpP34F7O1Q5VZ6lsc
	 dcPezRucPyL02hIAs69TvT5TcIMWCept3G6nHIw9W22fvhQUmDf1Nb9ujER1Hejdw5
	 mU7aHSVkkKNhdTy1A1eN6vsuHsKMfdzon9WG5Apk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Marnix Rijnart <marnix.rijnart@iwell.eu>
Subject: [PATCH 6.12 043/169] serial: 8250_pci: Fix broken RS485 for F81504/508/512
Date: Wed, 28 Jan 2026 16:22:06 +0100
Message-ID: <20260128145335.569121457@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260128145334.006287341@linuxfoundation.org>
References: <20260128145334.006287341@linuxfoundation.org>
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

From: Marnix Rijnart <marnix.rijnart@iwell.eu>

commit 27aff0a56b3c77ea1a73641c9b3c4172a8f7238f upstream.

Fintek F81504/508/512 can support both RTS_ON_SEND and RTS_AFTER_SEND,
but pci_fintek_rs485_supported only announces the former.

This makes it impossible to unset SER_RS485_RTS_ON_SEND from
userspace because of uart_sanitize_serial_rs485(). Some devices
with these chips need RTS low on TX, so they are effectively broken.

Fix this by announcing the support for SER_RS485_RTS_AFTER_SEND,
similar to commit 068d35a7be65 ("serial: sc16is7xx: announce support
for SER_RS485_RTS_ON_SEND").

Fixes: 4afeced55baa ("serial: core: fix sanitizing check for RTS settings")
Cc: stable <stable@kernel.org>
Signed-off-by: Marnix Rijnart <marnix.rijnart@iwell.eu>
Link: https://patch.msgid.link/20260112000931.61703-1-marnix.rijnart@iwell.eu
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/8250/8250_pci.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/tty/serial/8250/8250_pci.c
+++ b/drivers/tty/serial/8250/8250_pci.c
@@ -1641,7 +1641,7 @@ static int pci_fintek_rs485_config(struc
 }
 
 static const struct serial_rs485 pci_fintek_rs485_supported = {
-	.flags = SER_RS485_ENABLED | SER_RS485_RTS_ON_SEND,
+	.flags = SER_RS485_ENABLED | SER_RS485_RTS_ON_SEND | SER_RS485_RTS_AFTER_SEND,
 	/* F81504/508/512 does not support RTS delay before or after send */
 };
 


