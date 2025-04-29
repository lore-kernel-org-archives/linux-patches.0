Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25675247291;
	Tue, 29 Apr 2025 16:49:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745945354; cv=none; b=M8HrnCXHQP/bnemeIhPryzB90oGPO5MI/72wuPCoJWCLMHY+fjRpAwEAaS4n3RL2O8RPDyKPyseAwqZOYqPukkFoo5hTFefj+afdiMm2X7Rb7xzKJhiFb8E9vjvin2vgfcuk/NZPDUWt7b+dBDdJKr/AzSVPWY2yTm1mi+mpJgE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745945354; c=relaxed/simple;
	bh=zvPZwg80rURjhMa6qXa7uSMXaGK2lg1PiQxHKi+kaeM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YqhePmjlmI9rvQ6tfb6JQm43Nk6QFx3DzBcY8EdkFwtBffKiyxja2rCts/RS21/YxaWmVzvQmM/I9yZ2tgfD79GHxX/Y9WAy8aGSEDqVqqgrTA03lfr3XEB3+XWmbig6hIgNWwC0HUQbwU68Rc57rEThOVoVWUsvl78+sWGNjno=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Zq1mhk3s; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Zq1mhk3s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28240C4CEE3;
	Tue, 29 Apr 2025 16:49:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745945353;
	bh=zvPZwg80rURjhMa6qXa7uSMXaGK2lg1PiQxHKi+kaeM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Zq1mhk3sw6l6hYM/4QEemy2p8dKBCKmmVFXTGz07TF3CDNd3ZTlY68slA/RMoMW5M
	 /mfi8ZKQJT4uilrPfbWg7R9BzpAeJvZfBsDw27vZNwiUhCFDaMK9go/XO/9li7EUXM
	 SalRKniq4xojTRmpIKJFj1ceT8f8mCMS7GqCep4E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kaixin Wang <kxwang23@m.fudan.edu.cn>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Sebastian Reichel <sebastian.reichel@collabora.com>
Subject: [PATCH 5.4 082/179] HSI: ssi_protocol: Fix use after free vulnerability in ssi_protocol Driver Due to Race Condition
Date: Tue, 29 Apr 2025 18:40:23 +0200
Message-ID: <20250429161052.723974118@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161049.383278312@linuxfoundation.org>
References: <20250429161049.383278312@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kaixin Wang <kxwang23@m.fudan.edu.cn>

commit e3f88665a78045fe35c7669d2926b8d97b892c11 upstream.

In the ssi_protocol_probe() function, &ssi->work is bound with
ssip_xmit_work(), In ssip_pn_setup(), the ssip_pn_xmit() function
within the ssip_pn_ops structure is capable of starting the
work.

If we remove the module which will call ssi_protocol_remove()
to make a cleanup, it will free ssi through kfree(ssi),
while the work mentioned above will be used. The sequence
of operations that may lead to a UAF bug is as follows:

CPU0                                    CPU1

                        | ssip_xmit_work
ssi_protocol_remove     |
kfree(ssi);             |
                        | struct hsi_client *cl = ssi->cl;
                        | // use ssi

Fix it by ensuring that the work is canceled before proceeding
with the cleanup in ssi_protocol_remove().

Signed-off-by: Kaixin Wang <kxwang23@m.fudan.edu.cn>
Acked-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Link: https://lore.kernel.org/r/20240918120749.1730-1-kxwang23@m.fudan.edu.cn
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hsi/clients/ssi_protocol.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/hsi/clients/ssi_protocol.c
+++ b/drivers/hsi/clients/ssi_protocol.c
@@ -403,6 +403,7 @@ static void ssip_reset(struct hsi_client
 	del_timer(&ssi->rx_wd);
 	del_timer(&ssi->tx_wd);
 	del_timer(&ssi->keep_alive);
+	cancel_work_sync(&ssi->work);
 	ssi->main_state = 0;
 	ssi->send_state = 0;
 	ssi->recv_state = 0;


