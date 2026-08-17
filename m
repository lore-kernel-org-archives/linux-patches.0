Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1BFA3BB57;
	Mon, 17 Aug 2026 13:43:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786974239; cv=none; b=TrdyrYYTP5LsmLvH37fyugnd54glvIZn/bb/Bx+0QOsrmpGzu+6g1lvF1tsN8rL5ntdhZdb2wstJ334GEvTKeqhGEhLq2pnNBcz3zMV44bPkM2jphtoXc7IhCU7Q1RdTOT750Td423Tx/gqaPfzdJODMj9peBc7gdKT6DQyelhw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786974239; c=relaxed/simple;
	bh=Ai+7IkpySoHeMRYVJqMR1F9zJLCJdEUZ1LDX06NHySA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=swt28WT2on5asa/FJXUSI1LlwHoMajyDfAsjrg6qhG4c38Y0F36XrQBqVcRDVCP6d/PgsXFJiwHj+7/kGHkdaBci7d43uN0UruNwipI2jGi3MVqn8QkjSj3eKfTjm+Hq9QqSgv75ShLtNHy3Nbr22pT7dSN7d+aetQ+bgTsvlhg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Q/q7Ydz8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q/q7Ydz8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 220761F000E9;
	Mon, 17 Aug 2026 13:43:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786974238;
	bh=aMvZ4ISD94jFG0tCVk4rnKWSKGS69LRjpaGu5ofrVkk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Q/q7Ydz80R3CtVJtTvsV9Ek9nJVN0xB4jVsHSeT1HZq12DzTf6AVHxLbMqRyxX1r3
	 3J/9bbqcgfulkQLP19Eg9MQ8ECSmkzxzyPd2ArIgGP8TFRH6z0brdgAWvnRX5jTXJu
	 xOTVoidNRLFyfKWwiQ1Tz+3M1NaiSTRRKrDHDOp4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Joshua Rogers <linux@joshua.hu>
Subject: [PATCH 7.1 138/271] vt: add permission check for KDSKBMETA ioctl
Date: Mon, 17 Aug 2026 15:31:03 +0200
Message-ID: <20260817132542.528446333@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132536.752504388@linuxfoundation.org>
References: <20260817132536.752504388@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joshua Rogers <linux@joshua.hu>

commit a7ad0034453ba4c353f9b8f810ee2569de33d283 upstream.

KDSKBMETA modifies keyboard meta mode but lacks the !perm check that all
other keyboard setter ioctls in vt_k_ioctl() enforce, allowing a process
to change meta mode on a non-controlling console without authorization.

Assisted-by: AISLE:Snapshot
Cc: stable <stable@kernel.org>
Signed-off-by: Joshua Rogers <linux@joshua.hu>
Link: https://patch.msgid.link/20260731-tty-vt-stuff-v1-2-be99b9da8e30@linuxfoundation.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/vt/vt_ioctl.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/tty/vt/vt_ioctl.c
+++ b/drivers/tty/vt/vt_ioctl.c
@@ -406,6 +406,8 @@ static int vt_k_ioctl(struct tty_struct
 	/* this could be folded into KDSKBMODE, but for compatibility
 	   reasons it is not so easy to fold KDGKBMETA into KDGKBMODE */
 	case KDSKBMETA:
+		if (!perm)
+			return -EPERM;
 		return vt_do_kdskbmeta(console, arg);
 
 	case KDGKBMETA:


