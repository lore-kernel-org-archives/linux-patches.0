Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76F961C07FF;
	Tue, 15 Oct 2024 13:09:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728997751; cv=none; b=kCNtzX8Aq5WIO4BpZ+MOVFrih4uvuzxa41uCPqZ07HWq0VQ9mFcEvmsXiIudq3i5u0FObGJXoGHz4VkvsPBtjR3g+tLByE1GhHvtK803St6zbNaSLl3KTaAxNfvLgaUQD+z0WI04F4Fr6F/tskyaKQ/Cf8g+/iVyUUj9oWl+o1A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728997751; c=relaxed/simple;
	bh=/m7x+kE2XqsLF7ryr6F5oJiqE1bHCRhyLn0+UGRurpA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BySxJ+9YuUwlfIZjRJqVjIniK1tNtqIrdsQaamvcxiy9irJBpA+X2ThHvuXjUp2qjct+dnAXX8Kos6yjnldE7fG+d8KFa/XAXTt+2yCz0F5jOXXCCbpagyvzKnjmWtX3vFXO3qPR0AfDTJvLJEOpJ/Xn409/AurAq2dpAa1c9hY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kl8Gq+lu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kl8Gq+lu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC0E3C4CEC6;
	Tue, 15 Oct 2024 13:09:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728997751;
	bh=/m7x+kE2XqsLF7ryr6F5oJiqE1bHCRhyLn0+UGRurpA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kl8Gq+lukFQcABt3fw7N8ZhgjG1fUtP12wi3gae5Joc5qAQcK+vROrDlwSVu6fvr6
	 gBjxXP1EbsEbiiEcAwNw6+8EUv4QACYwTa6VSgk5R+FCvU35/ftep2s9Z984dlCmpG
	 7lkCVF2avPSVPF/3ul5b78WX8cXcmYI+d9ydN5F4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiubo Li <xiubli@redhat.com>,
	Patrick Donnelly <pdonnell@redhat.com>,
	Ilya Dryomov <idryomov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 268/518] ceph: remove the incorrect Fw reference check when dirtying pages
Date: Tue, 15 Oct 2024 14:42:52 +0200
Message-ID: <20241015123927.337566528@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015123916.821186887@linuxfoundation.org>
References: <20241015123916.821186887@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 3465ff95cb89f..2362f2591f4ad 100644
--- a/fs/ceph/addr.c
+++ b/fs/ceph/addr.c
@@ -91,7 +91,6 @@ static int ceph_set_page_dirty(struct page *page)
 
 	/* dirty the head */
 	spin_lock(&ci->i_ceph_lock);
-	BUG_ON(ci->i_wr_ref == 0); // caller should hold Fw reference
 	if (__ceph_have_pending_cap_snap(ci)) {
 		struct ceph_cap_snap *capsnap =
 				list_last_entry(&ci->i_cap_snaps,
-- 
2.43.0



