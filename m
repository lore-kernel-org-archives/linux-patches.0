Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9226E4ED185;
	Thu, 17 Sep 2026 15:41:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789659667; cv=none; b=Gu3vsOa7GXvy56GJQh2S4G+zAlD6oi36fnff0qcoICzulHYn7V3Ti5TrNxYCcR02bdW8aM88kfuRFgwYCI6wBHC6VVskzkC+r7Ep6RMPCKbmHhogHYVHjsOFOo2QlFGR1qffPfxiZ4ODOysVNdYYn2U9BfyyFEgZrpywHQpGW6E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789659667; c=relaxed/simple;
	bh=TzDVd3wDu70rQaLwAiaOKd4X1Mqa1sxpSOr6OSznVg0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jUh/a8eZvUQjpAcjdpxrUsUVvP0Dnp0LeMgZ41GWvi3sEeaXG9ZMrQNQbTrNorCPybVY+tASTW6ULI++GrU4GF5IFpn6j1tkmHNZqP6gsoY+kRGPjVTtEMTI8unugRkjKQa9Pyb2IRsycJ1uZ/vvLpAp838Y0Slea6/27zlG+2w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LLNR/GV5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LLNR/GV5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C94C11F00899;
	Thu, 17 Sep 2026 15:41:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789659661;
	bh=PJnFg4JMTvrsoKe2WhY8WmW5Hc8+MH0Q57d+vJ0x+WA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LLNR/GV5WV8WoXfzoh3z/spA6/04yO109lbl1QoRdaknPkDqNwwrzIshhSD+V5HFB
	 WOp1CeQHlVr28hjlAE4H6i5w7SCcRIvwHfJ1EwdkgdZd1sIy6K/LSQbol3Whi/bGgS
	 jM15wAN37KMneZNMdl/xNqG7GTkQWn4NC11STKAk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thorsten Blum <thorsten.blum@linux.dev>,
	Sourabh Jain <sourabhjain@linux.ibm.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 292/733] powerpc/kexec_file: Use inclusive range checks for excluded memory
Date: Thu, 17 Sep 2026 16:10:00 +0100
Message-ID: <20260917151358.687855884@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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

From: Thorsten Blum <thorsten.blum@linux.dev>

[ Upstream commit 449f60f99f8f3cbe80a9bd2242945e827c5ed003 ]

arch_check_excluded_range() checks if a kexec segment overlaps an
excluded memory range.

Both ranges use inclusive end addresses, but the overlap check uses
exclusive comparisons. This skips ranges with start == ->ranges[i].end
or end == ->ranges[i].start. Use inclusive comparisons instead.

Fixes: 6e5250eaa665 ("powerpc/crash: use generic APIs to locate memory hole for kdump")
Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
Reviewed-by: Sourabh Jain <sourabhjain@linux.ibm.com>
Signed-off-by: Madhavan Srinivasan <maddy@linux.ibm.com>
Link: https://patch.msgid.link/20260810145827.157972-3-thorsten.blum@linux.dev
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/kexec/file_load_64.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/powerpc/kexec/file_load_64.c b/arch/powerpc/kexec/file_load_64.c
index c2ed0d1c92e75..d990880b77dfd 100644
--- a/arch/powerpc/kexec/file_load_64.c
+++ b/arch/powerpc/kexec/file_load_64.c
@@ -57,7 +57,7 @@ int arch_check_excluded_range(struct kimage *image, unsigned long start,
 
 	emem = image->arch.exclude_ranges;
 	for (i = 0; i < emem->nr_ranges; i++)
-		if (start < emem->ranges[i].end && end > emem->ranges[i].start)
+		if (start <= emem->ranges[i].end && end >= emem->ranges[i].start)
 			return 1;
 
 	return 0;
-- 
2.53.0



