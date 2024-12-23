Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69DEF3D6D;
	Mon, 23 Dec 2024 16:08:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734970089; cv=none; b=phbQn3M+VEctQPcWHTGoZo87e/nDMihVeZCNqforLwD020OqKaKUpPB9skY1gSSqKHixi5/PfpRNVNpiwe17+3bjqh79wbrT2ltyvaPmD9ynCfmSNfNwXXLxuJBXF+NGMCh/QQsftgA802uV5eqlyiV0+XJPwrFvVrQEjEtjthg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734970089; c=relaxed/simple;
	bh=Ug6euxqdRtoERdsFM9TI5bIUMUWU9RiWChFVU+MzFR0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DcdBETKS6f1jro+tydcRppAF/77Fk5zp5W1ul16ViuHdth445ONOnUS3SvBKbfr7MbfytT5naI83r+4quY5+FAuAreYkpt10vrTpFyjpXW+cwABrlwLtIazftDFxE0iyZ3yct78OySq1Rc+3srNG3jRI8+uXYnbhDrY58keyOZQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=snHrE8bI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="snHrE8bI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDC60C4CED3;
	Mon, 23 Dec 2024 16:08:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734970089;
	bh=Ug6euxqdRtoERdsFM9TI5bIUMUWU9RiWChFVU+MzFR0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=snHrE8bI2J+WPYUuOR568S0b3dMZ+DZd8lJVe8qFq50IRgOpq0ThPKxPtxoJMemLp
	 V/hf09ba8RHm6jMDU1vwNYLDTv5AG9msZQdbGyaO539TCgLJei4hm7y0CkNht/nEjq
	 wRY/NCzlcBWUiz/Uu17gxrlvDz3wUirO7eVgYx7E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zijun Hu <quic_zijuhu@quicinc.com>,
	"Rob Herring (Arm)" <robh@kernel.org>
Subject: [PATCH 6.12 140/160] of/irq: Fix interrupt-map cell length check in of_irq_parse_imap_parent()
Date: Mon, 23 Dec 2024 16:59:11 +0100
Message-ID: <20241223155414.206845249@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241223155408.598780301@linuxfoundation.org>
References: <20241223155408.598780301@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zijun Hu <quic_zijuhu@quicinc.com>

commit fec3edc47d5cfc2dd296a5141df887bf567944db upstream.

On a malformed interrupt-map property which is shorter than expected by
1 cell, we may read bogus data past the end of the property instead of
returning an error in of_irq_parse_imap_parent().

Decrement the remaining length when skipping over the interrupt parent
phandle cell.

Fixes: 935df1bd40d4 ("of/irq: Factor out parsing of interrupt-map parent phandle+args from of_irq_parse_raw()")
Cc: stable@vger.kernel.org
Signed-off-by: Zijun Hu <quic_zijuhu@quicinc.com>
Link: https://lore.kernel.org/r/20241209-of_irq_fix-v1-1-782f1419c8a1@quicinc.com
[rh: reword commit msg]
Signed-off-by: Rob Herring (Arm) <robh@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/of/irq.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/of/irq.c
+++ b/drivers/of/irq.c
@@ -111,6 +111,7 @@ const __be32 *of_irq_parse_imap_parent(c
 	else
 		np = of_find_node_by_phandle(be32_to_cpup(imap));
 	imap++;
+	len--;
 
 	/* Check if not found */
 	if (!np) {


