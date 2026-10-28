Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793211237;
	b=VGPXrSzS2VErVMouUCkvSz1ikaMI+7LqKYXv1Fk8tz5cz6hKS3FInQ4pNEbJUT3Cuzf8
	 3UkXSqFr8JNiczIVwzHrKcYPacji0XRYCzcWOItMbViZA+XVt7IDsFywZkSXIOdtuTP3Z
	 HJEQ17FcchIHQbg7O6HopeuYaThWxi35z3h92LlwO/BCpKpot15O9Nx5jxkmzk9/7jbb/
	 mnz02xnYjz+F6D3eLRYI3GBLy5zQYytP78oUQQzD1KXU+F00AqJDmSPxkcgoc896GmeRy
	 Ca0qNPVViFz2m1EPjCC8R7CxDSGSewbQLL/AJPNkXIP2tpEKBM/NCbm1cNquVSnkcYA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793211237;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=A1hbNRRGYMMN5eznQYjIAL8fbUwkQ6Krc3QKcVKi1Ac=;
	b=jrqaIngLQngJ458fzxWln78EjnkgMnuJCPdeXp3xP9N9UPDVZ1ZSmH1Ix9ogp5OGAMt3
	 j8R5XjdG/qQhLifLQ6nS0GmyIPZD76pk8kaPuSm7rLsJWoknL6e01IoUqFiU1WulrX6JB
	 j1Usm41Wj5j0uwBSGs3hWGlAHV8CSSCi98ezQsl7igtgPRhU+kps7s0m1R7BnJUrNJcNw
	 mOFAvkRpf5gdA2kDuazb8BT/6Afo7+r1gJVsyk41DjgfNiqgvJt9Y9CZm20y9nsD+5YGU
	 J9BHKyUW0TfxGhDx6ACcd4hjNHJj9H/0vdb8X/Kexbi12d2XkRxMe+W3ZUjXZLlhl5Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="aK/wzRez";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FC2760A2606;
	Wed, 28 Oct 2026 18:13:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aK/wzRez
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95D1E1F01825;
	Wed, 28 Oct 2026 18:13:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793211237;
	bh=A1hbNRRGYMMN5eznQYjIAL8fbUwkQ6Krc3QKcVKi1Ac=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aK/wzRezJ9WdjxO+sLvt8fpYJ+jZ+P8y3cEgE3j34LcNlIn6u639o8qlJHncXkUy+
	 4zxBoze00tMx+1ddI+ZlEhExuKjR7MpvvwbIXhPlOG+ZAx439Dj6bv6wvuR/9Vx3de
	 KSP4Fb64omsODqrX6tS0hNbMN3A1HI2RPoQB3Ns4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Orgad Shaneh <orgads@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 306/571] usb: octeon-hcd: fix the FIFO-flush timeout computation
Date: Wed, 28 Oct 2026 17:57:33 +0100
Message-ID: <20261028170015.260645372@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index a1cd81d4a1144..16fb72eb3d185 100644
--- a/drivers/staging/octeon-usb/octeon-hcd.c
+++ b/drivers/staging/octeon-usb/octeon-hcd.c
@@ -578,7 +578,7 @@ static int cvmx_wait_tx_rx(struct octeon_hcd *usb, int fflsh_type)
 	int result;
 	u64 address = CVMX_USBCX_GRSTCTL(usb->index);
 	u64 done = cvmx_get_cycle() + 100 *
-		   (u64)octeon_get_clock_rate / 1000000;
+		   (u64)octeon_get_clock_rate() / 1000000;
 	union cvmx_usbcx_grstctl c;
 
 	while (1) {
-- 
2.53.0



