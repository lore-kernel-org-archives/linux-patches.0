Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 421D03F9D1;
	Mon, 29 Jan 2024 17:14:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548443; cv=none; b=Q37BbFY4G1NcMtSTRhaJDgsRuCmVcQgaxuPSXtojZr2IIO0y9oFQJrRPiuNqGHnMM9aLLdcVgfBUwLnMvIUyeVoWpGrlv/z+m8xnfEJPqgabifiQzbnfZLZFNtQZEK1Cyr2i1NUm+i7UIMqjhdie9R48Ei/LbjWnCpFtBfDnH0I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548443; c=relaxed/simple;
	bh=QO3Jzb2q0cDNkYijAgRRd2byfmkUjIiACpwhjHHGrjE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LglAdKSF75cYXKRiW43DKekrTCD0gwpq91N9sluD7Q0Ndu2lD01JE/4cvG4agvmk2cvHf6tdFvyO3ELMh56dbGWhvXwnzMTW9fP2NJw91QHRE+tGICbrIZBN3256GG4wOyIvqUHgZwzp9pNNHEgkRozqzn9bed+B3YFrldAYC7w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2Y5bEHnK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2Y5bEHnK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A91C3C433C7;
	Mon, 29 Jan 2024 17:14:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548442;
	bh=QO3Jzb2q0cDNkYijAgRRd2byfmkUjIiACpwhjHHGrjE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2Y5bEHnK/DIl3XhBk00LbWIGO2Pi+AXlKa/9XlRawcaJPuFPyRyEJbzSb5D2Ra0DC
	 7hXfC/knE/h/cTuiUZwUau7HGa1ze3FsLwCUzmqH0uyMkhzp4SzyishJTYWVAxNifm
	 8h9YsMyGNyEfItC/++q6wlc3TgP0S5w0csNCmzgA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	=?UTF-8?q?Martin=20Hundeb=C3=B8ll?= <martin@geanix.com>
Subject: [PATCH 6.6 048/331] mtd: rawnand: Prevent sequential reads with on-die ECC engines
Date: Mon, 29 Jan 2024 09:01:52 -0800
Message-ID: <20240129170016.339255150@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129170014.969142961@linuxfoundation.org>
References: <20240129170014.969142961@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Miquel Raynal <miquel.raynal@bootlin.com>

commit a62c4597953fe54c6af04166a5e2872efd0e1490 upstream.

Some devices support sequential reads when using the on-die ECC engines,
some others do not. It is a bit hard to know which ones will break other
than experimentally, so in order to avoid such a difficult and painful
task, let's just pretend all devices should avoid using this
optimization when configured like this.

Cc: stable@vger.kernel.org
Fixes: 003fe4b9545b ("mtd: rawnand: Support for sequential cache reads")
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Tested-by: Martin Hundebøll <martin@geanix.com>
Link: https://lore.kernel.org/linux-mtd/20231215123208.516590-4-miquel.raynal@bootlin.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mtd/nand/raw/nand_base.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/drivers/mtd/nand/raw/nand_base.c
+++ b/drivers/mtd/nand/raw/nand_base.c
@@ -5171,6 +5171,14 @@ static void rawnand_late_check_supported
 	/* The supported_op fields should not be set by individual drivers */
 	WARN_ON_ONCE(chip->controller->supported_op.cont_read);
 
+	/*
+	 * Too many devices do not support sequential cached reads with on-die
+	 * ECC correction enabled, so in this case refuse to perform the
+	 * automation.
+	 */
+	if (chip->ecc.engine_type == NAND_ECC_ENGINE_TYPE_ON_DIE)
+		return;
+
 	if (!nand_has_exec_op(chip))
 		return;
 


