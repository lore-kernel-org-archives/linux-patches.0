Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B77B3AC17;
	Sat, 12 Sep 2026 15:08:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789225715; cv=none; b=Zj8exwL+JI/pkpxgat8hzHmzr+Xkk4L7bLcV8KcqFPqCugdsK7E1QoLBRcr6PS6zWLKgZ757TQ0pXRtQVJdlQrZ3mGppTROFVEuRIrhwBH2d6PMUnJAl3+IcVgxbLfozkJSlUNGGIdBzLxG83HQQBs6Q6qQT/3palz1dyDLa3yA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789225715; c=relaxed/simple;
	bh=J9O+RbWSjyJSRYLm5D6kgL+BXwe5fVWrYsNLn/T/xww=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ribnaf5PjybouW3hRLRNIIdthAGzyTo20TQNpviWejuQaJGhWcTNdss6GMv0zqQnlLDtISNhvPvzIa77XmKid8KbNEuy9fNDggSv4I5UDVzTle5+0QyDKvhddr35tDILFcp0/28O0U0+9x1S++GB9lw7pG48nnQHpR5fV7R5NCY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XhaVDRnZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XhaVDRnZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C98C1F000FF;
	Sat, 12 Sep 2026 15:08:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789225714;
	bh=Llu6DioZzKEqESpHWbxJ4Xp292lUbqXJlEcEmk0BZxQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XhaVDRnZLx3vNjyg+zZXcGCzA65ggmOphpR0th1anzwMUq3//hzYIj4u1/RZKmJu2
	 QzlxH5QIc7GSqgpWoOVLw+P2s7qYAtEg+fLR2eYGGzAO+qY+nSkbmNoaVExHJaYObG
	 Efp1kny+795jIBSKtLCGjlnS23+nUdzA6hO3iGW0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andreas Schwab <schwab@linux-m68k.org>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1254/1424] m68k: nfcon: Do not call console_is_registered() in nfcon_device()
Date: Sat, 12 Sep 2026 09:01:26 +0200
Message-ID: <20260912065635.365395814@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andreas Schwab <schwab@linux-m68k.org>

[ Upstream commit 2f8e3cad53b5c36ab0ed5d3195bfc55c59ea61a5 ]

Since 7c2af0f634f1 ("tty: tty_io: use console_list_lock for list
synchronization") show_cons_active() calls the .device() method under
the console_list_lock, but console_is_registered() tries to acquire
console_list_lock as well, causing a deadlock.  It should not be
necessary to check console_is_registered() here since the function
should not be called in the fist place when the console is not
registered.

Fixes: 7c2af0f634f1 ("tty: tty_io: use console_list_lock for list synchronization")
Signed-off-by: Andreas Schwab <schwab@linux-m68k.org>
Reviewed-by: Geert Uytterhoeven <geert@linux-m68k.org>
Link: https://patch.msgid.link/87ecfzsv6h.fsf@igel.home
Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/m68k/emu/nfcon.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/m68k/emu/nfcon.c b/arch/m68k/emu/nfcon.c
index 3a74d493eb3e6..977209a28db61 100644
--- a/arch/m68k/emu/nfcon.c
+++ b/arch/m68k/emu/nfcon.c
@@ -49,7 +49,7 @@ static void nfcon_write(struct console *con, const char *str,
 static struct tty_driver *nfcon_device(struct console *con, int *index)
 {
 	*index = 0;
-	return console_is_registered(con) ? nfcon_tty_driver : NULL;
+	return nfcon_tty_driver;
 }
 
 static struct console nf_console = {
-- 
2.53.0



