Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4C2538910F;
	Tue, 21 Jul 2026 18:56:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784660220; cv=none; b=jqRiT4L0K4bumbSePXE8aNegefwWHwzy2OoY2iGJR0KgYbkIDGREdT/kHegwKoPqUvlJH89B5WA/zlDb76Tj/+Qqwac1p7JEVz4lPKTa68HwYJP6O6Hi5DxcMEopCqUCIU07XNfrhD9MuVeHDjRf4LFrzq7L3UCmp6y6nNt/nNY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784660220; c=relaxed/simple;
	bh=5KbJwdcC3GlWoMrZjkwxnRCPZbEY0AREvOZeJJetjik=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YtNzqPCQzFCcVMJQS7DY1NDwzmNfLP6MA+7MG83FEX7Wkm70CWEW2EYhYGakkv9cih9AplMSoLzNkilGOY07/X6Q27HciNv1t5raeB83SxJcWYDvg4KIy1dBg8GFWXqszUdeE2Z6J9yhPsNyf2I9fsr+SbFgSrKRnJxiKtdgpnA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pfUwdRby; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pfUwdRby"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41BB61F00A3A;
	Tue, 21 Jul 2026 18:56:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784660218;
	bh=Euzt9CgVZFVTUb33wx+T08pXgdknt5oV+5gWBjp9xj4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pfUwdRbyfgWU2ham+1XNRcuEtZrvC/O1Ad6N93gj4FB4rLzLAD+w/H4crKXgdu332
	 LiQPxS2oqu4ytPIJxlyeB3Q1bDNLwF9cOvy5sSRx84NDr+QYgNQZ3QPkXq6yTMl8yb
	 7Z3hYg6vgW9dEQHXwobmNYvr50TytyeQMvNj0cSM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ruikai Peng <ruikai@pwno.io>,
	Adam Crosser <adam.crosser@praetorian.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0897/2077] gpib: fix double decrement of descriptor_busy in command_ioctl()
Date: Tue, 21 Jul 2026 17:09:30 +0200
Message-ID: <20260721152613.976729225@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

From: Adam Crosser <adam.crosser@praetorian.com>

[ Upstream commit c4faab452b3c1ada003d49c477609dd80523b9bf ]

commit d1857f8296dc ("gpib: fix use-after-free in IO ioctl handlers")
introduced a descriptor_busy reference counter to pin struct
gpib_descriptor across IO ioctl operations.  In command_ioctl(), the
error path inside the loop decrements descriptor_busy and breaks, but
execution then falls through to the unconditional decrement after the
loop, underflowing the counter to -1.

This re-enables the use-after-free that the original fix was meant to
prevent: a concurrent close_dev_ioctl() sees descriptor_busy == 0 on
an actively-used descriptor and frees it.

Remove the early decrement from the error path.  The post-loop
decrement already handles all exit paths, matching the correct pattern
used in read_ioctl() and write_ioctl().

Fixes: d1857f8296dc ("gpib: fix use-after-free in IO ioctl handlers")
Reported-by: Ruikai Peng <ruikai@pwno.io>
Signed-off-by: Adam Crosser <adam.crosser@praetorian.com>
Link: https://patch.msgid.link/20260424123750.855863-1-adam.r.crosser@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpib/common/gpib_os.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/gpib/common/gpib_os.c b/drivers/gpib/common/gpib_os.c
index 7dca60488872f3..fcf13432c7dd55 100644
--- a/drivers/gpib/common/gpib_os.c
+++ b/drivers/gpib/common/gpib_os.c
@@ -1017,7 +1017,6 @@ static int command_ioctl(struct gpib_file_private *file_priv,
 		userbuf += bytes_written;
 		if (retval < 0) {
 			atomic_set(&desc->io_in_progress, 0);
-			atomic_dec(&desc->descriptor_busy);
 
 			wake_up_interruptible(&board->wait);
 			break;
-- 
2.53.0



