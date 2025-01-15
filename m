Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14E99248BA1;
	Wed, 15 Jan 2025 10:49:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736938178; cv=none; b=sekAE2iSq36XxaUXIiLOsSYy1jCRmvtuyQ3RjcD4POY+Hq2VtFu8yBFF3xKukp5mwGFAo4HYIls8sMG+ihqnmfEdmdgRfjmAPD5cE/F9bngebr+YR3geS4yofdLC2fgQxT1PQOaGyDTWtUX+pczgl5NEmXXoHm2SL8DG+z+xicY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736938178; c=relaxed/simple;
	bh=Y6ocCXgMg9wBOrLPHIOKEdjKtokqwQp6p4q6n0qljhk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t60eezLDZ3pwmVD5bGb2Qlh+oeZ/DnjgcSEhddqYLbg47fjbV8j70QP3VYemuz8PXywDvOK76dM/r2K2IENK1tm5tu2PW0YFTngpzsthBCXcBSb9uhVBoiB9/gEN6Om4Kge2N8n+1bS3NjQHLwMao5tkd53lKVRmGNF9AoXhXjA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jH5jx3SR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jH5jx3SR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 784DCC4CEDF;
	Wed, 15 Jan 2025 10:49:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736938178;
	bh=Y6ocCXgMg9wBOrLPHIOKEdjKtokqwQp6p4q6n0qljhk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jH5jx3SRrKnzetOcwTkUJjV2QPd5Z6x5EFrNc4/sp6JyiEZzQ8gdRScOGnFrf16r0
	 /R8NBZlG/y9tlDKS+W1bTlvL+VStHY327nlFOt2dIf+QahRZtz2uBK/Bo15ug5JMjG
	 1rS2vQNasqhN2cI+/rvRsYMwkhm7HJjGPN2KmSm4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 107/189] thermal: of: fix OF node leak in of_thermal_zone_find()
Date: Wed, 15 Jan 2025 11:36:43 +0100
Message-ID: <20250115103610.721999496@linuxfoundation.org>
X-Mailer: git-send-email 2.48.0
In-Reply-To: <20250115103606.357764746@linuxfoundation.org>
References: <20250115103606.357764746@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>

[ Upstream commit 9164e0912af206a72ddac4915f7784e470a04ace ]

of_thermal_zone_find() calls of_parse_phandle_with_args(), but does not
release the OF node reference obtained by it.

Add a of_node_put() call when the call is successful.

Fixes: 3fd6d6e2b4e8 ("thermal/of: Rework the thermal device tree initialization")
Signed-off-by: Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>
Link: https://patch.msgid.link/20241224031809.950461-1-joe@pf.is.s.u-tokyo.ac.jp
[ rjw: Changelog edit ]
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/thermal/thermal_of.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/thermal/thermal_of.c b/drivers/thermal/thermal_of.c
index 07e09897165f..5d3d8ce672cd 100644
--- a/drivers/thermal/thermal_of.c
+++ b/drivers/thermal/thermal_of.c
@@ -176,6 +176,7 @@ static struct device_node *of_thermal_zone_find(struct device_node *sensor, int
 				goto out;
 			}
 
+			of_node_put(sensor_specs.np);
 			if ((sensor == sensor_specs.np) && id == (sensor_specs.args_count ?
 								  sensor_specs.args[0] : 0)) {
 				pr_debug("sensor %pOFn id=%d belongs to %pOFn\n", sensor, id, child);
-- 
2.39.5



