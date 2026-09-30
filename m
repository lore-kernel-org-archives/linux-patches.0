Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02D985208C2;
	Wed, 30 Sep 2026 18:44:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790793894; cv=none; b=P7/C3pr6hAQv2fzi+gVTny4nEqVDExu8jt3sBSCRGXoRBUTLZnsDVWtOXw9WKxIsYApEjilvhw+RA/xx3eQcg2w9CG93YX+jMIZxijR4YS0lix04WJDTX1D3BQ3XA3k/JJb/cTE+mxqRAuq+fKvM58qWDFvjtzHbaTe0zCmGPSI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790793894; c=relaxed/simple;
	bh=V+LjpO5EINPU5DSKbqtxFgBhmt5btMVFLKHPqICwh40=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VWBSOydp+8vOWVpDCy4Vopu4Z1r2XNqvJohFddO2zz60PzZN1ic2qO6Fnuyc6sgdUrXLTtDg3a087bxn5fIFKzYpRjwO57+nrAXqIrEwpoY/4FF8u/FQ6rb6LeUX76TRHDNM5ie88tW2Ag/O1jR0z7+Ca314SCnrqyWMIm+STUI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HmTczHmk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HmTczHmk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F5E31F000FF;
	Wed, 30 Sep 2026 18:44:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790793892;
	bh=+/Xb4FRuUr6fmNlrxEUkIk737S7MVQkDXD604OeYYyQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HmTczHmk24U3LMORLROwsdQSfFL64epXSAZM1kDuyq5AiAOz7Dl0RZmCaHZUMb4gI
	 OC2DoBcvr4DNzZhv0nkvS3MDT7BOSsz5F5llDBb4bFLU4RYIdj2FrL//IQRl9p8REQ
	 o21sub73cUcOB9eD3q7p58038wi6jiTtHED0fciU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0020/1193] soundwire: validate DT compatible before parsing it
Date: Wed, 30 Sep 2026 17:11:44 +0200
Message-ID: <20260930152434.746746475@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pengpeng Hou <pengpeng@iscas.ac.cn>

[ Upstream commit 45c7bda7b7440183850012153988e40b300f40d0 ]

`sdw_of_find_slaves()` fetches raw `"compatible"` bytes with
`of_get_property()` and then immediately parses them with
`sscanf("sdw%01x%04hx%04hx%02hhx", ...)`.

Live-tree OF properties are stored as raw bytes plus a separate length;
they are not globally guaranteed to be NUL-terminated. Validate the
first compatible string before parsing it.

Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Link: https://patch.msgid.link/20260403183504.4-soundwire-compatible-pengpeng@iscas.ac.cn
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soundwire/slave.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/soundwire/slave.c b/drivers/soundwire/slave.c
index 0aadfc2010287..9076208bd06e9 100644
--- a/drivers/soundwire/slave.c
+++ b/drivers/soundwire/slave.c
@@ -233,8 +233,8 @@ int sdw_of_find_slaves(struct sdw_bus *bus)
 		struct sdw_slave_id id;
 		const __be32 *addr;
 
-		compat = of_get_property(node, "compatible", NULL);
-		if (!compat)
+		ret = of_property_read_string(node, "compatible", &compat);
+		if (ret)
 			continue;
 
 		ret = sscanf(compat, "sdw%01x%04hx%04hx%02hhx", &sdw_version,
-- 
2.53.0



