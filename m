Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 371746BB5B;
	Tue, 12 Aug 2025 18:40:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755024013; cv=none; b=HW4qlBC0KsdZxsrSlh4IZKk4JtoZheB4lobH6bd/EzJI3N670I14xmGQvKDqva6qLsjk3gYI3//h+vsMEI/OLYVqqwNRoPjAcK5jubPURgzmvi+zRMXgqnh5hg6FUWJF1LJ7wjGyStZy2/nOpnq7Z4Xe5JzHm4ct7vIENTAtuxY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755024013; c=relaxed/simple;
	bh=OY7gIT7lHPzG5t74NPw1Mn0OlsSyxpFVC3DY78S5M6s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MDntm/sUJpYmxNNI2shZm8FCTu5hj7RsurPEzE2ZPYKnD3YUhl27kCVpHoot6G9HeYzve2Uz+yTPAHRLNFk92Lv9h/zEbHlk+uRfcKUqz95qR+1qcBNWVfHGygwcXq9+BBAz+IoAAix2lDZbpJQLNNgXTbwSjt5p4zvwKMyiY3Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Z4+E6GTX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z4+E6GTX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F176C4CEF0;
	Tue, 12 Aug 2025 18:40:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755024013;
	bh=OY7gIT7lHPzG5t74NPw1Mn0OlsSyxpFVC3DY78S5M6s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Z4+E6GTXY47ypt+dMgjssO43IpmSGuB1vGvujwWVNSG8aPGe64TRDtlwOMSQqVHck
	 cE/61CuEFSoces5WzGOIZlDonWS5sMPfhgeww1k3n8rWsyrXu5TRj7RR8uBIhbGcIN
	 fIcIbb7lW0rMPEVuaCQChcSP5YwaeDKhXMfxUUQw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Harry Yoo <harry.yoo@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 248/627] memcg_slabinfo: Fix use of PG_slab
Date: Tue, 12 Aug 2025 19:29:03 +0200
Message-ID: <20250812173428.737563680@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
References: <20250812173419.303046420@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

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



