Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 177361509BF;
	Tue, 20 Feb 2024 21:00:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708462823; cv=none; b=auF/tEhgFDsoBZNL2G9hsvNAGyWXvYGkrqp5AoYwBU7ceDqESEfcx0k+JBKPw/GE9hxPqG6ozeyqr/VOkZpRF4QFsfLuKI8Z8bT/yxsC2onTvsRaEseLI9NQJUxcHj8BCrm6FcEo/8ljRaZx95W7QVHr1Wo81rDEcel6tqQKu9k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708462823; c=relaxed/simple;
	bh=DXne/qZ7yATbzlUnbwZ2k4AvpnqoELGMqaLMbby/LG4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pphXrQxw6VuPuy+PeS3hZJRRRmt8pf4GhUbLlFgVPpxQO0BabiASfu5IFpK/1HDxmTX5iTbkeErsSODQTVDMUM83M7LqIQX1FgURShFK+e//iPAKCRCY4/srzihMGkMqpij4g6I8oyZAvmIEeyjJzfqDfjALtt8fkOFcT3h/Kmc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qXxQWBf+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qXxQWBf+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AB51C43390;
	Tue, 20 Feb 2024 21:00:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708462823;
	bh=DXne/qZ7yATbzlUnbwZ2k4AvpnqoELGMqaLMbby/LG4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qXxQWBf+9A3vdXzDLHEdP06uE9uN5MvcAXVmqcPEB12qYTovndpjCmEfzYuD8zKmA
	 2JfQOl90VMx1g8O7M+1VGklAj4vzzaUD8Jwi8Y7Fa1jsMSEL+LirM9wdFidXW1j7Z5
	 hGJEEnBdzmAInQiTyuw7yJnX9LHsow6KfqnxZvRs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Christian A. Ehrhardt" <lk@c--e.de>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>
Subject: [PATCH 6.1 048/197] usb: ucsi: Add missing ppm_lock
Date: Tue, 20 Feb 2024 21:50:07 +0100
Message-ID: <20240220204842.520585866@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220204841.073267068@linuxfoundation.org>
References: <20240220204841.073267068@linuxfoundation.org>
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

From: Christian A. Ehrhardt <lk@c--e.de>

commit c9aed03a0a683fd1600ea92f2ad32232d4736272 upstream.

Calling ->sync_write must be done while holding the PPM lock as
the mailbox logic does not support concurrent commands.

At least since the addition of partner task this means that
ucsi_acknowledge_connector_change should be called with the
PPM lock held as it calls ->sync_write.

Thus protect the only call to ucsi_acknowledge_connector_change
with the PPM. All other calls to ->sync_write already happen
under the PPM lock.

Fixes: b9aa02ca39a4 ("usb: typec: ucsi: Add polling mechanism for partner tasks like alt mode checking")
Cc: stable@vger.kernel.org
Signed-off-by: "Christian A. Ehrhardt" <lk@c--e.de>
Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Link: https://lore.kernel.org/r/20240121204123.275441-2-lk@c--e.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/typec/ucsi/ucsi.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/usb/typec/ucsi/ucsi.c
+++ b/drivers/usb/typec/ucsi/ucsi.c
@@ -831,7 +831,9 @@ static void ucsi_handle_connector_change
 
 	clear_bit(EVENT_PENDING, &con->ucsi->flags);
 
+	mutex_lock(&ucsi->ppm_lock);
 	ret = ucsi_acknowledge_connector_change(ucsi);
+	mutex_unlock(&ucsi->ppm_lock);
 	if (ret)
 		dev_err(ucsi->dev, "%s: ACK failed (%d)", __func__, ret);
 


