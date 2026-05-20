Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E4273F0A83;
	Wed, 20 May 2026 17:41:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779298881; cv=none; b=erh8bwBN44ELamI8sRQKUimZRSn/JgR/LpU6cx8FA3Lc4LiGFw48zktuaZzV2d43mbsZoS7wdpLMfGSFN/+hmlTq0hG7sna+CoYZjSBoetCUdO5PGL3Q3bmtg/8S0PQtdeihwScPa/ZIzgLN79b9Od6Tvgm1uhthzRP7Bun5IN0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779298881; c=relaxed/simple;
	bh=SRfhTI9Ux98y9htu9TV7t57ZN1a13XQ2u+Vcvtqzx6o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e/nFq2ddJSNTD3H/Le6I8F7/IPI6NkiDcNFa2vyXplQUjlnugkFFWh4VGpGLsmzbVu9DLLqR6Xr9oeEOPc/VsvYyYl/OrYmb2YCo4LhBjmUuf2vE3TxPU2PshAS2+pFKBgNiICJl3dWO8rSxmGGMsx52oBsRqSlvUBzvSMCQUpQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=R4p4wJnj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="R4p4wJnj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B401D1F00893;
	Wed, 20 May 2026 17:41:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779298880;
	bh=r5hZ09EnQCPAyFJUoqc//X7N58cQSGiHFYABT17VEEA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=R4p4wJnju5KSBHOnGx0yLuf+Lmiopkf/rIselO+d48fBhEZ1fhM5YsDiDM+FGy3+p
	 Tb2Q/m/BsARJ2ayJVAo70R8BMx3SUu/JwaAnQ01a2C6JqQvA1bKDnze0CohDG5FlBs
	 FMqGVNAw/IO9XEU//FUS7TR5H0keQQliSjSEpzPQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adrian Hunter <adrian.hunter@intel.com>,
	Frank Li <Frank.Li@nxp.com>,
	Jorge Marques <jorge.marques@analog.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 527/957] i3c: master: adi: Fix error propagation for CCCs
Date: Wed, 20 May 2026 18:16:50 +0200
Message-ID: <20260520162145.962201566@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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

From: Jorge Marques <jorge.marques@analog.com>

[ Upstream commit 0b73da96b6eb6b9354654f96a9d423ab22cb222d ]

adi_i3c_master_send_ccc_cmd() always returned 0, ignoring the transfer
result populated in the completion path. As a consequence, CCC command
errors were silently dropped, including the default -ETIMEDOUT and
later overwritten by adi_i3c_master_end_xfer_locked().

Fix this by returning xfer->ret so that callers correctly receive any
transfer error codes.

Fixes: a79ac2cdc91d ("i3c: master: Add driver for Analog Devices I3C Controller IP")
Reviewed-by: Adrian Hunter <adrian.hunter@intel.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Jorge Marques <jorge.marques@analog.com>
Link: https://patch.msgid.link/20260323-ad4062-positive-error-fix-v3-5-30bdc68004be@analog.com
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i3c/master/adi-i3c-master.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/i3c/master/adi-i3c-master.c b/drivers/i3c/master/adi-i3c-master.c
index 82ac0b3d057ab..d329faf4b3f96 100644
--- a/drivers/i3c/master/adi-i3c-master.c
+++ b/drivers/i3c/master/adi-i3c-master.c
@@ -362,7 +362,7 @@ static int adi_i3c_master_send_ccc_cmd(struct i3c_master_controller *m,
 
 	cmd->err = adi_i3c_cmd_get_err(&xfer->cmds[0]);
 
-	return 0;
+	return xfer->ret;
 }
 
 static int adi_i3c_master_priv_xfers(struct i3c_dev_desc *dev,
-- 
2.53.0



