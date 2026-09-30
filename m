Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74DCE3D45CF;
	Wed, 30 Sep 2026 19:07:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790795263; cv=none; b=HBqRZaG5V9tZ8Z0qJoHxUJDWzC6yXHQz8A7SaCstacePl3ABDNqktFmeWBjAtwpI+In4TxxheccPV413PckS9XT0arSJG7ff4ueyhBZXlJFRjAlE9NZqS2VjJRQc0WpGVuVkjA4Axzzu++qnRxIZ1Zc/8fggBoau0C2mCP8BCZE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790795263; c=relaxed/simple;
	bh=8m5doOrlSOTfpluhcTL4kJrOGso5dqV+/UhUxiDiCs4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OLXH1fKgQzmXVE2Z864kjnxv0bp56xcXslkXFGbY1NI+X0Ayl0tjSBJJMTl/njddUjZSQ4ASAQjyv4EtPSuIQ9ZsZ36orQrw7g+BtcfgcLNPHyptPo+NvJcdoStzJUyadn1JTInm3Z8bKTh4EZK2E7i+wZlLx25qB/itVFOGuc0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WwUtlciR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WwUtlciR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D08331F000FF;
	Wed, 30 Sep 2026 19:07:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790795262;
	bh=MwaLM4a5MIErwgu2IkSF6+uSo9TNZhaoKQ7fRfzLz0k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WwUtlciRcDUQnaL1YnqP1uhfH3SJzBtHBjkJBq7F+zPjbl3e1nAejELZBPy8jzcUQ
	 Lh2x7z+mDC+vd31q6X36yKBHwqJI/lDSh4M+/DMfud0B/aSuFOEdTZWDp8pbeXDpzm
	 h3E80oVilVfdgb5nhgZP/GvnMxAGxC76Vc0FkHzs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thorsten Blum <thorsten.blum@linux.dev>,
	Sourabh Jain <sourabhjain@linux.ibm.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0499/1193] powerpc/kexec_file: Use inclusive range checks in add_usable_mem()
Date: Wed, 30 Sep 2026 17:19:43 +0200
Message-ID: <20260930152445.241148157@linuxfoundation.org>
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
index 12cbfc9fce451..a0972debb875a 100644
--- a/arch/powerpc/kexec/file_load_64.c
+++ b/arch/powerpc/kexec/file_load_64.c
@@ -483,7 +483,7 @@ static int add_usable_mem(struct umem_info *um_info, u64 base, u64 end)
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



