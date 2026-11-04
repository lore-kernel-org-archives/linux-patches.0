Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829166;
	b=QbY1Rshp+2u+5qZn3hOTte+/jj918t5my4lIPTeij7NzGG9vtdHVYhQLbUGhf8ffvTYS
	 hEYe86LDFXR9j7XikCXJWBaGg+xitxpLOV55Ydd2TVmwEtxGfEU16M8NGLX69iEyEvCue
	 kkeRwWp53FyhS9tIKkZ/E3Ax6zcVA74+DrUgoGPW5ztRntb2Qc7PQbV1q/jjMlg/3lGck
	 Cl1/qlk4MP4Ya8kfuHnzz4hMpZNuoxaso7/TLL5mrsYwponRm5kMl4fjPPRfY3GYchPuc
	 PoxyJg8BMUXE8xVveZ8+l2DASSmEJ/YNNx84s0o2R4HwGe9ReEoej+U+eWM+xCFgIcw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829166;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Ksd/twjITxJ/A7DkGicwjRikXxqC3R2hOxaTXYs7dng=;
	b=g7uLE6v1WHGmVz/h1fZ5QspuJ4iB34B3ZU+ORjY36Ehe5ljDIZ57+1y7kEy0F5EzhFsw
	 OaFzNuQgkCEZNme0cOikglljLp8Tn6qJcxEZJaHuaSCGGR8kf58+pChUypNXlbHbBvwGi
	 tjCnOPr8Bbokl4t1aRH0xLrkCEx3X6CmlfNHEwZP7KpGEKHKLS6EVEG6jqC454wrCoAZk
	 bZVN2JKFkzok5H4xI5q/dB3J3W7g4Kmd8JbOZTFvljdw5rklzPPOU3ch/2V8tjwS/PmRp
	 1ZlnkNPbGByOx2qOCa/nFrLoxUEa1tbhLAaoGWvhVTfS6Um/VGtjmxoK5UgYS+fdLmQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NKNDn4yz;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25AE36070989;
	Wed,  4 Nov 2026 21:52:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NKNDn4yz
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABA971F00919;
	Wed,  4 Nov 2026 21:52:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829166;
	bh=Ksd/twjITxJ/A7DkGicwjRikXxqC3R2hOxaTXYs7dng=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NKNDn4yz3OiZfP9cTbfnwsSg6mHqOMl5VhiXRs1cgDW94kHoMrVlwd1h177Eu66Pa
	 Ge7ldJA79aKxJhe+mZR+QAO9LW92XJafJvm3EmYJWxzDIqoiqPUDixAB+7VtdDZEZp
	 lGHQXK3ceRGSKHSDwyNUMr2Wa+PGXTkUQ5R9/NGg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alan Stern <stern@rowland.harvard.edu>,
	syzbot+25a1d2907885b2182275@syzkaller.appspotmail.com,
	Benjamin Tissoires <bentiss@kernel.org>
Subject: [PATCH 7.3 488/547] HID: core: Fix out-of-bounds left shift by 32 in s32ton()
Date: Wed,  4 Nov 2026 16:11:12 -0500
Message-ID: <20261104211052.241402915@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211038.406938024@linuxfoundation.org>
References: <20261104211038.406938024@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alan Stern <stern@rowland.harvard.edu>

commit 5fe63b415c636c7f4f6848a8e53bdd4bbf0c300d upstream.

Syzbot reported an out-of-bounds shift (32-bit integer shifted left by
32) in the s32ton() routine in the HID core.  This routine converts a
signed 32-bit integer to a signed n-bit integer, and it caps the value
of n at 32.  But when n == 32 there's no need to do anything; it can
simply return the input value.  This will avoid calculating (1 << n)
when n is 32, which was the cause of the invalid shift.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Fixes: 69c02ffde6ed ("HID: core: clamp report_size in s32ton() to avoid undefined shift")
Reported-by: syzbot+25a1d2907885b2182275@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/linux-usb/6ac9cbd8.a150a118.27e199.0025.GAE@google.com/
Tested-by: syzbot+25a1d2907885b2182275@syzkaller.appspotmail.com
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/dfa0aa1c-e55e-4316-8307-f72a07383634@rowland.harvard.edu
Signed-off-by: Benjamin Tissoires <bentiss@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/hid-core.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -71,8 +71,8 @@ static u32 s32ton(__s32 value, unsigned
 	if (!value || !n)
 		return 0;
 
-	if (n > 32)
-		n = 32;
+	if (n >= 32)
+		return (u32) value;
 
 	a = value >> (n - 1);
 	if (a && a != -1)


