Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 290E01DED53;
	Wed,  6 Nov 2024 12:18:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730895483; cv=none; b=LRF1H+BC1WPtKfLMEgINWnAiTUFmEh1Nx6ZQSAxykyaIoexbjVvNIkd2BXNrema2GIohuVj99qFIbbuWo0LfYTYju74KBYd7q17JU3DUTWt2gFx3/FtwWAbwibmM+l4jePVCo8VTc47CSeY6cvMqKz8CRYJfIrnHySRzsf7Ce+c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730895483; c=relaxed/simple;
	bh=3J0tKMdykzn6bdsH1m/8WFL3hW/QrpIYTyJ/h9tFbno=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p0nO/0zbL/2Gj9mGCmVf7i66QutnpDr5wZkYKwqkp/H4ReLzUfMOIE7h4H4r6ep9WxXqxdIQcWsNLsWtqvWBniZ+WZGJnhfdpQnuWf9q/TBYuWp2dHpRmR6Jou8Q44SAdkeJZvamQADKeEpKApiBKKHziIqwI6PSc5NQw92ZUvI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Hco7FuTt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Hco7FuTt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0BECC4CECD;
	Wed,  6 Nov 2024 12:18:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730895483;
	bh=3J0tKMdykzn6bdsH1m/8WFL3hW/QrpIYTyJ/h9tFbno=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Hco7FuTt6EgEKiyEP2Y2YVhOrgNfKdCsvAhMQE3tgrABw940YnuX+2kB25a+mwP1u
	 c9HmufJf8GBNtEmXmq/6cBkkbY8sPnaglxC1BIVBu1tU+UtzQDxQaKi9exr5R45FM+
	 uqiK22OHrqTa1LBP8rC187cmuimpqgXiBi90PxYQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Torsten Hilbrich <torsten.hilbrich@secunet.com>,
	Mathias Krause <minipli@grsecurity.net>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Tzung-Bi Shih <tzungbi@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 233/350] Input: synaptics-rmi4 - fix UAF of IRQ domain on driver removal
Date: Wed,  6 Nov 2024 13:02:41 +0100
Message-ID: <20241106120326.724220655@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120320.865793091@linuxfoundation.org>
References: <20241106120320.865793091@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
index 0da814b41e72b..75cd4c813cbb4 100644
--- a/drivers/input/rmi4/rmi_driver.c
+++ b/drivers/input/rmi4/rmi_driver.c
@@ -981,12 +981,12 @@ static int rmi_driver_remove(struct device *dev)
 
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



