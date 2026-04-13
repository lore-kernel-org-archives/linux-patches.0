Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEA8C2D8364;
	Mon, 13 Apr 2026 16:34:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776098053; cv=none; b=l7LJWQbTB6q1DINDkPEgfviFS04126AvH1AhvzPXsmk+d6Us5CPADlCVrpTXvpRjvjg8N5PzZAvu+BO/ULe5p26Ewb4CJeI6ZoyVK7nSwecUQ9BkJP7MCbdLeBP1r+elgBfs0Bp5ijiyPglXv9c/HhfOBsYK2vLq6E8sUUePFjM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776098053; c=relaxed/simple;
	bh=OdFd8dclx3AkTCowvqn0TG20v3AEug6SnuY4BH4J5fo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dIL5PxpYWZnmFTuEAN5+LM1XkpTXtt47dXc0JmIc6A8cyOummo4KvtulYmPTLpIiCTPEAnW2+CDmirdakoS2Y/UvTCrXp8B9oeYu+mbooQo/4Jga9HszaT1z3WvzzMSfnqJ3uP+aqfpKwUMzA5E45FueQKmrRI2PMppOJAK4UzU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jeV5QI7y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jeV5QI7y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1575AC2BCAF;
	Mon, 13 Apr 2026 16:34:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776098053;
	bh=OdFd8dclx3AkTCowvqn0TG20v3AEug6SnuY4BH4J5fo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jeV5QI7yd4Nr87VaAepDjZ5bPZAtSDqg2GlhizfGvPVDXSIl9SyvBDbP/HAp/8Ni7
	 bPdPZ/jhhG9/4lgEn1eI+zjyxIhxRRQppBZDKp81d9JmXYoqot+0jpmjK1+C7HIxqd
	 YsrOyO4fuxGrj5K+ioSP5lT0DcssglYThpFvzygw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuhao Jiang <danisjiang@gmail.com>,
	Tyllis Xu <LivelyCarpet87@gmail.com>,
	Dave Marquardt <davemarq@linux.ibm.com>,
	Tyrel Datwyler <tyreld@linux.ibm.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 5.15 376/570] scsi: ibmvfc: Fix OOB access in ibmvfc_discover_targets_done()
Date: Mon, 13 Apr 2026 17:58:27 +0200
Message-ID: <20260413155844.563885135@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155830.386096114@linuxfoundation.org>
References: <20260413155830.386096114@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -4926,7 +4926,8 @@ static void ibmvfc_discover_targets_done
 	switch (mad_status) {
 	case IBMVFC_MAD_SUCCESS:
 		ibmvfc_dbg(vhost, "Discover Targets succeeded\n");
-		vhost->num_targets = be32_to_cpu(rsp->num_written);
+		vhost->num_targets = min_t(u32, be32_to_cpu(rsp->num_written),
+					   max_targets);
 		ibmvfc_set_host_action(vhost, IBMVFC_HOST_ACTION_ALLOC_TGTS);
 		break;
 	case IBMVFC_MAD_FAILED:


