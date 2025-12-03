Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0ED3F3314D4;
	Wed,  3 Dec 2025 15:59:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764777594; cv=none; b=fPeJfsiGxVNYOOFxVLmOotqXwP2ycbJdiIY1q1lwnsjYNac8Z0vdiDUo2uIJGRfaLkPFQ51qQr2GXQdYkAkj6EtlMEVug9IZxuntUY7vGNHeQjgMPhiQuKnIBrg81FIqD/eXfA/ekmWaQKAvlmq2tjUIfvMxAfK7dm9SWvCk5Nw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764777594; c=relaxed/simple;
	bh=spPs0jEF4SK3O4fw4vCJ0AsF3UfqWMwz8wXK0C/PnVQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nfhHvRethUlVOi9WjZpRZNymtcfcfsbsI6yU3W0EoS+44ykrPg8bN2b4woxF7tcjGAJTQWJFRk94aA2xkRPMXkDbZwih3Wf7pHZXTp/9nWHca3r4/I3i8qpb3wo5hSTGp4obUXntnaaXQZWA5wpk7Xz7mSrcTU4SYnUHUba0Afs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vwMDTzc8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vwMDTzc8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4336EC116B1;
	Wed,  3 Dec 2025 15:59:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764777593;
	bh=spPs0jEF4SK3O4fw4vCJ0AsF3UfqWMwz8wXK0C/PnVQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vwMDTzc8P5DuIJH+F3FkYQca+nAr6B/sjwRKHBj5cLTds2gDtUhjobjBTY78+Ff3h
	 pgizfnQ2Fc6l3V+k31yAxeXnBJ65t+OcRPg57zyXdmrogrh7cVpRRoyZKpYbYXY/Bt
	 aMRtOGFG2dxoJjpMvSBqaqnWKknDCTXXjrstqftw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Stein <alexander.stein@ew.tq-group.com>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 086/392] mfd: stmpe: Remove IRQ domain upon removal
Date: Wed,  3 Dec 2025 16:23:56 +0100
Message-ID: <20251203152417.268763715@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152414.082328008@linuxfoundation.org>
References: <20251203152414.082328008@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 743afbe4e99b7..0c4e49716ee1c 100644
--- a/drivers/mfd/stmpe.c
+++ b/drivers/mfd/stmpe.c
@@ -1498,6 +1498,9 @@ int stmpe_probe(struct stmpe_client_info *ci, enum stmpe_partnum partnum)
 
 int stmpe_remove(struct stmpe *stmpe)
 {
+	if (stmpe->domain)
+		irq_domain_remove(stmpe->domain);
+
 	if (!IS_ERR(stmpe->vio) && regulator_is_enabled(stmpe->vio))
 		regulator_disable(stmpe->vio);
 	if (!IS_ERR(stmpe->vcc) && regulator_is_enabled(stmpe->vcc))
-- 
2.51.0



