Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 789464E2F35;
	Fri,  9 Oct 2026 14:23:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791555794; cv=none; b=d365Z8dn2qC3Ak3SYkBd25rRlwYtYpSfxZm/OPfUc/mO5T7JNN+7c8v8kbUFCIdWm80noLJrmfa/+jhZLKPpfOLfLJsDp+w8bIjBv4OrbUiSnLh05HmdSWWcVJk/gOu0nCdK2IUazyLujNJAgyfLm5B3ogudhe4zzaFlmOhqgW0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791555794; c=relaxed/simple;
	bh=VDUkdx1sCrKGXzK5drHemW7cSJIZiN7IXcJu7l4Lv4o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n3n6U/x5UC1gq+xS/L9T+VBsTmshdX4dzvNJHx69xDWWQ+mKkKo4kirwUx+wMczTLFiA9yZ61kZU9WcJK7Dh4AZtslm5v0aaxPaKK9kK9IE12/jtZKqg8YRag6f3oPqbeZQF+KSp9gq2CjVz2sPqkqWaDpx1752xAysk2g/afbg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=if7uhtnz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="if7uhtnz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A43CD1F000FF;
	Fri,  9 Oct 2026 14:23:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791555791;
	bh=x4RZRqf5RdLlMGuBPD3sBb91SJLfkwK77TCSw76zbVQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=if7uhtnzPQ/sSAqOJ+0+UBM8ufWtEqUoxmZJw3YenmbJJ2cmmVAF+jfkwC76yvWXG
	 7yCWWBhq5v2WMa0CAX9GPjbbOsGSfFwkhoKB3zYbjNIsql7M8xuC8yv9dkyRzCdsRu
	 VGp2pyUf7S9qBJRsKHPZ2AK5Oe9aibszO3etXh8Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 070/428] mtd: core: call _get_device() with the master MTD
Date: Fri,  9 Oct 2026 16:06:47 +0200
Message-ID: <20261009140947.690356304@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140946.008206689@linuxfoundation.org>
References: <20261009140946.008206689@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Karl Mehltretter <kmehltretter@gmail.com>

[ Upstream commit 12b31d1acd20b3185bb5f0748db0cf6874c8e9d1 ]

__get_mtd_device() calls the master's _get_device() callback with mtd,
which may be a partition. __put_mtd_device() passes the master.

This breaks gluebi partitions because gluebi_get_device() uses
container_of() and therefore requires the master MTD. Pass the master
to _get_device(), matching _put_device().

Fixes: 46b5889cc2c5 ("mtd: implement proper partition handling")
Assisted-by: Codex:gpt-5.6-sol
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/mtdcore.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mtd/mtdcore.c b/drivers/mtd/mtdcore.c
index 6158452be24d6..491a27d0315fa 100644
--- a/drivers/mtd/mtdcore.c
+++ b/drivers/mtd/mtdcore.c
@@ -1333,7 +1333,7 @@ int __get_mtd_device(struct mtd_info *mtd)
 	int err;
 
 	if (master->_get_device) {
-		err = master->_get_device(mtd);
+		err = master->_get_device(master);
 		if (err)
 			return err;
 	}
-- 
2.53.0



