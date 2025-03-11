Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D509325D54A;
	Tue, 11 Mar 2025 15:04:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741705474; cv=none; b=We0DvQPywsgjosMFjyqcxiiUvHFherQ5W70D9uYsCu++hf6yNzBXhjRzzb4judBx3HjBE4SSvJbCfnDxQfhwp6qiJwSjAbdQHpCWkN5k2tHdunszqFVWpOGKRz5KzvDuBvrSIPxrSFTL4/oqJ+IOc0mCwz/Kne+2q691nZUlL78=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741705474; c=relaxed/simple;
	bh=39bVXTAGvDFY8Wc1Dy2DpE2bMr5YgKTUn5bAULV0KtU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rApHWkTQfogDztscjSH9N/+Y7lodHuYxJBJ+B8FF/OAdSAXz+urmfuE66nMJhR7Zo980ujKCzckDAcjXCMBaM7JHPsQLK/KTb5mvVtV0UYWxYrzXCy5O9LJIS+Trgap7tqhqTtal4Zq69V6GJZuYJruszm+Y49TjLpA//JSBOPs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tHG5Ogq+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tHG5Ogq+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F598C4CEE9;
	Tue, 11 Mar 2025 15:04:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741705474;
	bh=39bVXTAGvDFY8Wc1Dy2DpE2bMr5YgKTUn5bAULV0KtU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tHG5Ogq+beYK1TKi+Doo4IE/9bIw42PjI6WWEbvgzYCQ49Ldor/0DnXpOTXOSMQyZ
	 h+axobyPxUNiTUmY48J3KmmAP4ErXqe2odmdJDjQWuOxnJszbIlApafnETUXCoqjRg
	 xILW9ddGGiyTAEjdHNtKH/FIH8prSlXZsC/pxnw8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oliver Neukum <oneukum@suse.com>,
	syzbot+ffba8e636870dac0e0c0@syzkaller.appspotmail.com,
	Sean Young <sean@mess.org>,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 048/328] media: rc: iguanair: handle timeouts
Date: Tue, 11 Mar 2025 15:56:58 +0100
Message-ID: <20250311145716.803238582@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145714.865727435@linuxfoundation.org>
References: <20250311145714.865727435@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index a7deca1fefb73..f50362bb59f27 100644
--- a/drivers/media/rc/iguanair.c
+++ b/drivers/media/rc/iguanair.c
@@ -200,8 +200,10 @@ static int iguanair_send(struct iguanair *ir, unsigned size)
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



