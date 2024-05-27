Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 971F6168C4;
	Mon, 27 May 2024 19:20:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716837635; cv=none; b=YeVJRudkFmDRTNqALChWXBk4SV5VUrbEmlTpW2FTr/+XvYJNMf4bPmxql9hfLB0FmOU5wNFTNGUycRekLPYbKF+rIgp3K0cC96kXX8Z+FH/l8mgHXpMSL7/LTiAgb81J0imQP03ioXviYk/PDuKPL2Q2klbhm6Qe+gRuDHO8KjQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716837635; c=relaxed/simple;
	bh=zk54leyV3veHbji2/wQGOO+Ff3MDCuDlCGudtfxM1A0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rZwu6u31Rlz5VY0nSwIGcEJ0hUX0bM/F1q9uHNONpcgpWgG5bxFp7n7ji4BAgHyTlDSVNxFCLd0DrhrZWA7II0jTSUkxtma+0oo7IkvEXClAXfsaOxgCzMwJ5e2RzBxa+QFMrlqlKGzkzb30i5/gggLK+MJ6bAB9zpHkmHHxHRQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DUJNjjWh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DUJNjjWh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FEE5C2BBFC;
	Mon, 27 May 2024 19:20:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716837635;
	bh=zk54leyV3veHbji2/wQGOO+Ff3MDCuDlCGudtfxM1A0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DUJNjjWhk18sKve55QwX9FfrB3pkpEtoovAiAfgb9pRVTfYu7fdcekEcGtCo/fJ5q
	 xUI8lkYED7C36KAZOVED8ytopwguFXqc4mLx0wOMVUKKyIXftq6v5jlh+fOSCJQjZ9
	 gGu8qSJAk/O81w7Z7kfrfN9eMNSGsPILSXtrh/z0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abdelrahman Morsy <abdelrahmanhesham94@gmail.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 045/493] HID: mcp-2221: cancel delayed_work only when CONFIG_IIO is enabled
Date: Mon, 27 May 2024 20:50:47 +0200
Message-ID: <20240527185630.432225039@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185626.546110716@linuxfoundation.org>
References: <20240527185626.546110716@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Abdelrahman Morsy <abdelrahmanhesham94@gmail.com>

[ Upstream commit 3cba9cfcc1520a2307a29f6fab887bcfc121c417 ]

If the device is unplugged and CONFIG_IIO is not supported, this will
result in a warning message at kernel/workqueue.

Only cancel delayed work in mcp2221_remove(), when CONFIG_IIO is enabled.

Signed-off-by: Abdelrahman Morsy <abdelrahmanhesham94@gmail.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-mcp2221.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/hid/hid-mcp2221.c b/drivers/hid/hid-mcp2221.c
index f9cceaeffd081..da5ea5a23b087 100644
--- a/drivers/hid/hid-mcp2221.c
+++ b/drivers/hid/hid-mcp2221.c
@@ -944,9 +944,11 @@ static void mcp2221_hid_unregister(void *ptr)
 /* This is needed to be sure hid_hw_stop() isn't called twice by the subsystem */
 static void mcp2221_remove(struct hid_device *hdev)
 {
+#if IS_REACHABLE(CONFIG_IIO)
 	struct mcp2221 *mcp = hid_get_drvdata(hdev);
 
 	cancel_delayed_work_sync(&mcp->init_work);
+#endif
 }
 
 #if IS_REACHABLE(CONFIG_IIO)
-- 
2.43.0



