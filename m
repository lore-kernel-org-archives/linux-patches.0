Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECADD12C544;
	Mon, 23 Dec 2024 16:15:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734970519; cv=none; b=B1ZbeWTZdjjV+q3gDcIlWVQ8ys70GSc/G7xFPg6WfxKGuqVH8PUoczDjbZ+zVcfEvNvkDb9ZZO3HzauD+sPCdRfYwBYRnh8qpp+ySsF0EFMMuA9n8FEpgxytoelgJRKVegzBx8XIkuQ9qRiogevSR5HYFhiiU7YGUbAvhWnpa+I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734970519; c=relaxed/simple;
	bh=gTGVipsKljuXB60K+PG7R7au31EMMCWknWR9w6t5Ue4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eQqbzsDDlHD3BlFfRc1Z+CxpHSZlZExRSsvB8ktit6D8oA7AnxmPvXYCYFY6qKWqDQKW/YCcrEm0paLKLLwe92cIs0md3FJUrd0yoDglnp4TWedwnnw/JVhiZX0wg/9bVwvB6PRXkqbhrYTUugy4UbGR2kY58Mw/CJU+ImEsp5w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vCemoz9+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vCemoz9+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15EC8C4CED3;
	Mon, 23 Dec 2024 16:15:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734970517;
	bh=gTGVipsKljuXB60K+PG7R7au31EMMCWknWR9w6t5Ue4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vCemoz9+dJswTqqwB6HZ6DApavzZObdxt9fLK5H5F335FHpgeYf36Gpbx2RYrdegg
	 S+vZdIcsQCDwR+ELE/Cq+BDctnVRHAgVxcPFa5JW9ykhV6FH4iBNGu9aTmxyB+oywg
	 xRA3ROBQM5yPvRj+mCvVVyJV+99Layk6m0sMU7Bc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ilya Dryomov <idryomov@gmail.com>,
	Alex Markuze <amarkuze@redhat.com>
Subject: [PATCH 6.6 107/116] ceph: validate snapdirname option length when mounting
Date: Mon, 23 Dec 2024 16:59:37 +0100
Message-ID: <20241223155403.709830093@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241223155359.534468176@linuxfoundation.org>
References: <20241223155359.534468176@linuxfoundation.org>
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

From: Ilya Dryomov <idryomov@gmail.com>

commit 12eb22a5a609421b380c3c6ca887474fb2089b2c upstream.

It becomes a path component, so it shouldn't exceed NAME_MAX
characters.  This was hardened in commit c152737be22b ("ceph: Use
strscpy() instead of strcpy() in __get_snap_name()"), but no actual
check was put in place.

Cc: stable@vger.kernel.org
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Reviewed-by: Alex Markuze <amarkuze@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ceph/super.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/fs/ceph/super.c
+++ b/fs/ceph/super.c
@@ -427,6 +427,8 @@ static int ceph_parse_mount_param(struct
 
 	switch (token) {
 	case Opt_snapdirname:
+		if (strlen(param->string) > NAME_MAX)
+			return invalfc(fc, "snapdirname too long");
 		kfree(fsopt->snapdir_name);
 		fsopt->snapdir_name = param->string;
 		param->string = NULL;


