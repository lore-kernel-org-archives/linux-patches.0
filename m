Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61E5A2F5E;
	Tue, 12 Aug 2025 18:12:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755022353; cv=none; b=qyVZ2jleiIQQrpSpYRZGSIutXKnQfgdgIYbtyTWab7w5LUi1cqiyGX69PjqlbPzrRqHbDyPwHXsIyCdcUu4gRBS8wS+yjuNzx+/BStiSKvyzDuUtAQpQTPF5wuogezlq8DViyw5K3HbNCuCbOJUqZvMJIQ/nAdieDnKPUsS6QlU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755022353; c=relaxed/simple;
	bh=3ic3//5g2T+c33Ub3RG1J4wOfemVQ6SefDS+4iq2HAU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Evek1E5rX576CdTtFHM3trsr1loXNvIQiPxPy374LIfd52AY58tTEzySz2+J1vuchHu7zB1Ox8hT4mAY418ejuv90ikLVU/iam3z4GFtTCT0QbD5Vf36r4MNl0+m06iAuHvaOvguEIwpu8FJ+SRA4SIXxZYTyN5omKHNVi8/LyA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=q2cgDnvu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="q2cgDnvu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 860E3C4CEF0;
	Tue, 12 Aug 2025 18:12:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755022353;
	bh=3ic3//5g2T+c33Ub3RG1J4wOfemVQ6SefDS+4iq2HAU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=q2cgDnvuXKjZjhLD4+rqHqdcHi5XPORK2sJIrBgysVdNV1IruNvFG7O22AfDRlU1r
	 MetWWnGKebCFEJApiagObF8+s2i+Z4ZFJGZDsR2N+sOxu8P2Fx5b4aAGrYa7AvFyvP
	 be+oVjmGLOyKAdzfLpYJDQ1c3XtYrDe/pC8OWuxo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Harry Yoo <harry.yoo@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 130/369] memcg_slabinfo: Fix use of PG_slab
Date: Tue, 12 Aug 2025 19:27:07 +0200
Message-ID: <20250812173019.663118965@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173014.736537091@linuxfoundation.org>
References: <20250812173014.736537091@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Matthew Wilcox (Oracle) <willy@infradead.org>

[ Upstream commit 7f770e94d7936e8e35d4b4d5fa4618301b03ea33 ]

Check PGTY_slab instead of PG_slab.

Fixes: 4ffca5a96678 (mm: support only one page_type per page)
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Tested-by: Roman Gushchin <roman.gushchin@linux.dev>
Reviewed-by: Roman Gushchin <roman.gushchin@linux.dev>
Reviewed-by: Harry Yoo <harry.yoo@oracle.com>
Link: https://patch.msgid.link/20250611155916.2579160-11-willy@infradead.org
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/cgroup/memcg_slabinfo.py | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/cgroup/memcg_slabinfo.py b/tools/cgroup/memcg_slabinfo.py
index 270c28a0d098..6bf4bde77903 100644
--- a/tools/cgroup/memcg_slabinfo.py
+++ b/tools/cgroup/memcg_slabinfo.py
@@ -146,11 +146,11 @@ def detect_kernel_config():
 
 
 def for_each_slab(prog):
-    PGSlab = ~prog.constant('PG_slab')
+    slabtype = prog.constant('PGTY_slab')
 
     for page in for_each_page(prog):
         try:
-            if page.page_type.value_() == PGSlab:
+            if (page.page_type.value_() >> 24) == slabtype:
                 yield cast('struct slab *', page)
         except FaultError:
             pass
-- 
2.39.5



