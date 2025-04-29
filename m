Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CDD4229B05;
	Tue, 29 Apr 2025 17:02:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745946179; cv=none; b=iI4IuZjS5SjOZoSM3BMfpvQmM0FZNwGX8D0Reghc/YHkXKD8nrE5LbqFFZJUwBoi7jwzzSgj6gqyBXyLi5xZMbYZh/mWrK0zRRzmnf1/MNK4Uu7wMivNEZGQhTVN2y5QuTPVUhfQPdtIOyR0J3zwhCnEUQG9qKS1XuWXn9jeiBk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745946179; c=relaxed/simple;
	bh=jNTvtLRo+OwxmhOiqxY8wkN2aOBHarJe9b6EAceqPZ8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WPX2d0NP83dkOGKBCrW9JVUPpCwiEezf7ZJo6Cxt24G+xJ57l2vV6ukCRLm/v0G2ZOINN1dX5e1aFsfcH+Awm6BEozqVCZAIrbjp2hw3ubjWGQvPf9qKIMhdArk9/yHx46J3vz5XTiJcESymEZXKLpkIxYEwgPmKhs9z6Em/yi8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UIq6BQaz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UIq6BQaz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2A29C4CEE3;
	Tue, 29 Apr 2025 17:02:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745946179;
	bh=jNTvtLRo+OwxmhOiqxY8wkN2aOBHarJe9b6EAceqPZ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UIq6BQaz9o5xFtgcNcaeh0qbBnl/+VLrDVQtS9wjTniFqwvrT0O8KqX5XGceCbcVc
	 EYuy04Y47f6zNBgpogyaWa9D/ywcfbTxjpYj40G9cjzNa6fysxmy8DPK/O+kW9paRh
	 TqNN4hV2AF4bta8FL/iTNV9Z4FwTJy8fVsaJXmbs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jared Finder <jared@finder.org>,
	Jann Horn <jannh@google.com>,
	=?UTF-8?q?Hanno=20B=C3=B6ck?= <hanno@hboeck.de>,
	Jiri Slaby <jirislaby@kernel.org>,
	Kees Cook <kees@kernel.org>,
	stable <stable@kernel.org>,
	=?UTF-8?q?G=C3=BCnther=20Noack?= <gnoack3000@gmail.com>
Subject: [PATCH 6.14 152/311] tty: Require CAP_SYS_ADMIN for all usages of TIOCL_SELMOUSEREPORT
Date: Tue, 29 Apr 2025 18:39:49 +0200
Message-ID: <20250429161127.264130937@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161121.011111832@linuxfoundation.org>
References: <20250429161121.011111832@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Günther Noack <gnoack3000@gmail.com>

commit ee6a44da3c87cf64d67dd02be8c0127a5bf56175 upstream.

This requirement was overeagerly loosened in commit 2f83e38a095f
("tty: Permit some TIOCL_SETSEL modes without CAP_SYS_ADMIN"), but as
it turns out,

  (1) the logic I implemented there was inconsistent (apologies!),

  (2) TIOCL_SELMOUSEREPORT might actually be a small security risk
      after all, and

  (3) TIOCL_SELMOUSEREPORT is only meant to be used by the mouse
      daemon (GPM or Consolation), which runs as CAP_SYS_ADMIN
      already.

In more detail:

