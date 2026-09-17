Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EB763E40F5;
	Thu, 17 Sep 2026 17:22:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789665751; cv=none; b=ROyDwdS9QpXBzRjNHRDbqcRtZKqbNmF9gAQni+OiTWi1k4IRkoWeAkM4PuJHC6j9ennS1qcFZFVlAGxwBvUeLmOeEE/SHiCp+kpZNI4K8wHLQu500kKV79fRRtixFmwTpDCopGR74y6DcRzz2ViL47wTa8bO1uxClke1vtdSCpw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789665751; c=relaxed/simple;
	bh=jfZMcG/JAbB1r9Yo3YwHprOhuFup8RH24uJeto7L4A8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CGns0h9BTCgmib6DuI8PEY/O2BPcVhGxmv5533pK5H8X3hyNHmjMLw3gbBL6O3E5OupOqBsqU0YIH1ncAM97WVjp4GwKxdDU8Yx0haUff2KVHLKXbcsZS0j9t6WhF66MMfwKAHlzPsskm1rEpKWmKixYkY1imUcLokhs59o1A9o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YhmubZZf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YhmubZZf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA99F1F000FF;
	Thu, 17 Sep 2026 17:22:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789665750;
	bh=ePxmcsq16/bFj+HPRxPAuykJyv39adzNderJ7w6js1k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YhmubZZf1zCrS+T9JM3+C4jhEcdQDon7XxC45c41MOAIsdr+1/wq+o4HSfUNfsx6n
	 ctd+a5lxkDVLabUTteEGvRjhM4K15YHdCpapmEDqD2cWr4nSJLJvNP1vroeuq6JeOP
	 kskCFJYOTTfCrlVzucPoVSHI3ZGGZBPXufFK9quU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thorsten Blum <thorsten.blum@linux.dev>,
	Sourabh Jain <sourabhjain@linux.ibm.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0807/1250] powerpc/kexec_file: Use inclusive range checks in add_usable_mem()
Date: Thu, 17 Sep 2026 16:10:02 +0100
Message-ID: <20260917151613.787494541@linuxfoundation.org>
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

From: Thorsten Blum <thorsten.blum@linux.dev>

[ Upstream commit c6755be4838d6ccd641effbcdc3d917b82631ff9 ]

add_usable_mem() adds usable memory ranges for the kdump kernel.

The ranges are inclusive, but the partial overlap check uses exclusive
comparisons. This skips ranges with base == loc_end or end == loc_base.
Use inclusive comparisons instead.

Fixes: 7c64e21a1c5a ("powerpc/kexec_file: Restrict memory usage of kdump kernel")
Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
Reviewed-by: Sourabh Jain <sourabhjain@linux.ibm.com>
Signed-off-by: Madhavan Srinivasan <maddy@linux.ibm.com>
Link: https://patch.msgid.link/20260809162403.18142-2-thorsten.blum@linux.dev
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/kexec/file_load_64.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/powerpc/kexec/file_load_64.c b/arch/powerpc/kexec/file_load_64.c
index 6075b1c88511a..c2ed0d1c92e75 100644
--- a/arch/powerpc/kexec/file_load_64.c
+++ b/arch/powerpc/kexec/file_load_64.c
@@ -113,7 +113,7 @@ static int add_usable_mem(struct umem_info *um_info, u64 base, u64 end)
 		loc_end = um_info->ranges[i].end;
 		if (loc_base >= base && loc_end <= end)
 			add = true;
-		else if (base < loc_end && end > loc_base) {
+		else if (base <= loc_end && end >= loc_base) {
 			if (loc_base < base)
 				loc_base = base;
 			if (loc_end > end)
-- 
2.53.0



