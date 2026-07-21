Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3650146EC7A;
	Tue, 21 Jul 2026 18:37:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784659070; cv=none; b=fc5dPutfZDmRl+ySXmkchIgHHMa/66STglhnkA+9DTDid7NGkXLxZ2JAx1/xc86q+2S/QXmGI3qNMIqKfNkw4j/XJGeGKDX/lTIdG4nnpRWcFp2rXR8qP0KSPJUBpFL2Efv+LiBq9FJGtdwesRmjDZ8NjLy4JAPo3eyQNZujolc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784659070; c=relaxed/simple;
	bh=BY/yfOJM8d6JfQHF8BupaOnlIq6KQDq9zHtL1BAOgXk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hFKtIDyJ1ihNWpyvLOo+W+9fWnth2PiVNKeWoQ+y0GQRyg+KZk4YSFWAcWpz8fJ661oT388weM+9LNjkVhIz4BNnvr4ASBnwsvQ8Npf2xCWsJwTRJWCrGXLZ25/BV8W2OAh60+0hPsWbBtlI/lDUYBwGrfCIqiG320N/fQzK474=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=u9iUHfDM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="u9iUHfDM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1028F1F000E9;
	Tue, 21 Jul 2026 18:37:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784659067;
	bh=2R2LkNFWJxeqSUl2c35xeBgmsfW5jxW7bb4rIQukkHw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=u9iUHfDMpGJlgMz4pjQCP6EHS2ZkVUQwy3f6rIs9gV+Y6t0g/E6mkmT5UeNs71ZRz
	 4GrRNXyODIQyIGNYhu+AUiJZDrenD4Xio8mqzLpUpejIP8Yjtq6qvmLS49zYMPIdjd
	 XoMOVgngCiwHQcqII5BP1+aGoqCpat4CmMK958h4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko bot <sashiko-bot@kernel.org>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 6.18 1380/1611] Input: ims-pcu - fix firmware leak in async update
Date: Tue, 21 Jul 2026 17:24:56 +0200
Message-ID: <20260721152546.482850659@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -944,9 +944,10 @@ out:
 	return retval;
 }
 
-static void ims_pcu_process_async_firmware(const struct firmware *fw,
+static void ims_pcu_process_async_firmware(const struct firmware *_fw,
 					   void *context)
 {
+	const struct firmware *fw __free(firmware) = _fw;
 	struct ims_pcu *pcu = context;
 	int error;
 
@@ -966,8 +967,6 @@ static void ims_pcu_process_async_firmwa
 	scoped_guard(mutex, &pcu->cmd_mutex)
 		ims_pcu_handle_firmware_update(pcu, fw);
 
-	release_firmware(fw);
-
 out:
 	complete(&pcu->async_firmware_done);
 }


