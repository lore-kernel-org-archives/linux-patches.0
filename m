Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC9261494BB;
	Tue, 11 Mar 2025 15:23:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741706619; cv=none; b=gDpvR2WMu5fdnaWZ9/+PX4E3PQEYn5FK/zDkKjYGDRFQzI4YRLJ+3NMXLR0FJQZTrTtnXiRaWEzYrtkzyUg25DnVcZPEGv5g/EhaRnZ3/vRxPH7Xkb/5CDcO+77GYCIFGfArC7lk2W2hzkFq8pYFxoQU9YUI+H/vDlGmnjikExM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741706619; c=relaxed/simple;
	bh=eax1xw2XhyGmJ8g6V9CYB8cEtDkv/BZtbCYF047F1bc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Pi8beKAcmANOaH49DIuZ8QEYyoKrnW0B3n1WeSVI/SHqfhiUo5f40vPiDz6CMkr2A0le0ZE13B/WkLy8133h/amGV7cgV5gxonJRWMtn4TXWEyX7q3NiRRUSwy0CtRNvua4D5sL5P0RxCKGDy1/nYlas51hVuWCblPyCd0UtCrs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PbTrGKgg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PbTrGKgg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B3F0C4CEED;
	Tue, 11 Mar 2025 15:23:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741706619;
	bh=eax1xw2XhyGmJ8g6V9CYB8cEtDkv/BZtbCYF047F1bc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PbTrGKggA6CvuvXOCusnwc0mTjuYs5hjEdoPJZbmZ4Of4PYtY2UIaBLLBXRrMSgJf
	 ts4NaD0FuHDYHtlBr5RpAn+uUBGiPksOkW/D+EUoqCa39B9Gsl80nMmrLFH8aRQNnT
	 WHNEJ1+Hp68oZMQKiyfA2ok9fQ1kI3rnrfTNt7fc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oliver Neukum <oneukum@suse.com>,
	syzbot+ffba8e636870dac0e0c0@syzkaller.appspotmail.com,
	Sean Young <sean@mess.org>,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 079/462] media: rc: iguanair: handle timeouts
Date: Tue, 11 Mar 2025 15:55:45 +0100
Message-ID: <20250311145801.470903392@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145758.343076290@linuxfoundation.org>
References: <20250311145758.343076290@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Oliver Neukum <oneukum@suse.com>

[ Upstream commit b98d5000c50544f14bacb248c34e5219fbe81287 ]

In case of a timeout the IO must be cancelled or
the next IO using the URB will fail and/or overwrite
an operational URB.

The automatic bisection fails because it arrives
at a commit that correctly lets the test case run
without an error.

Signed-off-by: Oliver Neukum <oneukum@suse.com>
Fixes: e99a7cfe93fd ("[media] iguanair: reuse existing urb callback for command responses")
Reported-by: syzbot+ffba8e636870dac0e0c0@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/all/66f5cc9a.050a0220.46d20.0004.GAE@google.com/
Tested-by: syzbot+ffba8e636870dac0e0c0@syzkaller.appspotmail.com
Signed-off-by: Sean Young <sean@mess.org>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/rc/iguanair.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/media/rc/iguanair.c b/drivers/media/rc/iguanair.c
index 84949baf9f6b3..c1343df0dbbab 100644
--- a/drivers/media/rc/iguanair.c
+++ b/drivers/media/rc/iguanair.c
@@ -197,8 +197,10 @@ static int iguanair_send(struct iguanair *ir, unsigned size)
 	if (rc)
 		return rc;
 
-	if (wait_for_completion_timeout(&ir->completion, TIMEOUT) == 0)
+	if (wait_for_completion_timeout(&ir->completion, TIMEOUT) == 0) {
+		usb_kill_urb(ir->urb_out);
 		return -ETIMEDOUT;
+	}
 
 	return rc;
 }
-- 
2.39.5



