Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A985E1F16B;
	Sat, 17 Oct 2026 17:31:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792258294; cv=none; b=tS/lqztqE2fXb5IML2yR5HrXqjPx5fUTs1/E4ZHHm1nI8MYLha7s9CoiDtDQq9uKSdxrZvZhRBz6eTu8qlQcLlkmRVkFxNC9OaXN5lO3StlZ9CfjaZW1BEWCg7zriz6Ttg4CVykcgZTB4/Y1xCYGYlQJpA1AqDBeVe3gK0A6BT8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792258294; c=relaxed/simple;
	bh=E/8HC54LTCcRoIQUBzjn6B+aHMkpbIZep6GEqVz2cp4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HfFbZX+SeBJy2ZCrPbaeR1XGrA7tyfBUcW+RX4S63lgYbxvwe+RbPrI8nL2bfIT0739Pl/jTCy1jUxe3ZSZxg40SxxMaYtoi1R5O01O/KLipn7A3hZSSIzAVjcStdUCkXESJ7qzk2DxeBOd7RNv/cTRTJhFXMy/0yWV8ZWKeZm4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iIzc+2c+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iIzc+2c+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 005F11F000C4;
	Sat, 17 Oct 2026 17:31:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792258292;
	bh=cOsDtmMxBrLoOL0H4B0fBt/BVR0PyrhkhxjOJkyCi4U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iIzc+2c+3tDSo/Z7RDCMw355KT+aH1RzkPh+YV2bVE92sClHl5UgtB5fXa56ZhbqK
	 JrBz2zFbSZL/GIc0dP3diyrHQ3nHNcjR1QPfToxeApv2BwqqkBCeuR8PNjiGe9pnzJ
	 UVb76dq2ij9uHrrdQqirUIieGDEWlSGFpXpOF4IM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Duoming Zhou <duoming@zju.edu.cn>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0835/1674] Input: alps - fix use-after-free bugs caused by dev3_register_work
Date: Sat, 17 Oct 2026 17:51:47 +0200
Message-ID: <20261017160452.563439120@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

From: Duoming Zhou <duoming@zju.edu.cn>

[ Upstream commit bf40644ef8c8a288742fa45580897ed0e0289474 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/input/mouse/alps.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/input/mouse/alps.c b/drivers/input/mouse/alps.c
index e2c11d9f3868f..e2a3d08791ee7 100644
--- a/drivers/input/mouse/alps.c
+++ b/drivers/input/mouse/alps.c
@@ -2971,6 +2971,8 @@ static void alps_disconnect(struct psmouse *psmouse)
 
 	psmouse_reset(psmouse);
 	timer_shutdown_sync(&priv->timer);
+	psmouse_set_state(psmouse, PSMOUSE_IGNORE);
+	cancel_delayed_work_sync(&priv->dev3_register_work);
 	if (priv->dev2)
 		input_unregister_device(priv->dev2);
 	if (!IS_ERR_OR_NULL(priv->dev3))
-- 
2.53.0



