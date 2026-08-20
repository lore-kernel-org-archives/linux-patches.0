Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C180D37CD47;
	Thu, 20 Aug 2026 15:12:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787238740; cv=none; b=QWwdESzx5Ek/3tOPyRlf87AafIfuG8Vy7NmS3dqvqU85v//ojqO7PbTo8379VMncYL56qT5J9ySD9HJ9aTiTAPYdkdAeil4I4kgWKfhI0x0Cb5oYEG2AIdQsEgUT83rSmt2jdeFVuW5FyI31xzZuCjm33+9NV76qPPIKYnFyVnA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787238740; c=relaxed/simple;
	bh=thQRJD+PpBtPK8pI4UJ9fqK6L+ui9y8Yj5CHLO/m6eE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Zlk7U3IX/zlxAzqK3JZdrtqkThRjbCgcqloOl1GU+Iqau/oFQOyf9Z9+x/jfx5MAfJOrzlmQnUuddp5PMiIG1MFXkbz7dCTDzVlSOS5VYjlSl2BfP1pIhYgFy/RpjH/tGLviv0/R4WeK2lXm/9SWF+tnYyKjN6ML47yRbgEu3xk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UdER3Hon; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UdER3Hon"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB3A31F000E9;
	Thu, 20 Aug 2026 15:12:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787238739;
	bh=FfXiBnsicBQniKdYSUgpiHHbK/fHKoExljwoGNtwfII=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UdER3HonvH+0HJ2+bi4iBqS0TqbYIa+Io9EPl6JuvLAEoW4tP1I8Zptc7odQC+Nbc
	 Fvl6uMghBcaJvMhEFEJoR0YXEePseMgKG+FG/ztUmITg3GUeWlrczq1WOEvtayUufL
	 m0w/ruWtjqA8NniEseVk8UiWTZLsQx2GWgdLgnRc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mingyu Wang <25181214217@stu.xidian.edu.cn>,
	Helge Deller <deller@gmx.de>
Subject: [PATCH 6.18 024/217] fbdev: core: Fix pointer desynchronization in fb_io_read()
Date: Thu, 20 Aug 2026 16:53:12 +0200
Message-ID: <20260820145238.348527623@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145237.531699751@linuxfoundation.org>
References: <20260820145237.531699751@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -61,6 +61,14 @@ ssize_t fb_io_read(struct fb_info *info,
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


