Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17007350286;
	Tue, 16 Dec 2025 12:24:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765887866; cv=none; b=Zr6rAVayDxRN9bLCy6iCkXsAz0J/syKc6D47S5rmH+P928qWN8zpZaIfmuxb1c3AmnivhXF9t1ebHyTKwdllLgNio3b1Qx9yOT456Zm4NNL851lhGQyB6fnxTD94N+KyodHmCjyviMWhVqgSz5jRjvC7tmUEgogUSTYkDwPTaUQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765887866; c=relaxed/simple;
	bh=e7Pf0aiM7N8eQlPPup6svKtsnCBcLnPsp9hoQQirutE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sFeDMsgE6H1cw2nTdTCqjbWA9hk96wVhTZFAkApFSXaOTmm9j02XNaVUgVYR5o0/HAjblqUmF6uQ/skOaPbrSrmMOhDEHKWbyrKPD0KAMF67T9Cj+bpuiQXhkAhtAOmGW/yHymixJbt4jB70Jaz3ywGuVJ+/AiNzWR3vPq2TiC0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZQQZvzoC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZQQZvzoC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A5C7C4CEF1;
	Tue, 16 Dec 2025 12:24:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765887865;
	bh=e7Pf0aiM7N8eQlPPup6svKtsnCBcLnPsp9hoQQirutE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZQQZvzoCyEYTMAY4IrxW0uwQfwApo7U4psyJlHsjE1zUy4HhNqXK/z3gEZ2EpKFC+
	 Ic9ONeiXqoSNC5uFmNS6xNlFy7JZz1CvtohCR6i0JXGT+jofM8/UoxEIddmn2e5Dry
	 kXbMXaJ/I+8zsLHuhHVWeQDnIgzlrCYMKwgIk1Js=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oliver Neukum <oneukum@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 362/614] usb: chaoskey: fix locking for O_NONBLOCK
Date: Tue, 16 Dec 2025 12:12:09 +0100
Message-ID: <20251216111414.476311325@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111401.280873349@linuxfoundation.org>
References: <20251216111401.280873349@linuxfoundation.org>
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

From: Oliver Neukum <oneukum@suse.com>

[ Upstream commit a2fa8a12e6bc9d89c0505b8dd7ae38ec173d25de ]

A failure to take a lock with O_NONBLOCK needs to result
in -EAGAIN. Change it.

Fixes: 66e3e591891da ("usb: Add driver for Altus Metrum ChaosKey device (v2)")
Signed-off-by: Oliver Neukum <oneukum@suse.com>
Link: https://patch.msgid.link/20251030093918.2248104-1-oneukum@suse.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/misc/chaoskey.c | 16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/misc/chaoskey.c b/drivers/usb/misc/chaoskey.c
index 225863321dc47..45cff32656c6e 100644
--- a/drivers/usb/misc/chaoskey.c
+++ b/drivers/usb/misc/chaoskey.c
@@ -444,9 +444,19 @@ static ssize_t chaoskey_read(struct file *file,
 			goto bail;
 		mutex_unlock(&dev->rng_lock);
 
-		result = mutex_lock_interruptible(&dev->lock);
-		if (result)
-			goto bail;
+		if (file->f_flags & O_NONBLOCK) {
+			result = mutex_trylock(&dev->lock);
+			if (result == 0) {
+				result = -EAGAIN;
+				goto bail;
+			} else {
+				result = 0;
+			}
+		} else {
+			result = mutex_lock_interruptible(&dev->lock);
+			if (result)
+				goto bail;
+		}
 		if (dev->valid == dev->used) {
 			result = _chaoskey_fill(dev);
 			if (result < 0) {
-- 
2.51.0



