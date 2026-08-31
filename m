Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DA12599A40;
	Mon, 31 Aug 2026 13:51:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184300; cv=none; b=gER8rRhjiwnCYbpKvFfWNS9wotSMbJANqZdZ5YzlNG3ely4ax0Zr+h19MPo0urpSN9lWGPImi866gUjkdrzcWI/qRX8YYMbSlsWIFY5toA1f5WBKtvbUNG2yzOpNt4uzRgPjbqLRaGZfZTty/lte862aWnEUEvuXKLVnOWl3VeU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184300; c=relaxed/simple;
	bh=5j7ukQfYcwqTPg+p0PJkC26jROQHlilS0jNTdDh0jfA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qT3mwHE3KxXyZOnc1L5pvjAa03RDr3JIJ9dDcSv1Fzq2T1KJBrIokz31/1sPOol28odQ+YXmKQ6D9JQtWcjKbtT283g0GLB5dvQQf5L3sjGzqYChTmh5/U2arEN0Hk8TAeSoUVsQPLF2ytTXTkoBTUFwpmiSuMkrOG5fj5JS4mE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ert+EjQn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ert+EjQn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DD5E1F00A3F;
	Mon, 31 Aug 2026 13:51:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788184297;
	bh=E9oQgUW0njuWmWqr+Y+67jLm7u1duPPbAkX/fZ75Bx4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ert+EjQnm7Q38mZPnMiJZu2TiPii224XtdnyxndGqbIWSREBwppd5zgiY/yaxFKVy
	 9omhJnmZuTptdTZRFEcxComVwI+X3moDz//g/28vrvYZVeX/Zv7s51A6V+TB6mCQJL
	 oLn0ajrzN6gDmXII+PFWJPiq2UZfGipoDk1kvDN4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haoxiang Li <lihaoxiang@isrc.iscas.ac.cn>,
	Samuel Thibault <samuel.thibault@ens-lyon.org>
Subject: [PATCH 6.12 57/99] accessibility: speakup: unregister tty ldisc on later init failures
Date: Mon, 31 Aug 2026 15:34:26 +0200
Message-ID: <20260831133402.872385034@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260831133359.740409777@linuxfoundation.org>
References: <20260831133359.740409777@linuxfoundation.org>
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

From: Haoxiang Li <lihaoxiang@isrc.iscas.ac.cn>

commit a76acbaec9b8fd74413646984d2e3626d0543e39 upstream.

The ldisc registration is intentionally non-fatal, since some synth
drivers do not use tty/ldisc.  However, once speakup_init() continues
past the registration point and later fails, the init unwind path should
mirror speakup_exit() and call spk_ttyio_unregister_ldisc().

Add the missing unregister call to the error path after synth_release(),
matching the normal module exit cleanup order.

Signed-off-by: Haoxiang Li <lihaoxiang@isrc.iscas.ac.cn>
Signed-off-by: Samuel Thibault <samuel.thibault@ens-lyon.org>
Fixes: e23a9b439ce9 ("staging: speakup: safely register and unregister ldisc")
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20260531230804.254962-16-samuel.thibault@ens-lyon.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/accessibility/speakup/main.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/accessibility/speakup/main.c
+++ b/drivers/accessibility/speakup/main.c
@@ -2444,6 +2444,7 @@ error_kbdnotifier:
 	mutex_lock(&spk_mutex);
 	synth_release();
 	mutex_unlock(&spk_mutex);
+	spk_ttyio_unregister_ldisc();
 	speakup_kobj_exit();
 
 error_kobjects:


