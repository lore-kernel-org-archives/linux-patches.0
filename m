Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 481923E639D;
	Tue, 13 Oct 2026 12:38:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791895106; cv=none; b=BLP3oDzw4iRQnk+gbMlpcYSYDtpf25xiF5Tst9prIet7CGGtsVKAaFJuQO/f/3S/WKvX0bzO6dDXPTAZHn6U6rDLYAVOvhesPjwV2SCyaMa6nJySSPjFTFK9hQLl3c0Bxbg+tbrLx6XbvgP05OO4dBvV/gmAA58FzMVQT6aoNtw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791895106; c=relaxed/simple;
	bh=ZECm0moWcXUZSzabxPfWZJxKZ7VlXrGEA2D1ypg/fHo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c7ENvwlkqHDbhgI7Nwu6CZZGMy1CPiDxQoDPBaT4tKGGoUdgHX9mfrHZ8m7mJx2PUL71MbexLUEg7/8ZQoNCkH7ZtYYMTSXj4s5grFiIKGoAybcmC16NnNPc2gow6psXPX0mgMHWZqq1/Ee9+xaGwmf02e+mgb7HYgLmau8lFw4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BrMzcfiW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BrMzcfiW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FF201F00899;
	Tue, 13 Oct 2026 12:38:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791895105;
	bh=kF3Td9E4Rte7qqSIQLOld1MwpKSo1+hCOE96pDnrzJA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BrMzcfiWmXm2iQQhxc5xir8Aq5A+IHotJXwiwXyik0UB/tuNcBWxHPgf0UeJGMbTp
	 OCWyd5aYWjgKBsCpXyFDOpLrQERIzYuAXmh2YWyHDsyI2hC2gTfhq86ymwu0kODZaL
	 PGHJebXsmSTAA0RnoHNQPyDgeakEM+d2zwlyEobQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Joshua Rogers <linux@joshua.hu>,
	Jiri Slaby <jirislaby@kernel.org>
Subject: [PATCH 6.12 162/497] tty: vcc: hold port lock when clearing tty pointer in vcc_cleanup
Date: Tue, 13 Oct 2026 13:35:29 +0200
Message-ID: <20261013112911.734388920@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112907.864180619@linuxfoundation.org>
References: <20261013112907.864180619@linuxfoundation.org>
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

From: Joshua Rogers <linux@joshua.hu>

commit 03b49c991abb8d021ca6fe51cd173447236b0552 upstream.

vcc_cleanup() sets port->tty to NULL without holding port->lock, racing
with vcc_event() LDC callbacks that read port->tty under port->lock and
then use tty->port. This can cause a use-after-free when the callback
dereferences tty->port after cleanup has already destroyed and freed it.

Assisted-by: AISLE:Snapshot
Cc: stable <stable@kernel.org>
Signed-off-by: Joshua Rogers <linux@joshua.hu>
Reviewed-by: Jiri Slaby <jirislaby@kernel.org>
Link: https://patch.msgid.link/20260803-aisle-tty-vcc-v2-2-a50bc9b15193@linuxfoundation.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/vcc.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/tty/vcc.c
+++ b/drivers/tty/vcc.c
@@ -986,7 +986,8 @@ static void vcc_cleanup(struct tty_struc
 
 	port = vcc_get(tty->index, true);
 	if (port) {
-		port->tty = NULL;
+		scoped_guard(spinlock_irqsave, &port->lock)
+			port->tty = NULL;
 
 		if (port->removed) {
 			vcc_table_remove(tty->index);


