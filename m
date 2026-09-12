Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0555137FF60;
	Sat, 12 Sep 2026 13:09:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789218586; cv=none; b=hv2EJGGIyw9/pRqj1ivyLZORkJgfRd3vW5OvG7wb43lotKm1feyrwVPd+bMxXDNfNUni4T464c+SCSbdljZfHjouWSrAckRRC0UnEfI/O+51sJxXi2ECP8cIheGko8ApzOyzu9pZoVDvkZo02AlHK/rH+lafrcpt6zFCSUTU9LY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789218586; c=relaxed/simple;
	bh=edMnLONHEjvRfv/OKcUHgNZBn7WrmL5RvHBuE+xw/uI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZeMwtpkum6JhIS3TXi3a95hwW0qqvpV2DSWYhdnd9SnxMByD8XjOxCAEyf4eKLqvgbiDB2uQWlYm7doue3ToB/SzcPWZUy9y7UtAxo3SDcNvu1RUlSHLqvxVCJn0mSYxb6C7Ufb/QHzM6Lkj9qNKqcN0FEFNc1TyHOuDwFNOqx0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pwjnSmw/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pwjnSmw/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B59D11F000FF;
	Sat, 12 Sep 2026 13:09:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789218584;
	bh=MN3eN54fmOoTrHLWQfRfEPTLsbaayU/qFna/NQKwKf0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pwjnSmw/ky89dQE1HmqMPy+DJknAfcCxy7L8VWqUu+MKDcIkU3t7CNuSkQkowXtr5
	 QxIRziA108d/S8wEXSTAzPxk4nYLlKe1bgRkxJokyQrLp5fyrQ95w/mSd8Jgrv4TYO
	 Os+9RHc15ycaucQW7/osEnmTIuGGFXQDoBXe/Iv0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andreas Schwab <schwab@linux-m68k.org>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1175/1376] m68k: nfcon: Do not call console_is_registered() in nfcon_device()
Date: Sat, 12 Sep 2026 09:00:01 +0200
Message-ID: <20260912065633.739891622@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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



