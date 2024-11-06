Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C28281E04A8;
	Wed,  6 Nov 2024 12:44:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730897073; cv=none; b=CI5Cwjjg+1UHNwpSTPgIgTLuZoWsbZJwnNKzQ29ZRxBtm6COWKr3SVmKdoxgVBa5gZVkdsDbL22JS8++Q98LwIulZ1kw1EFIlbRlEb5y3sB8ycVWcUA/DfQe+Ce10ekr1KUi/PfeZ4lKDR3MaQ3Os3CPNrk/I3eHKk19iuOsqy0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730897073; c=relaxed/simple;
	bh=WAkKt4QbBtD/zk+NgXalnvUKrHp+d3yDRab/V/bBc7w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m3N6imANBfP7+tFtS9NClcyMxLW50V5/IPdlin1BCPjMtMr4yjQSFlST8aJMgL9qot9o2IMRAqUrhrVLlDKgt+5toYo9ADDUw1sf8IUc4BlNa1JrVakrQO2MktdE5KmFUNp8DxpN79NqiqqGeIJmf7mg85mM12cj/AjV+7sfyRA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GIFGVNNr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GIFGVNNr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A540C4CED6;
	Wed,  6 Nov 2024 12:44:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730897073;
	bh=WAkKt4QbBtD/zk+NgXalnvUKrHp+d3yDRab/V/bBc7w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GIFGVNNrZNyUcVdvo+/BgTK0woa88JC1CH3g+w7bCjlJcAZewSKNNkRKu3myW86Bx
	 Z6vpyE158RljbGqCcti4JfXFxTsr7fgIoHxB8TA5FHq7aK8P6OO6XXLYuPZEnDgOKw
	 QK08K7Vi8T/24jiVh4ua01tg0NrJpF74LIbsLezc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Marzinski <bmarzins@redhat.com>,
	"Ewan D. Milne" <emilne@redhat.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 057/126] scsi: scsi_transport_fc: Allow setting rport state to current state
Date: Wed,  6 Nov 2024 13:04:18 +0100
Message-ID: <20241106120307.638966643@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120306.038154857@linuxfoundation.org>
References: <20241106120306.038154857@linuxfoundation.org>
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

From: Benjamin Marzinski <bmarzins@redhat.com>

[ Upstream commit d539a871ae47a1f27a609a62e06093fa69d7ce99 ]

The only input fc_rport_set_marginal_state() currently accepts is
"Marginal" when port_state is "Online", and "Online" when the port_state
is "Marginal". It should also allow setting port_state to its current
state, either "Marginal or "Online".

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
Link: https://lore.kernel.org/r/20240917230643.966768-1-bmarzins@redhat.com
Reviewed-by: Ewan D. Milne <emilne@redhat.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/scsi_transport_fc.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/scsi_transport_fc.c b/drivers/scsi/scsi_transport_fc.c
index 8934160c4a33b..1aaeb0ead7a71 100644
--- a/drivers/scsi/scsi_transport_fc.c
+++ b/drivers/scsi/scsi_transport_fc.c
@@ -1252,7 +1252,7 @@ static ssize_t fc_rport_set_marginal_state(struct device *dev,
 		 */
 		if (rport->port_state == FC_PORTSTATE_ONLINE)
 			rport->port_state = port_state;
-		else
+		else if (port_state != rport->port_state)
 			return -EINVAL;
 	} else if (port_state == FC_PORTSTATE_ONLINE) {
 		/*
@@ -1262,7 +1262,7 @@ static ssize_t fc_rport_set_marginal_state(struct device *dev,
 		 */
 		if (rport->port_state == FC_PORTSTATE_MARGINAL)
 			rport->port_state = port_state;
-		else
+		else if (port_state != rport->port_state)
 			return -EINVAL;
 	} else
 		return -EINVAL;
-- 
2.43.0



