Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68A4030DD2F;
	Sat, 12 Sep 2026 19:20:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789240812; cv=none; b=kjIJPcHJU3Sawc8VuhymaQK/uZVAYCgMgVHFNSIz9tYO3eu/tTNtmRYMWHWJ/tCtyGoe2Lg/A9FURS6WtWWxnIkDBwwYQEX2csUyipFSOAEnuUy/qfQ01lL1K7LKOAdgXotM9h2nXwrgJAZbkwdBDz1NYgZ6TL7+QjrgPL34tdU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789240812; c=relaxed/simple;
	bh=UUiJocF8qV7gd5kMuXB2TZt9CeYtKh8/3XE2r7mrbXA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FUdEQA3N9ZZnFZfFiQ/NB60i4EVYlNjq9lVC9RjfmKZ03LrtykzTNEWfKoXt7ssqN9Ap6IhUX2wj/DLB1B8S1iLOisoj51WSFigUUkSZ0pPnE3yBkEmywtRX8AxTWtT/NTeIfUC/3VfFglPCJRxXxHAXdUGOuhA5p7cmcnviXwY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZK6k018D; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZK6k018D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 491D21F000FF;
	Sat, 12 Sep 2026 19:20:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789240811;
	bh=0PmO4ENlgyR0hSWZN/7vGC6hAmGBHFfWRq7l0C1kH54=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZK6k018DuSxArXXKCB52EyT5DtBo1E4NrDVtY6HSPPcFlOODoK9c0ytNExutzRwxd
	 b9c/BSIHXvCmswnMd0asRlCLCfPpgTmLaoo8r/6cGuOhkwU7CO57x3fskeENHFppJC
	 PHnv5R5aPE1adRP1L9n+c9AwSSg+oMm0SjKGQGAQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fedor Pchelkin <pchelkin@ispras.ru>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 001/798] Revert "USB: serial: keyspan_pda: fix information leak"
Date: Sat, 12 Sep 2026 08:53:49 +0200
Message-ID: <20260912065516.988983643@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fedor Pchelkin <pchelkin@ispras.ru>

This reverts commit cccef1711efbcdbe999738ac27d37b9ef6271abd which is
commit 6bfc8d01ac4068eced509f8fc74d0cd205e4dcec upstream.

The 5.10 backport is incorrect - instead of keyspan_pda_write_start() it
touches the wrong function keyspan_pda_write() which now returns an
incorrect number of buffered bytes.

It turns out that the proper fix for keyspan_pda_write_start() has been
already incorporated into the ported version of upstream commit
034e38e8f687 ("USB: serial: keyspan_pda: add write-fifo support"), for
unknown reason.

Other stable kernels, starting with 5.15, got proper backports.

Found by Linux Verification Center (linuxtesting.org) with Svace static
analysis tool.

Signed-off-by: Fedor Pchelkin <pchelkin@ispras.ru>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/serial/keyspan_pda.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/serial/keyspan_pda.c b/drivers/usb/serial/keyspan_pda.c
index 21dfd9bdc1504..7141660d5d591 100644
--- a/drivers/usb/serial/keyspan_pda.c
+++ b/drivers/usb/serial/keyspan_pda.c
@@ -606,7 +606,7 @@ static int keyspan_pda_write(struct tty_struct *tty, struct usb_serial_port *por
 	if (rc)
 		return rc;
 
-	return 0;
+	return count;
 }
 
 static void keyspan_pda_dtr_rts(struct usb_serial_port *port, int on)
-- 
2.53.0



