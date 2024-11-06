Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 816D71E0DBD;
	Wed,  6 Nov 2024 13:20:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730899207; cv=none; b=VvPrKA9QBuwJ9/kSj0idK2gtkS3cd4wLR9Psz1w1Dsb+ynTtzjHEiGUP19ZTHDtl5mmPLcG+eafdweMiCUJqRJyLLaqpCsBHb3IMWKsdJvya6AkHDcABhHypgFRUCHMrHoVMKeo7BNZ0Mq0E1nNBZ8cjmDvvvsRm7l4ipfnR7+M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730899207; c=relaxed/simple;
	bh=4bl8luB91je7woID+I1w6yKFKoVHbslWSaXSFyh+qfA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YBwFMNDeAzgj9McTIlin7Eo/gYSsaug7gKfmac0IXpcAtfbm0hhPu59Ha0oj3fVz0qlL1fNm21Qz9aFk6emKHrsQycLSaKHc+7tJrNMVj6rOtkFfjIMb5dLi6h3cYQepW76PV0DzKRKXUqlcBKkbOSusVRu4QBOWQFq5eoHjZKM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZdcpekQS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZdcpekQS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2421C4CED4;
	Wed,  6 Nov 2024 13:20:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730899207;
	bh=4bl8luB91je7woID+I1w6yKFKoVHbslWSaXSFyh+qfA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZdcpekQSke44+Evc743CcaRd9X0is/w48Qu73+vVJ6RhZqeLZcGH/Aw8xOWu+DZiX
	 +hcnLI9RLGvNmdrJryksJOYru+dsoUCRnYk3DEvrr81uCaB0FpFI4u0AEgQfVasHe0
	 D8S7W31ugynf1KurmMvWuLqAA+GVEP3D86DSN6Kc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Marzinski <bmarzins@redhat.com>,
	"Ewan D. Milne" <emilne@redhat.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 34/73] scsi: scsi_transport_fc: Allow setting rport state to current state
Date: Wed,  6 Nov 2024 13:05:38 +0100
Message-ID: <20241106120300.984611095@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120259.955073160@linuxfoundation.org>
References: <20241106120259.955073160@linuxfoundation.org>
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
index a2524106206db..fbe2036ca6196 100644
--- a/drivers/scsi/scsi_transport_fc.c
+++ b/drivers/scsi/scsi_transport_fc.c
@@ -1250,7 +1250,7 @@ static ssize_t fc_rport_set_marginal_state(struct device *dev,
 		 */
 		if (rport->port_state == FC_PORTSTATE_ONLINE)
 			rport->port_state = port_state;
-		else
+		else if (port_state != rport->port_state)
 			return -EINVAL;
 	} else if (port_state == FC_PORTSTATE_ONLINE) {
 		/*
@@ -1260,7 +1260,7 @@ static ssize_t fc_rport_set_marginal_state(struct device *dev,
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



