Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11100214A9B;
	Tue,  8 Jul 2025 16:45:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751993139; cv=none; b=XqpiV2rpe4iJ7mth0WKI4h6gP21zPCqa1QTM8AOB+KkPrJblleAs5BrqlgrKJiZx6O0Ub/MzIqWjfi98P/9yaWJc1Jm/joi5NPpf882mkcsUPJhNNFANfmfK2tCOOD+R+IgtgVn/G9phexGQV2bH626nWAl0ePLgqqM01buSjT4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751993139; c=relaxed/simple;
	bh=qQp/1NJVTJCzmAu4dCAGQ5r8JTzLnNgy+9p8uuQO6fA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IOWWpJi+D3MavjPrvrvHLtCDheX5nrs+AQ2SEGnTT8wdJldIajdO6fDM01/H54XrpZ7dBINSDJQHpkAJR5SKyPjZEKqrhPWtSTGP2oiQWhGbwxoJHQq67ba/jt+LK20soUbga16H3+/3CZZVINCuutZRMcjmx3w584MgzzwLN7k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JmIK8TO/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JmIK8TO/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12879C4CEED;
	Tue,  8 Jul 2025 16:45:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751993137;
	bh=qQp/1NJVTJCzmAu4dCAGQ5r8JTzLnNgy+9p8uuQO6fA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JmIK8TO/w7LwshM3D55P+cyzWaxj30JTlW+R1fS9IS5bLU6gp18KsoFBiAaJ1Ly5x
	 BFC7MKwkjGtzGR97rWWZ4K5ANrzTfVispu67j80SRvCDiTpZErnMz4lFFpXMhTrnYo
	 iRLS2uBsWSNNdgfh07kO66vH/nm36e5BS/wu7UaE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marco Patalano <mpatalan@redhat.com>,
	"Ewan D. Milne" <emilne@redhat.com>,
	Justin Tee <justin.tee@broadcom.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 170/232] scsi: lpfc: Restore clearing of NLP_UNREG_INP in ndlp->nlp_flag
Date: Tue,  8 Jul 2025 18:22:46 +0200
Message-ID: <20250708162245.888135371@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162241.426806072@linuxfoundation.org>
References: <20250708162241.426806072@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ewan D. Milne <emilne@redhat.com>

[ Upstream commit 040492ac2578b66d3ff4dcefb4f56811634de53d ]

Commit 32566a6f1ae5 ("scsi: lpfc: Remove NLP_RELEASE_RPI flag from nodelist
structure") introduced a regression with SLI-3 adapters (e.g. LPe12000 8Gb)
where a Link Down / Link Up such as caused by disabling an host FC switch
port would result in the devices remaining in the transport-offline state
and multipath reporting them as failed.  This problem was not seen with
newer SLI-4 adapters.

The problem was caused by portions of the patch which removed the functions
__lpfc_sli_rpi_release() and lpfc_sli_rpi_release() and all their callers.
This was presumably because with the removal of the NLP_RELEASE_RPI flag
there was no need to free the rpi.

However, __lpfc_sli_rpi_release() and lpfc_sli_rpi_release() which calls it
reset the NLP_UNREG_INP flag. And, lpfc_sli_def_mbox_cmpl() has a path
where __lpfc_sli_rpi_release() was called in a particular case where
NLP_UNREG_INP was not otherwise cleared because of other conditions.

Restoring the else clause of this conditional and simply clearing the
NLP_UNREG_INP flag appears to resolve the problem with SLI-3 adapters.  It
should be noted that the code path in question is not specific to SLI-3,
but there are other SLI-4 code paths which may have masked the issue.

Fixes: 32566a6f1ae5 ("scsi: lpfc: Remove NLP_RELEASE_RPI flag from nodelist structure")
Cc: stable@vger.kernel.org
Tested-by: Marco Patalano <mpatalan@redhat.com>
Signed-off-by: Ewan D. Milne <emilne@redhat.com>
Link: https://lore.kernel.org/r/20250317163731.356873-1-emilne@redhat.com
Reviewed-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/lpfc/lpfc_sli.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index 80c3c84c23914..c4acf594286e5 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -2921,6 +2921,8 @@ lpfc_sli_def_mbox_cmpl(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmb)
 				clear_bit(NLP_UNREG_INP, &ndlp->nlp_flag);
 				ndlp->nlp_defer_did = NLP_EVT_NOTHING_PENDING;
 				lpfc_issue_els_plogi(vport, ndlp->nlp_DID, 0);
+			} else {
+				clear_bit(NLP_UNREG_INP, &ndlp->nlp_flag);
 			}
 
 			/* The unreg_login mailbox is complete and had a
-- 
2.39.5



