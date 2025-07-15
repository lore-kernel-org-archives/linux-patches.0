Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D3692E7186;
	Tue, 15 Jul 2025 13:44:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752587055; cv=none; b=ZeU3tsni8LTtDK/YYr0gQAD6FCLjpr/of74BVYFrqzIwD9F4EJk8QXgRdfPHlh39ZpsraplMFk3NBGGTUUQ7eEwHfv6HS99Vf40rWqU9vfVp7S/8q7SBarIVGNlCQ1M9wkjAP23KJdkw/djL5iE19Hi/HR2F+ZxcZmci1yu26ns=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752587055; c=relaxed/simple;
	bh=jI1bcSY3Tob9dwHMXCeAjepimVlcV5L3z2R0pH+Hf6E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZAkjBW2rrE+Ie2kKuULxfsvA9wXNFqek60EARzburCHWgFeBHs/MpIzEdzl2y+6QWSJI9b1PA33ztKMD8aRxEHFJIkif5mcsJsy7RHwv75X+ukiOpK6qp/M1WURg/VUkL5I6845p4Pz8OkptS0GppMJR+w3HY81SL3pY+8kCF1E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=T8kro404; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T8kro404"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C83A5C4CEE3;
	Tue, 15 Jul 2025 13:44:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752587055;
	bh=jI1bcSY3Tob9dwHMXCeAjepimVlcV5L3z2R0pH+Hf6E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=T8kro404rqDOnFRd9ElYEc7+H3inGahGYJdq0qeIALtLTyQpBeC2glN6/FDH0DR5l
	 OPrlinOdavQq3U1BId8xTDAOGkF2m2DDIv/i/nZCOSa7togS6s48vedA0RjFUrOGsu
	 +Bfh3DQYNQifXuJD9Afq6ecvFvFOwjN18vDnvzaA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chao Yu <chao@kernel.org>,
	Gao Xiang <hsiangkao@linux.alibaba.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 149/192] erofs: fix to add missing tracepoint in erofs_readahead()
Date: Tue, 15 Jul 2025 15:14:04 +0200
Message-ID: <20250715130820.890777412@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130814.854109770@linuxfoundation.org>
References: <20250715130814.854109770@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chao Yu <chao@kernel.org>

[ Upstream commit d53238b614e01266a3d36b417b60a502e0698504 ]

Commit 771c994ea51f ("erofs: convert all uncompressed cases to iomap")
converts to use iomap interface, it removed trace_erofs_readahead()
tracepoint in the meantime, let's add it back.

Fixes: 771c994ea51f ("erofs: convert all uncompressed cases to iomap")
Signed-off-by: Chao Yu <chao@kernel.org>
Reviewed-by: Gao Xiang <hsiangkao@linux.alibaba.com>
Link: https://lore.kernel.org/r/20250707084832.2725677-1-chao@kernel.org
Signed-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/erofs/data.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/erofs/data.c b/fs/erofs/data.c
index 0ab0e8ec70d03..33cb0a7330d23 100644
--- a/fs/erofs/data.c
+++ b/fs/erofs/data.c
@@ -363,6 +363,9 @@ static int erofs_read_folio(struct file *file, struct folio *folio)
 
 static void erofs_readahead(struct readahead_control *rac)
 {
+	trace_erofs_readahead(rac->mapping->host, readahead_index(rac),
+					readahead_count(rac), true);
+
 	return iomap_readahead(rac, &erofs_iomap_ops);
 }
 
-- 
2.39.5



