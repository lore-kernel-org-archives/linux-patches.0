Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BA36139D0B;
	Mon, 14 Oct 2024 15:28:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728919709; cv=none; b=LOokWK5kYfynGbksYTKuqRoXZHWSI+5Z68Gd6PeXCP+5BQgKgw9kbYPpW2QEUwhlNW3LCIcMmDW5xs+tTVjzGGevzu/DmozT+i35GxH4JqJz9Ji2jNuyQs61Qa/AtaYIeZBlPhwMTIgkYdsmktIF9H2Urio4/0Tcz6dm4Zx3Q90=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728919709; c=relaxed/simple;
	bh=DetPzYkFNY7JA2sIeysjeqcmrWVspWmc8Y/a+MCwgGg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P+cy2WQ0ZpCGK04VvYb4W6HBW2IEOvMkm6CiZ+bHU4COPXQAHUMB6fK6tVxKqRiI20y+dv10N7OZNgMdgBeV96eO0dDH4nHMLdZ74zL/9LWFHij+Dz1qlrJ5OtsICzk8wH2CRFSoKctp7sjNs849ptQzMX+ySOVj8+HqAW/Ff1A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mjvHJz6M; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mjvHJz6M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 921D1C4CEC3;
	Mon, 14 Oct 2024 15:28:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728919709;
	bh=DetPzYkFNY7JA2sIeysjeqcmrWVspWmc8Y/a+MCwgGg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mjvHJz6Mv/US+e/tYuD5hxHUUaiEKZkKKPJ/qig2EzU8cdjOL4fdlJq0xOyXpNnZU
	 ND5Q/yvR/k8owNXP0C6huH3hKI/tRqANGQIzh82pLa6Gh5Rro0CL2Mv9KwI2mUTw0B
	 QErEIEd++g8QHrkM5Bn1eEbtcuNHe2gJlcAicBGs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Torsten Hilbrich <torsten.hilbrich@secunet.com>,
	Mathias Krause <minipli@grsecurity.net>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Tzung-Bi Shih <tzungbi@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 685/798] Input: synaptics-rmi4 - fix UAF of IRQ domain on driver removal
Date: Mon, 14 Oct 2024 16:20:39 +0200
Message-ID: <20241014141244.980899811@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mathias Krause <minipli@grsecurity.net>

commit fbf8d71742557abaf558d8efb96742d442720cc2 upstream.

Calling irq_domain_remove() will lead to freeing the IRQ domain
prematurely. The domain is still referenced and will be attempted to get
used via rmi_free_function_list() -> rmi_unregister_function() ->
irq_dispose_mapping() -> irq_get_irq_data()'s ->domain pointer.

With PaX's MEMORY_SANITIZE this will lead to an access fault when
attempting to dereference embedded pointers, as in Torsten's report that
was faulting on the 'domain->ops->unmap' test.

Fix this by releasing the IRQ domain only after all related IRQs have
been deactivated.

Fixes: 24d28e4f1271 ("Input: synaptics-rmi4 - convert irq distribution to irq_domain")
Reported-by: Torsten Hilbrich <torsten.hilbrich@secunet.com>
Signed-off-by: Mathias Krause <minipli@grsecurity.net>
Link: https://lore.kernel.org/r/20240222142654.856566-1-minipli@grsecurity.net
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Tzung-Bi Shih <tzungbi@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/input/rmi4/rmi_driver.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/input/rmi4/rmi_driver.c b/drivers/input/rmi4/rmi_driver.c
index aa32371f04af6..ef9ea295f9e03 100644
--- a/drivers/input/rmi4/rmi_driver.c
+++ b/drivers/input/rmi4/rmi_driver.c
@@ -978,12 +978,12 @@ static int rmi_driver_remove(struct device *dev)
 
 	rmi_disable_irq(rmi_dev, false);
 
-	irq_domain_remove(data->irqdomain);
-	data->irqdomain = NULL;
-
 	rmi_f34_remove_sysfs(rmi_dev);
 	rmi_free_function_list(rmi_dev);
 
+	irq_domain_remove(data->irqdomain);
+	data->irqdomain = NULL;
+
 	return 0;
 }
 
-- 
2.43.0



