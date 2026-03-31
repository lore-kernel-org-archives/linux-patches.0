Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 156BA2E1C7C;
	Tue, 31 Mar 2026 17:05:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774976758; cv=none; b=XYALDiWGURlvu+2Mfmdl6WTmV/qVvhIQ1PIBzWI18T3YEBCCQ2eaL1Iqn3RqQCGx9OXVoNF8dmnoJIc17RAMUrlnkXJ0pqdsxzQMrciSrhokF7HS7qFnRCgk/TFcz5oHMhU2AJIGafqGmstc2oVZ5S1JpmiwLuFZCInF24qzzDI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774976758; c=relaxed/simple;
	bh=4RfKTY0H7P57i/VQwERo/1QulP4Hwp/WfaowSktGWu0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VTg9ZyvH0lnR6qi6KPxHkVDZ7aOmR42X1ttO8b5oYgHsl1gGMJGfUjgV72OWmOSw8Xmzk7yCUtzu1YE0m0KyU8p2tg7fAECWNzsoCne5YtMTFwhO+SzDI4JTbAV1fHvARwCDnz5lq4BHZtViN6xmMLNdSOikBHFHiAZMdJxOYt8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cpY6l847; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cpY6l847"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E22CC19423;
	Tue, 31 Mar 2026 17:05:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774976758;
	bh=4RfKTY0H7P57i/VQwERo/1QulP4Hwp/WfaowSktGWu0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cpY6l847SXvUhUlp6y90RhTRAIx+wF0WYs/d8Rk3jSm+g01DR0Pw0Cvz3B0/7uDr0
	 jMin9VOeFvLUWwwignfex5bLSsTC07EeGSdGDBwblywe4DRNS/grK4irr65XX5CWZJ
	 KYC+adbva8emNQlxmNUyUx53ffIeEe5yj9L3KrnA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuhao Jiang <danisjiang@gmail.com>,
	Tyllis Xu <LivelyCarpet87@gmail.com>,
	Dave Marquardt <davemarq@linux.ibm.com>,
	Tyrel Datwyler <tyreld@linux.ibm.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 6.18 217/309] scsi: ibmvfc: Fix OOB access in ibmvfc_discover_targets_done()
Date: Tue, 31 Mar 2026 18:22:00 +0200
Message-ID: <20260331161801.437376316@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161753.468533260@linuxfoundation.org>
References: <20260331161753.468533260@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tyllis Xu <livelycarpet87@gmail.com>

commit 61d099ac4a7a8fb11ebdb6e2ec8d77f38e77362f upstream.

A malicious or compromised VIO server can return a num_written value in the
discover targets MAD response that exceeds max_targets. This value is
stored directly in vhost->num_targets without validation, and is then used
as the loop bound in ibmvfc_alloc_targets() to index into disc_buf[], which
is only allocated for max_targets entries. Indices at or beyond max_targets
access kernel memory outside the DMA-coherent allocation.  The
out-of-bounds data is subsequently embedded in Implicit Logout and PLOGI
MADs that are sent back to the VIO server, leaking kernel memory.

Fix by clamping num_written to max_targets before storing it.

Fixes: 072b91f9c651 ("[SCSI] ibmvfc: IBM Power Virtual Fibre Channel Adapter Client Driver")
Reported-by: Yuhao Jiang <danisjiang@gmail.com>
Cc: stable@vger.kernel.org
Signed-off-by: Tyllis Xu <LivelyCarpet87@gmail.com>
Reviewed-by: Dave Marquardt <davemarq@linux.ibm.com>
Acked-by: Tyrel Datwyler <tyreld@linux.ibm.com>
Link: https://patch.msgid.link/20260314170151.548614-1-LivelyCarpet87@gmail.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/ibmvscsi/ibmvfc.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/scsi/ibmvscsi/ibmvfc.c
+++ b/drivers/scsi/ibmvscsi/ibmvfc.c
@@ -4965,7 +4965,8 @@ static void ibmvfc_discover_targets_done
 	switch (mad_status) {
 	case IBMVFC_MAD_SUCCESS:
 		ibmvfc_dbg(vhost, "Discover Targets succeeded\n");
-		vhost->num_targets = be32_to_cpu(rsp->num_written);
+		vhost->num_targets = min_t(u32, be32_to_cpu(rsp->num_written),
+					   max_targets);
 		ibmvfc_set_host_action(vhost, IBMVFC_HOST_ACTION_ALLOC_TGTS);
 		break;
 	case IBMVFC_MAD_FAILED:


