Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BC053CAE7F;
	Tue, 21 Jul 2026 22:47:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784674040; cv=none; b=oFMCvjMi6Jg2zadB2N31RkDhnfzfHAvzwuff/C6F0yb1w+CBk5ulKc6yiFcTNvHBKPP/YJvoc19kdZy/aGlWNWMvE1W1Q/sMoz33XeWoNzbMpEbNyrDSTof0m3rez65OvJxrdh4mRsH80iTXz51Gegys18XqrZ5bXG1t/xkN0pY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784674040; c=relaxed/simple;
	bh=aqZixjY4TPaYkUeUzTnJ3pKtmDBuUTRRg1u9pI6SuvM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZDrLKRMzSPionh6j9Uw5QO3lokBC643Ioh3DkusnLepWzfVXWt0JzOy6vQZLRHBAI3+Rg9HY608HZq6gtMgeKbX946mMML5E366mz38Y3WVbXvIaMBKoTnEKApIDszJmh10m+TpQEV/GQuCqSRPP5Ac8vVxfGo6vkFd9eksV/7g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Lc+6sQz9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Lc+6sQz9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBBF71F000E9;
	Tue, 21 Jul 2026 22:47:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784674038;
	bh=WXTpjeoA7teR90qGS6Q7m127ojTZW+/BH9jJUn8vADo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Lc+6sQz96e2qGK4enGzPcykzDAXq6bGd7vePieiYWGEiyx3nZckU6IVI/qp5gn1am
	 6zIx9mnL9bQyX/Kcb0qaEwkLHQwK0GniX7VaZi8tXki+NmiLXTC0MeSfPzmvA5FMZE
	 qcsGwN4DNmLmo5sant7F8bTEcNdQv6p4V28ZgEI4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Georgiy Osokin <g.osokin@auroraos.dev>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 389/699] HID: picolcd: prevent NULL pointer dereference in picolcd_send_and_wait()
Date: Tue, 21 Jul 2026 17:22:28 +0200
Message-ID: <20260721152404.467604684@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152355.667394603@linuxfoundation.org>
References: <20260721152355.667394603@linuxfoundation.org>
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

From: Georgiy Osokin <g.osokin@auroraos.dev>

[ Upstream commit 0021eb09041f021c079be1022934a280f7f176c0 ]

In picolcd_send_and_wait(), an integer overflow of the signed loop counter
'k' can theoretically lead to a NULL pointer dereference of 'raw_data'.
If the loop executes more than INT_MAX times, 'k' becomes negative,
making the condition 'k < size' true even when 'size' is 0.

Change the type of 'k' to 'unsigned int' to prevent the overflow and
eliminate the out-of-bounds access.

Found by Linux Verification Center (linuxtesting.org) with the Svace static
analysis tool.

[jkosina@suse.com: extended hash length]
Fixes: fabdbf2fd22fa17 ("HID: picoLCD: split driver code")
Signed-off-by: Georgiy Osokin <g.osokin@auroraos.dev>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-picolcd_core.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/hid/hid-picolcd_core.c b/drivers/hid/hid-picolcd_core.c
index 1b5c63241af058..34a9068a258041 100644
--- a/drivers/hid/hid-picolcd_core.c
+++ b/drivers/hid/hid-picolcd_core.c
@@ -72,7 +72,8 @@ struct picolcd_pending *picolcd_send_and_wait(struct hid_device *hdev,
 	struct picolcd_pending *work;
 	struct hid_report *report = picolcd_out_report(report_id, hdev);
 	unsigned long flags;
-	int i, j, k;
+	int i, j;
+	unsigned int k;
 
 	if (!report || !data)
 		return NULL;
-- 
2.53.0



