Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F3FD1D04BA;
	Wed,  2 Oct 2024 14:32:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727879532; cv=none; b=VbtO1e5PwA8kl6LmphGEEiRj4uBg2nCqGdo1v4sBHv921sENO6pl/VTCpcdNQtDG3NlBXvEdRoym+Hw8ZqyIuh/dmiVja5bUXBvZrKfmp1zn92HwDIgTJ+EnFJtYWaDZqTMaZBu5BjCRA7xJAaNRv73OltqV81ubfBzR+uVudIc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727879532; c=relaxed/simple;
	bh=WJfCVtTuScAFv75WzUvVxJFMc4xhECRLLVbT2du8snA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d/nI7fQ7ce96Vu4Yk8TnLnFZYiC91kSPE5I8E3w/iPvnTUXEz/uj409uTePll0vuajcpyUrdNffeE37DsH0MtgqV3qbmunSLY1glzJ0zdtJCmOWmjW7H9m18ePtwiUBrReS56ZmLkTTucMt34XaPb3PwyWOJLeSY8XiqsMlOMtE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IuVcuzTV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IuVcuzTV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DEEFC4CEC2;
	Wed,  2 Oct 2024 14:32:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727879532;
	bh=WJfCVtTuScAFv75WzUvVxJFMc4xhECRLLVbT2du8snA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IuVcuzTVJVWa5rzOLEgd/dKw1WBU7k8b3MVc1RR1ZIu8VlMsoSCy07eZpjZs5YGhR
	 U2wMFvP6z4H6YUqD7sk4DfpOZtmen2Fk84jo9epg+OQvs3rUq8jFkhPXfiq1+D2DKr
	 vM3Mu8s9pr6TjnZtHi77TI/bWMLyzbfzmJgysq2c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Daniel Wagner <dwagner@suse.de>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 151/538] scsi: elx: libefc: Fix potential use after free in efc_nport_vport_del()
Date: Wed,  2 Oct 2024 14:56:30 +0200
Message-ID: <20241002125758.214447418@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125751.964700919@linuxfoundation.org>
References: <20241002125751.964700919@linuxfoundation.org>
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

From: Dan Carpenter <dan.carpenter@linaro.org>

[ Upstream commit 2e4b02fad094976763af08fec2c620f4f8edd9ae ]

The kref_put() function will call nport->release if the refcount drops to
zero.  The nport->release release function is _efc_nport_free() which frees
"nport".  But then we dereference "nport" on the next line which is a use
after free.  Re-order these lines to avoid the use after free.

Fixes: fcd427303eb9 ("scsi: elx: libefc: SLI and FC PORT state machine interfaces")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Link: https://lore.kernel.org/r/b666ab26-6581-4213-9a3d-32a9147f0399@stanley.mountain
Reviewed-by: Daniel Wagner <dwagner@suse.de>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/elx/libefc/efc_nport.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/elx/libefc/efc_nport.c b/drivers/scsi/elx/libefc/efc_nport.c
index 2e83a667901fe..1a7437f4328e8 100644
--- a/drivers/scsi/elx/libefc/efc_nport.c
+++ b/drivers/scsi/elx/libefc/efc_nport.c
@@ -705,9 +705,9 @@ efc_nport_vport_del(struct efc *efc, struct efc_domain *domain,
 	spin_lock_irqsave(&efc->lock, flags);
 	list_for_each_entry(nport, &domain->nport_list, list_entry) {
 		if (nport->wwpn == wwpn && nport->wwnn == wwnn) {
-			kref_put(&nport->ref, nport->release);
 			/* Shutdown this NPORT */
 			efc_sm_post_event(&nport->sm, EFC_EVT_SHUTDOWN, NULL);
+			kref_put(&nport->ref, nport->release);
 			break;
 		}
 	}
-- 
2.43.0



