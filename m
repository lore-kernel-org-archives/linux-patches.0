Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793208917;
	b=XIeS3EmivFwnEBx3bfLKjFBJUPnoWFSAzVzL1MALTE3U/W9wK2bVIKCCRq9VRS3zW0Cn
	 IFRg/u7aqLtSC5FSevbF1z28/7CrWpbJ3u5B6pVYk1aEaxDfvKYmmiVAlNYPDGxZfHe7S
	 uyCS6SbfTI5rH0owEyaQKpct3PFacdIV26pd8mvyOHGk4o5hKD41SDk+YqlGh1Q9zROcH
	 6zeddUvts1NuaSknTE3A46wuiCoPZNJxZzQPoFw9ashEmEFUXRuCHCup8XDjzFKU4TWGU
	 NldIWlvrKUkrOMHnmAFxXGGQpd2GZ884/wjC7tbaLldX5Oi0zDtbqY/50CK3gETJMHQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793208917;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=dkIgB1URHR8H/zDcUYDJKoSaSfZuRbHy6APgMDiKrlU=;
	b=cyYqMQnGkjcnG9RPI0tF/JFbkmdFTfxGLnJ6xYv9S+hmeZpdW62sdRcUa7R8GaACnQOI
	 0zD7kZV+PAw8uNpO7ZclBuEeiQs1LvOXJa3PiWF0zF4aKs+y7mf56YlwAzaFGwqofYaOJ
	 oIa432d90uR1oVroro3YgCR9NqdqUT3TUS0hLvcT0K677QgwsNgNu8HzZACgtnUQZLqIM
	 1seuTzlTrMouAy+CBSwTV1hNmDcoO9/skFn5Xf24Yp1JAKm2gZIiSWOhNAe6tsqftOmpM
	 YXJS10tqHDtN+waLglfgHMkqzXtSS66UVArB0Q2rDAfMcgjcNJ7iIP8NlqIRqPwuPKA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sBBTlqh4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A34AE606A31A;
	Wed, 28 Oct 2026 17:35:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sBBTlqh4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0C841F01825;
	Wed, 28 Oct 2026 17:35:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793208917;
	bh=dkIgB1URHR8H/zDcUYDJKoSaSfZuRbHy6APgMDiKrlU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sBBTlqh44mpLYmrNh8UMtRsg5K1XJpudNK/LN6G+V3SU2dg10NSkyRkxuEf35mPxT
	 2W1fbZ9Vb7VF46Uz+OVr+DXvquRV5M9ZmtgbLpync+3ejCRtiZFexnsnuz9rv5QTXQ
	 UVytO44aibg1XdrYSHSa9kmYBFxQ0qLWUv1BPcTg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Orgad Shaneh <orgads@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 281/516] usb: octeon-hcd: fix the FIFO-flush timeout computation
Date: Wed, 28 Oct 2026 17:57:13 +0100
Message-ID: <20261028170010.147419608@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
References: <20261028170003.522232767@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Orgad Shaneh <orgads@gmail.com>

[ Upstream commit 4c7a1b9f1f1979f2b3b69428ada12680695159c2 ]

cvmx_wait_tx_rx() computes its 100us deadline from
(u64)octeon_get_clock_rate - the address of the function, not its
return value; the parentheses have been missing since the
CVMX_WAIT_FOR_FIELD32 macro became a function. The cast makes it
compile silently, and the resulting deadline is effectively infinite.

On a healthy controller the flush bit clears on the first read and
nothing is noticed. On a controller whose PHY did not come up (for
example when the reference-clock configuration is wrong for the board),
txfflsh/rxfflsh never clear and probe spins forever in __delay() -
observed as a hard hang with a soft-lockup splat on a CN5020 board,
where the board watchdog then resets the system with no console output.

Call the function, restoring the 100us timeout the code always
intended.

Fixes: 3e195a80e096 ("Staging: octeon-usb: Replaces CVMX_WAIT_FOR_FIELD32 macro with a function")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-opus-5
Signed-off-by: Orgad Shaneh <orgads@gmail.com>
Link: https://patch.msgid.link/20260901193100.1352110-1-orgads@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/octeon-usb/octeon-hcd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/octeon-usb/octeon-hcd.c b/drivers/staging/octeon-usb/octeon-hcd.c
index e2f8b6b67f75e..10dcc9b8072e8 100644
--- a/drivers/staging/octeon-usb/octeon-hcd.c
+++ b/drivers/staging/octeon-usb/octeon-hcd.c
@@ -576,7 +576,7 @@ static int cvmx_wait_tx_rx(struct octeon_hcd *usb, int fflsh_type)
 	int result;
 	u64 address = CVMX_USBCX_GRSTCTL(usb->index);
 	u64 done = cvmx_get_cycle() + 100 *
-		   (u64)octeon_get_clock_rate / 1000000;
+		   (u64)octeon_get_clock_rate() / 1000000;
 	union cvmx_usbcx_grstctl c;
 
 	while (1) {
-- 
2.53.0



