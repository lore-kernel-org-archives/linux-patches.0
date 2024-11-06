Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A38F1DFE3A;
	Wed,  6 Nov 2024 13:04:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730898251; cv=none; b=UIB0hVw8GRvloMKzREQXE+TS3jYUHhLVRbA9BCRxBYD+4pE31V7WNCWZJvGqftjF0nPNZSun9mYXZ3bi9H0jFsmXc65kJ8HfdwrsrjedhHkfVAbdo2PWucIxpO2437iBSDTVUXpeOFfuJYwhhggtdJr/tvyPEXs0qVHPeFtB8Ug=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730898251; c=relaxed/simple;
	bh=9iv/Iv66Pugi0yaagaol8/yBidgPrI1HVCfVSriUDdE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LZsqkqnFsGtT2vjF2V2a2+sajB++cC9NmnB73Aqkj1rbmviGhHXjtncwMavipBsDBKXvfq06jEKjWVHSXt1ZzPylP9d9fGmsLRqsmfz6q2lqN84KDDSDqqzTJUrHhYHmLB7lH8s6Quw+I0TzEmUomjTi1Lm59fTdaMF/eMt6now=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=c/dBf84w; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="c/dBf84w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6690BC4CECD;
	Wed,  6 Nov 2024 13:04:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730898250;
	bh=9iv/Iv66Pugi0yaagaol8/yBidgPrI1HVCfVSriUDdE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=c/dBf84wapbyDKPn7KTkawKsNEzc86kly5EKPIWCMyqKkb1zxpcjUhWjfJdt8LNck
	 MFdnVsFGWbS3xGAg+87YmErZ5Q15lnXIs8v+1XwwwgI1QeivvM1657bSaov/E9cNkc
	 viNOIu9BPlor2BIHFIZTmOd5NjGoHI9+b5t8fJ1c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiubo Li <xiubli@redhat.com>,
	Patrick Donnelly <pdonnell@redhat.com>,
	Ilya Dryomov <idryomov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 175/462] ceph: remove the incorrect Fw reference check when dirtying pages
Date: Wed,  6 Nov 2024 13:01:08 +0100
Message-ID: <20241106120335.841320457@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120331.497003148@linuxfoundation.org>
References: <20241106120331.497003148@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xiubo Li <xiubli@redhat.com>

[ Upstream commit c08dfb1b49492c09cf13838c71897493ea3b424e ]

When doing the direct-io reads it will also try to mark pages dirty,
but for the read path it won't hold the Fw caps and there is case
will it get the Fw reference.

Fixes: 5dda377cf0a6 ("ceph: set i_head_snapc when getting CEPH_CAP_FILE_WR reference")
Signed-off-by: Xiubo Li <xiubli@redhat.com>
Reviewed-by: Patrick Donnelly <pdonnell@redhat.com>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ceph/addr.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
index 34ab7b892b700..0791855963647 100644
--- a/fs/ceph/addr.c
+++ b/fs/ceph/addr.c
@@ -89,7 +89,6 @@ static int ceph_set_page_dirty(struct page *page)
 
 	/* dirty the head */
 	spin_lock(&ci->i_ceph_lock);
-	BUG_ON(ci->i_wr_ref == 0); // caller should hold Fw reference
 	if (__ceph_have_pending_cap_snap(ci)) {
 		struct ceph_cap_snap *capsnap =
 				list_last_entry(&ci->i_cap_snaps,
-- 
2.43.0



