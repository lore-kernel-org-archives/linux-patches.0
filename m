Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6543F547065;
	Thu, 17 Sep 2026 17:12:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789665166; cv=none; b=sMKTZ1Nc3hLOZmUJL9cyioA8tfb09debbC80XQ614itFo0yCekbGBnISLBMpncQQCGA+8FvNZMqmFQG+Belba2w3msZHKioplzic0j+Ur6gKKwI84Win6t1MphiQ4dYMBJMlQPvmlBKOokx9wC4rnHW3Wqm4VWXtRu5z2v3k7VA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789665166; c=relaxed/simple;
	bh=hDfUv+0QOlLIapBwFlgpdXHLadfXKBL3OJyvVYV73ZA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qjt3v2mWDCZYCPMtS0ZTWHNJqJKFq+2g5v6M2hnddNqOdqsoSbGHJv9GBUxqkJKdxznue0RIdrcDXRKY5KpZMxtx570P/1OKzfh9luh9ffM/CF2zxXcYcgFYg8USf+oL7WlOXur+e3Cg+oeQZE/qsESqmcLvDDePfUdX476A2CI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Kct2NGsB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Kct2NGsB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A71951F000FF;
	Thu, 17 Sep 2026 17:12:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789665165;
	bh=Y8U3wLnQFHTk/bNuuEagCbOCWFM92PuO+4GA9dAcARw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Kct2NGsBGtaG+ZEQtsIh2nLFE67tLH2smG/RAoiIx5CnZtaChXxkItVfcbIOe7lj+
	 9mRdBTGdXlOQP8v3alDHAWnKLVw9/3X42ngTTqcvEXRiBEdj2soSKqQ6Zl7Z5eERnb
	 3k33/eYjaoDly652M0kjltyNEHIpJP7wNxdMkMb8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Max Zhen <max.zhen@amd.com>,
	Lizhi Hou <lizhi.hou@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0615/1250] accel/amdxdna: Remove __counted_by from struct amdxdna_cmd_chain
Date: Thu, 17 Sep 2026 16:06:50 +0100
Message-ID: <20260917151608.541840589@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

From: Lizhi Hou <lizhi.hou@amd.com>

[ Upstream commit b3709d354545e70388177500761f92d906c4dfd6 ]

struct amdxdna_cmd_chain contains a flexible array annotated with
__counted_by(command_count). Since the structure is stored in shared
AMDXDNA_BO_SHARE memory, userspace can modify command_count concurrently.
If command_count is changed to zero, the bounds check generated from
__counted_by may fail and trigger a kernel panic.

Remove __counted_by to avoid relying on the userspace-controlled
command_count for the flexible array bounds check.

Fixes: aac243092b70 ("accel/amdxdna: Add command execution")
Reviewed-by: Max Zhen <max.zhen@amd.com>
Signed-off-by: Lizhi Hou <lizhi.hou@amd.com>
Link: https://patch.msgid.link/20260821033543.1839719-1-lizhi.hou@amd.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/accel/amdxdna/amdxdna_ctx.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/accel/amdxdna/amdxdna_ctx.h b/drivers/accel/amdxdna/amdxdna_ctx.h
index 8c1d181df6e79..383f3f15fac8c 100644
--- a/drivers/accel/amdxdna/amdxdna_ctx.h
+++ b/drivers/accel/amdxdna/amdxdna_ctx.h
@@ -51,7 +51,7 @@ struct amdxdna_cmd_chain {
 	u32 submit_index;
 	u32 error_index;
 	u32 reserved[3];
-	u64 data[] __counted_by(command_count);
+	u64 data[];
 };
 
 /* Exec buffer command header format */
-- 
2.53.0



