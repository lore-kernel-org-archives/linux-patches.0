Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40AFD414A2A;
	Fri,  4 Sep 2026 05:43:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788500616; cv=none; b=NhmfEDu+XYTABfhA/QrsozrC+dDlod6MsnxpbsjOWVpXmsJeMq39nNGwXKhNG7SQ0i4k3h69rnzjuIz8rnTvgk+3mn87F5S6UhXXNYJrrijugwy6n/x7qNu3ZQP+jE6UO2R+LGj9Oww8hYBQ4/4cyaAx4WDIvHnQzP7SA4fcXfc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788500616; c=relaxed/simple;
	bh=IyhqG+t1UNNrvbKtNGHxS/AnF4wxa8Um8EgaLiy07wU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VrljWDw5bDy7u1asJy8pnlSV/+jrBd467DA4xdMu92S3eX8DZ4LohoDAQHCNdRaYtMGmqAjnqVv0Qw1nGPIf70KrfJTkthJAOP/gkvxEnvc9sEIZ8NauNTRTo4qd2pFsISBP5B41I0KR2Zt+yMNZcl8R3cqTcK2m53qIbHF0Bic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=V6uE9FZX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="V6uE9FZX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47BE11F00A3D;
	Fri,  4 Sep 2026 05:43:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788500614;
	bh=6Hjy8OUxixpmKHCNfNg86kDAUFGPJdWEBvcSPkSIRtw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=V6uE9FZXM4SE57MtpzgQgRPCjhIJJOFFoH2oZtTl/2VeFSQY+ZpckeTuyFJBSfFVz
	 3UM4kyuvsmV9nQjrFDmzCDY+WVh/XLfBQBGaDKE8tA1fZvXRf4AWoWOMSpPeCdeXs0
	 S1OVD3CqpO+I8E+WucQIU443Dn9DRiFK8bZzIo6Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fan Wu <fanwu01@zju.edu.cn>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>
Subject: [PATCH 6.18 076/552] usb: typec: thunderbolt: Disable work before freeing tbt on remove
Date: Fri,  4 Sep 2026 06:53:53 +0200
Message-ID: <20260904045749.578989547@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045747.813364717@linuxfoundation.org>
References: <20260904045747.813364717@linuxfoundation.org>
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

From: Fan Wu <fanwu01@zju.edu.cn>

commit 92090f6ff2acc81e9dd99881dcfb4f8c1bdaabd3 upstream.

tbt_altmode_remove() drops the plug and cable references without
draining tbt->work. The work function dereferences those references,
and can also requeue itself in its error path. The VDM callbacks can
queue the same work item.

Disable and drain tbt->work before dropping the references. This waits
for an existing invocation and prevents subsequent schedule_work()
calls from queueing it during teardown.

This issue was found by an in-house static analysis tool and confirmed
by manual code review.

Fixes: 100e25738659 ("usb: typec: Add driver for Thunderbolt 3 Alternate Mode")
Cc: stable@vger.kernel.org
Assisted-by: Codex:gpt-5.6
Signed-off-by: Fan Wu <fanwu01@zju.edu.cn>
Acked-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Link: https://patch.msgid.link/20260802014959.416687-1-fanwu01@zju.edu.cn
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/typec/altmodes/thunderbolt.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/usb/typec/altmodes/thunderbolt.c
+++ b/drivers/usb/typec/altmodes/thunderbolt.c
@@ -303,6 +303,8 @@ static void tbt_altmode_remove(struct ty
 {
 	struct tbt_altmode *tbt = typec_altmode_get_drvdata(alt);
 
+	disable_work_sync(&tbt->work);
+
 	for (int i = TYPEC_PLUG_SOP_PP; i >= 0; --i) {
 		if (tbt->plug[i])
 			typec_altmode_put_plug(tbt->plug[i]);


