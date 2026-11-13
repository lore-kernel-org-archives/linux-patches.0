Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794591575;
	b=eFVE44oxMKjht8A/WB13xUBQvt5UWTWpWfDV5fb4ELm/sTNydHJuyRJkwPjj8ZNlrAMQ
	 +CJt9GTOeZPKpZweninBBayOJOrz+zytyl68rB/29Ki0p+trWnBBkPlE1UU2ir/fcUdhI
	 i8hio3WYYZPuuaw4F1Y2xmP1ufhY86r59jc8YpkOSqAVRBUowtVLbHfD1mJcnSbNMkOZg
	 gyyDNWipZA0o5RhVny/5KuatljGiz+Um09Rbkod5ntXaEQxKDT7ZTsq/d64bleZUIHLFb
	 0xL1djdBoplGGbSz02eDwwHwOHZOwkIYiw5xV4Thx17cKzHI//XAxDYfd/Mqnp+cU2Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794591575;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=sPeIqu13BsYv18WbawKZ4T1mWM8ld6MMwDxYQQyQULA=;
	b=Ada+kSUEeEa4CTZ6GgHD/g3dGEYkLxtmmjNSCu5NHm+I87Eg2QF4ilFJuKC+7FmknojZ
	 h0llUX+J1+UX7g/F7IDRNfrxxag5ZAAB6rzFK5Umd9Ujm9DNNXDKMbVLRkLoZVTENUzKY
	 tOuRhWQsZD9ozRJ2eSuGOaFjXkCYJAMxybngD0QqehyVgjqGzpGnpgYXItcFhzrTwi9nA
	 YdQ4avCDOaM+wnIvs1FQAqTt/UcdB9gQyFl9LZwapKfylsEAxf54DWKehZp/+h8Y8R97h
	 7LfmQoa8S9PvO6uTtuuTdI9rnoGTQuhOIUiO43FwSV6oySubrSEpKhlXmbCGAQZnQtg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cEGdtmKC;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 083F1606E64F;
	Fri, 13 Nov 2026 17:39:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cEGdtmKC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7B561F000C4;
	Fri, 13 Nov 2026 17:39:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794591574;
	bh=sPeIqu13BsYv18WbawKZ4T1mWM8ld6MMwDxYQQyQULA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cEGdtmKCxZVhSnff2pKRGKeY/mDo7CIaF+U/1/EA8pshc7T7Q0rBRNS/vte4ZO9oc
	 9ouHsuVSKEpNbjTfQrFneP+uls0o9oTMJKLD87ocfnojGOFeEW0yn+2kNTa9BjbVqq
	 78LSGW3j5uwe2AU4VkPtGiZTuVVtE22oGx4fgRAU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Young <sean@mess.org>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 624/670] media: serial_ir: Fix race condition where timer can be re-armed
Date: Fri, 13 Nov 2026 10:53:08 -0500
Message-ID: <20261113153832.944613971@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sean Young <sean@mess.org>

[ Upstream commit d74ac4016ba64cb3b20f395511d0b18025ca0ba9 ]

Ensure the timer cannot be re-armed.

Fixes: 2940c7e49775 ("[media] serial_ir: generate timeout")
Signed-off-by: Sean Young <sean@mess.org>
Cc: stable@vger.kernel.org
Acked-by: Hans Verkuil <hverkuil+cisco@kernel.org>
[ sashal: adjusted the replacement to target del_timer_sync() instead of timer_delete_sync() ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/rc/serial_ir.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/rc/serial_ir.c b/drivers/media/rc/serial_ir.c
index fc5fd39271772..f6702b3df9a03 100644
--- a/drivers/media/rc/serial_ir.c
+++ b/drivers/media/rc/serial_ir.c
@@ -798,7 +798,7 @@ static int __init serial_ir_init_module(void)
 
 static void __exit serial_ir_exit_module(void)
 {
-	del_timer_sync(&serial_ir.timeout_timer);
+	timer_shutdown_sync(&serial_ir.timeout_timer);
 	serial_ir_exit();
 }
 
-- 
2.53.0



