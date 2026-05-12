Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 311752EBB84;
	Tue, 12 May 2026 17:45:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778607939; cv=none; b=BLG+qkd6RS4GoHze88WjlS0si2MCvQ87y7z8TqbpldE1cvMXqibMkxttqtZ9Gj7xLBkBh8IMC0tWsLbV20BiWR04fY5oLnD6fsxGJUsMrf8xhJNkhBNBlxtBEKzjF+laCZ3AkIngEIT2a6B+aQm8QNsoefe13HsVJzroEAjUatY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778607939; c=relaxed/simple;
	bh=QIWQaSFUkWVCn82uEUadi6EPi2icGLC6apZm8giDGp0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EHvoXvLWHuVcPbZFLcJqOIgYj6mdK0cafXe+AjrAFJ/upvf3sb/AahJRT+tv3sr5TlimoWEmM654Ca7yyqeLa8JgyqdvE9XIDB/bFv8DZXEDruT9jJVuQxszngVU7kgg2a4RTLY27cXWWwzW+pfDzLUOtyMqM7pvZt1RGN3bZkU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MFFjeYue; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MFFjeYue"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC5B5C2BCB0;
	Tue, 12 May 2026 17:45:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778607939;
	bh=QIWQaSFUkWVCn82uEUadi6EPi2icGLC6apZm8giDGp0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MFFjeYuemrVJMzmrya3hD+p/feK+C8/99mAfh4Bca/94Kzp/WE4MYGXBn4ZjPPDKu
	 n90P4jVXAxpg7xpbtzs2NLEa/QKzvTX0KTeeD4G47lGXyZ8iN7I9Z6mtY0gQaYdl28
	 qIl3+eUBjTQ2nFu33UHtrKaPRhGosTAxN/eNi0eE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	MyungJoo Ham <myungjoo.ham@samsung.com>,
	Xu Yang <xu.yang_2@nxp.com>,
	Chanwoo Choi <cw00.choi@samsung.com>
Subject: [PATCH 6.12 093/206] extcon: ptn5150: handle pending IRQ events during system resume
Date: Tue, 12 May 2026 19:39:05 +0200
Message-ID: <20260512173934.826029926@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260512173932.810559588@linuxfoundation.org>
References: <20260512173932.810559588@linuxfoundation.org>
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

From: Xu Yang <xu.yang_2@nxp.com>

commit 4652fefcda3c604c83d1ae28ede94544e2142f06 upstream.

When the system is suspended and ptn5150 wakeup interrupt is disabled,
any changes on ptn5150 will only be record in interrupt status
registers and won't fire an IRQ since its trigger type is falling
edge. So the HW interrupt line will keep at low state and any further
changes won't trigger IRQ anymore. To fix it, this will schedule a
work to check whether any IRQ are pending and handle it accordingly.

Fixes: 4ed754de2d66 ("extcon: Add support for ptn5150 extcon driver")
Cc: stable@vger.kernel.org
Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Acked-by: MyungJoo Ham <myungjoo.ham@samsung.com>
Signed-off-by: Xu Yang <xu.yang_2@nxp.com>
Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
Link: https://lore.kernel.org/lkml/20251115025905.1395347-1-xu.yang_2@nxp.com/
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/extcon/extcon-ptn5150.c |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

--- a/drivers/extcon/extcon-ptn5150.c
+++ b/drivers/extcon/extcon-ptn5150.c
@@ -331,6 +331,19 @@ static int ptn5150_i2c_probe(struct i2c_
 	return 0;
 }
 
+static int ptn5150_resume(struct device *dev)
+{
+	struct i2c_client *i2c = to_i2c_client(dev);
+	struct ptn5150_info *info = i2c_get_clientdata(i2c);
+
+	/* Need to check possible pending interrupt events */
+	schedule_work(&info->irq_work);
+
+	return 0;
+}
+
+static DEFINE_SIMPLE_DEV_PM_OPS(ptn5150_pm_ops, NULL, ptn5150_resume);
+
 static const struct of_device_id ptn5150_dt_match[] = {
 	{ .compatible = "nxp,ptn5150" },
 	{ },
@@ -346,6 +359,7 @@ MODULE_DEVICE_TABLE(i2c, ptn5150_i2c_id)
 static struct i2c_driver ptn5150_i2c_driver = {
 	.driver		= {
 		.name	= "ptn5150",
+		.pm = pm_sleep_ptr(&ptn5150_pm_ops),
 		.of_match_table = ptn5150_dt_match,
 	},
 	.probe		= ptn5150_i2c_probe,


