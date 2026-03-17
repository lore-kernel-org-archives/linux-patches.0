Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFFBD3F54B4;
	Tue, 17 Mar 2026 16:47:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773766064; cv=none; b=WPNSJ7t1uOMzqZNpjQOTnVmnkOyvj1h/FT87UGT5ihJ7RytY2Wxh61BrFVnkykzFNREB0G8w/TbLvSnewaY3UGLVDKPuoETT+58YJPu94R6HIeJDXh8MeN2TKIYDikPY+6WUt6huBIz/RU8DIzXvP+R1fV/uywjtv7xiUtC+0SQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773766064; c=relaxed/simple;
	bh=exNmnKXBWp9ynKx0hL/6jStGWhE93C9oC7/IdFe3pdE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uu/neXBd7NzqY064bQ9YGQ7WTId3+Z+5uIbKMJ1u/vNVJfLXdHSnFjIWgy8D0/Za9QMez7qHnl6k/43Sw63kUsPQWjcV8qATDnvZTH5gXOkIVaNbpwpg0Vy0Qu24sq/czkPUyqSVSUV3Ky+HvILKrit5nkc47KwuvuUsYZthyCs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kcU0bVp0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kcU0bVp0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2036C2BC86;
	Tue, 17 Mar 2026 16:47:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773766064;
	bh=exNmnKXBWp9ynKx0hL/6jStGWhE93C9oC7/IdFe3pdE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kcU0bVp0RX7+FkcCuKjidOVqKsVgyELaHzWfHMgCUEqqX40XJe+5zwdMrgnPXAhNL
	 iTzN+RUGTgDvUDmMR8Hkcl0WIsFt9EzEh1kzdNgOtFd4TDIWPvJfzvo7zZ2xvE13zB
	 MSXPiYkyy3/2ujmmhOCPmVn24gVUoHwQJuV4K2SM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oliver Neukum <oneukum@suse.com>,
	stable <stable@kernel.org>
Subject: [PATCH 6.19 161/378] usb: mdc800: handle signal and read racing
Date: Tue, 17 Mar 2026 17:31:58 +0100
Message-ID: <20260317163012.935698613@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260317163006.959177102@linuxfoundation.org>
References: <20260317163006.959177102@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Oliver Neukum <oneukum@suse.com>

commit 2d6d260e9a3576256fe9ef6d1f7930c9ec348723 upstream.

If a signal arrives after a read has partially completed,
we need to return the number of bytes read. -EINTR is correct
only if that number is zero.

Signed-off-by: Oliver Neukum <oneukum@suse.com>
Cc: stable <stable@kernel.org>
Link: https://patch.msgid.link/20260209142048.1503791-1-oneukum@suse.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/image/mdc800.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/image/mdc800.c
+++ b/drivers/usb/image/mdc800.c
@@ -707,7 +707,7 @@ static ssize_t mdc800_device_read (struc
 		if (signal_pending (current)) 
 		{
 			mutex_unlock(&mdc800->io_lock);
-			return -EINTR;
+			return len == left ? -EINTR : len-left;
 		}
 
 		sts=left > (mdc800->out_count-mdc800->out_ptr)?mdc800->out_count-mdc800->out_ptr:left;