1. The previous patch has inconsistent logic:

   In commit 2f83e38a095f ("tty: Permit some TIOCL_SETSEL modes
   without CAP_SYS_ADMIN"), we checked for sel_mode ==
   TIOCL_SELMOUSEREPORT, but overlooked that the lower four bits of
   this "mode" parameter were actually used as an additional way to
   pass an argument.  So the patch did actually still require
   CAP_SYS_ADMIN, if any of the mouse button bits are set, but did not
   require it if none of the mouse buttons bits are set.

   This logic is inconsistent and was not intentional.  We should have
   the same policies for using TIOCL_SELMOUSEREPORT independent of the
   value of the "hidden" mouse button argument.

   I sent a separate documentation patch to the man page list with
   more details on TIOCL_SELMOUSEREPORT:
   https://lore.kernel.org/all/20250223091342.35523-2-gnoack3000@gmail.com/

2. TIOCL_SELMOUSEREPORT is indeed a potential security risk which can
   let an attacker simulate "keyboard" input to command line
   applications on the same terminal, like TIOCSTI and some other
   TIOCLINUX "selection mode" IOCTLs.

   By enabling mouse reporting on a terminal and then injecting mouse
   reports through TIOCL_SELMOUSEREPORT, an attacker can simulate
   mouse movements on the same terminal, similar to the TIOCSTI
   keystroke injection attacks that were previously possible with
   TIOCSTI and other TIOCL_SETSEL selection modes.

   Many programs (including libreadline/bash) are then prone to
   misinterpret these mouse reports as normal keyboard input because
   they do not expect input in the X11 mouse protocol form.  The
   attacker does not have complete control over the escape sequence,
   but they can at least control the values of two consecutive bytes
   in the binary mouse reporting escape sequence.

   I went into more detail on that in the discussion at
   https://lore.kernel.org/all/20250221.0a947528d8f3@gnoack.org/

   It is not equally trivial to simulate arbitrary keystrokes as it
   was with TIOCSTI (commit 83efeeeb3d04 ("tty: Allow TIOCSTI to be
   disabled")), but the general mechanism is there, and together with
   the small number of existing legit use cases (see below), it would
   be better to revert back to requiring CAP_SYS_ADMIN for
   TIOCL_SELMOUSEREPORT, as it was already the case before
   commit 2f83e38a095f ("tty: Permit some TIOCL_SETSEL modes without
   CAP_SYS_ADMIN").

3. TIOCL_SELMOUSEREPORT is only used by the mouse daemons (GPM or
   Consolation), and they are the only legit use case:

   To quote console_codes(4):

     The mouse tracking facility is intended to return
     xterm(1)-compatible mouse status reports.  Because the console
     driver has no way to know the device or type of the mouse, these
     reports are returned in the console input stream only when the
     virtual terminal driver receives a mouse update ioctl.  These
     ioctls must be generated by a mouse-aware user-mode application
     such as the gpm(8) daemon.

   Jared Finder has also confirmed in
   https://lore.kernel.org/all/491f3df9de6593df8e70dbe77614b026@finder.org/
   that Emacs does not call TIOCL_SELMOUSEREPORT directly, and it
   would be difficult to find good reasons for doing that, given that
   it would interfere with the reports that GPM is sending.

   More information on the interaction between GPM, terminals and the
   kernel with additional pointers is also available in this patch:
   https://lore.kernel.org/all/a773e48920aa104a65073671effbdee665c105fc.1603963593.git.tammo.block@gmail.com/

   For background on who else uses TIOCL_SELMOUSEREPORT: Debian Code
   search finds one page of results, the only two known callers are
   the two mouse daemons GPM and Consolation.  (GPM does not show up
   in the search results because it uses literal numbers to refer to
   TIOCLINUX-related enums.  I looked through GPM by hand instead.
   TIOCL_SELMOUSEREPORT is also not used from libgpm.)
   https://codesearch.debian.net/search?q=TIOCL_SELMOUSEREPORT

Cc: Jared Finder <jared@finder.org>
Cc: Jann Horn <jannh@google.com>
Cc: Hanno Böck <hanno@hboeck.de>
Cc: Jiri Slaby <jirislaby@kernel.org>
Cc: Kees Cook <kees@kernel.org>
Cc: stable <stable@kernel.org>
Fixes: 2f83e38a095f ("tty: Permit some TIOCL_SETSEL modes without CAP_SYS_ADMIN")
Signed-off-by: Günther Noack <gnoack3000@gmail.com>
Link: https://lore.kernel.org/r/20250411070144.3959-2-gnoack3000@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/vt/selection.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/drivers/tty/vt/selection.c
+++ b/drivers/tty/vt/selection.c
@@ -193,13 +193,12 @@ int set_selection_user(const struct tioc
 		return -EFAULT;
 
 	/*
-	 * TIOCL_SELCLEAR, TIOCL_SELPOINTER and TIOCL_SELMOUSEREPORT are OK to
-	 * use without CAP_SYS_ADMIN as they do not modify the selection.
+	 * TIOCL_SELCLEAR and TIOCL_SELPOINTER are OK to use without
+	 * CAP_SYS_ADMIN as they do not modify the selection.
 	 */
 	switch (v.sel_mode) {
 	case TIOCL_SELCLEAR:
 	case TIOCL_SELPOINTER:
-	case TIOCL_SELMOUSEREPORT:
 		break;
 	default:
 		if (!capable(CAP_SYS_ADMIN))


