Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 534C947FB10;
	Tue, 25 Aug 2026 13:31:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787664671; cv=none; b=Qvs2yVnEnks7xVtXl7o03Tl9sJ57px+zLJl9RYImRf46+qmgjXx+yuyQonxTGeBuv+xpgnjTzYGMFdqBu5CxJ8ompOcwBCKNMY37r1+083ATq8d80s9GGZGiVvs5FGeShO+N+NXh0ch8XmI8ZhvgK9Le8hfTFeqgG2hgvVms2l0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787664671; c=relaxed/simple;
	bh=eIqI7tS03MP6xJdV0rzD1KQhEE+Y1mXJ1HCZMseoxms=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r16rwq4+umLprL6jpQW8AOS3UBpd9TX/5OmPllexofkKRyHpxNx9Y9J4Djr+q6KhXc1HIocdOTSC6K+2FaM93M1KaT43hR7t3UPRGmZWBfuJdlLz+sazAeiSFyRKfN0fbYiJO74T3WHo+uma/8Ilj0EEP69m8WMZbeEMyIfi62k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aeyNuQqz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aeyNuQqz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85E101F000E9;
	Tue, 25 Aug 2026 13:31:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787664670;
	bh=uYxebZwjMU3a2e4rbg12jYuzGcAXQ7/7a7fXqMkTlqo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aeyNuQqzEutwa4OzgkaaTl5NgFoMrWt2gWHARqfXc+Pk09nkkt1lSK8zq5F6m7qvY
	 vgfFEK4Eaea15vXtCMjPVUwfZgCsVtYVXBwjQTVoOVnR9vbuYA0ZpHWAkNBF4416bA
	 1AQMd0+lE9ArGNONFCIPecyzVD8xc4WJ7iFnZM3Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jassi Brar <jassisinghbrar@gmail.com>,
	Griffin Kroah-Hartman <griffin@kroah.com>
Subject: [PATCH 7.2 48/82] mailbox: mchp-ipc-sbi: Add null check for devm_kasprintf()
Date: Tue, 25 Aug 2026 15:25:35 +0200
Message-ID: <20260825132543.399084233@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260825132541.560541185@linuxfoundation.org>
References: <20260825132541.560541185@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Griffin Kroah-Hartman <griffin@kroah.com>

commit b37c4d0a2fd90c0c31223acd37f763eb8953ed1a upstream.

Add a check to see if devm_kasprintf() is not NULL in
mchp_ipc_get_cluster_aggr_irq(), returning -ENOMEM if the function
failed.

Assisted-by: gkh_clanker_t1000
CC: Jassi Brar <jassisinghbrar@gmail.com>
Signed-off-by: Griffin Kroah-Hartman <griffin@kroah.com>
Signed-off-by: Jassi Brar <jassisinghbrar@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mailbox/mailbox-mchp-ipc-sbi.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/mailbox/mailbox-mchp-ipc-sbi.c
+++ b/drivers/mailbox/mailbox-mchp-ipc-sbi.c
@@ -378,6 +378,8 @@ static int mchp_ipc_get_cluster_aggr_irq
 	for_each_online_cpu(cpuid) {
 		hartid = cpuid_to_hartid_map(cpuid);
 		irq_name = devm_kasprintf(ipc->dev, GFP_KERNEL, "hart-%lu", hartid);
+		if (!irq_name)
+			return -ENOMEM;
 		ret = platform_get_irq_byname_optional(pdev, irq_name);
 		if (ret <= 0)
 			continue;


