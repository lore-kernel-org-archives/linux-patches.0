Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 593ED35BDBB;
	Wed,  3 Dec 2025 16:23:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764779015; cv=none; b=tBgDkN6FvR+tJispv77v4KWzsy4ENKjb1NwgrbKfwOKH1OPi90Hc1DZDGtb9fPnvJVqTIuwxuI0M7rtoLIhNlbRxb5Khh10kaxr19vRo0IdC5E7o635GVYQmcUuGmv1WGbYx8H4D3Vy7wvbiFnp0bQSo9htML6pYlN3RGQyI8Bs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764779015; c=relaxed/simple;
	bh=q1oG4giZHsfTDOoKVQXTkVNcddV51cdaTLB8Oar2Zcc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cNS4x4EouqSV/tE/h3u9MWG0wC1G7jE0rc+IgPH6nsYPNto3sB/t2toV69pHWqCixYgXga/3eMPO2Grulb71U09H6dxF/MpyIR5cL914dxt8FmzkL5QqLFeDEqsjON21AmkCmqRNCqYYKWhN5cZnKUl1z+zC0VF4R0aV/15ZLEE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HyF3V8Y0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HyF3V8Y0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B38C1C116B1;
	Wed,  3 Dec 2025 16:23:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764779015;
	bh=q1oG4giZHsfTDOoKVQXTkVNcddV51cdaTLB8Oar2Zcc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HyF3V8Y0+uUfhUoYByVlnhLd3/pJdni0QmR531ARVrMLrLcREyjg9s2zs7m2Ed0Ad
	 Sue5e/2u0gNndXvgWsAT/mDLmv1wWjbo4HOh0k41xu0hMFInQQzFgWWrQD9vcof/gD
	 o0qPgZSWVxNBeJ0yH0QdujdCGTmR/bTdnGOASlCM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Stein <alexander.stein@ew.tq-group.com>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 129/568] mfd: stmpe: Remove IRQ domain upon removal
Date: Wed,  3 Dec 2025 16:22:11 +0100
Message-ID: <20251203152445.453304720@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152440.645416925@linuxfoundation.org>
References: <20251203152440.645416925@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index aef29221d7c12..a23b3816eee37 100644
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



