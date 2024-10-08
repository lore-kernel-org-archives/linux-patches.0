Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3B061DE2A5;
	Tue,  8 Oct 2024 12:38:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728391126; cv=none; b=TntXseoxLmea4BI6MuMdFXVhrJ269UKD0iPbR5wnavs3LeKNXJjoU2CFmoBGyn9Hls5h4seO7AObAQgwfuuampuPuSzpAffVRNdfKOYQSo+5H7M+9gtdq9sJlvHwADdPR014LDeRJJ0CY4yDYJS9VCYi7MrgUNvTfuDB54LWM/I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728391126; c=relaxed/simple;
	bh=XcblZYqDcZsIZq0vg3DN5xrSkWg0OBjd6F6dLBb1lv4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NQFyl3mPsn4YudnafyFn87sdiHmSpKLfJHFMIPKbMOu4dwNOHxxwLSJ42dwrpPyA1oYvfWRjsQyO97t1XPWrOnVbnwrUzUIXQJQg1tSTQqCA2VanYGypItdrQo7/PxM8b/Jn7J6vZ3K2ibLIXICigUPGSOcPE5j0EF3fR8GdZNc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OnqusIVT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OnqusIVT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B301AC4CEC7;
	Tue,  8 Oct 2024 12:38:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728391126;
	bh=XcblZYqDcZsIZq0vg3DN5xrSkWg0OBjd6F6dLBb1lv4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OnqusIVTzoqTikK0vmpXj4WAnA1zswro10/iQ5VKOx8UTIDChrtJ3kyTNC+SMoxo7
	 RS6RwjmqKlyBg6kvWzo+sgLGjhTahB4WHiHjoduRPLJ1V5XP/dxU1cjJpm+IfKN8Vn
	 CeX6b/glDA2Msixn5DiAfPpCqrFYk/4Sq+zAjggs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiubo Li <xiubli@redhat.com>,
	Patrick Donnelly <pdonnell@redhat.com>,
	Ilya Dryomov <idryomov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 016/558] ceph: remove the incorrect Fw reference check when dirtying pages
Date: Tue,  8 Oct 2024 14:00:46 +0200
Message-ID: <20241008115702.861916653@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115702.214071228@linuxfoundation.org>
References: <20241008115702.214071228@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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
index c4744a02db753..0df4623785ddb 100644
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



