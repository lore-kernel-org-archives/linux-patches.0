Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2E9A1CF284;
	Wed,  2 Oct 2024 14:25:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727879150; cv=none; b=ubyNDiG0xxJzxMifemmVkJGhII13xdYUIq6hrhRBQoAr0Rz/17P5dvD5C2GFmfXn5iYnkWzZBAMRFJRPfMC9isbEpXlX0HIsNs4cdqe8qAEG7ZEACE2SjojwzX3swZtEWePVK++o527soxP/D4iN4bcZ+JpVzljgZ9t88TYd46A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727879150; c=relaxed/simple;
	bh=H5V6rtOYKPgHCva7dTCbUULF5A3iSzgr8nXOd7rh98A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gHmuJcftQQWgqRGc6MM9B3WixJH4mbutkl1n2Hp/dQUwC496d86LCtkurG7DC84hHGwow7KMA0gTIvsYRD11rQR5l4QpuKv6GHkbrf/cxoOFguHMMUOdQXBhDAaECQJyu2Pwmle1CQs6RS7AgUA+efQZYLlwADxGoCn8Sqtjm8A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YfFwGhqA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YfFwGhqA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5941FC4CEC2;
	Wed,  2 Oct 2024 14:25:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727879150;
	bh=H5V6rtOYKPgHCva7dTCbUULF5A3iSzgr8nXOd7rh98A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YfFwGhqAoy7H95UsOWlHZ7FSvYg6UfxmnuwgqucaeJXV75g/z56mW5qKxKB6iyber
	 6liRevlNTzFdh2rsjdmmMIvHxCfLV5TOQB2iJD6dYYhaDm1Z6DcYv3DR0gZhfdsvbm
	 nFhG/IDSLwO8c4cj8kdWbJkpYp3bkgmqWO0KWT7Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Zhang Rui <rui.zhang@intel.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 020/538] powercap: intel_rapl: Fix off by one in get_rpi()
Date: Wed,  2 Oct 2024 14:54:19 +0200
Message-ID: <20241002125752.807167731@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125751.964700919@linuxfoundation.org>
References: <20241002125751.964700919@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@linaro.org>

[ Upstream commit 95f6580352a7225e619551febb83595bcb77ab17 ]

The rp->priv->rpi array is either rpi_msr or rpi_tpmi which have
NR_RAPL_PRIMITIVES number of elements.  Thus the > needs to be >=
to prevent an off by one access.

Fixes: 98ff639a7289 ("powercap: intel_rapl: Support per Interface primitive information")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Acked-by: Zhang Rui <rui.zhang@intel.com>
Link: https://patch.msgid.link/86e3a059-504d-4795-a5ea-4a653f3b41f8@stanley.mountain
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/powercap/intel_rapl_common.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/powercap/intel_rapl_common.c b/drivers/powercap/intel_rapl_common.c
index 3dfe45ac300aa..f1de4111e98d9 100644
--- a/drivers/powercap/intel_rapl_common.c
+++ b/drivers/powercap/intel_rapl_common.c
@@ -738,7 +738,7 @@ static struct rapl_primitive_info *get_rpi(struct rapl_package *rp, int prim)
 {
 	struct rapl_primitive_info *rpi = rp->priv->rpi;
 
-	if (prim < 0 || prim > NR_RAPL_PRIMITIVES || !rpi)
+	if (prim < 0 || prim >= NR_RAPL_PRIMITIVES || !rpi)
 		return NULL;
 
 	return &rpi[prim];
-- 
2.43.0



