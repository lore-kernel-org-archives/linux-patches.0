Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C31EE2E7179;
	Sun,  7 Jun 2026 10:20:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780827641; cv=none; b=ctozHuFZI+TTUDHc1Ge2rMI6TJvn2J7rFSh8bQXVrB1BTkXEe3poGA17mKCDxcJfqAqFreg1LnVre0JGW1xrb5anJkAbJBHgW0FnnOVfxM25R1UYIcQlJEj4F0iwvW7VBv+y3cVxtpwLmfvUWiHxwwNohcDtXAmZgeG0ApQzJE0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780827641; c=relaxed/simple;
	bh=G3x/BkbsLJsEGubDo3EW+qg3Mjq8MxVwz7UOrURjcbI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=juHGqnjXihDCrNHn8T0shwNI+rxRUSjHJMvsKJjjwVwCefv6hCpt3BM1/Y2k/rgpNN7XTg7EcyNLKkTAD3P+0brnIwlQdlejVO99yctLGTL4EnnpiPlzGAu4/bEyPLydwga+0C2tSuzVy+GN5fyrwykN2qfdX8mVNhvA2WKRfuU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kdLo9s5w; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kdLo9s5w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 136171F00893;
	Sun,  7 Jun 2026 10:20:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780827640;
	bh=eHVvPkN246vfKlNkYET54RExpyb8eKC4c3mQiWEsiL4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kdLo9s5wglwGDQOGMeUWT8k8X8R+qDYSXn6KlcFn/+WaesS8fyVEapZmTqpHbWapB
	 ldHSr/NUkyOMTQqbBBdkBIDq2RbhadUZ8pvN4FzLqtRm6VobkE7DBS6OtbuT+hrBmb
	 bBxY8lt2zDsfJuPrPNdy64gZH2p/lfADYtK3k37Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Lechner <dlechner@baylibre.com>,
	Linus Walleij <linusw@kernel.org>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 101/332] gpio: adnp: fix flow control regression caused by scoped_guard()
Date: Sun,  7 Jun 2026 11:57:50 +0200
Message-ID: <20260607095731.846226095@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095728.031258202@linuxfoundation.org>
References: <20260607095728.031258202@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>

[ Upstream commit a5c627d90809b793fc053849b3a00609db305776 ]

scoped_guard() is implemented as a for loop. Using it to protect code
using the continue statement changes the flow as we now only break out
of the hidden loop inside scoped_guard(), not the original for loop. Use
a regular code block instead.

Fixes: c7fe19ed3973 ("gpio: adnp: use lock guards for the I2C lock")
Reported-by: David Lechner <dlechner@baylibre.com>
Closes: https://lore.kernel.org/all/cde2abb2-4cc8-4fc9-b34a-0c5d2b95779f@baylibre.com/
Reviewed-by: Linus Walleij <linusw@kernel.org>
Link: https://patch.msgid.link/20260522073527.9812-1-bartosz.golaszewski@oss.qualcomm.com
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpio-adnp.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/gpio/gpio-adnp.c b/drivers/gpio/gpio-adnp.c
index e5ac2d2110137f..fe5bcaa90496aa 100644
--- a/drivers/gpio/gpio-adnp.c
+++ b/drivers/gpio/gpio-adnp.c
@@ -237,7 +237,9 @@ static irqreturn_t adnp_irq(int irq, void *data)
 		unsigned long pending;
 		int err;
 
-		scoped_guard(mutex, &adnp->i2c_lock) {
+		{
+			guard(mutex)(&adnp->i2c_lock);
+
 			err = adnp_read(adnp, GPIO_PLR(adnp) + i, &level);
 			if (err < 0)
 				continue;
-- 
2.53.0



