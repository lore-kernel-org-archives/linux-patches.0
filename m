Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADDB340B101;
	Tue, 21 Jul 2026 15:49:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784648992; cv=none; b=L94LVNL31umzpagt1pbPNho9QDDHjZ2fkQvQNxSqC+kajx7JLzJqMZo8L7JNakVkP+Buosw9/voRXCyNOreAgSkq23tN++MFtINE4jIjhXTDyTZUgdG5yJ6VXRLFPQmM37v7ZGdEYQuHepZLHP6JltxV8dJClbFKhQAZP9uKUKQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784648992; c=relaxed/simple;
	bh=AuxxasNn02NGvumV4CM85af2lmkFhr9eZK4YjI+ogOU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AXs91Qv8T8QSRJO63uUSE2FIdT2LmmLbxGJLKhiAG2DPL5AzhRdCyFb8vm+gor9Qd0zQ494Vyq13fB/V/dDYvW4ws/DzCW+vrMZ7Cf0MPisc5QOm+c3TTLnRLa6QfL/a1mL3pjaPDFaA9sL0byh6IMlkLZ7APADlIo8Fe/6J/nc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=udRaKR9l; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="udRaKR9l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A02E1F000E9;
	Tue, 21 Jul 2026 15:49:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784648991;
	bh=kH3+Zky0tfOkW6LeRDgvGh7f1jkgb95r16PhsJOoo/s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=udRaKR9lZuQgMCQKt6eLAAywXuY5JVzlSUsud4O0g5j3bH3sB8ctmhmuT7F1p1L/A
	 wdYzY81z19AfHdf5blUsEnI0l0ghYIsCSkAr1Dq+1F1Fnh9wzqRtwq+0jGkmSn6M/S
	 Eb6t4W9bCWoK3nk6hCNzVlOYtNNB33gA/z3BDL1k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aleksander Jan Bajkowski <olek2@wp.pl>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0366/2077] crypto: inside-secure/eip93 - Add check for devm_request_threaded_irq
Date: Tue, 21 Jul 2026 17:00:39 +0200
Message-ID: <20260721152601.320442749@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aleksander Jan Bajkowski <olek2@wp.pl>

[ Upstream commit 85a61bf9145d4097c740ffcf3aa832d930a8913b ]

As the potential failure of the devm_request_threaded_irq(),
it should be better to check the return value and return
error if fails.

Fixes: 9739f5f93b78 ("crypto: eip93 - Add Inside Secure SafeXcel EIP-93 crypto engine support")
Signed-off-by: Aleksander Jan Bajkowski <olek2@wp.pl>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/inside-secure/eip93/eip93-main.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/crypto/inside-secure/eip93/eip93-main.c b/drivers/crypto/inside-secure/eip93/eip93-main.c
index 7dccfdeb7b11c0..276839e1a515fc 100644
--- a/drivers/crypto/inside-secure/eip93/eip93-main.c
+++ b/drivers/crypto/inside-secure/eip93/eip93-main.c
@@ -433,6 +433,8 @@ static int eip93_crypto_probe(struct platform_device *pdev)
 	ret = devm_request_threaded_irq(eip93->dev, eip93->irq, eip93_irq_handler,
 					NULL, IRQF_ONESHOT,
 					dev_name(eip93->dev), eip93);
+	if (ret)
+		return ret;
 
 	eip93->ring = devm_kcalloc(eip93->dev, 1, sizeof(*eip93->ring), GFP_KERNEL);
 	if (!eip93->ring)
-- 
2.53.0



