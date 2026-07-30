Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1ECBA38E5DC;
	Thu, 30 Jul 2026 16:17:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785428240; cv=none; b=YUn+GMcnPMV/HM1eVSJiT7V1XrKyV+yz7VyrHvj0M6Bgjpk44IR49lIStAVlPw7NPJnkblkKfWVDoRQm+zkTqWZKhfBdPSR+L7RjF+1wrxgs1fsaapJJ6twH/MJApTWhQGZPcOXhikj+VojwC86X6ZDk8X3DnXZoZUj1OL2tsG4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785428240; c=relaxed/simple;
	bh=5+FAH7wym9Y93ZI9THsolznBvLURY93Diy3nNU2t7Vg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=snDG/2HJbOD3FLnid1sEhgpjn/UzeYtcT7dEnwVHnsa8hYuchG3Vc/Igfvnl4NIZ/TDxojKCNvNrKJERaCIxBfz1cGa6324XaXoByY4zAlGPpiOC4TxNL693muCpNktD5nhmKx3JwaT127GA/Y5GvxyRPF8kg5/0KNye/L95Blw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=itAqAozB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="itAqAozB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79E791F000E9;
	Thu, 30 Jul 2026 16:17:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785428239;
	bh=goOE+50WTih4viSA8FXb4ur8O14ZV+slyKA6/Ge72Xg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=itAqAozByBBduvkJjWI0PCFddMTj4eb4S4o5IiVTHOPxjoeKARrYWy5vTsDheZJxb
	 dSiQcF3O9KlZjIaI0ZDp6imcb0Bet/Hd8mTOyvouP3vzy2q4twaIGXkAFXrd1ioZo3
	 Nzp3xoVHedD8tXO2GrVt/SOZFY/8ApAKEpgJUds8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko bot <sashiko-bot@kernel.org>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 451/484] Input: ims-pcu - fix firmware leak in async update
Date: Thu, 30 Jul 2026 16:15:48 +0200
Message-ID: <20260730141433.279147150@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141423.392222816@linuxfoundation.org>
References: <20260730141423.392222816@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


