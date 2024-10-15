Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE3371DD0CD;
	Tue, 15 Oct 2024 13:18:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728998335; cv=none; b=suzfxvpzn/EhAGZkShXQkz0fdOwwPBUzxxhJfN7r8SXLLFrXrEhq24+zRmbdnOO2+ncM0e4qnL49bmpwP0MxO/4WDhoIAULcsZyheCKtrW/zJdZ0fJj95o1gybqkIcvrGpn/PtGmFw1K7Ewr5RRtEE9Q3S+9WZg65qJiMrnHBmg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728998335; c=relaxed/simple;
	bh=dW+iZHkeg9GZnScn/aivDXAUjkSGjuLjVOHHlDCxfd0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bGlC3rWsVb9rq1KaMrUU9XNx0kHT+3lOY8p5zSFMLRFGRpeqkzkii//k2UQYWT55H3U3wNaNSuhZ33JfhB0xDBoPaE1ioKgy0ngYok3zbrsTosIdLuEvJb2KoMRIHu3YE2V7plTrOjsfyP1h63tYuk0mHN2cDyk56L+DA5mdKyE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mX0whDnC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mX0whDnC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15065C4CECE;
	Tue, 15 Oct 2024 13:18:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728998334;
	bh=dW+iZHkeg9GZnScn/aivDXAUjkSGjuLjVOHHlDCxfd0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mX0whDnC99xnwR/XYDpiYmJmqoeamU2cqFfvUhKxty/GAxFZrExtfr1QO5k4XDvGx
	 YGfljA38JZzpwDvCNrmeSnSvb2Ol9fzT92gdjxraqEeY4TuwLFl9XaJccbxs9Iq1v9
	 yNMkI64RkA94wPPUeTCKhHnT3dy7cwTaEUQZTO6s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Torsten Hilbrich <torsten.hilbrich@secunet.com>,
	Mathias Krause <minipli@grsecurity.net>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Tzung-Bi Shih <tzungbi@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 448/518] Input: synaptics-rmi4 - fix UAF of IRQ domain on driver removal
Date: Tue, 15 Oct 2024 14:45:52 +0200
Message-ID: <20241015123934.295796743@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015123916.821186887@linuxfoundation.org>
References: <20241015123916.821186887@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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



