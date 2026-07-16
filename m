Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5210C400982;
	Thu, 16 Jul 2026 14:17:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784211481; cv=none; b=oJ8bLWLNAL+tY+pBHvMAhOzB52yPNoNZ6xZ/eysMIdqaaDuSGgIVFkk9Ois2WNr/4XkswuklnWxbNKAuwqI+j+Ukg0fdatTv1iFp2aGXVP80wljmNyCWjgG82EZcE5L5fM/rthePP+8f6CqSVp6tm/pvv7usoFumfOe8JWpCzWc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784211481; c=relaxed/simple;
	bh=skG3G+8Y5YIswIza2kCUHcK5aqMV09E2ZrD1bw+Crn4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f/f6HrJGjbR/pw8u8D4npDnoBMKWcG8QD+jfIk+N3zoPFoun3xvb/IBgPlTJq1lC0XK1rB23qzUcgOQsQ3t9cY8lfQbtNyvHNpLYOIK5eEHFBEu8Aps3xo1TmuQv+EIXwUnCuMelnyXkpBcDPU9/5tQeIUxDutGvkHYrpZtqTzw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=naIsqVgV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="naIsqVgV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1D361F000E9;
	Thu, 16 Jul 2026 14:17:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784211477;
	bh=PQ2rYiFFGm2HQ/eAutgPpq2AVRloBvLDTuGWdGz6vUo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=naIsqVgVQekGgZ4FKhZwixAOho2+c/LYqkU2yDYmTSBNNSflWVOdk1Fcm9/Bh2FVm
	 GDdyUQl7gyYirHTj0FctrCJCkbcTqSCQMyJTLMeewCGJ5kX0zwg4sD8EYZ3sIf5vst
	 eZV02JPU9iblWGkLyf6C/C03DXRW4VTMziVGCO9M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haoxiang Li <haoxiang_li2024@163.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 6.18 443/480] Input: synaptics-rmi4 - unregister function handlers on physical driver registration failure
Date: Thu, 16 Jul 2026 15:33:10 +0200
Message-ID: <20260716133054.402489973@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133044.672218725@linuxfoundation.org>
References: <20260716133044.672218725@linuxfoundation.org>
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


