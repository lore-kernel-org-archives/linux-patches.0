Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 086B91D0492;
	Tue, 15 Oct 2024 11:58:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728993480; cv=none; b=osMxeRLakEiWxlf97dSI4ufdN17vbsN3upB5dUqelJWeCmpxa/9veCVcn+mHF3UuyUUCYjGt8Qt83CXjGJ6m+P2dutPzTxrIi/WkbsfX9tpSjJvtUfN6JDu7rO3AX3Uj58hjAkKFlR4+x3XxDM7bhNG+3fap1F3AigP/w7UloyM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728993480; c=relaxed/simple;
	bh=1v7wss//mfn9ZhUeU2zlLtwbke7J0sT/cONP4QU80Ww=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rD5slLvXxe+YbJsa0ZAGy2Zfn8Ud3jA4ulNMLmQi/tMo2ZPHZMk9RAp/hQli8of+7sPtD+LY/0ATu5P+qfrWyReRwC4BpQDqCxbhX+oQojUDhPVFrbDWy64bpsOLLXUugKhDsLF6MzgnxjtZFheRdvDPkN6DqeVoQKKWk/aqL7w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PxPQiysC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PxPQiysC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CAC3C4CED2;
	Tue, 15 Oct 2024 11:57:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728993479;
	bh=1v7wss//mfn9ZhUeU2zlLtwbke7J0sT/cONP4QU80Ww=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PxPQiysCz420lKcl4x4AvXA9/DGWSXnNUTfcQ+tItjwYBazo7PKJ/+AQUXl5O+5FI
	 wfhhXO/yY3Nsscf+dVy+Le9ZtvMpl4EujYgyE/O3oevoRf1MQCb8fCZFZgCZtKGFp9
	 kJtbfGvcV2SxV+r6EoIC1msClTN+DCLTKOizLMWU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Simon Horman <horms@kernel.org>,
	Marcin Wojtas <marcin.s.wojtas@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 425/691] net: mvpp2: Increase size of queue_name buffer
Date: Tue, 15 Oct 2024 13:26:13 +0200
Message-ID: <20241015112457.211991541@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015112440.309539031@linuxfoundation.org>
References: <20241015112440.309539031@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Simon Horman <horms@kernel.org>

[ Upstream commit 91d516d4de48532d967a77967834e00c8c53dfe6 ]

Increase size of queue_name buffer from 30 to 31 to accommodate
the largest string written to it. This avoids truncation in
the possibly unlikely case where the string is name is the
maximum size.

Flagged by gcc-14:

  .../mvpp2_main.c: In function 'mvpp2_probe':
  .../mvpp2_main.c:7636:32: warning: 'snprintf' output may be truncated before the last format character [-Wformat-truncation=]
   7636 |                  "stats-wq-%s%s", netdev_name(priv->port_list[0]->dev),
        |                                ^
  .../mvpp2_main.c:7635:9: note: 'snprintf' output between 10 and 31 bytes into a destination of size 30
   7635 |         snprintf(priv->queue_name, sizeof(priv->queue_name),
        |         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   7636 |                  "stats-wq-%s%s", netdev_name(priv->port_list[0]->dev),
        |                  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   7637 |                  priv->port_count > 1 ? "+" : "");
        |                  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Introduced by commit 118d6298f6f0 ("net: mvpp2: add ethtool GOP statistics").
I am not flagging this as a bug as I am not aware that it is one.

Compile tested only.

Signed-off-by: Simon Horman <horms@kernel.org>
Reviewed-by: Marcin Wojtas <marcin.s.wojtas@gmail.com>
Link: https://patch.msgid.link/20240806-mvpp2-namelen-v1-1-6dc773653f2f@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/marvell/mvpp2/mvpp2.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2.h b/drivers/net/ethernet/marvell/mvpp2/mvpp2.h
index 72608a47d4e02..24a8c9b8126b7 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2.h
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2.h
@@ -1088,7 +1088,7 @@ struct mvpp2 {
 	unsigned int max_port_rxqs;
 
 	/* Workqueue to gather hardware statistics */
-	char queue_name[30];
+	char queue_name[31];
 	struct workqueue_struct *stats_queue;
 
 	/* Debugfs root entry */
-- 
2.43.0



