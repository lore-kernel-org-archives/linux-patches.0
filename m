Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064056;
	b=UMs55fHUiDDr+EO+xEgyamkInB+RzT/f9j9auEjQNRVUvPQdYFXYqYzhnLHylRifnoOR
	 NYINVGLY9lkuYQDZCvcz9WNFkKh7t6rT4L2kzg8THNAdy3h8VXVNHGpxReONwBpG3YYR2
	 DnIpiR7SxirB+iKSh75/T6DemJbzMWVH06Z+QlzieDtOltt8zryaAK5v4X7Ug7x1tHf3D
	 UFML8WAOSOUMe/vy2ZmTIWRYJ8Ds1zj0B/0mJ7nhHt7oszDA2H7zfh9BnrfwpTaQ1h3TZ
	 sjFnxHPzDCu5AtiOqhaktT04U5njDOti0B//tgWBDFnCJqeBFFPIShBr6cFRaNOr8vw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064056;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=K52S6CVZIT456X8ms9JqG4vIIvjpcxBXozTzSuY+ohc=;
	b=npq4ybpEpBuoZhR+TowRQkEjJlolKSssCJKqurCrXYxNyMSPWxS5Bp1juLA9mSOZeIQy
	 X4azwYmgkfHHcK1QZ4QIzs7w2/Ye8tCOVvu73Z12aB7siqF9c/ivHlGhckJsBla+XEB9A
	 6ExcObdPFs0jxSw1niXoFcmukUUXRei9OeJTzHcWArvhuS2R7JL264E0IvY1zLuw9E32+
	 tSeup8aqEEYkGB4hpmvUNVe0lCpiLLGysVcIuPiRyd+0SMuHzE9WwCZ4+ljJKIUjv2h4L
	 tD4bscSaOj+17MqLqOhWYRx4zrOsNXmQs0jEx6X7KTyprmh7FJ9v07/sMYCbeQrlqHA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OLr7voyE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C2E2606A9D4;
	Sat,  7 Nov 2026 15:07:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OLr7voyE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 484C61F0089F;
	Sat,  7 Nov 2026 15:07:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064056;
	bh=K52S6CVZIT456X8ms9JqG4vIIvjpcxBXozTzSuY+ohc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OLr7voyE3nBtRVDjc5kVuWF2WCoGY6RtvwpdQt7RiEMcJapAJcAtgR8dB3kxgx3z/
	 Y0W6cGM/SI06V4iFfoVD4husfuhOQNzbB14S9DbTGoQ1jyukXAzI3ELsJ0vJ+W0Gqz
	 p/oJjp7v4UTt1oBQrv+wmeY85QAozG7Q/CFEsbWE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Young <sean@mess.org>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0227/1257] media: serial_ir: Fix race condition where timer can be re-armed
Date: Sat,  7 Nov 2026 08:42:03 -0500
Message-ID: <20261107134945.797312423@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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



