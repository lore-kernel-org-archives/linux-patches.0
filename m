Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 288B834C9A1;
	Tue,  6 Jan 2026 17:19:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767719988; cv=none; b=RuZbnuH/gIzdzPVOBaRbDtndsswtJkLfhMVyw1SwWDgDr8xPzCOkvi+Tye8A1CCqUp4G17rDPG42uxUzlp26PRs8ThRmf2w9WSqmFsGvThfZ5L19TT4XT1A2FbHq/X1QaDeu1pwxGIMr39yzVcVp5nkPlc3+tsyAski+pCDUOb4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767719988; c=relaxed/simple;
	bh=zIbYNmd2fS4Y6UViDAur1tjKxrOlvXLeS9mZJkOIXdU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SOLjFq8rylhAS5dohm5AT5t0j+wG5uGbsCaCECkeiHF3EAb3gIYUPOVAiU369JrVNzWYE6QKVZrzlAnGerDpaIfjebzIEQ/ieqFRUgaYxlAWu01ARw7SNf1qZzaYavAWycU45V3fNu6JMAdHOuxlR2E6uZ/Z6FWPfzlCgwRiIBM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IU9PZvsK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IU9PZvsK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F19DC116C6;
	Tue,  6 Jan 2026 17:19:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767719988;
	bh=zIbYNmd2fS4Y6UViDAur1tjKxrOlvXLeS9mZJkOIXdU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IU9PZvsK7dYhIQWYgG8Fk0LK3B8EZjHuLW54j+P3HJdBHJMTJhCKKPSaCXHYyQiRA
	 TpttqK8G0SYtUtL6MTsDEFpDDQhVFoeIXmnQPunu8S8h1K36EprDmJSfnymExjQgJZ
	 9WwYWuvEZ9AIVGev7Suv3RnbTxAgJJHAgu+YGyKQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Duoming Zhou <duoming@zju.edu.cn>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 6.12 099/567] Input: alps - fix use-after-free bugs caused by dev3_register_work
Date: Tue,  6 Jan 2026 17:58:01 +0100
Message-ID: <20260106170454.991275545@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170451.332875001@linuxfoundation.org>
References: <20260106170451.332875001@linuxfoundation.org>
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

From: Duoming Zhou <duoming@zju.edu.cn>

commit bf40644ef8c8a288742fa45580897ed0e0289474 upstream.

The dev3_register_work delayed work item is initialized within
alps_reconnect() and scheduled upon receipt of the first bare
PS/2 packet from an external PS/2 device connected to the ALPS
touchpad. During device detachment, the original implementation
calls flush_workqueue() in psmouse_disconnect() to ensure
completion of dev3_register_work. However, the flush_workqueue()
in psmouse_disconnect() only blocks and waits for work items that
were already queued to the workqueue prior to its invocation. Any
work items submitted after flush_workqueue() is called are not
included in the set of tasks that the flush operation awaits.
This means that after flush_workqueue() has finished executing,
the dev3_register_work could still be scheduled. Although the
psmouse state is set to PSMOUSE_CMD_MODE in psmouse_disconnect(),
the scheduling of dev3_register_work remains unaffected.

The race condition can occur as follows:

CPU 0 (cleanup path)     | CPU 1 (delayed work)
psmouse_disconnect()     |
  psmouse_set_state()    |
  flush_workqueue()      | alps_report_bare_ps2_packet()
  alps_disconnect()      |   psmouse_queue_work()
    kfree(priv); // FREE | alps_register_bare_ps2_mouse()
                         |   priv = container_of(work...); // USE
                         |   priv->dev3 // USE

Add disable_delayed_work_sync() in alps_disconnect() to ensure
that dev3_register_work is properly canceled and prevented from
executing after the alps_data structure has been deallocated.

This bug is identified by static analysis.

Fixes: 04aae283ba6a ("Input: ALPS - do not mix trackstick and external PS/2 mouse data")
Cc: stable@kernel.org
Signed-off-by: Duoming Zhou <duoming@zju.edu.cn>
Link: https://patch.msgid.link/b57b0a9ccca51a3f06be141bfc02b9ffe69d1845.1765939397.git.duoming@zju.edu.cn
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/mouse/alps.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/input/mouse/alps.c
+++ b/drivers/input/mouse/alps.c
@@ -2977,6 +2977,7 @@ static void alps_disconnect(struct psmou
 
 	psmouse_reset(psmouse);
 	timer_shutdown_sync(&priv->timer);
+	disable_delayed_work_sync(&priv->dev3_register_work);
 	if (priv->dev2)
 		input_unregister_device(priv->dev2);
 	if (!IS_ERR_OR_NULL(priv->dev3))


