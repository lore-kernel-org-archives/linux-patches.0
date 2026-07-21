Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FD9046D567;
	Tue, 21 Jul 2026 15:54:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784649251; cv=none; b=WNZU/TAfS7lC5Y96aI57EvdUKqWR03206Kf4oWcBcp4/ID1vJL0zJGgVbuxPQMGxLsW3Ca7PNzhle+l5jHx2GnnMspRB5HkI5TTZV7VwHH8ZUMA+nbtD0XpDExHBs3qQ2exzvkDkFt7cnUUek+s58xq6aP1dXXBmuFeo3JLIV7A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784649251; c=relaxed/simple;
	bh=XQNO9Qwbwno9DCS68aoGJj/p5/p/jpA/uk7jenXZ2f4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u5fH5z0guDEwyHgVdxgVExXGLUTV1X4DRn692LL6Wzye2zPokoS2HFiEJvSL2CWJ+TAThUnHXognXnys4yZ3OgViDiRw4kMBQg3Uujxxuf9ysiLmpFMH9u2FaKbFjIEl6FL+EGTlRjpCGCRkOLbWnBOobAgGYfaKP+CTdE40MwM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cTT3YYwF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cTT3YYwF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 754C41F00A3A;
	Tue, 21 Jul 2026 15:54:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784649250;
	bh=towMZ+gCzle43pIAPYnUztzK0gXLwz6aOk5fCJET+Y0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cTT3YYwFb5aYwJbre7PRE2RQpohJwMm7LN6sILqWy4sobjaehAG1zK93PEtMErK5K
	 HBfofPe5Yyl4ABZZKrgTKGWVtgtU1O+xZKwcDIeodYygewwXsqSY7x/58L2pw7hWV0
	 9vUNxVrJAWO7rW8Dk0Tc1aWJZcf5nLHyqdPXWuxw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Mario Limonciello (AMD)" <superm1@kernel.org>,
	Lizhi Hou <lizhi.hou@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0454/2077] accel/amdxdna: Return errors for failed debug BO commands
Date: Tue, 21 Jul 2026 17:02:07 +0200
Message-ID: <20260721152603.493361942@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lizhi Hou <lizhi.hou@amd.com>

[ Upstream commit 62c1671f6454ceaa80e9ceff63f821aa36f35154 ]

The config and sync debug BO commands currently may report success even
when the operation fails.

Capture the firmware return status and propagate the corresponding error
to userspace.

Fixes: 7ea046838021 ("accel/amdxdna: Support firmware debug buffer")
Reviewed-by: Mario Limonciello (AMD) <superm1@kernel.org>
Signed-off-by: Lizhi Hou <lizhi.hou@amd.com>
Link: https://patch.msgid.link/20260529162122.1976376-1-lizhi.hou@amd.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/accel/amdxdna/aie2_ctx.c | 13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

diff --git a/drivers/accel/amdxdna/aie2_ctx.c b/drivers/accel/amdxdna/aie2_ctx.c
index d719000c453252..93535806e72a1b 100644
--- a/drivers/accel/amdxdna/aie2_ctx.c
+++ b/drivers/accel/amdxdna/aie2_ctx.c
@@ -270,17 +270,13 @@ aie2_sched_drvcmd_resp_handler(void *handle, void __iomem *data, size_t size)
 	struct amdxdna_sched_job *job = handle;
 	int ret = 0;
 
-	if (unlikely(!data))
-		goto out;
-
-	if (unlikely(size != sizeof(u32))) {
+	if (unlikely(!data || size != sizeof(u32))) {
+		job->drv_cmd->result = U32_MAX;
 		ret = -EINVAL;
-		goto out;
+	} else {
+		job->drv_cmd->result = readl(data);
 	}
 
-	job->drv_cmd->result = readl(data);
-
-out:
 	aie2_sched_notify(job);
 	return ret;
 }
@@ -894,6 +890,7 @@ static int aie2_hwctx_cfg_debug_bo(struct amdxdna_hwctx *hwctx, u32 bo_hdl,
 	aie2_cmd_wait(hwctx, seq);
 	if (cmd.result) {
 		XDNA_ERR(xdna, "Response failure 0x%x", cmd.result);
+		ret = -EINVAL;
 		goto put_obj;
 	}
 
-- 
2.53.0



