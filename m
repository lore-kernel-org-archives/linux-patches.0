Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6A5F6FA1
	for <patches@lists.linux.dev>; Mon,  3 Apr 2023 14:27:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DE52C4339E;
	Mon,  3 Apr 2023 14:27:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1680532073;
	bh=IKQomHzk0YuxwGm+Zh7vyflVXcYZUmY63Ox9zyNiL6A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=I2+aeaRSXCHwonVooyoLAgg7k/FHtyQULEGUeG6/RtMpR9t5hxaIJ3Tb6+2HnvlZq
	 URrLVLUoHY/uh44WUTJUPbstT3oxweTIB85ZONGJA5u5yVF+PZuvUrvjXqZVR+X7pS
	 oBUC34slsCft2c4CFae8eeHraxGhrpq1+OMfj/AI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Chen <peter.chen@kernel.org>,
	Xu Yang <xu.yang_2@nxp.com>
Subject: [PATCH 5.10 085/173] usb: chipdea: core: fix return -EINVAL if request role is the same with current role
Date: Mon,  3 Apr 2023 16:08:20 +0200
Message-Id: <20230403140417.175338548@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230403140414.174516815@linuxfoundation.org>
References: <20230403140414.174516815@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Xu Yang <xu.yang_2@nxp.com>

commit 3670de80678961eda7fa2220883fc77c16868951 upstream.

It should not return -EINVAL if the request role is the same with current
role, return non-error and without do anything instead.

Fixes: a932a8041ff9 ("usb: chipidea: core: add sysfs group")
cc: <stable@vger.kernel.org>
Acked-by: Peter Chen <peter.chen@kernel.org>
Signed-off-by: Xu Yang <xu.yang_2@nxp.com>
Link: https://lore.kernel.org/r/20230317061516.2451728-1-xu.yang_2@nxp.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/chipidea/core.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/usb/chipidea/core.c
+++ b/drivers/usb/chipidea/core.c
@@ -966,9 +966,12 @@ static ssize_t role_store(struct device
 			     strlen(ci->roles[role]->name)))
 			break;
 
-	if (role == CI_ROLE_END || role == ci->role)
+	if (role == CI_ROLE_END)
 		return -EINVAL;
 
+	if (role == ci->role)
+		return n;
+
 	pm_runtime_get_sync(dev);
 	disable_irq(ci->irq);
 	ci_role_stop(ci);


