Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 479CB20C00A;
	Fri, 17 Oct 2025 15:18:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760714325; cv=none; b=NcyozW+3dG1BMc88KLN9+Nf91gXgtp3X/JNvEhx5gfFfb8KBeBzEHnGLSVckQSZ/xVlcotH03lzJGkNL4a5MJzINxk6jxX8CrNB0x5BssH1TFYEssNDdwgNvajAMLyL7C+WG/V6imZNPB9Kdy8ZffWjurc+5w1OQdu3FzLKvtOw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760714325; c=relaxed/simple;
	bh=mra2Zl2FpvSKon7GrXSkJlJwEQJ5YmKeSKmxvg7klVQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kZ+w3+InE8A9ysq0KpdraIix1BKlgoZNcpQrD9f+2auBIKx9r9YNDgCeoCTKJqinG6JLEyv2pbiBgN8hUzNlKftc/qw8nY4hkxNQ0mQBKCVzpQQ1Gf0FXGkiMgEucKJYty8yzgdhi2KGqHNUMOeF63XTyAj4nMhISlHtS7KETLQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0SZeKW+T; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0SZeKW+T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84AF0C4CEFE;
	Fri, 17 Oct 2025 15:18:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760714324;
	bh=mra2Zl2FpvSKon7GrXSkJlJwEQJ5YmKeSKmxvg7klVQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0SZeKW+TRHJYMyG6QWiiKs4xcjMzAXROYQeHmrXYJ3x3xUAqdONKl7hxm170h5KhV
	 EeQdfgNBXbZuNof+tR4ML9Gj3nq+wmv8bDMbsxmLFiRIoZpio1P2o4VoqYm9w96eK7
	 bNGEOiZXu87YBL81lZh+TausdZ4leJjpZ8CuZ4nI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Harini T <harini.t@amd.com>,
	Peng Fan <peng.fan@nxp.com>,
	Jassi Brar <jassisinghbrar@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 062/277] mailbox: zynqmp-ipi: Remove dev.parent check in zynqmp_ipi_free_mboxes
Date: Fri, 17 Oct 2025 16:51:09 +0200
Message-ID: <20251017145149.409719138@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145147.138822285@linuxfoundation.org>
References: <20251017145147.138822285@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Harini T <harini.t@amd.com>

[ Upstream commit 019e3f4550fc7d319a7fd03eff487255f8e8aecd ]

The ipi_mbox->dev.parent check is unreliable proxy for registration
status as it fails to protect against probe failures that occur after
the parent is assigned but before device_register() completes.

device_is_registered() is the canonical and robust method to verify the
registration status.

Remove ipi_mbox->dev.parent check in zynqmp_ipi_free_mboxes().

Fixes: 4981b82ba2ff ("mailbox: ZynqMP IPI mailbox controller")
Signed-off-by: Harini T <harini.t@amd.com>
Reviewed-by: Peng Fan <peng.fan@nxp.com>
Signed-off-by: Jassi Brar <jassisinghbrar@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mailbox/zynqmp-ipi-mailbox.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/mailbox/zynqmp-ipi-mailbox.c b/drivers/mailbox/zynqmp-ipi-mailbox.c
index 388f418aebb72..411bbc10edeaf 100644
--- a/drivers/mailbox/zynqmp-ipi-mailbox.c
+++ b/drivers/mailbox/zynqmp-ipi-mailbox.c
@@ -893,10 +893,8 @@ static void zynqmp_ipi_free_mboxes(struct zynqmp_ipi_pdata *pdata)
 	i = pdata->num_mboxes;
 	for (; i >= 0; i--) {
 		ipi_mbox = &pdata->ipi_mboxes[i];
-		if (ipi_mbox->dev.parent) {
-			if (device_is_registered(&ipi_mbox->dev))
-				device_unregister(&ipi_mbox->dev);
-		}
+		if (device_is_registered(&ipi_mbox->dev))
+			device_unregister(&ipi_mbox->dev);
 	}
 }
 
-- 
2.51.0



