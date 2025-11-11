Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8329246768;
	Tue, 11 Nov 2025 01:03:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762823040; cv=none; b=mS/IX+ScXzflLMGiAMVdBrNk1Nh/jmJpbMUlc/HpUGoFyVXShogly1oDxKte67yQSmZN8+xw+OZFuJ5nm2gtNUPDjtWHSB4hJ4Hf3urffXN4b0IOwF/r66iflTN7eZHlSsYEzyidcYL6dBkesxsM6yAVSqCp7HaQkpbXmjouGLs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762823040; c=relaxed/simple;
	bh=2xCsSzRmAVhl5X6SUDpAUoUUSyF5tCXwzQ6CLRQ7UzE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kh4coNLYX06a9QpV5P+X7nxXV4nLED0q7R8w0cHldMDzcQgqslhHfCW5V2M08wOoKqk+MGJoxRgdDAkBTdk+GZYmMNT2U4ign+JWxoFVtxyMwfoOUXLVyfTg1yg5I+s/BNfoyi9bF1t87gmiBu8k+4A5hw0ghxBTBAgxiM4RLqk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2nUf8eLZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2nUf8eLZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76F88C2BC86;
	Tue, 11 Nov 2025 01:03:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762823039;
	bh=2xCsSzRmAVhl5X6SUDpAUoUUSyF5tCXwzQ6CLRQ7UzE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2nUf8eLZdhEJtID94287eT5U5AaiexZVu40y6aD8kInS2u1rmAGLymxWEcznHPnuu
	 fg5Vht3g4rRHFpC28sOMHBLpDofbM/gSutDHs2m0QYmcEr7bc7HB1DT/3ZCWW+hZDR
	 EaNz3yho/N3zoCQtJBJZCG+1Tf3XgMmI/+J/HLdw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Stein <alexander.stein@ew.tq-group.com>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 219/849] mfd: stmpe: Remove IRQ domain upon removal
Date: Tue, 11 Nov 2025 09:36:29 +0900
Message-ID: <20251111004541.734011954@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexander Stein <alexander.stein@ew.tq-group.com>

[ Upstream commit 57bf2a312ab2d0bc8ee0f4e8a447fa94a2fc877d ]

The IRQ domain is (optionally) added during stmpe_probe, but never removed.
Add the call to stmpe_remove.

Signed-off-by: Alexander Stein <alexander.stein@ew.tq-group.com>
Link: https://lore.kernel.org/r/20250725070752.338376-1-alexander.stein@ew.tq-group.com
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mfd/stmpe.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/mfd/stmpe.c b/drivers/mfd/stmpe.c
index 819d19dc9b4a9..e1165f63aedae 100644
--- a/drivers/mfd/stmpe.c
+++ b/drivers/mfd/stmpe.c
@@ -1485,6 +1485,9 @@ int stmpe_probe(struct stmpe_client_info *ci, enum stmpe_partnum partnum)
 
 void stmpe_remove(struct stmpe *stmpe)
 {
+	if (stmpe->domain)
+		irq_domain_remove(stmpe->domain);
+
 	if (!IS_ERR(stmpe->vio) && regulator_is_enabled(stmpe->vio))
 		regulator_disable(stmpe->vio);
 	if (!IS_ERR(stmpe->vcc) && regulator_is_enabled(stmpe->vcc))
-- 
2.51.0



