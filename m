Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B415C412294;
	Fri,  4 Sep 2026 05:36:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788500198; cv=none; b=qekf4TXJdoDoquduBxiTyIbmJLx/76GVyZBbDjHAA7BWtVe0TfJAZEXu+FnBOAjzp7gQBdwPLSYU5ZSCEUizNcixM3vG3S0cABTgXfrzAGda43cU6FyiwHB6IZ/4Exbcmyc4OjlaPU+pPacyxT+7leRMVO37VCrp/pf+uVp7rIA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788500198; c=relaxed/simple;
	bh=LN3UsFGlktXMcuZIp5JO1lWMREiZvEHtLG6n0A70Qq8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aI9VTxH2ohTQhs8x0fIx+5AVhxC3NMQdcWL3hSB8dMCgIqq7ZYlBcQRVL4Q9W1UYj6okN6MWLZ8v28azjpanfy1gBLylB7ZsavgozZNCC4k5FhVVQw/kPAyCfhcBeiqrbsmXGmRUGmoi11g2hcY+XnTw3zpLk8930oRY7Sp73zY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=H1IFt8ul; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="H1IFt8ul"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D56B11F00A3D;
	Fri,  4 Sep 2026 05:36:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788500197;
	bh=rTZd+s26cpHyh5DiQOkD46erl4o/VMXiYloCluNHRDA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=H1IFt8ulqOSATFDdNdvTRxCshn5W7v4gYBxaV11xrrNXjtp9EZOgvCWztSpIRFKSl
	 WCJGSw7pVDYGaAinYdQEXzEIH6bboqTM5/8C3eXER45xv/4h4hy67Yz+PIE7HLks3k
	 5DHrsBd9b4b+0rlLwxD7aesgmkRL4ROutaVMRP28=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Thomas Richard <thomas.richard@bootlin.com>,
	Lee Jones <lee@kernel.org>
Subject: [PATCH 7.2 632/713] mfd: cgbc: Fix teardown ordering in cgbc_remove()
Date: Fri,  4 Sep 2026 07:00:00 +0200
Message-ID: <20260904045817.997097756@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045803.810145556@linuxfoundation.org>
References: <20260904045803.810145556@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Richard <thomas.richard@bootlin.com>

commit 2970c2db8ab3d97ea6250c14ca49b1e1731115ab upstream.

Release Board Controller session once children are removed by the core.

Cc: stable@vger.kernel.org
Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://sashiko.dev/#/patchset/cover.1783507945.git.u.kleine-koenig%40baylibre.com?part=19
Fixes: 6f1067cfbee7 ("mfd: Add Congatec Board Controller driver")
Signed-off-by: Thomas Richard <thomas.richard@bootlin.com>
Link: https://patch.msgid.link/20260713-cgbc-core-fix-cgbc-remove-v1-1-79274ad62b3a@bootlin.com
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mfd/cgbc-core.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/mfd/cgbc-core.c
+++ b/drivers/mfd/cgbc-core.c
@@ -364,9 +364,9 @@ static void cgbc_remove(struct platform_
 {
 	struct cgbc_device_data *cgbc = platform_get_drvdata(pdev);
 
-	cgbc_session_release(cgbc);
-
 	mfd_remove_devices(&pdev->dev);
+
+	cgbc_session_release(cgbc);
 }
 
 static struct platform_driver cgbc_driver = {


