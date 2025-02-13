Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67E842222D2;
	Thu, 13 Feb 2025 14:38:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739457502; cv=none; b=R8b7o4FD31p1I245U/MWANVMdO28wJiF1oGHEL6o8U5KsGQCnFRlEShF1xNUt/BfDn9216n9SMaU6HFJuVTtbcR/W6H7pG4P6rZj80i11BuGCsDVKmoiUfwGWvdQALPoBWT6Vny1uF+IHDX314Wjezy2XGmZDDN/97PMPDrSHpM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739457502; c=relaxed/simple;
	bh=UN6AzCGM7ji2VjYxqqEGpW1LciOD4gQfwKtOzMYRfcQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=p1la8dNwFltrXyZctgCtpynenV0NlUytHdY+xp+FA74IQCskLvDBjcDeK4PZPBtAE+2VJs7KUu+R3C69mLAqlFdGuXwleS4ZUZA53VwEyK/vVaySsHshVZhsG/A9BiU0ZS7TB7qgASPG4tE1zLLyjYGg0Vp9nJ02iDAcD/DngA4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zp+Fl3jO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zp+Fl3jO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC599C4CED1;
	Thu, 13 Feb 2025 14:38:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739457502;
	bh=UN6AzCGM7ji2VjYxqqEGpW1LciOD4gQfwKtOzMYRfcQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zp+Fl3jOvqX7Of5h9pffiLnhLezwW9BbXM7A4i5Ot+LeBZ1MizpjjOXyM4IBrPHmi
	 /uvyZitPdyenxsZ1eIhE91Y6TBfaOqPFNND0Np1lJ5Vl4lb4rX0JFjS4M5gj4IK4Pq
	 RN2dFxKVm5Sx/gw0vI7IuhHIQsKS0CBamZhQiTCw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	=?UTF-8?q?G=C3=BCnther=20Noack?= <gnoack@google.com>,
	Kees Cook <kees@kernel.org>
Subject: [PATCH 6.12 097/422] tty: Permit some TIOCL_SETSEL modes without CAP_SYS_ADMIN
Date: Thu, 13 Feb 2025 15:24:06 +0100
Message-ID: <20250213142440.299478951@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142436.408121546@linuxfoundation.org>
References: <20250213142436.408121546@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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


