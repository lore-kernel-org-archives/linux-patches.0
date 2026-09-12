Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1F4D429000;
	Sat, 12 Sep 2026 11:13:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789211620; cv=none; b=asouQpCuVEjcB4uu133bg+Ga6+5lgB3sFaOxqPHJYKsINjzdDi6jsEY5QTbzjJlNWbK77TLTdf6eSQ44MvHR/1b4E9cYes5/83JudAF7eW/b6cEKXb5OOfkWbFzEYiBgtfUGLi5bPSGHDIp3Nj1PuswdaWBlpFAiNHIIphL6OWg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789211620; c=relaxed/simple;
	bh=e7fwJzY7K5dimtywnqxY2TzytQzrhGazFP+B/S+V/kM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kFPHNV3taY3lpzmurTiuAlDn2MXWZA0FPSFcyVeWg0lFPE5WrFBXvkzQys/xrttTvY1Cpg/ndjjvEzg6OKfxF7lrTaN4QtjKzM0Jqa+2QOX4H/LcfDFiUA0/1AIAN/Eu8+TT9YvOyRVxBiL4dwerhH+d+DKbnaRtLP2bFdVIyAs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xnVqpeIh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xnVqpeIh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87BF71F000FF;
	Sat, 12 Sep 2026 11:13:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789211619;
	bh=SLDMyy75SEsIUUKtNTVnNcA94acmZHjT7sVnTKPPoSA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xnVqpeIhVaNm/ERkvrKvcbUeTyukxksQM6PF3gr50y39NkHRRA49ML0QRNsAW2zXk
	 9lkPog9RBCORpMEefaLpAUoyTWm25pzrTgNmd5z1IhGBnmXF31RZ9f+QwMaD9zygSy
	 N+GxxrI/z9tPjpqQtEG8xmx3OcteZo0Alx7nLud8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andreas Schwab <schwab@linux-m68k.org>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1241/1518] m68k: nfcon: Do not call console_is_registered() in nfcon_device()
Date: Sat, 12 Sep 2026 08:56:50 +0200
Message-ID: <20260912065651.579687829@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index d41260672e24b..f4657d9f4f153 100644
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



