Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAE95353EF7;
	Sat, 12 Sep 2026 10:11:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789207897; cv=none; b=Xt6ODrsSycc1yEf2PKhJFRu1fcFbIv1ORvEcKdQKbngafxDHRkUUdB4skq2Z7UOBLa6FFo5ukkeJvrJJocNHkyPSMnSyIHrJ2YKOYiDbF6xvmmnfEkAqHE7V6P5V38JUJZWtQHPOqq696Kb5OzY6LsJvuisuCap/8UgqryRs254=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789207897; c=relaxed/simple;
	bh=a4NVhnnmbsNdGNeyGNrlCO+j2K0N3n4ISArWPwvldVk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jwU6AnasqDqSiQObyKAv5woSmv6YQVmiB/LDJNDixQ3TcydAFsmem5oC0TuT01Y2rNgF0z2oXKJALkPE5LQAOtRl4aHsDQ75Oe6NKFOKe8wv/Y41GEQQ3Ydkd69XChS76wUPRy2JgtBcicphpMB2jtAvZBf87hnDtiJslO/n07k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yZ9hhqn2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yZ9hhqn2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9DA01F000FF;
	Sat, 12 Sep 2026 10:11:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789207896;
	bh=XejnUUt5zKcjEitXKWriLxHVT5Q7fT1d1yBLhRkC8S4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yZ9hhqn202yYl3Ej7ezMf4jvhdQmwMb14dLo5c9EBdfbWLyLs4CbYq6Qy+v+DGpXC
	 E5OJ/wN2E+2hWNSffcPrxJzCTUjQnNZruON1Y9jFSZo58rB5OIG6Shs1+qTei5hv3b
	 zzqmENJX1apKkYHOfWMwEHdUdpvAkn3x/O1jTa9M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Raag Jadav <raag.jadav@intel.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0464/1518] mtd: intel-dg: Fix runtime PM error path in probe
Date: Sat, 12 Sep 2026 08:43:53 +0200
Message-ID: <20260912065633.944021198@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guangshuo Li <lgs201920130244@gmail.com>

[ Upstream commit df6f582df3377af316a60ca8ee0d590b2d03924d ]

intel_dg_mtd_probe() allocates region names before enabling runtime PM
and before calling pm_runtime_resume_and_get().

If kasprintf() fails while building a region name, the error path jumps
to err, which calls pm_runtime_put(). At that point there has not been a
successful pm_runtime_resume_and_get() call to balance, so the runtime PM
usage count can underflow.

Jump to err_norpm from the kasprintf() failure path, as the runtime PM
reference has not been acquired yet.

Fixes: 779c59274d03 ("mtd: intel-dg: Fix accessing regions before setting nregions")
Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
Reviewed-by: Raag Jadav <raag.jadav@intel.com>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/devices/mtd_intel_dg.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mtd/devices/mtd_intel_dg.c b/drivers/mtd/devices/mtd_intel_dg.c
index 7f751c48a76d4..c9855d6f1f95e 100644
--- a/drivers/mtd/devices/mtd_intel_dg.c
+++ b/drivers/mtd/devices/mtd_intel_dg.c
@@ -780,7 +780,7 @@ static int intel_dg_mtd_probe(struct auxiliary_device *aux_dev,
 				       dev_name(&aux_dev->dev), invm->regions[i].name);
 		if (!name) {
 			ret = -ENOMEM;
-			goto err;
+			goto err_norpm;
 		}
 
 		nvm->regions[n].name = name;
-- 
2.53.0



