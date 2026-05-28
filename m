Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CB3E321F5F;
	Thu, 28 May 2026 20:30:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780000219; cv=none; b=BTEbtxKpxkfMqopzxtJTOIsG75SK9LFST8F01+SV+SI0aLEJ9Pc2OHrpZY/IcIYonNbUwBCX1lqGnyLu9lSERp10Nt579Z3EWdkVmRjP1UXUOuOheiA9lyvTzs+tJVqL9mCJz603qC7eUTYY59JgFZs67C5uZ97h+dDXWRx35iA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780000219; c=relaxed/simple;
	bh=5J1Vsbq80Kxz/AoqsDsZt2Wq7IViNLBWcCGqcNTjobc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CnNvQneF2AipTlYo0dM0gWpoqQU586eQMKUUrUU/TfrxA1DU4ys5jrtkKpRtzxdi9180T6ZR3LXxc7jo9h+YqjJLwq7WgvpdIfui8gHTosteREVMJuHK2uTKwPW5wEVD70PHzFK4N2eZtyGim4jL06uG7Rk91Z0nKrgyIpFKtZQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=q279wgc8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="q279wgc8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE30B1F000E9;
	Thu, 28 May 2026 20:30:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780000218;
	bh=Ov4jEqgykkVYmezb/i4dmAYlZJihWyYJwXtTFxJ97Sc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=q279wgc8RK0r3CiMP0k6VmW+Tykv+dYvv2cycuTZ0Pno043GKYAGvHqe0or6LtBcr
	 UFEq7+Nvzy0WjF1VOdATkYoEmCLJxHBY4OebrTMjFlNEfZ+0aqQl1r+4SvZuizexIs
	 689g6MpTBUItbH2kb6fGLG/D1vtD0zEfveI9V0FU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Nikhil P. Rao" <nikhil.rao@amd.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 343/377] pds_core: fix error handling in pdsc_devcmd_wait
Date: Thu, 28 May 2026 21:49:41 +0200
Message-ID: <20260528194648.352550026@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194638.371537336@linuxfoundation.org>
References: <20260528194638.371537336@linuxfoundation.org>
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

From: Nikhil P. Rao <nikhil.rao@amd.com>

[ Upstream commit 0e46b6635b03d29807f810c3b415c4755a3f958d ]

Fix two cases where pdsc_devcmd_wait() returns stale success from
the completion register instead of an error:

1. FW crash: If firmware stops running, the wait loop breaks early with
   running=false. The condition "if ((!done || timeout) && running)" is
   false, so error handling is bypassed and stale status is returned.
   Check !running first and return -ENXIO.

2. Timeout: If a command times out, err is set to -ETIMEDOUT but then
   overwritten by pdsc_err_to_errno(status) which reads stale status.
   Return -ETIMEDOUT immediately after cleaning up.

Both errors now propagate to pdsc_devcmd_locked() which queues
health_work for recovery.

Fixes: 45d76f492938 ("pds_core: set up device and adminq")
Signed-off-by: Nikhil P. Rao <nikhil.rao@amd.com>
Link: https://patch.msgid.link/20260515212907.998028-1-nikhil.rao@amd.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/amd/pds_core/dev.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/amd/pds_core/dev.c b/drivers/net/ethernet/amd/pds_core/dev.c
index 495ef4ef8c103..1d1e559bd99d3 100644
--- a/drivers/net/ethernet/amd/pds_core/dev.c
+++ b/drivers/net/ethernet/amd/pds_core/dev.c
@@ -162,12 +162,19 @@ static int pdsc_devcmd_wait(struct pdsc *pdsc, u8 opcode, int max_seconds)
 		dev_dbg(dev, "DEVCMD %d %s after %ld secs\n",
 			opcode, pdsc_devcmd_str(opcode), duration / HZ);
 
-	if ((!done || timeout) && running) {
+	if (!running) {
+		dev_err(dev, "DEVCMD %d %s fw not running\n",
+			opcode, pdsc_devcmd_str(opcode));
+		pdsc_devcmd_clean(pdsc);
+		return -ENXIO;
+	}
+
+	if (!done || timeout) {
 		dev_err(dev, "DEVCMD %d %s timeout, done %d timeout %d max_seconds=%d\n",
 			opcode, pdsc_devcmd_str(opcode), done, timeout,
 			max_seconds);
-		err = -ETIMEDOUT;
 		pdsc_devcmd_clean(pdsc);
+		return -ETIMEDOUT;
 	}
 
 	status = pdsc_devcmd_status(pdsc);
-- 
2.53.0



