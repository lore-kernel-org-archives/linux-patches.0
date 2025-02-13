Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A604813F434;
	Thu, 13 Feb 2025 15:03:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739458988; cv=none; b=gCQp8Vr507GLKprvG+ltLh833f1YqE3Pv0wX4q5kpFZt5guRvTjvWfnDB9BGSfq3l+5fQsBdmuc9cZe1dey1KfnSQSS5px81MKLIHQxF6yVm9DqZJhSGRw526Tux1x1zeOypZvC7ETpJ4h1l7EUTmV+poF396HaTUwtvja8M0Yk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739458988; c=relaxed/simple;
	bh=Dao3p7888tod6HkIlDLt2OUxrSF8Gqw54vduWM/xNMI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=IT258syPwcsIbp1WpRGWwMmKp7/o8vgXCppHzhLOgq/B6bxYzU8ATjogDKg5UTHfLyQlMascErdKlggGe3R8dQay0d6GwU65uiHngT+J3x5y+fB2x6irxoMhBltvxL1Nm2hWtt9G352wuieFZ9s+s23yrXzSLpAU/jGxD2PHqzw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=w7ZkS4/V; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="w7ZkS4/V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13412C4CED1;
	Thu, 13 Feb 2025 15:03:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739458988;
	bh=Dao3p7888tod6HkIlDLt2OUxrSF8Gqw54vduWM/xNMI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=w7ZkS4/VGWg6O4wGazOGTpL2lp5eC3EwG7XspWvkHAFYeLnYpdMBYgTMI7PUZlVOj
	 rmkMQFCVSfeZIYMS+qNoXJFxUzeBLUJD587do2MbknEXbXF8N+tqJK4hWb6yl+ZMji
	 Ga7UrB5Pqi0E/CkFDeXLkQi9rN7wxs5t+2dSZ51s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	=?UTF-8?q?G=C3=BCnther=20Noack?= <gnoack@google.com>,
	Kees Cook <kees@kernel.org>
Subject: [PATCH 6.13 103/443] tty: Permit some TIOCL_SETSEL modes without CAP_SYS_ADMIN
Date: Thu, 13 Feb 2025 15:24:28 +0100
Message-ID: <20250213142444.586039894@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142440.609878115@linuxfoundation.org>
References: <20250213142440.609878115@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Günther Noack <gnoack@google.com>

commit 2f83e38a095f8bf7c6029883d894668b03b9bd93 upstream.

With this, processes without CAP_SYS_ADMIN are able to use TIOCLINUX with
subcode TIOCL_SETSEL, in the selection modes TIOCL_SETPOINTER,
TIOCL_SELCLEAR and TIOCL_SELMOUSEREPORT.

TIOCL_SETSEL was previously changed to require CAP_SYS_ADMIN, as this IOCTL
let callers change the selection buffer and could be used to simulate
keypresses.  These three TIOCL_SETSEL selection modes, however, are safe to
use, as they do not modify the selection buffer.

This fixes a mouse support regression that affected Emacs (invisible mouse
cursor).

Cc: stable <stable@kernel.org>
Link: https://lore.kernel.org/r/ee3ec63269b43b34e1c90dd8c9743bf8@finder.org
Fixes: 8d1b43f6a6df ("tty: Restrict access to TIOCLINUX' copy-and-paste subcommands")
Signed-off-by: Günther Noack <gnoack@google.com>
Reviewed-by: Kees Cook <kees@kernel.org>
Link: https://lore.kernel.org/r/20250110142122.1013222-1-gnoack@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/vt/selection.c |   14 ++++++++++++++
 drivers/tty/vt/vt.c        |    2 --
 2 files changed, 14 insertions(+), 2 deletions(-)

--- a/drivers/tty/vt/selection.c
+++ b/drivers/tty/vt/selection.c
@@ -192,6 +192,20 @@ int set_selection_user(const struct tioc
 	if (copy_from_user(&v, sel, sizeof(*sel)))
 		return -EFAULT;
 
+	/*
+	 * TIOCL_SELCLEAR, TIOCL_SELPOINTER and TIOCL_SELMOUSEREPORT are OK to
+	 * use without CAP_SYS_ADMIN as they do not modify the selection.
+	 */
+	switch (v.sel_mode) {
+	case TIOCL_SELCLEAR:
+	case TIOCL_SELPOINTER:
+	case TIOCL_SELMOUSEREPORT:
+		break;
+	default:
+		if (!capable(CAP_SYS_ADMIN))
+			return -EPERM;
+	}
+
 	return set_selection_kernel(&v, tty);
 }
 
--- a/drivers/tty/vt/vt.c
+++ b/drivers/tty/vt/vt.c
@@ -3345,8 +3345,6 @@ int tioclinux(struct tty_struct *tty, un
 
 	switch (type) {
 	case TIOCL_SETSEL:
-		if (!capable(CAP_SYS_ADMIN))
-			return -EPERM;
 		return set_selection_user(param, tty);
 	case TIOCL_PASTESEL:
 		if (!capable(CAP_SYS_ADMIN))


