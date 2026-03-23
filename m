Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25EBF26D4F9;
	Mon, 23 Mar 2026 14:54:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774277669; cv=none; b=L1v2VKgsZ3L/S85f5EPBprPVjsrwekDgwPJI8aydSTpDxacMQeq5CZXdokDqLB3UiEPqG5lskztK7ALw7eYRjkqbVT+PPizKiqwCEPFHLnV7vJZIgh8cbxhY1eWQfydqKR2kk2EWhDcSTIIMA/8mVVruUjKb8+K2S2ry9LQTwMU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774277669; c=relaxed/simple;
	bh=fQemhtQeZUvbDOatcBWCm2cHbyDJbJC17ayZVTpkhD0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A7nCUFuXjXOCGq1uEGa5NdTXGfoSEg05UDXrQWNI8YXSsMwG3bqUvRLYqIJmj6Dk/0B7cSPdcyajJqye9eJVT22PGc38ZZaKwa05dxAAn3oSA9mIfUwrxPHfzYBCOVQDeHdXiMo4RHGolvIFA8GKDXg9I/BefZIOualjZFUjxBo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2SV75i92; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2SV75i92"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FED1C4CEF7;
	Mon, 23 Mar 2026 14:54:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774277669;
	bh=fQemhtQeZUvbDOatcBWCm2cHbyDJbJC17ayZVTpkhD0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2SV75i92NI16Z+2FiyBCzVjoF11jwj74QUlashufy74oCuin845sO5OOW3/fLiBNd
	 AoR83j0Avm8c1l3bflFU0jsnVNR91LpaKBs0RSAhpLQpNEdrAQuQeKf1phlneRS6xJ
	 51SkwypDbo8r8kKS1Etrbdsf9rNbJuOTGSHUeKMY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joonwon Kang <joonwonkang@google.com>,
	Jassi Brar <jassisinghbrar@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 066/567] mailbox: Prevent out-of-bounds access in fw_mbox_index_xlate()
Date: Mon, 23 Mar 2026 14:39:46 +0100
Message-ID: <20260323134535.456073402@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134533.749096647@linuxfoundation.org>
References: <20260323134533.749096647@linuxfoundation.org>
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

From: Joonwon Kang <joonwonkang@google.com>

[ Upstream commit fcd7f96c783626c07ee3ed75fa3739a8a2052310 ]

Although it is guided that `#mbox-cells` must be at least 1, there are
many instances of `#mbox-cells = <0>;` in the device tree. If that is
the case and the corresponding mailbox controller does not provide
`fw_xlate` and of_xlate` function pointers, `fw_mbox_index_xlate()` will
be used by default and out-of-bounds accesses could occur due to lack of
bounds check in that function.

Cc: stable@vger.kernel.org
Signed-off-by: Joonwon Kang <joonwonkang@google.com>
Signed-off-by: Jassi Brar <jassisinghbrar@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mailbox/mailbox.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/mailbox/mailbox.c b/drivers/mailbox/mailbox.c
index 892aa0a048e0f..b4d52b814055b 100644
--- a/drivers/mailbox/mailbox.c
+++ b/drivers/mailbox/mailbox.c
@@ -504,12 +504,10 @@ EXPORT_SYMBOL_GPL(mbox_free_channel);
 static struct mbox_chan *fw_mbox_index_xlate(struct mbox_controller *mbox,
 					     const struct fwnode_reference_args *sp)
 {
-	int ind = sp->args[0];
-
-	if (ind >= mbox->num_chans)
+	if (sp->nargs < 1 || sp->args[0] >= mbox->num_chans)
 		return ERR_PTR(-EINVAL);
 
-	return &mbox->chans[ind];
+	return &mbox->chans[sp->args[0]];
 }
 
 /**
-- 
2.51.0



