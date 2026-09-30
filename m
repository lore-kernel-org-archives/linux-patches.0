Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63A3C3B2D1A;
	Wed, 30 Sep 2026 19:32:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790796750; cv=none; b=b/POwdkEULsAVWp4QkHhxuizuwkUgpYh0XxhMYim+V05B0L5ikpF0nl8ZJw2Lw7wySCfPo8arXYbRhkD719TA1UFApNWtKrE7bWhXBd9n3j3AXKiNWsMEPOMTI4eExn6WD/Jcmwpeva6Y98/lqdRN2kE8Wb3wVxkxM1T9IDc9B4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790796750; c=relaxed/simple;
	bh=QtQefKnq9hv50gPL7O/xLVrFcrA9Zv34AaLyF21s9Ig=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MqGPT2OVeP6eN95NkM9yCF71qgQSQxRyMSIRpAn9yT9J04FqUM9tqtzcEDZb6S9DB4vnILFH/kE7CodcvryZCPfEtxpMBpJyXTLrHBG24L3Mrw/D5VosJBL3LctEEqMK6M4JYkNyo7G0lEwnbB86hVijwQSNZt0LtUO1gRP9yBg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gqgSscLW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gqgSscLW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEC521F000FF;
	Wed, 30 Sep 2026 19:32:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790796749;
	bh=nhEjAt+bDzzAJL8cCjQD8WF+7FsxWrnkhZ2RkxK0zdU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gqgSscLWnBl/zxait6mpLAbLnDLFbzWV1xm9a0wsqB1BW+nL/jFtCkdPk2BgRlubN
	 peVLoxMhTUoxBwS/MVk/RQQT1fsClFkKTXDRw08USbFXQer0iEZXN4qcZ37wZ8jLnv
	 cjIM5lTp/udlvk+5lMbXhhs/FX0i6Hs5Lq6ARuH8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikhail Zaslonko <zaslonko@linux.ibm.com>,
	Peter Oberparleiter <oberpar@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1023/1193] s390/debug: Fix NULL pointer dereference in debug_info_copy()
Date: Wed, 30 Sep 2026 17:28:27 +0200
Message-ID: <20260930152456.963980324@linuxfoundation.org>
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

From: Mikhail Zaslonko <zaslonko@linux.ibm.com>

[ Upstream commit 012bfcd5a51082d5a65f096dfb9ca652b5267965 ]

When debug_register_static() fails, it clears areas, active_pages and
active_entries but leaves the area bounds unchanged. Copying such an
area, either by opening its view file or via debug_dump(), makes
debug_info_copy() dereference the NULL pointers.

Skip the copy loop when the source has no areas.

Closes: https://lore.kernel.org/r/20260903132123.12F271F00A3F@smtp.kernel.org
Fixes: d72541f94512 ("s390/debug: add early tracing support")
Signed-off-by: Mikhail Zaslonko <zaslonko@linux.ibm.com>
Reviewed-by: Peter Oberparleiter <oberpar@linux.ibm.com>
Acked-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/kernel/debug.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/s390/kernel/debug.c b/arch/s390/kernel/debug.c
index 8d939453e4021..3f6a78e45c29f 100644
--- a/arch/s390/kernel/debug.c
+++ b/arch/s390/kernel/debug.c
@@ -345,7 +345,8 @@ static debug_info_t *debug_info_copy(debug_info_t *in, int mode)
 		debug_info_free(rc);
 	} while (1);
 
-	if (mode == NO_AREAS)
+	/* debug_register_static() failure leaves areas NULL, bounds intact */
+	if (mode == NO_AREAS || !in->areas)
 		goto out;
 
 	for (i = 0; i < in->nr_areas; i++) {
-- 
2.53.0



