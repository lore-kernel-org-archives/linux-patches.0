Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3DDB46A5EA;
	Tue, 21 Jul 2026 17:28:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784654921; cv=none; b=HwqMYGAauCDpfVxneCtx0w0TtfMSXJDqVaEIP4ZApre2vTGasaVqe2uJr7IhzabVvM44Lv6FWMBmwYvUkQdZN8ZNn9rcDkzXy3lSxIHI8bftRSLpl+d8ShvBFmwyG+ZsNfiL3Rbh943qRY6uVjdAEqgzbR1IdaNFgH/biEzEtvU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784654921; c=relaxed/simple;
	bh=yzLv+n/8xMOLncirknOZ/uHVe9qlJmrvnxh97v/sGZY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZFKSMCZ1rPqSihxAx20bOuQXrq36lXvffbcaFoAHCiRWRNMDPJzTcSq6nrkmVp4TXKaQpM9255SnlFeuGXw1wDqAxRALZlDDbWb53s2ZeI5JByjS36H6EZvxGpcxxbHX0JuKWX07jDrz3bMkhXUv5CkcJTVPvRKzj7b5utVbYGs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cKkbmqRH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cKkbmqRH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36B6E1F000E9;
	Tue, 21 Jul 2026 17:28:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784654920;
	bh=ndPO+6ReosaMuyhs+PLloWIc2URH7Ib5S83Gnmr0QfQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cKkbmqRHej+IPsynDrLsGA2MjW5WOiZ06Sy8jeOhwDczdLwI3bECV8qhvMyrUbD8z
	 k+sHx4oULq54qNtgDs4qkOjj7DXYst9n0vR+1weifOVDgnwNqYpIrZP4n6t8TqbHfW
	 /qPkfN7hsRLTFFWXIygD4eO+0fQohIQaLNr1oxNc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko bot <sashiko-bot@kernel.org>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 7.1 1886/2077] Input: ims-pcu - fix firmware leak in async update
Date: Tue, 21 Jul 2026 17:25:59 +0200
Message-ID: <20260721152637.204567069@linuxfoundation.org>
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

From: Dmitry Torokhov <dmitry.torokhov@gmail.com>

commit d48795b5cd6828d36b707e8d62fc9e5c90e004ab upstream.

The firmware object was not being released if validation failed.
Use __free(firmware) to ensure the firmware is always released.

Fixes: 628329d52474 ("Input: add IMS Passenger Control Unit driver")
Cc: stable@vger.kernel.org
Reported-by: Sashiko bot <sashiko-bot@kernel.org>
Assisted-by: Gemini:gemini-3.1-pro
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/misc/ims-pcu.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/drivers/input/misc/ims-pcu.c
+++ b/drivers/input/misc/ims-pcu.c
@@ -964,9 +964,10 @@ out:
 	return retval;
 }
 
-static void ims_pcu_process_async_firmware(const struct firmware *fw,
+static void ims_pcu_process_async_firmware(const struct firmware *_fw,
 					   void *context)
 {
+	const struct firmware *fw __free(firmware) = _fw;
 	struct ims_pcu *pcu = context;
 	int error;
 
@@ -986,8 +987,6 @@ static void ims_pcu_process_async_firmwa
 	scoped_guard(mutex, &pcu->cmd_mutex)
 		ims_pcu_handle_firmware_update(pcu, fw);
 
-	release_firmware(fw);
-
 out:
 	complete(&pcu->async_firmware_done);
 }


