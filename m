Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9F063624A5;
	Sat, 12 Sep 2026 09:07:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789204025; cv=none; b=HV4IRGGebsQEpb+L+1cgpS4a3htolUu3DWSEB69hGcqhReeY7VVuuBbYhWhO5ccOuJpcHxfauFaky1944vM1zguASCRON+nw8LxTMQcQfYyGvYRAeqkS0QWzt8SLQBycGA2+YlBv97p7BBwsTrOmc+UY/s+i/RPMDzxXudMUb/o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789204025; c=relaxed/simple;
	bh=fwTUc9bx95zMnuZyIsU6TLzJtpJvWLPLVtdtXDj8lYw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AYDpMVv0aQXO7Oe+Uej1tHBnk85l9cFWH2XSY9+tNiPBiv/urLGvjqWJRJLwe6m0kNJFG8Xf6Xwh8XTZXI4VoAvu9MnUUoQzWz5gVzpYcdIflUqqGjDdmBAmW0YYI+XsFb5ET6K/X4FqzzsufaqGy0U+/GpkJEMdwiKMzQMqrP0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gcK6n9Z+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gcK6n9Z+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E02F21F00893;
	Sat, 12 Sep 2026 09:07:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789204024;
	bh=cl/bkWDxui1j3IQREh0ltdHdpGmRzwgWohbvJkaWTxY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gcK6n9Z+qop+82zugxziAW7wmOGYVHu9Vxr72yLgOcv81tLT53b+nD42j2LNfr5PH
	 m1iTKwraeR1AZxUFk5IjdqSWkwB8FjOKuANdHpHs+ymoC7fzTmurj4xSe65TDbdTtr
	 EUdFNnMhW+SChT9FzvADVAlUYR2EXm64JrcMLuhk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andreas Schwab <schwab@linux-m68k.org>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1528/1815] m68k: nfcon: Do not call console_is_registered() in nfcon_device()
Date: Sat, 12 Sep 2026 08:54:38 +0200
Message-ID: <20260912065724.876814995@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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



