Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC08651AEF2;
	Wed, 30 Sep 2026 17:26:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790789179; cv=none; b=Rfu6bWy2n/715RZirNA8GGRZJcm7C836eZO0xhETDaaoyITdo+9bYjySI2epwmV3eejFLAXBU+2RQIa7tGUpgiFszFtPJTsxBffIrZVRWTtVCS7/mf2CzXZ1+nPh6o9HjJpGTyeMuKIZnRmqlFbl6XTOqASwgJNJlLlz7cgq6/o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790789179; c=relaxed/simple;
	bh=L6AgfMk5syly2QN6xPBp7nz6OeUI5wLPwJFPHT59hns=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OF+BR8rvAWUkF75C0hTkL1CGC8daAxrNkR3fYB4QQEJUm6jpl9S/v6mAQFxaI0/iCx2/OEHUU1W+6MmtRhhyNstFiJoeYSbFfAuSZnGCIg6eOq4xGs49ANi6Jr/D+GyxFovPlchXZw85LSGiqAkFC07USL6kbXZy4HP5ozdVjTE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0FgFxap9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0FgFxap9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 323121F000FF;
	Wed, 30 Sep 2026 17:26:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790789178;
	bh=84rCoI9N0eUzuChghPoXAyNPkYakNCN0ZXC54WXOSlo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0FgFxap9ysBpmA9DpUElfQMscCpfv26F9Ru50hNtzw2N8jR5L5UBTGHdG8GQpv2vG
	 ffSS7QmmAiGUIQXeTZXPLBvue77aU7RRWThnF68YXALEF+n7qrR78u/YbqhPsf3ODY
	 C7YqSeu8nfiBm+Kg/xy2jsH/ARxeJtp6Wsmem9EM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikhail Zaslonko <zaslonko@linux.ibm.com>,
	Peter Oberparleiter <oberpar@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 385/877] s390/debug: Fix NULL pointer dereference in debug_info_copy()
Date: Wed, 30 Sep 2026 17:21:36 +0200
Message-ID: <20260930152422.989434360@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
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
index 9becc37529447..3aaab76f43d9b 100644
--- a/arch/s390/kernel/debug.c
+++ b/arch/s390/kernel/debug.c
@@ -344,7 +344,8 @@ static debug_info_t *debug_info_copy(debug_info_t *in, int mode)
 		debug_info_free(rc);
 	} while (1);
 
-	if (mode == NO_AREAS)
+	/* debug_register_static() failure leaves areas NULL, bounds intact */
+	if (mode == NO_AREAS || !in->areas)
 		goto out;
 
 	for (i = 0; i < in->nr_areas; i++) {
-- 
2.53.0



