Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 300B53BCD11;
	Thu, 16 Jul 2026 13:56:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784210215; cv=none; b=k8yDR1kh35P+KSn1wlJ3d8OfQLrJcxTf6xeilXQlrXU+xhS5Jvj4J94/jhAUK2oV6xld0FuDb8NEe8UV8N+NiWuPQ6oSNI6ECA971nnfIhLtp+TzSGOvWrpFAamIT07AFleJ6X8CFI+v9zisNl78fBHWTkWxQ3tQW5ny8sIpN2I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784210215; c=relaxed/simple;
	bh=5QrdOlGU1ZrU5ucgpml5d4G+TYV4jYOx877dNEI952k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kjHyixTrfePw36Esc1ayYu7ov5fMmqRkPjp0hey/XNiNyfkPp+068yOtXZFMXdtXpGGnKxwqEmtfcn2mzacPxaU4ky3ZN8tQOdihz2XwLcPg6+MPKWhoEd/SP1tGiKVf6n0H0T+Sv+N2khRzV7YQuXZajB0ct5BGSUSO635WxNY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=U1kbk/+r; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="U1kbk/+r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94F8A1F000E9;
	Thu, 16 Jul 2026 13:56:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784210214;
	bh=k9Nk7swJ64XH+okkvm78G12wuyFUom7lOjP7W4lyN+k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=U1kbk/+rKB16OZeRQGPN1ikRdIGt/Z0IXZ0OXwo3YAJPKbMmEiPKecSqfIDCSlIRL
	 ZK/1u4CovUOgqZEzh7UM2zGeCNMuF4g11j+5GG5Kfy4cLAg2iC5z1de+jmFe0ebxyI
	 sl8gEtvsoliLDUwSmIuD7ssHHbs0CZ3UlLRMcK+8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haoxiang Li <haoxiang_li2024@163.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 7.1 480/518] Input: synaptics-rmi4 - unregister function handlers on physical driver registration failure
Date: Thu, 16 Jul 2026 15:32:28 +0200
Message-ID: <20260716133058.351129832@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133047.772246337@linuxfoundation.org>
References: <20260716133047.772246337@linuxfoundation.org>
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
@@ -455,11 +455,13 @@ static int __init rmi_bus_init(void)
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


