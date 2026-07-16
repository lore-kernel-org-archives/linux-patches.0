Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53FEA2F28FF;
	Thu, 16 Jul 2026 14:34:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784212498; cv=none; b=cUnJbo5r6cl45vglm041poafjN0Hm2ZS0p01+g3rn9fRZFijHMocO+kL1jcjqe+cNAnq0MQMtpI2JV5pddNsv5qBieVE7mV5jkTCGqvheLHrRzeanT6exUOCzMrqJagiGj9au6ALy00AuzpqLrhHOL1Yh1E5H7L7YxY/CMQrdtw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784212498; c=relaxed/simple;
	bh=jwJoM4Bzy5sxITAsc37wbQbCUcpJEqD3NhlQOZAGn/A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KD1kbYQzxIcETENQm2fr4Z5bXitV24vL85Ft1pTzjlTEYJSlNiVvZK32H/BnXtblKH0ch8UujcmhSRASjr3QWIE0I2L8ovoq8o2AqIeL2Xs6QE14eYLipx4PHSLvJUU/zEx6JB4qsjclp28CsSTNlrbjNT+YOcM3c1p8O8BX5Bo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x6UJ+W+f; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x6UJ+W+f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A90E01F000E9;
	Thu, 16 Jul 2026 14:34:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784212497;
	bh=b3ytH1J9fdlmgvHvRt4WIkqbb/1h5g1nFfpP1kGN7BA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=x6UJ+W+fYjE1rq0qKqt00aTxucDUGuv1nSQ1pbWlEJS2lCk5jHanVHVUPJCKf7Tu/
	 Eg4Ga0J9D/2NGW3IaFP+0cqGHpM008n6tRlATZaH1ZGsBZbfcuJjxxhMVvBGjggOpQ
	 NlNfOW6iMZJelgqlGSCwbJI+p2qEQ9M4lHGeOBgw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haoxiang Li <haoxiang_li2024@163.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 6.12 330/349] Input: synaptics-rmi4 - unregister function handlers on physical driver registration failure
Date: Thu, 16 Jul 2026 15:34:24 +0200
Message-ID: <20260716133040.699815681@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133033.287196923@linuxfoundation.org>
References: <20260716133033.287196923@linuxfoundation.org>
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
@@ -448,11 +448,13 @@ static int __init rmi_bus_init(void)
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


