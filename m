Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85A6F2DF126;
	Sat, 17 Oct 2026 17:24:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792257896; cv=none; b=kgbFRoGUanGmpR0jE6B1mZo5m4jFsk6B2JRuBOuxkdfvZl0hlu+r4VCqfmGaQSM5q1PVj05breF0aF7zZj3GqEeJbpg0Aco30Jv46QSfY3r/k8Pr1OpuR6W7kq6zxG8g1wmbtjyZrNXo876i0xGeaRNX5yW2d9gJfVSITuO35cA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792257896; c=relaxed/simple;
	bh=wd4IC8Ywi39xXr9ZAo2P11lhSiN7dPhvu64eRjxq/Vw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Nvk5vZTg8OsLCV8wxosUAWRqsYjI0XWE0VP+PzuRqV7haP5nT3NGFcrW7+f4eM2kyR1OE/95T9iZ1IR5ZMrohkrgxSMIaJ5r2ijGIQYVxM2y41SNuOdqqL8WJd/yd3AUuv1OEp4pDxDnyBHf4yTQMd24uTysk1Y3Nkflo/uxIyc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FPfWgBsj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FPfWgBsj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D21E41F000C5;
	Sat, 17 Oct 2026 17:24:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792257895;
	bh=lbzVW0+DGzRWnjriPZBC/DDBDeLKj1do5QgfKuTR2g8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FPfWgBsjnDylXtDJLzoljIW0SjCXM2a8C/Eiyb3U5TAq1ulfsSSOJ24ii+PLBc2W4
	 eehtOiYWef6yrhR/uZBHHvhMg95ns+dN+yptwVNTO1oMn6Vx44fDXAeNI0iyKoL7e2
	 j3rkyKxZVzE8kulLbDIDZejsAJcx6AXtXqK1D2vw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vivek Kasireddy <vivek.kasireddy@intel.com>,
	Jann Horn <jannh@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0663/1674] udmabuf: fix memory leak on last export_udmabuf() error path
Date: Sat, 17 Oct 2026 17:48:55 +0200
Message-ID: <20261017160448.128984890@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jann Horn <jannh@google.com>

[ Upstream commit f49856f525acd5bef52ae28b7da2e001bbe7439e ]

In export_udmabuf(), if dma_buf_fd() fails because the FD table is full, a
dma_buf owning the udmabuf has already been created; but the error handling
in udmabuf_create() will tear down the udmabuf without doing anything about
the containing dma_buf.

This leaves a dma_buf in memory that contains a dangling pointer; though
that doesn't seem to lead to anything bad except a memory leak.

Fix it by moving the dma_buf_fd() call out of export_udmabuf() so that we
can give it different error handling.

Note that the shape of this code changed a lot in commit 5e72b2b41a21
("udmabuf: convert udmabuf driver to use folios"); but the memory leak
seems to have existed since the introduction of udmabuf.

Fixes: fbb0de795078 ("Add udmabuf misc device")
Acked-by: Vivek Kasireddy <vivek.kasireddy@intel.com>
Signed-off-by: Jann Horn <jannh@google.com>
Signed-off-by: Vivek Kasireddy <vivek.kasireddy@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20241204-udmabuf-fixes-v2-3-23887289de1c@google.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma-buf/udmabuf.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/drivers/dma-buf/udmabuf.c b/drivers/dma-buf/udmabuf.c
index 12d49793b0f2d..ddf8a9a66c0cc 100644
--- a/drivers/dma-buf/udmabuf.c
+++ b/drivers/dma-buf/udmabuf.c
@@ -285,7 +285,17 @@ static long udmabuf_create(struct miscdevice *device,
 	flags = 0;
 	if (head->flags & UDMABUF_FLAGS_CLOEXEC)
 		flags |= O_CLOEXEC;
-	return dma_buf_fd(buf, flags);
+	/*
+	 * Ownership of ubuf is held by the dmabuf from here.
+	 * If the following dma_buf_fd() fails, dma_buf_put() cleans up both the
+	 * dmabuf and the ubuf (through udmabuf_ops.release).
+	 */
+
+	ret = dma_buf_fd(buf, flags);
+	if (ret < 0)
+		dma_buf_put(buf);
+
+	return ret;
 
 err:
 	while (pgbuf > 0)
-- 
2.53.0



