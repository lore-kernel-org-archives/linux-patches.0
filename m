Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1381053161E;
	Wed, 23 Sep 2026 14:26:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790173568; cv=none; b=Qm9dWdD0U2hPy2XS7nAe8tTownyi5w6Q4TPvdoaGZZtb1RW0O1XLmQBxKiZCzQQQM26t5UPag09hY+oEYw94Ac+GZBq/5U0B4ccmWluU3IorKwOA9Y45vSFmUNbPZSwAPoUnIyit2nvVqTSHxqsdLLAmwiihEHtBydFEeXjUHIQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790173568; c=relaxed/simple;
	bh=ATBpuevM8rht5KgXc9WxLq5UmQ00MZ/RqDiJF2421FI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Gf3EmPCGVk4GGrTun2792J9dUdZZ5tFua8d2+SBy7/sSmSub7Tsg8WMujOaAckMPsH53lcwy79wiT1HGwLA8jViCX2bDLUs8SM1kyF8XU49VBwOeCyotOx9b5z4p+te4Yh0+VeQqEDviPRsod8dL8bgZ09rOL/BU85NpaqUwAas=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZhZMcPNn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZhZMcPNn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 502881F000FF;
	Wed, 23 Sep 2026 14:26:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790173567;
	bh=cXxj8umbt3dANLvcDcWlIBxcBOA/4zpo2qHLpwIBCJc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZhZMcPNnCuzceoqK6Jh8hEv9gOEaSYf0WHFHj01dTJcOs4agpAD0EAF5uaFkyrKA3
	 m5axrkdI8oXGd4H0qcXmRON35rxwBgBai8XiX0Qs3KMQbbF1SoctJU7qNoqrMrvfVu
	 hU+sxyaU5EO5YGoSYdHr7HxK6KWoulrMaKpZtnf8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michail Tatas <michail.tatas@gmail.com>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Subject: [PATCH 7.2 286/438] gpiolib: Put fwnode reference on failure
Date: Wed, 23 Sep 2026 16:05:07 +0200
Message-ID: <20260923140652.185823174@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140644.756254324@linuxfoundation.org>
References: <20260923140644.756254324@linuxfoundation.org>
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

From: Michail Tatas <michail.tatas@gmail.com>

commit 16b10f64c63f78220c3b4035f1ed6cd3bdcb0b02 upstream.

We get a reference to the fwnode handle which we pass to
gpio_shared_make_ref. In case it fails we do not put the reference.
Fix by putting the reference in the failure case

Fixes: 49416483a953 ("gpio: shared: allow sharing a reset-gpios pin between reset-gpio and gpiolib")
Cc: stable@vger.kernel.org
Signed-off-by: Michail Tatas <michail.tatas@gmail.com>
Link: https://patch.msgid.link/an4Asr4tx3D2QvLD@michalis-linux
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpio/gpiolib-shared.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/drivers/gpio/gpiolib-shared.c
+++ b/drivers/gpio/gpiolib-shared.c
@@ -261,10 +261,13 @@ static int gpio_shared_of_traverse(struc
 				con_id[con_id_len - suffix_len] = '\0';
 			}
 
-			ref = gpio_shared_make_ref(fwnode_handle_get(of_fwnode_handle(curr)),
-						   con_id, args.args[1]);
-			if (!ref)
+			struct fwnode_handle *curr_fwnode =
+				fwnode_handle_get(of_fwnode_handle(curr));
+			ref = gpio_shared_make_ref(curr_fwnode, con_id, args.args[1]);
+			if (!ref) {
+				fwnode_handle_put(curr_fwnode);
 				return -ENOMEM;
+			}
 
 			if (!list_empty(&entry->refs))
 				pr_debug("GPIO %u at %s is shared by multiple firmware nodes\n",


