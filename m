Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E04BB1D3653;
	Tue,  8 Oct 2024 13:16:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728393361; cv=none; b=AwnqpBpS05e/SL2JYNcrwMu9B5MAcWA3dc6OoYp2CTDQBlBKdNbrLLd1/2VH+OlByRGGo9LC67qrbMZ5QF8YX/MZ/eesk3klo5v2vawlfAf8R5HVB+FmwRb/wsKEl4e/thPGElcHx3hiI10Uk/Pj0zFwg+s+gwOE6ff1xea6TS0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728393361; c=relaxed/simple;
	bh=V1iKgGnX94bREtod46PdG/TSnHyEQZVJA9Ur43VAYU8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TlB8HGXB6D7VAtUon96Xrtx+/cioRRrIPOrglHbbpYVix3wtGXZ5PTOJq7jA6gMaS4qOavM+UuUArh/4AXKJDREgGeMdcIcI72IoSxfS+e51zoEjh5mPnhWXx6G7isXGGtaCTvQeUBg1begT9+FQMTGlMX0Li4iqSDw+aFkDXvo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=odwW5Qte; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="odwW5Qte"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 510F4C4CEC7;
	Tue,  8 Oct 2024 13:16:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728393360;
	bh=V1iKgGnX94bREtod46PdG/TSnHyEQZVJA9Ur43VAYU8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=odwW5QtecKedVqeS5u39PvTtqN9ITKv6GrpYseWzlrmQcV9+0tQ0up6JEMVKfknFh
	 AdROvyIs15HRS05ZTszC6J2rDttt0mOLdl3uPGvmXb92Q50H+3ac21/vMNI3MSMsy+
	 3ddc+8JRqhXDQy01r4WfaLrJRUPRUs4mTq1Jz1Pw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Simon Horman <horms@kernel.org>,
	Marcin Wojtas <marcin.s.wojtas@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 087/386] net: mvpp2: Increase size of queue_name buffer
Date: Tue,  8 Oct 2024 14:05:32 +0200
Message-ID: <20241008115632.878195965@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115629.309157387@linuxfoundation.org>
References: <20241008115629.309157387@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index e809f91c08fb9..9e02e4367bec8 100644
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



