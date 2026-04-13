Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0442A320393;
	Mon, 13 Apr 2026 16:55:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776099337; cv=none; b=PEuiuNsY1D82hFlp6Ta4GcsTeS5S8nX9FLgnrKZDiWpEdPXa+x9SvisMj/XgKb95Df5jxF51u16j+T/u/iSuA5fgXmvIWQru5BlY5Bs5nBVWC7pyteTV0ix+haCVEyzbNe0wz6drJV2NhMzeR+rDeRXtA4UvtJxT5oFGqu/zutg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776099337; c=relaxed/simple;
	bh=F6zyd4hlOgnQjn460UoLd5jyUDtzHWk/a/ALK5RthQI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KNdJMTV53xW45XXni0ONRCh0aWEqIEzFFEtySuBavxMulsw5ovCnYbZdZdkl8Un53p3CNwxYaKKtcI8pSn95mvqJpwz47UuoeHVbCBtBtegzDQ1xYlR61FhV/sYsRGrxJBckC5egnlQiXSAXMsRLgz754xfNTKQxTXBz1GOcj5w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XcOsjwZh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XcOsjwZh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D9C4C2BCAF;
	Mon, 13 Apr 2026 16:55:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776099336;
	bh=F6zyd4hlOgnQjn460UoLd5jyUDtzHWk/a/ALK5RthQI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XcOsjwZh21VkK5nPNyyMopNkmwAmSoK4gp3MBtrYf08rZNZVPgZ5NRMWWSa8XSxOD
	 DgVY1p25g6oTZSRG6cw+/9RmI0oKeg6pdEqLDUSur1JRgu7GpqpXNXbIeISTkKoJX8
	 awCLNv5RnzpDG5QTsRTYCb2EBTXcvK2Lp3wS7XlQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuhao Jiang <danisjiang@gmail.com>,
	Tyllis Xu <LivelyCarpet87@gmail.com>,
	Dave Marquardt <davemarq@linux.ibm.com>,
	Tyrel Datwyler <tyreld@linux.ibm.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 5.10 301/491] scsi: ibmvfc: Fix OOB access in ibmvfc_discover_targets_done()
Date: Mon, 13 Apr 2026 17:59:06 +0200
Message-ID: <20260413155830.311740386@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155819.042779211@linuxfoundation.org>
References: <20260413155819.042779211@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -4238,7 +4238,8 @@ static void ibmvfc_discover_targets_done
 	switch (mad_status) {
 	case IBMVFC_MAD_SUCCESS:
 		ibmvfc_dbg(vhost, "Discover Targets succeeded\n");
-		vhost->num_targets = be32_to_cpu(rsp->num_written);
+		vhost->num_targets = min_t(u32, be32_to_cpu(rsp->num_written),
+					   max_targets);
 		ibmvfc_set_host_action(vhost, IBMVFC_HOST_ACTION_ALLOC_TGTS);
 		break;
 	case IBMVFC_MAD_FAILED:


