Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 513771A76A5;
	Mon, 14 Oct 2024 15:10:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728918656; cv=none; b=nOqrVzw5bDBlL8gAgRzbk0jqgVUfGrOpuUkOKgpQYVyh4EI0xy+2ydC3k26mvcWWmcCTX7y4sKlem16IRHByhy/tulZqZqs3QbEm9vKLJ/ERXeF50lXS7a3VmknGysG/m1T1D48f4a5x2DbAxCUmOPt4mkHPbEUQnquQjr78WaY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728918656; c=relaxed/simple;
	bh=O0zuxs5j1oAnrV6LmOS8G+B7ZPREV5d6WBTvkKYbN/o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fw4hJT73lNzXiK78rA9MHcFCrbz5AZR0wEliQXQ80HWphlWZl+Ksb2TtbYOLGRqYqSeZz9tE98+9sj/GP10qx+CKb8Z5CNFjWnJItAfs78qIqXH7BHmpLCnil+b/addvVSfWjB4j15zVDnpFVc9AgVOxKXtctIk14aJdoaWz3iQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ieVuSh6y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ieVuSh6y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD4F8C4CEC3;
	Mon, 14 Oct 2024 15:10:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728918656;
	bh=O0zuxs5j1oAnrV6LmOS8G+B7ZPREV5d6WBTvkKYbN/o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ieVuSh6y+bbQkyhmZL5zTtNMWjxFJpeER6NWUBP2WtzkZwHJGdFvvGccORdp0mlyu
	 SHUkaqb5+lQcbtkOIjcbv85n1NI2G6T2no5rDgvMr6k+NKVhYOrvUynuJWeV98dI2t
	 PziMU8mbVTcDfKDoIjrQjXTZuWjYQT4lTckeWcnI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiubo Li <xiubli@redhat.com>,
	Patrick Donnelly <pdonnell@redhat.com>,
	Ilya Dryomov <idryomov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 384/798] ceph: remove the incorrect Fw reference check when dirtying pages
Date: Mon, 14 Oct 2024 16:15:38 +0200
Message-ID: <20241014141233.037166046@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index dd2ce7fabbaee..6c325efa1c4e5 100644
--- a/fs/ceph/addr.c
+++ b/fs/ceph/addr.c
@@ -94,7 +94,6 @@ static bool ceph_dirty_folio(struct address_space *mapping, struct folio *folio)
 
 	/* dirty the head */
 	spin_lock(&ci->i_ceph_lock);
-	BUG_ON(ci->i_wr_ref == 0); // caller should hold Fw reference
 	if (__ceph_have_pending_cap_snap(ci)) {
 		struct ceph_cap_snap *capsnap =
 				list_last_entry(&ci->i_cap_snaps,
-- 
2.43.0



