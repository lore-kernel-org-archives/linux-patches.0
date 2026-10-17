Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40C0436AB6B;
	Sat, 17 Oct 2026 16:38:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792255098; cv=none; b=Hce0MrfMytIGc2woshwmFzn/h0cUeJKe95ZGtpCTIFo7cA0QByQfjyPbyT9oyk36AiQ/85V7CvA67Q0JtjGA/Nwyr43pbd98rW+6owHwXx0MnZbK96tMqP7//U8O1vxJte+K1D9uP9OlP9VYhcBqQ6+1Jm1LlmUrGRhQzfAxkJ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792255098; c=relaxed/simple;
	bh=8knnFvGXTVdq/qh61d8fGazHQt+5efQdndl06EpdibM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cFZzhvcwLX9k/RZNmiezYj4YB75+sLxOZezR/FlOdeeXl3zffmz9d9UoAmv/q5r8wLQQC91jPN4GME4KH2pr4hB2NH/4uvwzrBF1niCGeXP1PineKNqEbTdzd8BOjjINuMnO/VhGyb5Rn1DpgOuuBb86Yi7u+uAMawjDQjJSCS4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qR4Q6gOe; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qR4Q6gOe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50DCA1F000C4;
	Sat, 17 Oct 2026 16:38:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792255096;
	bh=64AEkFHhp/qgfLw28IVKgtG5tIen8Uy0NRpABy5PLt0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qR4Q6gOeCx3B7rN9LoG/KQPRkFd3+zFtq6/kQEa4dFKLZvHvO1fAEnu75qVkghM8e
	 2A90Q5giTgYLrT8MPAfyI+3MqcpVZPYH4k1ViPbiIxCkiChgrymqVrZS4iilVr8cly
	 +KZZumznR0+UM3zEnEW6YKJ9GgbHxqQim+7kBlA8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haoxiang Li <haoxiang_li2024@163.com>,
	Bastien Nocera <hadess@hadess.net>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 665/869] HID: logitech-hidpp: Fix FF device cleanup on init failure
Date: Sat, 17 Oct 2026 17:58:26 +0200
Message-ID: <20261017160054.042381757@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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

[ Upstream commit dd5be4d9ce2dfc4d4a4527ef7d31d21a78e3cdac ]

hidpp_ff_init() creates the input force-feedback device with
input_ff_create(), then allocates the HID++ FF private data,
effect ID array, and workqueue.

If any of those allocations fail after input_ff_create() succeeds,
the function returns an error without destroying the FF device.
Add an unwind path that frees the private allocations made by
hidpp_ff_init() and calls input_ff_destroy() for failures after
input_ff_create() succeeds.

Fixes: ff21a635dd1a ("HID: logitech-hidpp: Force feedback support for the Logitech G920")
Signed-off-by: Haoxiang Li <haoxiang_li2024@163.com>
Reviewed-by: Bastien Nocera <hadess@hadess.net>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-logitech-hidpp.c | 23 ++++++++++++++++-------
 1 file changed, 16 insertions(+), 7 deletions(-)

diff --git a/drivers/hid/hid-logitech-hidpp.c b/drivers/hid/hid-logitech-hidpp.c
index 9926ab6e808eb..c84bd26faea96 100644
--- a/drivers/hid/hid-logitech-hidpp.c
+++ b/drivers/hid/hid-logitech-hidpp.c
@@ -2878,18 +2878,19 @@ static int hidpp_ff_init(struct hidpp_device *hidpp,
 	 * ownership to FF core
 	 */
 	data = kmemdup(data, sizeof(*data), GFP_KERNEL);
-	if (!data)
-		return -ENOMEM;
+	if (!data) {
+		error = -ENOMEM;
+		goto err_destroy_ff;
+	}
 	data->effect_ids = kcalloc(num_slots, sizeof(int), GFP_KERNEL);
 	if (!data->effect_ids) {
-		kfree(data);
-		return -ENOMEM;
+		error = -ENOMEM;
+		goto err_free_data;
 	}
 	data->wq = create_singlethread_workqueue("hidpp-ff-sendqueue");
 	if (!data->wq) {
-		kfree(data->effect_ids);
-		kfree(data);
-		return -ENOMEM;
+		error = -ENOMEM;
+		goto err_free_effect_ids;
 	}
 
 	data->hidpp = hidpp;
@@ -2919,6 +2920,14 @@ static int hidpp_ff_init(struct hidpp_device *hidpp,
 		 version);
 
 	return 0;
+
+err_free_effect_ids:
+	kfree(data->effect_ids);
+err_free_data:
+	kfree(data);
+err_destroy_ff:
+	input_ff_destroy(dev);
+	return error;
 }
 
 /* ************************************************************************** */
-- 
2.53.0



