Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062926;
	b=dHGNSE0Vcz8GeepE82afGK4sCu9wGPFR1M9gLJN2qmsm19dNbE7WSroxGbH7zp+hukN7
	 5olNWwqSohMKeyOACWqaaAtrYWV63LzHCfkKxVPsiR87VNRaow3m2/h47DF3jgk43/qkC
	 fPS3zAJM1j82asWB9okONXvNJCfinOsuQcGaE5kWq5XiWQeBQB4V69GcwTzGF9BR+Zni6
	 6s5bxb+ffKO1IlYJye2LWnIFuKT1uVRuLKN4Ytqv00+YapBLbBHKDEKg1vmId5yGkUEBy
	 G1wfU4+YuTA/5FK2sExoyCfaMfhBo/iXfVn0Y2vA8sqElrwjEetSYanx74/h57X495A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062926;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=t/5EWvylmZ+Pvi51zcHX1odsdoeBgIxtfI2HYPpnSRs=;
	b=ZvLYk/oc/Qe2g4ckHmotLiW9HJ7liCdWOlqlDcpn6zX4c0TEIQruH/j6YLi5sYfSXEJp
	 5MpownsH2NGQWGt3f8VpOs0gutcdI2K+BwIQ/r0ZRXiteTOXh6lsZpvHZU5rKpWGNpcFG
	 NRyyiTPKY8VoOU0DgHf5mI3w+BdqKWePyo0zCh1c1TVAbLvK5IBolL6sSBDoZ6mpRUpb6
	 39NkFDL+RlS/pz43bytoP2AOjuvxlYYFszO68e9vwsQ/1oxPEYnj/E6dWcZGZJ/7AS74b
	 eyW5sMCk7EvP02/2w01yW2B1SBSLq/3EnQV47Y86crdrVYhwG73ltPNyvkz61ReiKbw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iQfkOqlK;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09969606A326;
	Sat,  7 Nov 2026 14:48:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iQfkOqlK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAC601F0089F;
	Sat,  7 Nov 2026 14:48:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062925;
	bh=t/5EWvylmZ+Pvi51zcHX1odsdoeBgIxtfI2HYPpnSRs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iQfkOqlKgHbtZ56GY7y5XWG+viBoUHyrkoQWABNaC1E80r/zegr9an0zMbE6GfOpD
	 1DgkH1klVTryyKzh36DuRWfEC9aUA7sOb8JZ/rmsopImq8k2KKiqa2WiJTjvXUfuz5
	 QJBppD+jJED/S24gODYyj+lZeJcihqfGOQSQGREU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Young <sean@mess.org>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 181/869] media: serial_ir: Fix race condition where timer can be re-armed
Date: Sat,  7 Nov 2026 08:47:43 -0500
Message-ID: <20261107134858.279029935@linuxfoundation.org>
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

[ Upstream commit d74ac4016ba64cb3b20f395511d0b18025ca0ba9 ]

Ensure the timer cannot be re-armed.

Fixes: 2940c7e49775 ("[media] serial_ir: generate timeout")
Signed-off-by: Sean Young <sean@mess.org>
Cc: stable@vger.kernel.org
Acked-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/rc/serial_ir.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/rc/serial_ir.c b/drivers/media/rc/serial_ir.c
index 992fff82b5245..f6702b3df9a03 100644
--- a/drivers/media/rc/serial_ir.c
+++ b/drivers/media/rc/serial_ir.c
@@ -798,7 +798,7 @@ static int __init serial_ir_init_module(void)
 
 static void __exit serial_ir_exit_module(void)
 {
-	timer_delete_sync(&serial_ir.timeout_timer);
+	timer_shutdown_sync(&serial_ir.timeout_timer);
 	serial_ir_exit();
 }
 
-- 
2.53.0



