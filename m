Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 636ED3AE71F;
	Tue, 16 Jun 2026 17:11:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781629911; cv=none; b=gjWPZuBMIewRzcgUMA7qX16KTKTZhFd4jvwtGcjPS5oOl9Vvq/+e999vCSTAJI8ojAaHrue7/kmAr9a1cuztbHj4knHP2uQYOey90/TLuRNjs1eiKfiIsjJSUxuAUsCk/vues34anN1xnpnXCDtVatPIAqTcld7gX+ssIJF7OvE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781629911; c=relaxed/simple;
	bh=g7adNw6j1QhXACIkRwLYWbjJNoA1d7BAF1ZcrUONWbM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DvFG5vnSmy3IBiefE9lv3kbGBMeRIQagddUpyuND2CVzLdpn6/fa6Bjmk/oXBJI1vgINsLD+ziVyadPGuOVzXqdEk3WLYjEKzGsqdO/y7ELEi1Ct4t7cbbU3SZlMV1lZesx0wWS28G5nA7CJNHvrCmHhzE2F9zV6eqnU1tRNnbA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eku9kQ4l; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eku9kQ4l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 624931F000E9;
	Tue, 16 Jun 2026 17:11:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781629910;
	bh=4As23+kR10RPK0i/9LeCcVsHnf5FdM6/8aRKxuDVNxs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eku9kQ4lewSgpJwDfq7Q+Pm8+iMjzwsn2viZEr5BpJS8jIQuPSB2lGUBfd5hPDaQZ
	 NpSBGezH+pq2zGk7PbKziJqGm9Vdnmi88QnGsFQiuRXSiZRc9h8h0J5Kc142LO9YHx
	 dHQYeoGr9a6LM957dglsicJ2/vvVnOJJE9XpdCyw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dawei Feng <dawei.feng@seu.edu.cn>,
	Zilin Guan <zilin@seu.edu.cn>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 6.6 342/452] octeontx2-af: fix memory leak in rvu_setup_hw_resources()
Date: Tue, 16 Jun 2026 20:29:29 +0530
Message-ID: <20260616145135.247273799@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145117.796205997@linuxfoundation.org>
References: <20260616145117.796205997@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dawei Feng <dawei.feng@seu.edu.cn>

commit 09a5bf856aa759513afc4afd233d15bcc711b84e upstream.

If rvu_npc_exact_init() fails in rvu_setup_hw_resources(), the function
returns directly instead of jumping to the error handling path. This
causes a resource leak for the previously initialized CGX, NPC, fwdata,
and MSI-X states.

Fix this by replacing the direct return with goto cgx_err to ensure
proper cleanup.

The bug was first flagged by an experimental analysis tool we are
developing for kernel memory-management bugs while analyzing
v6.13-rc1. The tool is still under development and is not yet publicly
available. Manual inspection confirms that the bug is still present in
v7.1-rc6.

An x86_64 allyesconfig build showed no new warnings. As we do not have
access to Marvell OcteonTX2 RVU AF hardware to test with, no runtime
testing was able to be performed.

Fixes: 3571fe07a090 ("octeontx2-af: Drop rules for NPC MCAM")
Cc: stable@vger.kernel.org
Signed-off-by: Dawei Feng <dawei.feng@seu.edu.cn>
Signed-off-by: Zilin Guan <zilin@seu.edu.cn>
Link: https://patch.msgid.link/20260604143756.1524482-1-dawei.feng@seu.edu.cn
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/marvell/octeontx2/af/rvu.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
@@ -1130,7 +1130,7 @@ cpt:
 	err = rvu_npc_exact_init(rvu);
 	if (err) {
 		dev_err(rvu->dev, "failed to initialize exact match table\n");
-		return err;
+		goto cgx_err;
 	}
 
 	/* Assign MACs for CGX mapped functions */


