Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4FF618C00E;
	Wed,  6 Nov 2024 12:28:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730896104; cv=none; b=nK2mjdDqTyRiWEfFCN3idocbsIhnlt24/bDnbByM/SAXqfCgHRm/ZDYr139lY4+2imNh/VBFpnKBsw2AswNJzIXPm4CYGCFFkNKLvpTjilCnU2YXJzb0tkFLncgUCH9zZ9JAAfJYywe53PfGmXgvxRxEcP8xnAEJw/UPxvX/+9c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730896104; c=relaxed/simple;
	bh=vYNq2/a19aAUElB1u2muOe/8wIUWzf6oolp949gx2Xc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RSfxbkEwB0rBmJgrwRrrokO+nF15lnGL7fefleKf4wSLi+slTlGqKk0EVzsq/A2yg+6shJvPUuOcPElisIfW+9iNfEFJOEeV9uOYgnQy0PEMhNXdq7ZT+y5HmmtmOyyDNKZji2WCUBTJ+bIFRSDM3zN8LS7oNN9oxPpb5FjaV4A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0Nnmfmzo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0Nnmfmzo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B721C4CECD;
	Wed,  6 Nov 2024 12:28:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730896104;
	bh=vYNq2/a19aAUElB1u2muOe/8wIUWzf6oolp949gx2Xc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0Nnmfmzory4QZ5N9NDJ9qxyQXCAZ7mB4vo3jmqOZDH3+Lza+DZ+5JbrcwACZbTlJB
	 l8/NHeTqLVA05PFzUkvYQzcFlk8CPw1cxIEnq34R4iEUmpQD4O528YeksHYbvwx4K1
	 tGOTQpwVxAVdLwQX0BkLU2T1o8wtf+dW7AtEtED4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Marzinski <bmarzins@redhat.com>,
	"Ewan D. Milne" <emilne@redhat.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 092/245] scsi: scsi_transport_fc: Allow setting rport state to current state
Date: Wed,  6 Nov 2024 13:02:25 +0100
Message-ID: <20241106120321.473589534@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120319.234238499@linuxfoundation.org>
References: <20241106120319.234238499@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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
index 7d088b8da0757..2270732b353c8 100644
--- a/drivers/scsi/scsi_transport_fc.c
+++ b/drivers/scsi/scsi_transport_fc.c
@@ -1255,7 +1255,7 @@ static ssize_t fc_rport_set_marginal_state(struct device *dev,
 		 */
 		if (rport->port_state == FC_PORTSTATE_ONLINE)
 			rport->port_state = port_state;
-		else
+		else if (port_state != rport->port_state)
 			return -EINVAL;
 	} else if (port_state == FC_PORTSTATE_ONLINE) {
 		/*
@@ -1265,7 +1265,7 @@ static ssize_t fc_rport_set_marginal_state(struct device *dev,
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



