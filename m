Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29020386C3B;
	Tue, 25 Aug 2026 13:40:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787665225; cv=none; b=Wl+tUPQB5+pj2FKIOr/xv47VYk6/iykYVnwVnydQyDIFPbue7CwoaZyf+0iqHaqUlQibS3jVa8U7+hpAvGrEvsyR3nTiSpwvqvLkw+yKR8wLKOeaLJpEzLC9z6TThd6jZzQ3PCPczAa2mzt5NeqHrxyTL+DajZH6qyRQX7V53/c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787665225; c=relaxed/simple;
	bh=58jUwagxR/UDmsZHkT7TDmuOy/hFUClyMRfj6pEiF1w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RHCfNoyQMzO3qjbEmiTuz7h6kcEQO5wVue3UymJAI1GFuwPBU671aYvTJgCLIYaQ+hsfSdhEm6E43XZDvadc9c80bTihANWwEbOa5VsWJIyvstmu8lrHFz8hF32yuDvbOLX5C17clh9T+xGYMvMuwhC/YXSZG8ySZNWY32oAk5M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=R/mfwFDr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="R/mfwFDr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 819171F000E9;
	Tue, 25 Aug 2026 13:40:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787665224;
	bh=s2htfAXOPteXwc5hH8VKCsBwvpJChIQ9FSfo5Hw8i2o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=R/mfwFDrAoS1r1LJxLmDzSPvHWUZO28qqFuPrEv7aa0cV/O3+cDScpRdR3n4xHJRy
	 Lt1DRXyS8bOyPe2CaKEfEzZ7KxKBz648+SMJH0t6g7WlKQ9cx2JFCh5aObaxMei3v6
	 arFg+X6ENJOaZliCHrj+um47r1MtmJVUerlD6E30=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jassi Brar <jassisinghbrar@gmail.com>,
	Griffin Kroah-Hartman <griffin@kroah.com>
Subject: [PATCH 6.18 49/94] mailbox: mchp-ipc-sbi: Add null check for devm_kasprintf()
Date: Tue, 25 Aug 2026 15:25:45 +0200
Message-ID: <20260825132543.829476947@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260825132541.887883084@linuxfoundation.org>
References: <20260825132541.887883084@linuxfoundation.org>
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


