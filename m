Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D5C32E7398;
	Sat, 30 May 2026 18:45:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780166749; cv=none; b=tX2v84KtxKqQMBeJodTGcgUL5Ib3443m3AiETbzvMS0BzUz9BKEpNFYhAeiW1iBsldiUW4NNxINPZXxIzL+JDLQ/9E6+1ehu+NeqCHiPnwv2PnUG8t+GCXja1rPyyvEsamuGmKg2N/MeNyfz7Ayd5eX/D6Qo3NFS+UCOz6n+jAA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780166749; c=relaxed/simple;
	bh=HflaUW732wta8c1DV5PJno3VdlYS7mnEOZ/WzzhK0IA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VhAYoVkcOSgDI7Wh7tpsLdOnmspmfUHSTSic7RoRbFYZ9QlCldrcBQLUugyqMOCDFhX/Wwte8dPmk4ELM5kIoUxW51ZVkO2fAdQywW8GrF9Xz2KeSlhUn5CFXam56nuI3n1j2krRose2Q76Dj7dVibeF95RnczWrH+BjmLcxs3o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SP+tLGkt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SP+tLGkt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56D0E1F00893;
	Sat, 30 May 2026 18:45:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780166747;
	bh=/UYoVmDqDdP+RSZNZxbawr6EZWEmMBjZoVf/ZAiZiB8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SP+tLGktoqGMqVkEsOlDnJjIuseVcSL4eEDmIzvTyxQjMMNYay8PXkBbjXNfXBRdS
	 sqpChHXCOe3+P4OSOOK3jO2M4+XCEEwNtPeXZPQ5kd1xnH1i9NVJCdhMg1fY2N/fpy
	 TmskeAv34ta/Ko187bUHRfINeakXbTXkhgzAuK/s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wolfram Sang <wsa+renesas@sang-engineering.com>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Jassi Brar <jassisinghbrar@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 459/589] mailbox: add sanity check for channel array
Date: Sat, 30 May 2026 18:05:40 +0200
Message-ID: <20260530160236.740096340@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160224.570625122@linuxfoundation.org>
References: <20260530160224.570625122@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wolfram Sang <wsa+renesas@sang-engineering.com>

[ Upstream commit c1aad75595fb67edc7fda8af249d3b886efa1be9 ]

Fail gracefully if there is no channel array attached to the mailbox
controller. Otherwise the later dereference will cause an OOPS which
might not be seen because mailbox controllers might instantiate very
early. Remove the comment explaining the obvious while here.

Fixes: 2b6d83e2b8b7 ("mailbox: Introduce framework for mailbox")
Signed-off-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Jassi Brar <jassisinghbrar@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mailbox/mailbox.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/mailbox/mailbox.c b/drivers/mailbox/mailbox.c
index 090795c1b65db..363eaf3c962ec 100644
--- a/drivers/mailbox/mailbox.c
+++ b/drivers/mailbox/mailbox.c
@@ -484,8 +484,7 @@ int mbox_controller_register(struct mbox_controller *mbox)
 {
 	int i, txdone;
 
-	/* Sanity check */
-	if (!mbox || !mbox->dev || !mbox->ops || !mbox->num_chans)
+	if (!mbox || !mbox->dev || !mbox->ops || !mbox->chans || !mbox->num_chans)
 		return -EINVAL;
 
 	if (mbox->txdone_irq)
-- 
2.53.0



