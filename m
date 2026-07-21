Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B6B7367B63;
	Tue, 21 Jul 2026 22:36:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784673384; cv=none; b=j28AU72GkElYIpVL6lEWL2val0WAKnLnlvkhgG3R0MaFvqyCuTbXEoXUL9PdMW7SSquLE1Z1kiTYd3cQzeXxwzkdJA26IPEdEkTsE2QSHAds9l2xMJr/PKRPmRjjqG6hJ1Tyf9soWzJYmcyjCs58P2x7ZrfPb9+WX3qsTYiC0IA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784673384; c=relaxed/simple;
	bh=JgFnVeBxW+3Ow4pE6tnPf3yy4kR9N83RIW7YR1X8/wQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lHusIeP2f68wY9aRNhHN8f1g8TMUpOjtT58Grtu/7HQZtqwo5CKpRI/9qRtsUp2bP1h8QPum9I48Fgop1gjErxQSSdUMt+VpJaboUlGlRQfshhPKqn4m/MbONWXJCFkcHkAoyBIZov6VimkSa6tItABTkTX1SqKJUgiwSQFAu58=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mZRTL5sI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mZRTL5sI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DE7C1F000E9;
	Tue, 21 Jul 2026 22:36:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784673383;
	bh=JP5V3vuY3Rz/JMDX7I9dObu21+ggjeV1c2BSRUuT+AM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mZRTL5sIHVPtY7yfHTZGFVzlVe7V6ZLoID/FV9B2lWfur/0QtrEAhW6jx0I2F4sgp
	 Dug8PLyG0RorFTWtInbfpdNntk4GZ6wTvRU+mKBkGF6mMnPBqyPN/kIq6UNBVeiwxT
	 wYNcTc9I+9U2zjTpqRkNeK1xHn8e+IfXHHGxks+g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haoxiang Li <haoxiang_li2024@163.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 5.10 143/699] Input: synaptics-rmi4 - unregister function handlers on physical driver registration failure
Date: Tue, 21 Jul 2026 17:18:22 +0200
Message-ID: <20260721152358.934169372@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152355.667394603@linuxfoundation.org>
References: <20260721152355.667394603@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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


