Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C60D257AEC;
	Thu, 17 Apr 2025 18:29:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744914577; cv=none; b=Wc6+plZXj+kLe3WVKbAYIw4bah+y2xVo7x7jBz7aiJaoHdeYzaYQ2rJuYkQi2b1TSjGzFnxsSMhuPce+rn/pFRUH7r7ku5eKTj4B37H+1sILPBJt7Ijk4Tu1ZsWTKIuJKAkbFQvGREauvZWDmatUinBJUZmZb6UfJeOmhUY0SmY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744914577; c=relaxed/simple;
	bh=2neam/n+WGilAo+2xgUszFHpCNRbHGa1IEoZgkf2Wx8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HJUsWJf+4wR3HUrJG0+A4+wY5KTYD++Qo0cKSzPD+H9i0rSVddYXz4EH3fgoZT4OnQlk42MqCaVBTcoI4vhHMehax4r2GMDDRDWNWytg3JElBBJJ9I80eB4qGhmEUSdpusCSXgISsRca5NBVcfG6GrjNI8+M1012eaPJV+pM90Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=okxbXXuN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="okxbXXuN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D173CC4CEE7;
	Thu, 17 Apr 2025 18:29:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744914577;
	bh=2neam/n+WGilAo+2xgUszFHpCNRbHGa1IEoZgkf2Wx8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=okxbXXuN9cgET/1QMC+MXNqC8JSfjqWY1cqBWN7YXvdEmrL/TTviyf83Mnuo0osfR
	 NvX82CWQg5CKc1cXtyDpTU8t21ICXxkMcAeJFPBGPyMDV2wr2wLCDG5/DAPJt/K9Wm
	 tbGXWIERjNMUF7TxxloTkf9e/slMpCRZfydmy75M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marco Patalano <mpatalan@redhat.com>,
	"Ewan D. Milne" <emilne@redhat.com>,
	Justin Tee <justin.tee@broadcom.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 6.13 261/414] scsi: lpfc: Restore clearing of NLP_UNREG_INP in ndlp->nlp_flag
Date: Thu, 17 Apr 2025 19:50:19 +0200
Message-ID: <20250417175121.927927781@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175111.386381660@linuxfoundation.org>
References: <20250417175111.386381660@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ewan D. Milne <emilne@redhat.com>

commit 040492ac2578b66d3ff4dcefb4f56811634de53d upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/lpfc/lpfc_sli.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -2923,6 +2923,8 @@ lpfc_sli_def_mbox_cmpl(struct lpfc_hba *
 				clear_bit(NLP_UNREG_INP, &ndlp->nlp_flag);
 				ndlp->nlp_defer_did = NLP_EVT_NOTHING_PENDING;
 				lpfc_issue_els_plogi(vport, ndlp->nlp_DID, 0);
+			} else {
+				clear_bit(NLP_UNREG_INP, &ndlp->nlp_flag);
 			}
 
 			/* The unreg_login mailbox is complete and had a


