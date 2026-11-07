Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062956;
	b=IZY6xwSJ7xCjLmLydabtfRdGQZXAqwDvbLxUE8BYrO56tSRJMdmmDvl0virsYUn4Lt+M
	 PHY5q05/jkV0uXa5gg0tc67HJ8GiEtz2YRzKXKJrm3Z9r0Gzu2owInvPZkn4w6hF9nofH
	 bf763THm9+S2UiprzufEpxH0elvnUPp/YbPwAmL5DoSQ0R5pDDPuoOJB6XcciCZQctM4u
	 iPY5++c8VMiuy8+QLKD2cYD8vRigV5aBS3yMxTWicUJ1IaWVzDldoqsllUp8yfmAizZVD
	 QGY1W8Vh2brzrd/ElrQL+mqREwOFf97B+OjT+hTFvWV590oQEGzDNbWRek4xkt/Sazg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062956;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=sL6T9eXW1aYhfsy0qW6x103AQoi9mUSVy+AlfjG8Kw8=;
	b=Y5yGz4rrZ3KTXZ+oe1vIb9Q9xbEZXJrxV41ms9Dy2UnFAL9LdbkrsQaNbYK4UY8v+LcI
	 /UTUuSw9pSZgwpQqvE5WQaKk1I6cluW77s7qF9aoqeF24i9yQE7o3Olx4F7ttzioIVbj1
	 Jx9wPxOAF3Q+BILQHSJEwGNfL2MQ9y8BTD2/0+sJGK8CDUtVpmT+kpaNrq9/hb0IDvkOF
	 GOXeTlWoyy4GvI4KTWDCJvX0YDl63yuXWWa/s+gvuRbQnr5VWsi752QjhNLXR/ys91G3x
	 /ZVdDDMFJHxs6fcaMAC6Q07rvtXEI6djDG1p7HTQM+CWatTewtyUgSJvOxOZyW/p+dw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=R1zbjbqU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAA44606A330;
	Sat,  7 Nov 2026 14:49:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=R1zbjbqU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28C301F0089F;
	Sat,  7 Nov 2026 14:49:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062955;
	bh=sL6T9eXW1aYhfsy0qW6x103AQoi9mUSVy+AlfjG8Kw8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=R1zbjbqUqW6ZXM7o80IGP0DJeNhJMV+uUw0n5ej3o54Zf2drmHJdvImDuGy+3X2r1
	 gryEgihZCUCnSmVU4QoBaaqAraEDsobnCQD7GRq8wgx6K957f4zUmrfY//SK5nxTBC
	 7jJW/HXN7QLsbIGJsPtD5jcYRWvImBXKRdtBiieo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Young <sean@mess.org>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 183/869] media: meson-ir-tx: Prevent divide by zero in meson_irtx_prepare_pulse()
Date: Sat,  7 Nov 2026 08:47:45 -0500
Message-ID: <20261107134858.336041903@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sean Young <sean@mess.org>

[ Upstream commit 05d9c515cf13056875abbf73adb4a19dd7ba32eb ]

If an excesively high carrier is set, meson_irtx_prepare_pulse() will
cause a divide by zero if tb_us is 0. Prevent such a carrier from being
set.

Fixes: 49be1c78d575 ("media: rc: introduce Meson IR TX driver")
Signed-off-by: Sean Young <sean@mess.org>
Cc: stable@vger.kernel.org
Acked-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/rc/meson-ir-tx.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/media/rc/meson-ir-tx.c b/drivers/media/rc/meson-ir-tx.c
index 1ab898069e67f..a0d07da09f67a 100644
--- a/drivers/media/rc/meson-ir-tx.c
+++ b/drivers/media/rc/meson-ir-tx.c
@@ -219,6 +219,9 @@ static int meson_irtx_set_carrier(struct rc_dev *rc, u32 carrier)
 	if (carrier == 0)
 		return -EINVAL;
 
+	if (!DIV_ROUND_CLOSEST(USEC_PER_SEC, carrier))
+		return -EINVAL;
+
 	ir->carrier = carrier;
 	meson_irtx_set_mod(ir);
 
-- 
2.53.0



