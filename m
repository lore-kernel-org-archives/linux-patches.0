Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C42C9339866;
	Thu, 28 May 2026 20:43:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780001028; cv=none; b=IAN571TSBEr2ls1LDiQ4TL/653T2xSPRNtV/u8CcPdUgPYoCZjWToiqNmWGGUsbZv0zwRaXR5109kni5oJQD6P6qLq5i/ggZz183DiQCGdjsPZIy7A1Bb8A952O26NnwE/UwKzeb/Gqi8Oistnf7V6ZNAErMhaYpwZXi7nw4Fq4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780001028; c=relaxed/simple;
	bh=J4GwtFbvKLB+Qanq8O7k+8BHNtXgMN/q/40umQDX524=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k4a3twL+s1Kue92BNwbE0uXQBW37tKE/Ixs8sHnWZ+FCk9ilxmVT9FrXVwrwVim1wDrJcLrF3IlPU5w+DKPVcmWsz2BYHPOmqB6iXH3pbr0NvnQp2S3SX29Y5q5ZwinjPlv6jWHt1zJNE6aJawhXs3qUd0gGu5oN5i+tr4eIYzg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MtCrN9H/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MtCrN9H/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD8621F000E9;
	Thu, 28 May 2026 20:43:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780001026;
	bh=9Z/ABK7UoolF4DteHd/x4C7wexjkBevjIS/NE0Puywg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MtCrN9H/N2vGPfbYaubn4IqNt6IRm6brlZSCpoU8DhSilePvAqKW9/VPcNhGx+ruh
	 GG+ypmDAG5pI6frU/oSdmy0tFEmUkePc9SSbOb1zqgeajNcpaqeQy+5cWlo1DJjpbF
	 oCI6UB5fwCyEvioBrXaZ4OvL6Phf8LSg4muHNvjU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Nikhil P. Rao" <nikhil.rao@amd.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 255/272] pds_core: fix error handling in pdsc_devcmd_wait
Date: Thu, 28 May 2026 21:50:29 +0200
Message-ID: <20260528194636.249553464@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194629.379955525@linuxfoundation.org>
References: <20260528194629.379955525@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



