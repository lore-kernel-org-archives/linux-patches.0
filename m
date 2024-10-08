Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35F0D1DEFE6;
	Tue,  8 Oct 2024 13:09:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728392955; cv=none; b=OOGr8uY7aXt5Xg0qPfCP078MXB+Qb+AQAvMyP8Uxw3F9fmEhafHbsPr3ga60wqugP4DGORAIkexSiXNbsyUKNuiA8wMddVxBGeAwxsY8OeUOBfQvHICyTHBUrQptMB5iHfUG1m8/bUKG5jvTyXspKJcfHRDGV6LTTKF5et/PUl4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728392955; c=relaxed/simple;
	bh=Bn2zsm23XRWE3P36Goww0AXpkT3vfGVLhD+uoJJ9jAQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Tc7R1hNZJuZUR+3II1IQvoC+146REiR2uC6Dg47sZZLnVee46FoXGQFsHZAf6Ej5mO9Q3fzimLH9BdXdSmdBL+c/VJdzGaMz3wP3CQ10lJXgcu8YcbIuaKFLLA/Sxurh1L/1WPXHR1icwofQapetX42zqtfH6z/Soy8Sd2hq0lY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=khHXL3ue; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="khHXL3ue"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CF25C4CEC7;
	Tue,  8 Oct 2024 13:09:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728392954;
	bh=Bn2zsm23XRWE3P36Goww0AXpkT3vfGVLhD+uoJJ9jAQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=khHXL3uesGbZYsfxwys2hkkSbTIMnUUQT4gDUxbb+p461QGR2C86TftR4fBkPuFjk
	 FKI/9tZVydvo5ydaAJEEN0pB+uv3F0z3VMc9kVvlzY3w/PKjZwmdYt3S1xhjaepjsH
	 TbTS+zGmkUPbGlYGsfWzT9xG95EOp7m8BGUluqC0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiubo Li <xiubli@redhat.com>,
	Patrick Donnelly <pdonnell@redhat.com>,
	Ilya Dryomov <idryomov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 010/386] ceph: remove the incorrect Fw reference check when dirtying pages
Date: Tue,  8 Oct 2024 14:04:15 +0200
Message-ID: <20241008115629.726540993@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115629.309157387@linuxfoundation.org>
References: <20241008115629.309157387@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index da64bb7325dbc..7549e2b07b6af 100644
--- a/fs/ceph/addr.c
+++ b/fs/ceph/addr.c
@@ -95,7 +95,6 @@ static bool ceph_dirty_folio(struct address_space *mapping, struct folio *folio)
 
 	/* dirty the head */
 	spin_lock(&ci->i_ceph_lock);
-	BUG_ON(ci->i_wr_ref == 0); // caller should hold Fw reference
 	if (__ceph_have_pending_cap_snap(ci)) {
 		struct ceph_cap_snap *capsnap =
 				list_last_entry(&ci->i_cap_snaps,
-- 
2.43.0



