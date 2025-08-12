Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 401011E47AD;
	Tue, 12 Aug 2025 19:28:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755026933; cv=none; b=EHSWdYluEQWuTmqU9WhskFo1BDDwTvQjObR6+wfVor2EyGeu2gY8kXtZlVOBo9wpeOCi4rN2spzCMUDVLRk0Kus3Nae13OHwiUgn+x2CtSRYww/9s8mr2oDFNIfFW5HQsG2Ep3J87qFOt/fst65/BZjGjKBR0QyNeBXdTzEfaIA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755026933; c=relaxed/simple;
	bh=gDNpWiTBd0qE4tBWCUNdTqAJqGtM7Tf07Arok6bDBjI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uDM81BtlHZNK/wvW+RBm62/2doCk/BzvvV9xk33iS/sCYq9UVZrWolMqGrLkpbvCSpY6LxnVMgX+x9lsMkZAceoaIDhGN6Dnlcwi2bpAMQVO4VO9yZxYbv/op/63ABP5st9/DT9A8H3A7tKg1zb6noM10LTkmgeD48h2OV5g8GQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LOiOilDf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LOiOilDf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBAF0C4CEF0;
	Tue, 12 Aug 2025 19:28:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755026933;
	bh=gDNpWiTBd0qE4tBWCUNdTqAJqGtM7Tf07Arok6bDBjI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LOiOilDfaddiK90fbD3q/lkqVbAoASfU4mrHkUhQsSJV6FhpQ55IPOCHiEcxy3vFL
	 tMzu7c69UyOz9SoiNdBNC3y2dAkRi4MTiCV0B67G5XZBaVgsPK93pBXtMu40kkmQ7m
	 wcY9WR1SyqWkGqDg5KbJS6cTld3W+C9qyqDDlNqs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alan Stern <stern@rowland.harvard.edu>,
	syzbot+b63d677d63bcac06cf90@syzkaller.appspotmail.com,
	Benjamin Tissoires <bentiss@kernel.org>
Subject: [PATCH 6.15 477/480] HID: core: Harden s32ton() against conversion to 0 bits
Date: Tue, 12 Aug 2025 19:51:25 +0200
Message-ID: <20250812174417.043753867@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812174357.281828096@linuxfoundation.org>
References: <20250812174357.281828096@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alan Stern <stern@rowland.harvard.edu>

commit a6b87bfc2ab5bccb7ad953693c85d9062aef3fdd upstream.

Testing by the syzbot fuzzer showed that the HID core gets a
shift-out-of-bounds exception when it tries to convert a 32-bit
quantity to a 0-bit quantity.  Ideally this should never occur, but
there are buggy devices and some might have a report field with size
set to zero; we shouldn't reject the report or the device just because
of that.

Instead, harden the s32ton() routine so that it returns a reasonable
result instead of crashing when it is called with the number of bits
set to 0 -- the same as what snto32() does.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Reported-by: syzbot+b63d677d63bcac06cf90@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/linux-usb/68753a08.050a0220.33d347.0008.GAE@google.com/
Tested-by: syzbot+b63d677d63bcac06cf90@syzkaller.appspotmail.com
Fixes: dde5845a529f ("[PATCH] Generic HID layer - code split")
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/613a66cd-4309-4bce-a4f7-2905f9bce0c9@rowland.harvard.edu
Signed-off-by: Benjamin Tissoires <bentiss@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/hid-core.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -66,8 +66,12 @@ static s32 snto32(__u32 value, unsigned
 
 static u32 s32ton(__s32 value, unsigned int n)
 {
-	s32 a = value >> (n - 1);
+	s32 a;
 
+	if (!value || !n)
+		return 0;
+
+	a = value >> (n - 1);
 	if (a && a != -1)
 		return value < 0 ? 1 << (n - 1) : (1 << (n - 1)) - 1;
 	return value & ((1 << n) - 1);


