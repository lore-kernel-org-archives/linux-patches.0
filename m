Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2AF12590
	for <patches@lists.linux.dev>; Sun, 22 Jan 2023 15:14:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6AEB7C4339B;
	Sun, 22 Jan 2023 15:14:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1674400495;
	bh=K+8Is2GreAG+W9l+vBO97seHQeVY9YfpRQ1jHPY8Vnk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jY+MckFEYcIOV1RSMhsqKqnmwoQ+Gnz/2r/yus7AA6fhXjWddDAL8KbjqLU35DhuR
	 OkLuTWRcfhGP1Hw3PeE8kRqyCZg+zZ5qypy0n6j7GNTOdbZpkRGeSmYZkTf24Q62ax
	 h0D/KPvbKSHrgRV4/sgV23fR9634CGoHJ8lcw3L4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Venkata Lakshmi Narayana Gubba <gubbaven@codeaurora.org>,
	Marcel Holtmann <marcel@holtmann.org>
Subject: [PATCH 5.10 97/98] Bluetooth: hci_qca: check for SSR triggered flag while suspend
Date: Sun, 22 Jan 2023 16:04:53 +0100
Message-Id: <20230122150233.479379436@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230122150229.351631432@linuxfoundation.org>
References: <20230122150229.351631432@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Venkata Lakshmi Narayana Gubba <gubbaven@codeaurora.org>

commit 1bb0c66332babc5cbc4581d962da0b03af9f23e8 upstream.

QCA_IBS_DISABLED flag will be set after memorydump started from
controller.Currently qca_suspend() is waiting for SSR to complete
based on flag QCA_IBS_DISABLED.Added to check for QCA_SSR_TRIGGERED
flag too.

Fixes: 2be43abac5a8 ("Bluetooth: hci_qca: Wait for timeout during suspend")
Signed-off-by: Venkata Lakshmi Narayana Gubba <gubbaven@codeaurora.org>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/bluetooth/hci_qca.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/bluetooth/hci_qca.c
+++ b/drivers/bluetooth/hci_qca.c
@@ -2120,7 +2120,8 @@ static int __maybe_unused qca_suspend(st
 	    !test_bit(QCA_SSR_TRIGGERED, &qca->flags))
 		return 0;
 
-	if (test_bit(QCA_IBS_DISABLED, &qca->flags)) {
+	if (test_bit(QCA_IBS_DISABLED, &qca->flags) ||
+	    test_bit(QCA_SSR_TRIGGERED, &qca->flags)) {
 		wait_timeout = test_bit(QCA_SSR_TRIGGERED, &qca->flags) ?
 					IBS_DISABLE_SSR_TIMEOUT_MS :
 					FW_DOWNLOAD_TIMEOUT_MS;


