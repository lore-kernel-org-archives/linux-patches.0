Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43EC9435A96;
	Tue, 21 Jul 2026 20:21:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784665315; cv=none; b=lItJ0BxPKS9ZDBxJb7Tqc75JTYwRZgiJK6LB3EnxsR2zh8Rv1aM5AtCWHS05yCTEU8mLPCPmtWxdc0QnJiyyEC8Jl82VI6yJ78vJ/cJJa1ZdTfCFYvlXKNSdS5bzHKQeqgoNqIpXMX9WALRH5TG+MJKlIpr4OhER9tooz7MhWYM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784665315; c=relaxed/simple;
	bh=xLUpzb06zH+Gg9sOwOGYMlX5PxrysvgBDYKHx20v6qU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gCltDKeezVfYDcSFzIiCmwtqKuclqXGW/HXasmBGRMbUSHW7C5vjWlCnjnBq4DtiZoNOdZBqAb8ypisvfDFVf0XWRZ4SVQW61guA+R84eb28DkMgNgoLTY/v0is1IKzTyjvofqMdmlHFz/IuZ0ofepFRNJby3Xdn7sYEN7mPL+8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=H48zqAbz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="H48zqAbz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A25DD1F000E9;
	Tue, 21 Jul 2026 20:21:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784665313;
	bh=6Gh5mTwOwdQLBtC2JHBeDf/PqhQufgBcqMhG2bDQ3fk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=H48zqAbzI9dtKjk6hpq9IuA3IiTXnOVYYxlhH0fnKkSAbZn6ElwQqDF7rbdnChEsg
	 fUqeQk4XmDvzCrgCL8tyybPGfEQXrHx+2QbxgVIYbuk3hyrPBLSHJsjeYCIqSiXu4Z
	 4Lkbz+baznJMg9HvZxPf595AHZiUyhP7L7iGtiKc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Fan Wu <fanwu01@zju.edu.cn>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>
Subject: [PATCH 6.6 0256/1266] usb: typec: ucsi: ccg: Fix use-after-free of ucsi on remove
Date: Tue, 21 Jul 2026 17:11:33 +0200
Message-ID: <20260721152447.540760588@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fan Wu <fanwu01@zju.edu.cn>

commit 1f0bdc2884b67de337215079bba166df0cdf4ac5 upstream.

The threaded IRQ handler ccg_irq_handler() calls ucsi_notify_common(),
which on a connector-change event calls ucsi_connector_change() and
schedules connector work.  In ucsi_ccg_remove(), ucsi_destroy() frees
uc->ucsi (kfree) before free_irq() is called, so a handler invocation
already in flight may access the freed object after ucsi_destroy().

  CPU 0 (remove)            | CPU 1 (threaded IRQ)
    ucsi_destroy(uc->ucsi)  |   ccg_irq_handler()
      kfree(ucsi) // FREE   |     ucsi_notify_common(uc->ucsi) // USE

Move free_irq() before ucsi_destroy() in the remove path.  It is kept
after ucsi_unregister(): ucsi_unregister() cancels connector work whose
handler issues GET_CONNECTOR_STATUS through ucsi_send_command_common(),
which waits for a completion that is signalled from the IRQ handler, so
the IRQ must stay active until that work has been cancelled.

The probe error path already orders free_irq() before ucsi_destroy().

This bug was found by static analysis.

Fixes: e32fd989ac1c ("usb: typec: ucsi: ccg: Move to the new API")
Cc: stable <stable@kernel.org>
Signed-off-by: Fan Wu <fanwu01@zju.edu.cn>
Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Link: https://patch.msgid.link/20260616132011.103279-1-fanwu01@zju.edu.cn
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/typec/ucsi/ucsi_ccg.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/typec/ucsi/ucsi_ccg.c
+++ b/drivers/usb/typec/ucsi/ucsi_ccg.c
@@ -1440,8 +1440,8 @@ static void ucsi_ccg_remove(struct i2c_c
 	cancel_work_sync(&uc->work);
 	pm_runtime_disable(uc->dev);
 	ucsi_unregister(uc->ucsi);
-	ucsi_destroy(uc->ucsi);
 	free_irq(uc->irq, uc);
+	ucsi_destroy(uc->ucsi);
 }
 
 static const struct of_device_id ucsi_ccg_of_match_table[] = {


