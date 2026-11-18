Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795038612;
	b=0wy+TBR3guOsJ9wG3VlxDw7FlhrSSzhivSq5fNGKwavF1vMZJD+aTOgvNO7OMX30UeqD
	 03OSpqojmOAJYywl+G4yjxnpGO8uXxbppzO+XYM+dbXiXW67GqWL2LnGSmlC7djDeQS4m
	 kS26G4SUX4LzfJXC41lYRXr+S8u/seY2ey6VVsRP4JNMHo+xl/Z0iLJ42KK8qqZKBnX+b
	 j0sxlhogr5pruKsHeBQm2U7N96nnmeyyS4/oeBgDTd95tMVcfuwZn1Y08GnWEeHJI5c6t
	 iXk07UIr+8DtzizG1T6MUnlOT8kqLC+b/YSZw/NZwKjTrQWw/qUf6LgauM0ciuP3l8w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795038612;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=hHzO6Q3Hb4C7GtG309FloYRXNWjCZ4quqSBaEYlgebc=;
	b=kVBvgPZ+aPlOP93b16x9GYOF2q2tpptvn0sYsjGSgtk8PInx0T1AWP1BCLS5kvu4nWOp
	 GtPeBtjtYmT136MW9vjohgLNSl2bXW98VuZTszUk8ZGNRDf3M0qr1DR3UxCftLcMZvPgl
	 JkIQgBueaJlZkyIVb7U+cXrKhRarG7qWZzjcrExA3lVDSsD9dpHpeJ9mw/T8Ro4S73wXT
	 vddYZe2ZEuBYCzuKR6WCoupVEL2iRZYhDkXhcuCOtaKyhdM6YucXiTYrRnkAamrkZKKvo
	 1F8u7ALTaMbo3hbPY5Z9F9cFtBNOpu1EAqCI4AEL43KfbyXufmUq9h1jD5ipDyELPHQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pkxyJR+S;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3201606A320;
	Wed, 18 Nov 2026 21:50:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pkxyJR+S
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 314481F000C4;
	Wed, 18 Nov 2026 21:50:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795038612;
	bh=hHzO6Q3Hb4C7GtG309FloYRXNWjCZ4quqSBaEYlgebc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pkxyJR+SDlonCweXWOT+E2DHn5gGfPQZYYRMpYWSJvPAeAKlHGC/P+pZJPb/cL784
	 DejC9kKZ9nD+dR2CUCgfR44u+ACw2aVC3P0tBBq/RXIsO7hTfED/yhcDii2ULlN7/+
	 emKdpA5ryhCmYHSTsLKOK9EoZHd+q002D6hiv5Rc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Young <sean@mess.org>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1805/3318] media: serial_ir: Fix race condition where timer can be re-armed
Date: Wed, 18 Nov 2026 15:40:27 +0100
Message-ID: <20261118150416.005583549@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sean Young <sean@mess.org>

[ Upstream commit d74ac4016ba64cb3b20f395511d0b18025ca0ba9 ]

Ensure the timer cannot be re-armed.

Fixes: 2940c7e49775 ("[media] serial_ir: generate timeout")
Signed-off-by: Sean Young <sean@mess.org>
Cc: stable@vger.kernel.org
Acked-by: Hans Verkuil <hverkuil+cisco@kernel.org>
[ sashal: replaced the existing del_timer_sync() call instead of timer_delete_sync() ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/rc/serial_ir.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/rc/serial_ir.c b/drivers/media/rc/serial_ir.c
index 96ae0294ac102..dac341c68b2bb 100644
--- a/drivers/media/rc/serial_ir.c
+++ b/drivers/media/rc/serial_ir.c
@@ -797,7 +797,7 @@ static int __init serial_ir_init_module(void)
 
 static void __exit serial_ir_exit_module(void)
 {
-	del_timer_sync(&serial_ir.timeout_timer);
+	timer_shutdown_sync(&serial_ir.timeout_timer);
 	serial_ir_exit();
 }
 
-- 
2.53.0



