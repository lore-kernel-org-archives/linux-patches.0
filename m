Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66A2B42DFEC;
	Tue, 21 Jul 2026 19:59:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784663988; cv=none; b=q8AYuvR+yA1kYNhcqbXMVyN6k5v6N51L1f2Sd58W1iS9yulMTbNJ1u5HUpEwns1LXs8v6YahrX8/3n4NT3UtG4NTjegMPI2uY21nQdvqCF8vBlnNuP5mUP+UBFFbJjkUhE49LAIo+8FC328PVW4rhz9fJtH2Y9xxwx8zqnrkauI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784663988; c=relaxed/simple;
	bh=0AeMawJR0+ylnxWm4ZXfCA1ar1k5ScEjZPXK2wQ8qNU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Vtseq29eTFYjs0cB77Jk9PGQ99lEvHJsjxakiwvXixZD1vd1nlcsRqZWmn+ZhPS1QkUCyPxEYsiaaaPzg9CSbaGAOHu+gXtSLAsXN6sXH1rmrQe/ct0JegiTD98GY4mdCgu4tgT0usnXxx8VoflXkMtcASXLFpOd/prj7eXRfwY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RJ/dga2s; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RJ/dga2s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8774A1F000E9;
	Tue, 21 Jul 2026 19:59:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784663986;
	bh=fjBlqUcyq4EyZj0z5mux492IOykZdLBnLCp2fucqVrA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RJ/dga2s00sIXbqaJgkjiYr63IxcVDVbWbcPMkccBgbcssLVnwz1rVFEBaHZcCgxo
	 P6oVPQ2ptgDigB0w0KQu0cSgQjzjBEjgxTUyfqo6Q64pkCIxIIBIsO3SsxgRGENHQl
	 loclD/kBNp4RBO1BTrJIHs7PNbgbkUqZpJCmoDk4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko bot <sashiko-bot@kernel.org>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 6.12 1031/1276] Input: ims-pcu - fix firmware leak in async update
Date: Tue, 21 Jul 2026 17:24:34 +0200
Message-ID: <20260721152509.065620749@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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


