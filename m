Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78F7433120C;
	Mon, 29 Dec 2025 16:21:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767025262; cv=none; b=RlZr5+emxDGJzRXYRDZ0BJ0BUqMgWv6CSGQlBPWdpTp2bBsUhb/ZqK4WwzTM3v1JC9Xvog8Tzt8m90WPxSrAGisuctLjRVDfG2EyGXFTconyjjQvatuCpfo/jZ5hgiwXK/dUif3t5/OSKyqk29HzJP92IZQ2NiqVbYpz/xDnO8g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767025262; c=relaxed/simple;
	bh=DTqS2cALjxqe9ke9eyoQ8bWWt/Hbhm0CWnu0E684Oyk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FI7dZQmAkUClWEYVOSX8AcPZyznlLnAPGxwtvNlZ364m41I77eoP8WKuMtON+91bZzE95MUdGgY/ApzaRzIg7SXLSa1Da6q8z9uIEgptmjp+EnWfjc32HlJSKa2aOH66h3yPQp5bb1vob4NTmwqlWYGYoeWvwcvT6GmXWDSBxic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=E2nrFXxa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="E2nrFXxa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB4A7C19422;
	Mon, 29 Dec 2025 16:21:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767025262;
	bh=DTqS2cALjxqe9ke9eyoQ8bWWt/Hbhm0CWnu0E684Oyk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=E2nrFXxabg2t5kQD71c5p5BcIbAgoClceHIqVqLJ1xlOnUQdRbXqvuK7NK53QeENC
	 HH1v72GYg1Ma6KqfIsnwIz2eP9Juqa+2115FRV9nxwjLPxMDSv2eGG6pNrctIXZEh5
	 hGCcxNaWhS4DXiLVmNRhXVN1/myytHzRUJm15xO0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Duoming Zhou <duoming@zju.edu.cn>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 6.18 151/430] Input: alps - fix use-after-free bugs caused by dev3_register_work
Date: Mon, 29 Dec 2025 17:09:13 +0100
Message-ID: <20251229160729.917783221@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251229160724.139406961@linuxfoundation.org>
References: <20251229160724.139406961@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2975,6 +2975,7 @@ static void alps_disconnect(struct psmou
 
 	psmouse_reset(psmouse);
 	timer_shutdown_sync(&priv->timer);
+	disable_delayed_work_sync(&priv->dev3_register_work);
 	if (priv->dev2)
 		input_unregister_device(priv->dev2);
 	if (!IS_ERR_OR_NULL(priv->dev3))


