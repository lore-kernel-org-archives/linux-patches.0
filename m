Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0299E19750E;
	Thu,  6 Jun 2024 14:12:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683133; cv=none; b=FbNAEuDWFKixY9cttWWiiYTU7DEiOI5HYit2j4kqYUi5cu233VcNg3Zz8D64z1ia7pgxMhozkaW9H7lR46jdbS2h6VNT5qH4JujCTxHXj7k2Jlu5O85o/hYySf/xwhvMYOpONnw1EPDEWuU4BYXO6wr5G5Ot2jZFyLeRFtqJh9s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683133; c=relaxed/simple;
	bh=NGXX+7LAMX/0lTRt96jwsT/b4w6kxEF75sBkC0Pe3Qs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K7hC9Ur7Et0Axgw6j9PJhaqyL+G/d6VZc+FcCwiev91fBFtJ3lJr0IXWc5hqtz+NDJj3iS4IqGupFudxJ6m5ar/kUtFsdpPdkFX3zt2CC9vbCQElNsMqqSaSIGOo2DNM0pwg0oRWHscdm6CZrnvAv47P5NvqbT02Tv6CUiyEX28=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YKbd20ra; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YKbd20ra"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1D88C2BD10;
	Thu,  6 Jun 2024 14:12:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683132;
	bh=NGXX+7LAMX/0lTRt96jwsT/b4w6kxEF75sBkC0Pe3Qs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YKbd20rabLShefa/gItOgfKk5IkKYqDF+teX5ybEAlL5CTsJPHFhdpOEreiGQ3acx
	 oZwchEh0gFFYFYwdtJI0yWcFPwLZ2KD6KLGeuuH74pM8EmTGpwnLsqjzzxbiVliWdx
	 kMeMBsfJrolpppX9zd9S9ua8oTpnbQiPF7+aGbMc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abdelrahman Morsy <abdelrahmanhesham94@gmail.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 038/744] HID: mcp-2221: cancel delayed_work only when CONFIG_IIO is enabled
Date: Thu,  6 Jun 2024 15:55:10 +0200
Message-ID: <20240606131733.676338287@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index aef0785c91cc2..c5bfca8ac5e6e 100644
--- a/drivers/hid/hid-mcp2221.c
+++ b/drivers/hid/hid-mcp2221.c
@@ -922,9 +922,11 @@ static void mcp2221_hid_unregister(void *ptr)
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



