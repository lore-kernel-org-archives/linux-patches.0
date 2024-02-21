Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6482879DBF;
	Wed, 21 Feb 2024 14:05:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708524329; cv=none; b=gU1IfBLwDrF7Uk9XiO4y4JiZvyHfofewOZPByq+ONGNmv45wkIZMYndHVvbOc5hSu+f/Ro3XkxM7DO9AkOrAfN7kup++VHDSgr40IXzH8J9h7PCaRQ4Q+sRP3WLRnWHStaac/vQGze+jDe4Zu1EM1gelK4BRCunDg/3Wa+Wiiws=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708524329; c=relaxed/simple;
	bh=jrj298DkiZB5G8L0m9FYzgXQTyZn+GrHlSa9mS181kI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=elTMcyLl5riMERYZaGz0ra0z13uxuS14p39JqJUex8ObBBOnR1VNOpdRqjF4NuQV/KxPBvuTVjsQA2jKTN38W3U2FZ7OQwo2fbq4PInYePWkg3XvUksn3rdQ9t5DoEHXh8R8IVwtBL9F5baIIpoQI9KybvKKn8u+u7VSVYgX9hs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=A9apgEaN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="A9apgEaN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C36EEC43394;
	Wed, 21 Feb 2024 14:05:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708524329;
	bh=jrj298DkiZB5G8L0m9FYzgXQTyZn+GrHlSa9mS181kI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=A9apgEaNjGK5tJ489FIboDtZChN35/3wxG5kZBfn4GSo0/w0uBbd87AYSsg9NzLkZ
	 GCe6eXvm3rs4EN8Mg3jjSVSehDegWq0IMFsn4hKR5u/IOMPVHCGMuoBD3gmGMvQVGO
	 IMsRs1wiC6T/XvGc0I4zuTc3n1MfrUfDeBWnQjgE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Brauner <brauner@kernel.org>,
	Adrian Reber <areber@redhat.com>,
	Andrei Vagin <avagin@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 210/379] tty: allow TIOCSLCKTRMIOS with CAP_CHECKPOINT_RESTORE
Date: Wed, 21 Feb 2024 14:06:29 +0100
Message-ID: <20240221130001.113226078@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125954.917878865@linuxfoundation.org>
References: <20240221125954.917878865@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Adrian Reber <areber@redhat.com>

[ Upstream commit e0f25b8992345aa5f113da2815f5add98738c611 ]

The capability CAP_CHECKPOINT_RESTORE was introduced to allow non-root
users to checkpoint and restore processes as non-root with CRIU.

This change extends CAP_CHECKPOINT_RESTORE to enable the CRIU option
'--shell-job' as non-root. CRIU's man-page describes the '--shell-job'
option like this:

  Allow one to dump shell jobs. This implies the restored task will
  inherit session and process group ID from the criu itself. This option
  also allows to migrate a single external tty connection, to migrate
  applications like top.

TIOCSLCKTRMIOS can only be done if the process has CAP_SYS_ADMIN and
this change extends it to CAP_SYS_ADMIN or CAP_CHECKPOINT_RESTORE.

With this change it is possible to checkpoint and restore processes
which have a tty connection as non-root if CAP_CHECKPOINT_RESTORE is
set.

Acked-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Adrian Reber <areber@redhat.com>
Acked-by: Andrei Vagin <avagin@gmail.com>
Link: https://lore.kernel.org/r/20231208143656.1019-1-areber@redhat.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/tty_ioctl.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/tty/tty_ioctl.c b/drivers/tty/tty_ioctl.c
index 12a30329abdb..7ae2630cb750 100644
--- a/drivers/tty/tty_ioctl.c
+++ b/drivers/tty/tty_ioctl.c
@@ -763,7 +763,7 @@ int tty_mode_ioctl(struct tty_struct *tty, struct file *file,
 			ret = -EFAULT;
 		return ret;
 	case TIOCSLCKTRMIOS:
-		if (!capable(CAP_SYS_ADMIN))
+		if (!checkpoint_restore_ns_capable(&init_user_ns))
 			return -EPERM;
 		copy_termios_locked(real_tty, &kterm);
 		if (user_termios_to_kernel_termios(&kterm,
@@ -780,7 +780,7 @@ int tty_mode_ioctl(struct tty_struct *tty, struct file *file,
 			ret = -EFAULT;
 		return ret;
 	case TIOCSLCKTRMIOS:
-		if (!capable(CAP_SYS_ADMIN))
+		if (!checkpoint_restore_ns_capable(&init_user_ns))
 			return -EPERM;
 		copy_termios_locked(real_tty, &kterm);
 		if (user_termios_to_kernel_termios_1(&kterm,
-- 
2.43.0



