Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 795A837473A;
	Tue, 21 Jul 2026 22:01:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784671264; cv=none; b=csaM82uqsu+MGOq68X700S8OuemyEuHAbl+BLZXhDSch2Y8EHNFUPlBY9/521ku2jU8eHH8YAKmips9VRCQ1IBY9qZ2h8mv4oa79nT+Ogzb1BPT14SQcJFUjP0ZBxOBv+b3Y/T6KShDiuFTfVM/1xItBaZ2N5556zJJ/tUhYoZY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784671264; c=relaxed/simple;
	bh=XFSEkgsbTz1lL0XA46I0EaNzi1vruHNCOOUbQRe7yV0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TkPcSCli1QuN2ErRljPJMaHy43MOxul55fMScDxY+Z0fl3C1oat9OI+w3S5HAoLYWDyJ1VMhM9bwvqR+U5xbfZovhnhnUlB/KpcJcmg09HHVZBITbLnZkw/kt4cMrZojWrnvwrEiSq5WgqsF2CgYbyVzFPsijRZUMLfZlApSW6U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=o//5rAqO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="o//5rAqO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA5671F000E9;
	Tue, 21 Jul 2026 22:01:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784671263;
	bh=6NR3f15zksWeGVv0di2oOWNQnOS/BKGowtNi+zNNWks=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=o//5rAqOJ+QfanjwneHaiWjvKbMDvSAXxhV/Udet+6LzUftmoIQNl3vnqasjxD1fd
	 Snk9pEKSY6dIy6NbnzjFmD6xPkT3tcsQgA8YpFwPDKr93RoBR6wH5InKyPM/gSIyl0
	 EOdQS0TePsoqz2pNvg0RUESFO+WCui7saMzC5KrA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haoxiang Li <haoxiang_li2024@163.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 5.15 181/843] Input: synaptics-rmi4 - unregister function handlers on physical driver registration failure
Date: Tue, 21 Jul 2026 17:16:56 +0200
Message-ID: <20260721152410.090390749@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Haoxiang Li <haoxiang_li2024@163.com>

commit 6251f7d3472c0409e30f8d6a24f10d33d12e3f9a upstream.

If rmi_register_physical_driver() fails, the current error path
unregisters only the RMI bus. The function handlers registered
earlier remain registered with the driver core.

Add a separate error path to unregister the function handlers
before unregistering the bus in this failure case.

Fixes: 2b6a321da9a2 ("Input: synaptics-rmi4 - add support for Synaptics RMI4 devices")
Signed-off-by: Haoxiang Li <haoxiang_li2024@163.com>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20260610064633.2837084-1-haoxiang_li2024@163.com
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/rmi4/rmi_bus.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/input/rmi4/rmi_bus.c
+++ b/drivers/input/rmi4/rmi_bus.c
@@ -447,11 +447,13 @@ static int __init rmi_bus_init(void)
 	if (error) {
 		pr_err("%s: error registering the RMI physical driver: %d\n",
 			__func__, error);
-		goto err_unregister_bus;
+		goto err_unregister_function_handlers;
 	}
 
 	return 0;
 
+err_unregister_function_handlers:
+	rmi_unregister_function_handlers();
 err_unregister_bus:
 	bus_unregister(&rmi_bus_type);
 	return error;


