Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795047322;
	b=b26QLGc0DVpWKKYnNae65Y0KEIA2q7MQEJV3/C9qTmLWT3Bd3/iYeU4Rn/V4WmcKZ5i9
	 1x0lQmsaT++ztXc7D3eRlLzTmnhewrRyU5moMhFND+iKrnTjLIZbznnunFIkh6C3D92on
	 To8TXeO4Mcv0gWGSY4cHTEaE2jcdHPk/+PaioKU4wehMFoQChfJOlhpjlgLWNbPeYdhtQ
	 IfxZ8UH5T4wVZFuIvKeHvGTvAm1FqBKpE5PMoQjmEp75umvnLgEjHbmpVig14alc5IFau
	 w0bkmRJNuRkVwMIXVZPrlXrni8yShtSfX2NbBqaMZxBeDhJt3NQ9vlExzdnIKRVSBMQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795047322;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=n1JnLMBpLX45S+VoWdG4UQlg3+cINIW30VI1xMaNV20=;
	b=nLCFNWBlSzjcI8aar4um/oJVa+zuky3An/vRSO3ifdmuBhi4/210/2r4v2xlN3H/veV2
	 AcRE46NwQCKHf3Xtur6B33KN5esjSk8VeCVEnsyW/wbWUocu/5yK7enynM2dBz3Iplq9f
	 OAkoeHlIMBQ/zjgSXdHjdn7Nps6z2nmVW0/iytcoU+hfPHfiZD8pr/CYeHLcnp8uqr5pT
	 i/nDIhu7RZssT+CfjXC8bFVoXPzKqAYNgR3xEnWx6lNuPZKOat12t0z2/bVJgRUuKJtYn
	 lYSgsmZdA/ejDhCj30nQou7XLL2YXYV/h+uyh6y6hOHHyp/yGaiD/eETUTz0ukcgKag==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qOViJoPB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67B35606A32C;
	Thu, 19 Nov 2026 00:15:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qOViJoPB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B51261F000C4;
	Thu, 19 Nov 2026 00:15:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795047322;
	bh=n1JnLMBpLX45S+VoWdG4UQlg3+cINIW30VI1xMaNV20=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qOViJoPBteE5xjkIUMJ0H+DB7x61gaAL6UgtEjljS8I/+1sBvCv+5HCAkGDD8bE3D
	 nnSCOaP7JQTkUMP5K2XkBruIEqwQkoWnIfYoQpZYqncvhizXGaYwlf1M9jmOg/aCyI
	 WLffPiU/yRBBpvcWqnvAvITANh+JvfjkZKA2oeNc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Young <sean@mess.org>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1556/2857] media: serial_ir: Fix race condition where timer can be re-armed
Date: Wed, 18 Nov 2026 15:43:10 +0100
Message-ID: <20261118150257.409191534@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sean Young <sean@mess.org>

[ Upstream commit d74ac4016ba64cb3b20f395511d0b18025ca0ba9 ]

Ensure the timer cannot be re-armed.

Fixes: 2940c7e49775 ("[media] serial_ir: generate timeout")
Signed-off-by: Sean Young <sean@mess.org>
Cc: stable@vger.kernel.org
Acked-by: Hans Verkuil <hverkuil+cisco@kernel.org>
[ sashal: adjusted context for the existing del_timer_sync() call instead of timer_delete_sync() ]
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



