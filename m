Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2612019E96D;
	Wed,  4 Feb 2026 15:31:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770219104; cv=none; b=G2ewuVO5ad9YiMNlK1p3DosC0gCJr9qzFwL2E9NPSz9KeOBZopmEk4lUJARRrnEQC0o97xuqRkxOdaZ1CVDNvhUtnGwyntO4XI+l2omHnOeCrb9CRPqUHgOWHL2mMQKwIXo/2kZG1LEnWVVqKTx/wOrdmiADW0Tvh5ycpWX76ag=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770219104; c=relaxed/simple;
	bh=A8eUWcN2ljvNJvCbrW9Ti61HgS568MqaoWh+AXgakN4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LedfoVdqxPWCIo56ITBeRHGBYmqM1MC2M8VvaAdiWd49z/RTls+Itra3DbvhwkvHzlhlIHv02HdlKphrhB8f2FyifhJPihDQ6pL07WSkEWWdZmJv/o8JAsto/bZbOazfQzbQB/0iLoHtIIChoCoCEAd8CdPprNWpOri6rZlLYSs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x7WykGm3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x7WykGm3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB419C4CEF7;
	Wed,  4 Feb 2026 15:31:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770219104;
	bh=A8eUWcN2ljvNJvCbrW9Ti61HgS568MqaoWh+AXgakN4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=x7WykGm3CDZmxp0NpxvzeazKxqroouaul0N1iVQXbBvGrxiEb87lw0UXKq5y9CGXE
	 mjY14rnH6cyXNWRm2Ht6ICirRj1NxTSML63thGPMhmCrvy4oVXPFUTp8vVDh1YS+bP
	 HWnR4beYPWsDAGyouUzb9BCA9BjeFlPUZ0hEFE/8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haoxiang Li <lihaoxiang@isrc.iscas.ac.cn>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 6.18 069/122] scsi: be2iscsi: Fix a memory leak in beiscsi_boot_get_sinfo()
Date: Wed,  4 Feb 2026 15:40:51 +0100
Message-ID: <20260204143854.336984898@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143851.857060534@linuxfoundation.org>
References: <20260204143851.857060534@linuxfoundation.org>
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

From: Haoxiang Li <lihaoxiang@isrc.iscas.ac.cn>

commit 4747bafaa50115d9667ece446b1d2d4aba83dc7f upstream.

If nonemb_cmd->va fails to be allocated, free the allocation previously
made by alloc_mcc_wrb().

Fixes: 50a4b824be9e ("scsi: be2iscsi: Fix to make boot discovery non-blocking")
Cc: stable@vger.kernel.org
Signed-off-by: Haoxiang Li <lihaoxiang@isrc.iscas.ac.cn>
Link: https://patch.msgid.link/20251213083643.301240-1-lihaoxiang@isrc.iscas.ac.cn
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/be2iscsi/be_mgmt.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/scsi/be2iscsi/be_mgmt.c
+++ b/drivers/scsi/be2iscsi/be_mgmt.c
@@ -1025,6 +1025,7 @@ unsigned int beiscsi_boot_get_sinfo(stru
 					      &nonemb_cmd->dma,
 					      GFP_KERNEL);
 	if (!nonemb_cmd->va) {
+		free_mcc_wrb(ctrl, tag);
 		mutex_unlock(&ctrl->mbox_lock);
 		return 0;
 	}


