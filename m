Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26BD72E718B;
	Sat, 12 Sep 2026 07:34:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789198466; cv=none; b=PYpAdQIPWhDK9iWU8YZ5y3wrNIEp9tEtX+Wqn2vcdSDHx4rF3Ks8MsB1AkkhfSIaNbabhG+qc7eJB3qeUF/mahzDVLIWdYcShjAp3B/5/ecdwNb0fyEwiKI0C8n3dB8m7eDaKzerEVOX6v5Yq+QradYXTLmKo9JQWt4SKN3WhW8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789198466; c=relaxed/simple;
	bh=2rKcnypfIXdZ2s6fouesuYKrh5OfvYDHZMxO/ngk7Ug=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RDQUWvf0bIOdDU7oJ5JsBZf+9QgXpDvo4ruqolZHM0lNLQOyCVibpynKqBOFSV4SUhiUPFTBs/QFoffsWX3D0G90DMxrbSny0Yx8HUE9iKT+UdATnXNUM0HtGUzHxekbwOrXAuxxYtVkHgDmSfz9IltY34A7A5m6yL6C90ZK94Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QpktGAyo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QpktGAyo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3CBF1F000FF;
	Sat, 12 Sep 2026 07:34:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789198465;
	bh=3N/bo0NI4NzAV6IKCYHT9w+Fhn41HMVxWO+hb6LpAx0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QpktGAyo0hnDA4LJoXFTErU5WtAnIJYbVqLdfGqD6pr/FBrhwaSOagG1fotBashlJ
	 vy0p0EYzanS+1H1VYeQNv2V++CFNVd/v5wM0Tz3VewTteavPpXEtgJVpTxCLrzzPZG
	 XijxcZKvNjxiQnfWBf3X8x81kMRt02yOIYkx6/A8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alison Schofield <alison.schofield@intel.com>,
	Li Ming <ming.li@zohomail.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0386/1815] cxl/port: Restart port enumeration when a sibling adds the dport first
Date: Sat, 12 Sep 2026 08:35:36 +0200
Message-ID: <20260912065657.955754724@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index 1215ee4f40351..65f2d2f1eb003 100644
--- a/drivers/cxl/core/port.c
+++ b/drivers/cxl/core/port.c
@@ -1749,8 +1749,8 @@ static int add_port_attach_ep(struct cxl_memdev *cxlmd,
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



