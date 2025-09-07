Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE5411CDFAC;
	Sun,  7 Sep 2025 20:09:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757275780; cv=none; b=XmNDU+EnDrV6sLLHmUlzKzgQhjDidODlIPAm/m3I57NyMX03ZJKxuWO4uHoYzjd4D2aj9okRl7hq0Ytl6xGfxge9uMVjdRK8wIAZhNuShE76NI9T3wyH0vrftvil5tb/8wMBWT8npmsO3v3c4K354VK7rkPlYY8FV+lS8/b9ru4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757275780; c=relaxed/simple;
	bh=jgNLWj1bUxl7zpmQDJZuU6aJLQeOUdlDdgp78IlEALI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KX6cWWnVYIR8Q6N7vQNLwkDYJrUQGr4nEr8IzlTIOIV0yMmEOGjbosQFvC6QFFJsH0nauC6fDNkwMHywpdSH58lVuQIvgGLXr8qQHk9nDLYgI/WS2NhXGopxdKRe4d/u2ix7pf63okwcBfKoTChzcJHfSXbEF+7U0W+0LRN/eNA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tEa+go/v; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tEa+go/v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72BBAC4CEF0;
	Sun,  7 Sep 2025 20:09:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757275779;
	bh=jgNLWj1bUxl7zpmQDJZuU6aJLQeOUdlDdgp78IlEALI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tEa+go/vxYoxGBk4vgBQBH7OboV3ID6WFkRsNSn/mFqUIehLf54O/IIRPlilfc7/N
	 IDiS+6dy+nrrVxUUuQQcSAEGDWy33elakjXHBouHvj1loNaDnOdfX1ZRxTUz2M1snc
	 awlt+NDFG0RKaEpkrArgznROnT0lBPS7tlAzVlOM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nathan Chancellor <nathan@kernel.org>,
	Christophe Leroy <christophe.leroy@csgroup.eu>
Subject: [PATCH 5.4 01/45] powerpc: boot: Remove leading zero in label in udelay()
Date: Sun,  7 Sep 2025 21:57:47 +0200
Message-ID: <20250907195600.995944590@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195600.953058118@linuxfoundation.org>
References: <20250907195600.953058118@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nathan Chancellor <nathan@kernel.org>

When building powerpc configurations in linux-5.4.y with binutils 2.43
or newer, there is an assembler error in arch/powerpc/boot/util.S:

  arch/powerpc/boot/util.S: Assembler messages:
  arch/powerpc/boot/util.S:44: Error: junk at end of line, first unrecognized character is `0'
  arch/powerpc/boot/util.S:49: Error: syntax error; found `b', expected `,'
  arch/powerpc/boot/util.S:49: Error: junk at end of line: `b'

binutils 2.43 contains stricter parsing of certain labels [1], namely
that leading zeros are no longer allowed. The GNU assembler
documentation already somewhat forbade this construct:

  To define a local label, write a label of the form 'N:' (where N
  represents any non-negative integer).

Eliminate the leading zero in the label to fix the syntax error. This is
only needed in linux-5.4.y because commit 8b14e1dff067 ("powerpc: Remove
support for PowerPC 601") removed this code altogether in 5.10.

Link: https://sourceware.org/git/?p=binutils-gdb.git;a=commit;h=226749d5a6ff0d5c607d6428d6c81e1e7e7a994b [1]
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Reviewed-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/powerpc/boot/util.S |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/powerpc/boot/util.S
+++ b/arch/powerpc/boot/util.S
@@ -41,12 +41,12 @@ udelay:
 	srwi	r4,r4,16
 	cmpwi	0,r4,1		/* 601 ? */
 	bne	.Ludelay_not_601
-00:	li	r0,86	/* Instructions / microsecond? */
+0:	li	r0,86	/* Instructions / microsecond? */
 	mtctr	r0
 10:	addi	r0,r0,0 /* NOP */
 	bdnz	10b
 	subic.	r3,r3,1
-	bne	00b
+	bne	0b
 	blr
 
 .Ludelay_not_601:


