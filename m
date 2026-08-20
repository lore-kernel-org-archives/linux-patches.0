Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF07F37F738;
	Thu, 20 Aug 2026 15:22:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787239381; cv=none; b=dedyFkB+1VLN97jaBybCWNIeV9Wy4os4w1aJ57vbkSk71or8wNKuYeLBwGO5XldBUnW/qJ08XH22c5czypRC/dfSk0RE2iIflLh0aRwdGYH7Ll7h0TkDpjQ92aG2J931GVSPNw0gJ56iIC/QYaR0N3YUl0GzWmlTJ6qrU7TdJLc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787239381; c=relaxed/simple;
	bh=r7+4xFElIGZiBRy4pQV+/M5XtUTwvV20yyzQa6QjEKg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mJBfjwoRIU1MKBFHX7NAkhxSBJmHVSbGe9vvy1Li4f5rsOGdlhM7H1g4kGvt2tKADjZJtXpSUcSHimJViNWt4qZB/CDDnIwRoZf9rEhtYeUeBZGjQPpjeBYtWjWgn6/hduzOBtJ9wEz/fbYmLQ0NtTeVtzzQySMfJeFb+ShZw1g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=A78DpxA5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="A78DpxA5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54ED71F000E9;
	Thu, 20 Aug 2026 15:22:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787239379;
	bh=imgUFO6TFJVQvqoKEhOt2BQYxLsibLf8gPlwyR1ysTs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=A78DpxA55ei1cS4KRD/ELS1w335eATPjaR6e7w2C73hiCVBjWm69/tqwOJgefKlD4
	 XnNu09A/YMtYVu/sn9zBCzPtXF2z1lRKvpPmQFA658N31F7Pa1XfxM3apl/bJpPno1
	 lhccQZyFkuMJ+/PNZOZmZbUIVd3qCIHQfSc93BUc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mingyu Wang <25181214217@stu.xidian.edu.cn>,
	Helge Deller <deller@gmx.de>
Subject: [PATCH 6.12 030/220] fbdev: core: Fix pointer desynchronization in fb_io_read()
Date: Thu, 20 Aug 2026 16:53:40 +0200
Message-ID: <20260820145224.406583130@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145223.480031205@linuxfoundation.org>
References: <20260820145223.480031205@linuxfoundation.org>
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

From: Mingyu Wang <25181214217@stu.xidian.edu.cn>

commit 81cc73be40c6f028f1ee3f438ace46afe666dbae upstream.

In fb_io_read(), if copy_to_user() performs a partial copy (e.g., due to
a faulty user buffer), the loop adjusts the chunk size 'c' and updates
the remaining 'count'. However, the hardware 'src' pointer has already
been eagerly advanced by the original chunk size.

If the loop is allowed to continue, the read will resume from an
incorrect, over-advanced offset. Since the remaining 'count' was only
decremented by the successful bytes, this desynchronization causes the
next iterations to execute more hardware reads than originally bounded,
eventually leading to out-of-bounds I/O reads.

Fix this by breaking out of the loop immediately upon a partial
copy_to_user(). A partial copy indicates a faulty user buffer, making
subsequent read attempts futile. Breaking out ensures we return the
number of successfully read bytes without risking out-of-bounds hardware
accesses in subsequent mismatched iterations.

Fixes: 6121cd9ef911 ("fbdev: Move I/O read and write code into helper functions")
Cc: stable@vger.kernel.org
Signed-off-by: Mingyu Wang <25181214217@stu.xidian.edu.cn>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/video/fbdev/core/fb_io_fops.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/drivers/video/fbdev/core/fb_io_fops.c
+++ b/drivers/video/fbdev/core/fb_io_fops.c
@@ -60,6 +60,14 @@ ssize_t fb_io_read(struct fb_info *info,
 		buf += c;
 		cnt += c;
 		count -= c;
+
+		/*
+		 * If there was a partial copy, the user buffer is faulty.
+		 * Break out to avoid over-advancing the src pointer and
+		 * reading out of bounds in the next iteration.
+		 */
+		if (trailing)
+			break;
 	}
 
 	kfree(buffer);


