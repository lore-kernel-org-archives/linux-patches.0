Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A9AA2D0C79;
	Thu, 15 Jan 2026 17:39:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768498778; cv=none; b=S8S6aX33Llcj6MzTSwglj0VMk37o6XVLYU2WalXRdhPxsQJZavzI7srO25nce4EhgsG5ps53qNuc961s+xaGC0dXAwxu8DdBAp1QQMFhkjw2z/xIS35JWAiog7Dhi/t32dUtdy51MoEKemVs2Dod1b6KAZmeEJNB+fEeNsfQGGo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768498778; c=relaxed/simple;
	bh=hACj+KIMEuuiLZ3yqRrAFhNze5xzY2J3ajahYER2Flw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XhGYBFLabHa3cbZk6wmIegeHD/4sYtsv/4Tg4cVsdBiVSjFOfEsoXQgzATKrrL+fkYNSYoXEZ9W4Ka/vtPWbkOMD4IOTPJKXDaj1TZqdKWCxIowGLwWloDUdV5D//1JEtuKbG+FBO097K4FZLBynlufRXY+dXKrB9h84ZGqjVBo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xVET4aTx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xVET4aTx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EA63C116D0;
	Thu, 15 Jan 2026 17:39:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768498777;
	bh=hACj+KIMEuuiLZ3yqRrAFhNze5xzY2J3ajahYER2Flw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xVET4aTxrUwXRrLM9is2CCDGQeB/jVosSPowUENw8Fs/DvwuoNesVvU64vPnuEYF/
	 lVw+UasGJ+Py31mQItEIGnvvRGA24b/ySwyOhxs5SBG7gKAKWaJ35jJ4QShl8XNiVa
	 qLf+dh468q++HaZHP6bd6cQO5FXmYJxe1dO1hJbM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sumeet Pawnikar <sumeet4linux@gmail.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 550/554] powercap: fix race condition in register_control_type()
Date: Thu, 15 Jan 2026 17:50:16 +0100
Message-ID: <20260115164306.238160702@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164246.225995385@linuxfoundation.org>
References: <20260115164246.225995385@linuxfoundation.org>
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

From: Sumeet Pawnikar <sumeet4linux@gmail.com>

[ Upstream commit 7bda1910c4bccd4b8d4726620bb3d6bbfb62286e ]

The device becomes visible to userspace via device_register()
even before it fully initialized by idr_init(). If userspace
or another thread tries to register a zone immediately after
device_register(), the control_type_valid() will fail because
the control_type is not yet in the list. The IDR is not yet
initialized, so this race condition causes zone registration
failure.

Move idr_init() and list addition before device_register()
fix the race condition.

Signed-off-by: Sumeet Pawnikar <sumeet4linux@gmail.com>
[ rjw: Subject adjustment, empty line added ]
Link: https://patch.msgid.link/20251205190216.5032-1-sumeet4linux@gmail.com
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/powercap/powercap_sys.c | 16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff --git a/drivers/powercap/powercap_sys.c b/drivers/powercap/powercap_sys.c
index fd475e463d1fa..d7dadcaa3736b 100644
--- a/drivers/powercap/powercap_sys.c
+++ b/drivers/powercap/powercap_sys.c
@@ -624,17 +624,23 @@ struct powercap_control_type *powercap_register_control_type(
 	INIT_LIST_HEAD(&control_type->node);
 	control_type->dev.class = &powercap_class;
 	dev_set_name(&control_type->dev, "%s", name);
-	result = device_register(&control_type->dev);
-	if (result) {
-		put_device(&control_type->dev);
-		return ERR_PTR(result);
-	}
 	idr_init(&control_type->idr);
 
 	mutex_lock(&powercap_cntrl_list_lock);
 	list_add_tail(&control_type->node, &powercap_cntrl_list);
 	mutex_unlock(&powercap_cntrl_list_lock);
 
+	result = device_register(&control_type->dev);
+	if (result) {
+		mutex_lock(&powercap_cntrl_list_lock);
+		list_del(&control_type->node);
+		mutex_unlock(&powercap_cntrl_list_lock);
+
+		idr_destroy(&control_type->idr);
+		put_device(&control_type->dev);
+		return ERR_PTR(result);
+	}
+
 	return control_type;
 }
 EXPORT_SYMBOL_GPL(powercap_register_control_type);
-- 
2.51.0



