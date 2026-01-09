Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52091335561;
	Fri,  9 Jan 2026 12:03:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767960226; cv=none; b=Ab+eoDy2Dh9AV/s4ZIxfFyHsRyxd6YFYGUtJv0B1S79w1KEIiCPLu1GwCKF4vZbmvrG/c12upaag8Ki6Bm6hbOxn8fjeY7eHKVDHqqoUCzKK85lZQfExoiO4Sf6w8rhrc/Iul4KvPC9hXcAXB/JfJqgDabfIbXt4afrhpDb81k8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767960226; c=relaxed/simple;
	bh=0gfQMq628D0gy2AA1VgPVxIOJNhkCesxPPgQLRy8nu0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XJ6HrbzulrA6RxEwvRAB96+BFLkYaZUFbehqCWv676hD+mwbEpownzvAZ0hpNAh1HTui3rX3ebgM+TS3fAO9SUqXjnsJQU42TL4I341IiHg2G7T4EyvXuqAcK+wL/l7L4+WzZDbftYfXmXT3SHGW13YRPkOrFmxgv3RcuPJTTC4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iSfG9sGE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iSfG9sGE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97D85C4CEF1;
	Fri,  9 Jan 2026 12:03:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767960226;
	bh=0gfQMq628D0gy2AA1VgPVxIOJNhkCesxPPgQLRy8nu0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iSfG9sGEldljplCyOd3wVtJTvmd1MFojrKFHSuCXZMW0NHTKl3fzxuTTSpe2IxQ/Q
	 GrUTTx054IgD8le1DXkuT81V3JphjsDfwrHXcrmMa4HzivIbNyDe5YWbQ97uAkEZ83
	 8WlXBqPlAsMygYfRTMiSL+dAbiL2+/OHfk5ojpIk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stephen Zhang <starzhangzsd@gmail.com>,
	Andreas Gruenbacher <agruenba@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 330/737] gfs2: Fix use of bio_chain
Date: Fri,  9 Jan 2026 12:37:49 +0100
Message-ID: <20260109112146.407680032@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
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

From: Andreas Gruenbacher <agruenba@redhat.com>

[ Upstream commit 8a157e0a0aa5143b5d94201508c0ca1bb8cfb941 ]

In gfs2_chain_bio(), the call to bio_chain() has its arguments swapped.
The result is leaked bios and incorrect synchronization (only the last
bio will actually be waited for).  This code is only used during mount
and filesystem thaw, so the bug normally won't be noticeable.

Reported-by: Stephen Zhang <starzhangzsd@gmail.com>
Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/gfs2/lops.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/gfs2/lops.c b/fs/gfs2/lops.c
index 483f698070622..b25b741e3c96a 100644
--- a/fs/gfs2/lops.c
+++ b/fs/gfs2/lops.c
@@ -492,7 +492,7 @@ static struct bio *gfs2_chain_bio(struct bio *prev, unsigned int nr_iovecs)
 	new = bio_alloc(prev->bi_bdev, nr_iovecs, prev->bi_opf, GFP_NOIO);
 	bio_clone_blkg_association(new, prev);
 	new->bi_iter.bi_sector = bio_end_sector(prev);
-	bio_chain(new, prev);
+	bio_chain(prev, new);
 	submit_bio(prev);
 	return new;
 }
-- 
2.51.0



