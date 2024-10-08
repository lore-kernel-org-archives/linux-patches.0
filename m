Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B8191DDC06;
	Tue,  8 Oct 2024 12:11:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728389505; cv=none; b=H71gH7gFZvgAxQ6SxSi12pxSsDmTS+O5aS4yA18qMNctndgnKabp87GImMW61KYfeORrh8Jbhx49SmcAgcxGY7Esig6LltqdKrkfmTZUF1DymGp7sLJJ2iajJzpf9kVAc2rHybu8QTkc4cuHbKMuqoqsJYHzFJhcmeeOmy7jeyA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728389505; c=relaxed/simple;
	bh=gY89oKPU+oFZWYO/U7hPBzj0Po7Izv7T80tZgHaaG+s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=toFXeI4tg5iTppMi1JPvRbOTm3ejri66G/1qvw5qKSsj7AA6AQERqT8aCDKH8Byi3FCWNjdHDfPXEvthDVePu6UOEKTvVTaWN3j13rGYEkQlCwloQFWOb31nGUFYyqnYYLQUBq7YNw3q3Cewz7vlOZGMii3nOKSSaP1Q+8IG91k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yyiEZfA/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yyiEZfA/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64CA9C4CEC7;
	Tue,  8 Oct 2024 12:11:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728389504;
	bh=gY89oKPU+oFZWYO/U7hPBzj0Po7Izv7T80tZgHaaG+s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yyiEZfA/YmTMSX7mtKzWkJCiEfvYQsh7SaK8VSqs7OvKWPX1Tk2/N1z8+CaC9rO4e
	 bVfmCXRm3R33TVjQrj7HOSVL9ATi5Nf0iNB1fueXRoBy9nY6Q+A/JLa9m6TiVZsNc8
	 d67r1hIrOidaGJhAbIDecqRzYQfODsg4/RSALia4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiubo Li <xiubli@redhat.com>,
	Patrick Donnelly <pdonnell@redhat.com>,
	Ilya Dryomov <idryomov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 014/482] ceph: remove the incorrect Fw reference check when dirtying pages
Date: Tue,  8 Oct 2024 14:01:17 +0200
Message-ID: <20241008115648.860204562@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115648.280954295@linuxfoundation.org>
References: <20241008115648.280954295@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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
index 73b5a07bf94de..6551dac5d6191 100644
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



