Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D503248886;
	Wed, 25 Feb 2026 01:35:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983349; cv=none; b=Ue7VZLeDzmQyCKA4C/SA3Du+kgKVrhhoAnUk8U2ZAJ+PBBiKreSEqhyDjZvj1H/XsWBRxInkGATYJ4fA2tdOpBTMNxKIowVoepjIPUt75IspUSKbaamN5ex49def1TLLAsIxCeknsPbB0eAMU3S4jr2F8FkeCeWipp307cKdOxE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983349; c=relaxed/simple;
	bh=0cyLp9iaQmDNcv77rnPqUKjXCuKCc+g1mDc7gwhoHc0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h4XEyjgbmTOmHAlN9hLcUKk8qhqd5nJJJWyGraHu4DaDP483xPzgBUtMm9t4Rny1mUJwcoPHb4cB6/FSc3mG5imVncAlLsoCBEiF+UFQAEivviqmSlYzQ8kNLQyYMPzFy+cBXnZxQ/567Duo5bAWjD9NlcMQCW7pPU49iTA4Zmg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dPRj4UhN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dPRj4UhN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C16E5C116D0;
	Wed, 25 Feb 2026 01:35:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983348;
	bh=0cyLp9iaQmDNcv77rnPqUKjXCuKCc+g1mDc7gwhoHc0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dPRj4UhNraA4x87KbXZmH6Df+oRzSgn2ABjSwm3YfwcpC0il4v+iI2CWLRdGqtvYj
	 IuxowywO6mzr3j4GuX6eadi0Y5t8GHTnmbO/BjsJ5+xOGbrwJFgnsJWt1fjkd/A9QT
	 O8o0IhZHZ1I/tdvRuHzKujpVlISNRVUH3S105rRE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zilin Guan <zilin@seu.edu.cn>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 476/781] mtd: parsers: Fix memory leak in mtd_parser_tplink_safeloader_parse()
Date: Tue, 24 Feb 2026 17:19:45 -0800
Message-ID: <20260225012411.489425394@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zilin Guan <zilin@seu.edu.cn>

[ Upstream commit 980ce2b02dd06a4fdf5fee38b2e14becf9cf7b8b ]

The function mtd_parser_tplink_safeloader_parse() allocates buf via
mtd_parser_tplink_safeloader_read_table(). If the allocation for
parts[idx].name fails inside the loop, the code jumps to the err_free
label without freeing buf, leading to a memory leak.

Fix this by freeing the temporary buffer buf in the err_free label.

Compile tested only. Issue found using a prototype static analysis tool
and code review.

Fixes: 00a3588084be ("mtd: parsers: add TP-Link SafeLoader partitions table parser")
Signed-off-by: Zilin Guan <zilin@seu.edu.cn>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/parsers/tplink_safeloader.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/mtd/parsers/tplink_safeloader.c b/drivers/mtd/parsers/tplink_safeloader.c
index e358a029dc70c..4fcaf92d22e4f 100644
--- a/drivers/mtd/parsers/tplink_safeloader.c
+++ b/drivers/mtd/parsers/tplink_safeloader.c
@@ -116,6 +116,7 @@ static int mtd_parser_tplink_safeloader_parse(struct mtd_info *mtd,
 	return idx;
 
 err_free:
+	kfree(buf);
 	for (idx -= 1; idx >= 0; idx--)
 		kfree(parts[idx].name);
 err_free_parts:
-- 
2.51.0



