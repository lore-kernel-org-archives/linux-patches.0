Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71A831A76B6;
	Tue, 30 Jul 2024 17:26:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722360385; cv=none; b=i8M0KvR2hcOXI0fVqGv5B/SIswdx1Mbx1H9Z1dJa5Rme/WiztdGOGWQG8lfwKD/x53uzUJ0iN6vWULcNMDXELAobB2RYC2PUDUUfBMIrlb/gxXQVUd3Pta82xzMgpYWPeP8PB+GS/HaZxhBHZmp2SNyiFKg92UIoQmGZh/A4WAY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722360385; c=relaxed/simple;
	bh=38h8FuPXnzYDs/GbhPSJhJoA9I22cMNUFi7u83gFmDM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gJQ9/gsiMJlT3fhlwok97f1t+9JkwQSV7Hl8uUVaHTGMBshF+JN5kAySKVr/WyUiAWQq3Ceo2pcsmIOFq9LqDvUHQpA/fFvtt+gaT7R3Q//dVbyMbq4jsldJt32BURujRB5maQ6tJUlvicepyPX9LdIiMsBEK0Yfx8WPBz+Tkmk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DFiTCP7N; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DFiTCP7N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7CCBC32782;
	Tue, 30 Jul 2024 17:26:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722360385;
	bh=38h8FuPXnzYDs/GbhPSJhJoA9I22cMNUFi7u83gFmDM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DFiTCP7NprQnLLrk+rbdkkEndX3plBTabQWIYRl0Kiu7JJyHCrR6YBf9gq49NMm5W
	 QBy7PKBRtpKXtJViJ8JQAxYkiJ4SBbcwxZs0F/ZW+vGd+pvLkt56J9ujr77QdodNfj
	 ynAKjmfB08iKWJGJ2IPza/oBIDnKJJUoTvkwbAjs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Justin Tee <justin.tee@broadcom.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 6.10 682/809] scsi: lpfc: Allow DEVICE_RECOVERY mode after RSCN receipt if in PRLI_ISSUE state
Date: Tue, 30 Jul 2024 17:49:18 +0200
Message-ID: <20240730151751.846214584@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Justin Tee <justin.tee@broadcom.com>

commit 9609385dd91b26751019b22ca9bfa4bec7602ae1 upstream.

Certain vendor specific targets initially register with the fabric as an
initiator function first and then re-register as a target function
afterwards.

The timing of the target function re-registration can cause a race
condition such that the driver is stuck assuming the remote port as an
initiator function and never discovers the target's hosted LUNs.

Expand the nlp_state qualifier to also include NLP_STE_PRLI_ISSUE because
the state means that PRLI was issued but we have not quite reached
MAPPED_NODE state yet.  If we received an RSCN in the PRLI_ISSUE state,
then we should restart discovery again by going into DEVICE_RECOVERY.

Fixes: dded1dc31aa4 ("scsi: lpfc: Modify when a node should be put in device recovery mode during RSCN")
Cc: <stable@vger.kernel.org> # v6.6+
Signed-off-by: Justin Tee <justin.tee@broadcom.com>
Link: https://lore.kernel.org/r/20240628172011.25921-3-justintee8345@gmail.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/lpfc/lpfc_hbadisc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/scsi/lpfc/lpfc_hbadisc.c
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c
@@ -5725,7 +5725,7 @@ lpfc_setup_disc_node(struct lpfc_vport *
 				return ndlp;
 
 			if (ndlp->nlp_state > NLP_STE_UNUSED_NODE &&
-			    ndlp->nlp_state < NLP_STE_PRLI_ISSUE) {
+			    ndlp->nlp_state <= NLP_STE_PRLI_ISSUE) {
 				lpfc_disc_state_machine(vport, ndlp, NULL,
 							NLP_EVT_DEVICE_RECOVERY);
 			}


