Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B009A160783;
	Mon, 27 May 2024 19:15:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716837323; cv=none; b=Gf5mHjQv37D9GY3FxltwwpcQGA+UXcQZLH5RGrUq0QU2mTZfRmWs50E1N8NOBp2FJA4JmSVk5b+2FZ/d4Q+F1Wkvnp3Z5YHLEF7mxFrw21J/ILPQJYGAJGx2ibVGcNOpkZW4Iytpi1SApT8i4VhkPuZRyJFgdOm4B0pWD7jiWiA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716837323; c=relaxed/simple;
	bh=Jo1V8WmUB5dNWmR2qabwCXi2YSIdP2On1Vw2oHqQYTs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OW1ET/0iKCKIi57Csc/Pgont6dVmyXBvKpbmX1G3ldj8KVBBhaixCwtFyGYhne3zd5Y2ZEi1gwZw3l3hQvE7PU1gs6ByO2yEwvu4FA+gupC+MVuP/7CK9ydaDo2jsBfLWbE7F0u6WoK0fRhtjc9HTLYPP/KcIM3PDQShn7QRkVE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HTkG0k2e; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HTkG0k2e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27AF3C2BBFC;
	Mon, 27 May 2024 19:15:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716837323;
	bh=Jo1V8WmUB5dNWmR2qabwCXi2YSIdP2On1Vw2oHqQYTs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HTkG0k2ebnNgcTxca3sskKwd4k3O+sOjzzhzvEe/ZZRgrxMv+uCoe1caW1Qm6PSfy
	 i58Yf8GYvgZ4j7/RgPKoCOhakYiKaBBrrkBvULejKpd+7Yukip3xR3E5UUyQKprnPR
	 NFbT15jXKsfkBHtKoC6HzOppwTzOnMcQaaHJaLmU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Alison Schofield <alison.schofield@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 395/427] dax/bus.c: use the right locking mode (read vs write) in size_show
Date: Mon, 27 May 2024 20:57:22 +0200
Message-ID: <20240527185634.941981460@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185601.713589927@linuxfoundation.org>
References: <20240527185601.713589927@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vishal Verma <vishal.l.verma@intel.com>

[ Upstream commit 2acf04532d6d655d8c3b2ee4ddeb320107043086 ]

In size_show(), the dax_dev_rwsem only needs a read lock, but was
acquiring a write lock.  Change it to down_read_interruptible() so it
doesn't unnecessarily hold a write lock.

Link: https://lkml.kernel.org/r/20240430-vv-dax_abi_fixes-v3-4-e3dcd755774c@intel.com
Fixes: c05ae9d85b47 ("dax/bus.c: replace driver-core lock usage by a local rwsem")
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
Reviewed-by: Dan Williams <dan.j.williams@intel.com>
Cc: Alison Schofield <alison.schofield@intel.com>
Cc: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dax/bus.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/dax/bus.c b/drivers/dax/bus.c
index 0011a6e6a8f2a..f24b67c64d5ec 100644
--- a/drivers/dax/bus.c
+++ b/drivers/dax/bus.c
@@ -937,11 +937,11 @@ static ssize_t size_show(struct device *dev,
 	unsigned long long size;
 	int rc;
 
-	rc = down_write_killable(&dax_dev_rwsem);
+	rc = down_read_interruptible(&dax_dev_rwsem);
 	if (rc)
 		return rc;
 	size = dev_dax_size(dev_dax);
-	up_write(&dax_dev_rwsem);
+	up_read(&dax_dev_rwsem);
 
 	return sysfs_emit(buf, "%llu\n", size);
 }
-- 
2.43.0



