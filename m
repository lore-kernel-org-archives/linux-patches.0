Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02A4B1E0DBB;
	Wed,  6 Nov 2024 12:51:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730897474; cv=none; b=kLZS0rI1s06bXxoLNPo1KEcC0IZsszd+kKWpg3QfxMd1I3gxw+I8FGbIscBW/awmGzCv3A+Ht076WOwa/kNWpqv+qTGmOy6a7MFpsa2kFTtle2TrbQRTGbst8j/KzyR5sF0+7Tdbpeh0n/oQoDZKbBb5BB45CL4LyFBSKrVUHDw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730897474; c=relaxed/simple;
	bh=1yo6WE2dHag2l/0HdxsGQ4SryW+o+O7b34Q09nSYEE8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nuOwLKz55sAhxSXILygQgp23FcH8ejWH0b53f5lVNBpBJJRbze0/QDa3P00iulCb+yZnJY7Rgx65AwKGaK0IhI7CKY8SyxlrseuRRPJF9fVS7/gRGTDhAxOW8DyN8dhLJa33+tfD5qUqYAT/RYm+HgJXDRkhZunHIkiopy1FYf4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=L67031BT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L67031BT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E725C4CECD;
	Wed,  6 Nov 2024 12:51:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730897473;
	bh=1yo6WE2dHag2l/0HdxsGQ4SryW+o+O7b34Q09nSYEE8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=L67031BTmSsDe3FaIcYJWKEYcn2X1gPnoxgmJ6kCn0hnGNIeZT26MePPVM9u9LV3F
	 RLz7HKu+rzT8urMpZ0uY4KpIy0Obym6Rx0sHaKmqJbyPjOqPXMyQNN5N9yhx7GsVcv
	 pfPKslAAgPJw13ItBMpApDej2zi04KNyJgoCC/n0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Marzinski <bmarzins@redhat.com>,
	"Ewan D. Milne" <emilne@redhat.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 064/151] scsi: scsi_transport_fc: Allow setting rport state to current state
Date: Wed,  6 Nov 2024 13:04:12 +0100
Message-ID: <20241106120310.601104305@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120308.841299741@linuxfoundation.org>
References: <20241106120308.841299741@linuxfoundation.org>
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
index b04075f19445d..96002966ca568 100644
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



