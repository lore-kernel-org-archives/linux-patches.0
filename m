Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAD074DDB2B;
	Wed, 30 Sep 2026 15:44:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790783101; cv=none; b=hNN7YYBLSLkguflvHITy4tbT36FQWI+xtaywLsmVHD10DhFJ3I/dnDkgMvYCJX8hcn4yWK8QwRUGv4dZY1XUefb3Z2WoXK9f2lJigufDHrDazchhRUa2MK1XAaat6TRK6CgV3y2jBJluqFw7zKwaIRrPCXl1PlVj0tQWcmak0AY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790783101; c=relaxed/simple;
	bh=deulMlLAf5JoMdz8iAsZKLva059UuRFXO3XE3J/aYJg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jiClAyH2sJwnbVHo+uKd8HvIQCV5LQpQSaW0If0JqCwlMigjWph92KptRmG/0WzDN2SLdN20FF8EwmXzYOfs6kOJyBbQ955oS0W5IKg9YCquUVHuVKT+IQjuZw91pP7Zq1OupLXhT5WdRiDpK12sSXf0E/9f0UhGY52VzOp9DUY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QJllzERW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QJllzERW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1187A1F00893;
	Wed, 30 Sep 2026 15:44:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790783097;
	bh=02eRw8VY7zAccvR6dIfnfXGsxqD6IeZTzrMAQZt94To=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QJllzERWJpMnNhE1Jb7iBe0Z3xGh3/XB/6simfpkhxcJNMy9F3HgqTXoyxraGJbeQ
	 rSOVE1mZdFGDHZ30Byfp1V3Plg2lsT77hE2my1Wf+/AoL3qf4TVBmSvthQJ2cQUzZl
	 aaNyeY62xhu01rXAEfLZYM54Pfw1ArhuMJ1FurzY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Santosh Shilimkar <santosh.shilimkar@oracle.com>,
	rds-devel@oss.oracle.com,
	Linus Walleij <linus.walleij@linaro.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 279/595] net/rds: Pass a pointer to virt_to_page()
Date: Wed, 30 Sep 2026 17:22:52 +0200
Message-ID: <20260930152353.705121712@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152347.700140858@linuxfoundation.org>
References: <20260930152347.700140858@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Linus Walleij <linus.walleij@linaro.org>

[ Upstream commit a60511cf15204e41f4edbcdc4ee80208d528917c ]

Functions that work on a pointer to virtual memory such as
virt_to_pfn() and users of that function such as
virt_to_page() are supposed to pass a pointer to virtual
memory, ideally a (void *) or other pointer. However since
many architectures implement virt_to_pfn() as a macro,
this function becomes polymorphic and accepts both a
(unsigned long) and a (void *).

If we instead implement a proper virt_to_pfn(void *addr)
function the following happens (occurred on arch/arm):

net/rds/message.c:357:56: warning: passing argument 1
  of 'virt_to_pfn' makes pointer from integer without a
  cast [-Wint-conversion]

Fix this with an explicit cast.

Cc: Santosh Shilimkar <santosh.shilimkar@oracle.com>
Cc: rds-devel@oss.oracle.com
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Link: https://lore.kernel.org/r/20220829132001.114858-1-linus.walleij@linaro.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 2ac09b5353fe ("net/rds: fix tcp stream corruption with large pages")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/rds/message.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/rds/message.c b/net/rds/message.c
index 987ef9ca5a8fd..cd13f0c4de540 100644
--- a/net/rds/message.c
+++ b/net/rds/message.c
@@ -364,7 +364,7 @@ struct rds_message *rds_message_map_pages(unsigned long *page_addrs, unsigned in
 
 	for (i = 0; i < rm->data.op_nents; ++i) {
 		sg_set_page(&rm->data.op_sg[i],
-				virt_to_page(page_addrs[i]),
+				virt_to_page((void *)page_addrs[i]),
 				PAGE_SIZE, 0);
 	}
 
-- 
2.53.0



