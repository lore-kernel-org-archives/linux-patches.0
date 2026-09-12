Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6641F3F9F47;
	Sat, 12 Sep 2026 10:04:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789207457; cv=none; b=ToCfYqnjchTRM3myiqSq1yjBrM1Fz3sY6UBGeWfKgdED42gB6TxruTbtfapF/HMnKtb50H2aXfqL9FCGGxU4Ldh30hQ6dl6olzMNnr9KMTG7W18qFfx/p/5EX7wWts7LyBNjvC5mMfogSj4gKCJSpFyiaZSg2NUz0Z9dm5Uh+WA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789207457; c=relaxed/simple;
	bh=WuBhz0RyrDIG/pS+meYZmiBuJrCMtmfn6QW93I95bm4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GccV7iSbwwW3Bi1aqmkFCgLq5J2CKhYrALZhDpSp5NyWqyojI8X9Yo9Rd7iJIQhULFsabMlXwz4LX735ELzKlqfvyua7fgGAzpIQY8OX6YizSJ0buD7SnMmibBpax6KBL5uRKZG/cHDpA3sNr6MSJ10QTmTkGENdAr0aDSv3Uj4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=y9HovUKs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="y9HovUKs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9E121F000FF;
	Sat, 12 Sep 2026 10:04:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789207454;
	bh=NkfCyz4WTEa4mzW97cNjHBqiyUcYZeMCJT03mI75GFM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=y9HovUKsRuPOnJVCPdHNrSB+SrjRki2Ja4+gIMI+QvMr6c5fXgGR6X0dcLXGVHNHm
	 AgE18prUpbDJdwP5Pqk/ay2N41nZjZHvmDw2CjyGiyYgmCf7SyBJk2kS60zRcSB/wg
	 CTL1RhGHr4DO8/tYPfrRtug6P0aLtzvUNNNt8ZBQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alison Schofield <alison.schofield@intel.com>,
	Li Ming <ming.li@zohomail.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0373/1518] cxl/port: Restart port enumeration when a sibling adds the dport first
Date: Sat, 12 Sep 2026 08:42:22 +0200
Message-ID: <20260912065631.905382369@linuxfoundation.org>
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

From: Alison Schofield <alison.schofield@intel.com>

[ Upstream commit a623128bc2a1c257cbad97d0582f355fbe7be927 ]

Endpoint probes can race while enumerating a shared switch. If a
sibling probe adds the dport first, the losing probe finds the dport
already present, gets -EBUSY, and fails to enumerate the endpoint.

Treat this race the same as the existing port-created case by
restarting the port walk, allowing it to find the existing dport
and continue enumeration.

This race was discovered while testing a cxl_test mixed-granularity
topology, where twelve endpoints behind shared switches are probed in
parallel during module load.

Fixes: 4f06d81e7c6a ("cxl: Defer dport allocation for switch ports")
Signed-off-by: Alison Schofield <alison.schofield@intel.com>
Tested-by: Li Ming <ming.li@zohomail.com>
Reviewed-by: Li Ming <ming.li@zohomail.com>
Link: https://patch.msgid.link/20260714020438.1822669-1-alison.schofield@intel.com
Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cxl/core/port.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/cxl/core/port.c b/drivers/cxl/core/port.c
index c53a13d4f1662..2b9e166ea4e0e 100644
--- a/drivers/cxl/core/port.c
+++ b/drivers/cxl/core/port.c
@@ -1732,8 +1732,8 @@ static int add_port_attach_ep(struct cxl_memdev *cxlmd,
 					     parent_dport, uport_dev,
 					     dport_dev);
 		if (IS_ERR(dport)) {
-			/* Port already exists, restart iteration */
-			if (PTR_ERR(dport) == -EAGAIN)
+			/* Port or dport already exists, restart iteration */
+			if (PTR_ERR(dport) == -EAGAIN || PTR_ERR(dport) == -EBUSY)
 				return 0;
 			return PTR_ERR(dport);
 		}
-- 
2.53.0



