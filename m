Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D78051C1AAA;
	Tue, 12 Aug 2025 19:04:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755025489; cv=none; b=t/wJa7/6N1tut9DzhaGxEm7IDXI88uIbOauuVvPbBCPcobSBT9KWYmN3ao+1mrK/MxjJ+Xnra3t1Bth0Z/gr9rCvh50Pb2ySbVsEVdEpKHsy+VH3MT464dPa27iKkspJIv+dfqYhxbDoteek4CKl5QGxb1Rg8x2dJUje8QFLrt8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755025489; c=relaxed/simple;
	bh=GJjsI6pZo1VZ/l4eOm9OeioAlEcdYxhXbfokCDcY3eI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u6iYGqWuE87tU6MRlHzwPnIcD3Sakyqw7HtJwsDJj/GjQpYSWs9QYA7p8EIU0LzsF13jaUYH6OhRXYvb+TBBCzp7xdXd/Dgi0I+FgqEltvDDtVIzY36tjUVC14IGSR/PgzhtftcVrODNOBP+wJWhESjj2HiwjFUTFeM5wvs1RQc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XxMc+KSA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XxMc+KSA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B316C4CEF0;
	Tue, 12 Aug 2025 19:04:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755025489;
	bh=GJjsI6pZo1VZ/l4eOm9OeioAlEcdYxhXbfokCDcY3eI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XxMc+KSAcZWcIYkA04YIMcyjxyiuM15bOlPPsjEvKiiHeGWMzI+91DDyA7MINVa7v
	 MtMw7nhXihkQc2fjNOUFawWyq2ZboKERQ8Fq+upfUz4DZIEPjgtWH9a0sRO/Edavd5
	 wyRPqp78Psi7rDQrGJvPSZMnwAeE1QMqKhNT2Yp0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans de Goede <hansg@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 057/480] mei: vsc: Unset the event callback on remove and probe errors
Date: Tue, 12 Aug 2025 19:44:25 +0200
Message-ID: <20250812174359.770857248@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812174357.281828096@linuxfoundation.org>
References: <20250812174357.281828096@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hans de Goede <hansg@kernel.org>

[ Upstream commit 6175c6974095f8ca7e5f8d593171512f3e5bd453 ]

Make mei_vsc_remove() properly unset the callback to avoid a dead callback
sticking around after probe errors or unbinding of the platform driver.

Fixes: 386a766c4169 ("mei: Add MEI hardware support for IVSC device")
Signed-off-by: Hans de Goede <hansg@kernel.org>
Link: https://lore.kernel.org/r/20250623085052.12347-8-hansg@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/misc/mei/platform-vsc.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/misc/mei/platform-vsc.c b/drivers/misc/mei/platform-vsc.c
index 1ac85f0251c5..b2b5a20ae3fa 100644
--- a/drivers/misc/mei/platform-vsc.c
+++ b/drivers/misc/mei/platform-vsc.c
@@ -380,6 +380,8 @@ static int mei_vsc_probe(struct platform_device *pdev)
 err_cancel:
 	mei_cancel_work(mei_dev);
 
+	vsc_tp_register_event_cb(tp, NULL, NULL);
+
 	mei_disable_interrupts(mei_dev);
 
 	return ret;
@@ -388,11 +390,14 @@ static int mei_vsc_probe(struct platform_device *pdev)
 static void mei_vsc_remove(struct platform_device *pdev)
 {
 	struct mei_device *mei_dev = platform_get_drvdata(pdev);
+	struct mei_vsc_hw *hw = mei_dev_to_vsc_hw(mei_dev);
 
 	pm_runtime_disable(mei_dev->dev);
 
 	mei_stop(mei_dev);
 
+	vsc_tp_register_event_cb(hw->tp, NULL, NULL);
+
 	mei_disable_interrupts(mei_dev);
 
 	mei_deregister(mei_dev);
-- 
2.39.5



