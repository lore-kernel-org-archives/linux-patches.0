Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7148535DA68;
	Thu, 20 Aug 2026 17:50:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787248202; cv=none; b=T23yM5Bz2K9JIzj6ME4BfVfRBORUOGjY7rm5h7JFjSQbdlCOUxj3qcehB4jxi1F2OYdVzUPcu10yeELwpQvOGHO9EQllNPxSpa55XgObH3tUidtY1D7GWOGUesh4PYvhjw5MLpPGGKPu3MxHDhadiPD1BXJRVOY0j38WgCBFZW0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787248202; c=relaxed/simple;
	bh=vblmn7sXPyFesjprfedb6r3jGLC9xkhjTB5+LoD1RjM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cYaCVzNqSu+GtppxwZwQwtgPAO79B3aj6EOiJgYoIkvj6Hlakc5vUqDzbiN9dHIpAx/3omXGAempGTag24l8nSY2Rql62cdsKpuiz385gbPmfn+9XsvOJhjfHKey2LkU0hFAm316/MJ7wcdadX/56LPNykHV89rxSu1CkmvvIj0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2r2wPyMs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2r2wPyMs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3DA41F000E9;
	Thu, 20 Aug 2026 17:50:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787248201;
	bh=iixW9PS5SG2INqGI/bWBquXqsEXlOLccSey1zouYCo0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2r2wPyMsTYnCifLW2+v271QGqlImX2r0gn3no58xK5eN3Phl3e0aKlq8sEuPCQMkr
	 Z+G8xJJLnxsHL5wjhxmJ69MpJVAojT/sacApChU+CEBeaeC5DNoi3u/8JZk+BV9JKb
	 rQY06h4Alkw0ZutkYwmxVxitR7Tl2VC4wVkxalII=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko bot <sashiko-bot@kernel.org>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 143/303] Input: ims-pcu - fix firmware leak in async update
Date: Thu, 20 Aug 2026 16:54:39 +0200
Message-ID: <20260820145257.581158383@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145253.200766705@linuxfoundation.org>
References: <20260820145253.200766705@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Torokhov <dmitry.torokhov@gmail.com>

[ Upstream commit d48795b5cd6828d36b707e8d62fc9e5c90e004ab ]

The firmware object was not being released if validation failed.
Use __free(firmware) to ensure the firmware is always released.

Fixes: 628329d52474 ("Input: add IMS Passenger Control Unit driver")
Cc: stable@vger.kernel.org
Reported-by: Sashiko bot <sashiko-bot@kernel.org>
Assisted-by: Gemini:gemini-3.1-pro
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
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
 
@@ -987,8 +988,6 @@ static void ims_pcu_process_async_firmwa
 	ims_pcu_handle_firmware_update(pcu, fw);
 	mutex_unlock(&pcu->cmd_mutex);
 
-	release_firmware(fw);
-
 out:
 	complete(&pcu->async_firmware_done);
 }


