Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795620424;
	b=z8VztFqWK4GZzvzo8IOSx8WdJB0BvKpTykPBO49Pwfb7GYOELm6D231zVoXl0W7aUT7I
	 nfJFA6oFswIdidEaOpJgLtdpM3IeDsnneVvwWHx16krppQWCehqnCKf6V9qY1/TR14wiL
	 RH+9hF+8S/tXYGvBlgnqjA4MkDnx3IMatgrjT1ghDWljQkmb4l+VPCXJ3gFENSjuVl9fJ
	 gzhpMnJRATVCQsz/nA6PDNFAFVhwV9UA4G7eCw3oOtsHgkejOXlBnL5WavtT+Yi337eze
	 txGoQv8kDyCF+qqbDU5M9NEB9aZfjxn/ch1zpdq++zvys1Ra3AV20NQRAlDRkofe3lg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795620424;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=m3xtf5t4bHhJBIODasA01FmhCxRMcLoMSjkLiznKRV4=;
	b=3fjHzx0Qay5B3ZSoag4rh544xmGF9paYDoPELEfMiV9nJCXxCcptGmtgTcgue4IbjZWX
	 CZkOjKMBntlGgGMlL5hHDMs4YKubbx2J/9k0mwbFCLUEynJza83jQRH7BQ/pxlCpXxnHM
	 PdRM3xJcbcG5uUYR9Ixdt4CGX5YV2iX9FQZh/ygGuQUakOA5uKzgAY/PYD3WuFXTyLpRf
	 VNPLtTHdoik55rmczM69oKWAIbvYSlkviQNl1NivY40VyiHyp5UOFR2uFn0ptiekMiHOa
	 FddOnfIYlNPniIb7Huw8vc/eoODI1tEzg1KYZ002Z5KsgAOwLGf/6DaYZr+IChETDRg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Hi9Ii3vJ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32E0F606A31E;
	Wed, 25 Nov 2026 15:27:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Hi9Ii3vJ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 855821F000C6;
	Wed, 25 Nov 2026 15:27:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795620424;
	bh=m3xtf5t4bHhJBIODasA01FmhCxRMcLoMSjkLiznKRV4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Hi9Ii3vJVOVxFDS+K44Ehzpu9fcVfxEG7QeQXFS8gACpegKnN7cIxicW3y6mWmUoJ
	 SmGGlD1ak5ASzBud8Mr4LvA7Hd7PF/0AdjX4gwVjaqU7ZAksvJYzBcv1JkGZff9aIQ
	 VYVZ6XpTfL6pdCZr1o+SSGaulwGusnqsXv/SCSEE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Jiri Slaby (SUSE)" <jirislaby@kernel.org>
Subject: [PATCH 7.3 0913/1005] tty: fix misapplied compat_ptr() in tty_compat_ioctl()
Date: Wed, 25 Nov 2026 15:37:31 +0100
Message-ID: <20261125143843.079405410@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiri Slaby (SUSE) <jirislaby@kernel.org>

commit 895dc0eaa2779ff46a0b2a20b5ce9eb0b1125cb2 upstream.

Since commit f0193d3ea73b below, `cmd` was converted with compat_ptr(),
while `arg` was passed to ld->ops->ioctl() unmodified. Fix it so `cmd`
stays `cmd` and `arg` gets converted through compat_ptr() as intended.

Notes:
2) compat_ptr() did nothing to `cmd`, provided it is uint,
1) compat_ptr() is no-op everywhere (was different on s390 before
   8e0b986c59c6 ("s390: Remove compat support")),
3) `arg` might not have been chopped correctly until 8e0b986c59c6. But I
   am not sure why noone noticed all those (7) years (from f0193d3ea73b
   to 8e0b986c59c6)?

Fixes: f0193d3ea73b ("change semantics of ldisc ->compat_ioctl()")
Signed-off-by: Jiri Slaby (SUSE) <jirislaby@kernel.org>
Cc: stable@vger.kernel.org # applicable from 4.20 to 6.18 incl
Assisted-by: LLM
Link: https://patch.msgid.link/63e9d84a1e8e23852423206cf3f8907aafc88f17.1793704520.git.jirislaby@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/tty_io.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/tty/tty_io.c
+++ b/drivers/tty/tty_io.c
@@ -2969,8 +2969,7 @@ static long tty_compat_ioctl(struct file
 	if (ld->ops->compat_ioctl)
 		retval = ld->ops->compat_ioctl(tty, cmd, arg);
 	if (retval == -ENOIOCTLCMD && ld->ops->ioctl)
-		retval = ld->ops->ioctl(tty, (unsigned long)compat_ptr(cmd),
-				arg);
+		retval = ld->ops->ioctl(tty, cmd, (unsigned long)compat_ptr(arg));
 	tty_ldisc_deref(ld);
 
 	return retval;


