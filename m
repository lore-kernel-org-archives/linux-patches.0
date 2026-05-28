Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5AA0314A95;
	Thu, 28 May 2026 19:54:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779998069; cv=none; b=CGhSPV4UmXqAurr3vQI4/BZ6T5Zju9C4xptZO7rPk0gHKYLuqeG1JKQ1fgNj+KGg3TzMw8XrL2rTYjSnSnRYkelAVYDLG9BXaFufvjQkY4603rYx7IGkp/ug0XBIhKb808LXhiKDG67aDBTN2VY7LOOxAbpCiPedIU6fRPwy1Kg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779998069; c=relaxed/simple;
	bh=dy/QzXOovBBNwOwthvxPweV59KUBMrivFq/jjINIqIY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DMyX7yBdlUrC2qUAkuuwgw+UaTjdYr1UhJxa1U3wYUd9uYDtCWA7vE5y0X2W6uUe5xynN94/uJH7e4pG7zcAiFfBYd/RuIc07PJnYcEcGoQaEcLcGoNYDfaDLbnEE03z5he0YY6a8moLA1gyik2q7QTAnDXQ2YTM/NJ5/1RMBlU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fa9Fkc3C; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fa9Fkc3C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5D3A1F000E9;
	Thu, 28 May 2026 19:54:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779998068;
	bh=PUsco5vfJxBUi8BoJMOCpZKS3F7+Lh9UZWMqH2XRthk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fa9Fkc3Cbn/1aqg2nUGR5etRc9tK7TQWsbNp3+IqXmFi4nVR4QyeAvUdyH2DSSQW4
	 7UjuE8gUifvqB0eUIzHDWGKpGEtG/TX+jx3vLIfmQ0cYLexsNJtgyjALBvT6xZlHZ3
	 7yzlnPnYUN0C9Lq6dG1sgZk/Vzbmo87GyYebGmag=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rajat Jain <rajatja@google.com>,
	stable <stable@kernel.org>,
	"Rafael J. Wysocki (Intel)" <rafael@kernel.org>,
	Danilo Krummrich <dakr@kernel.org>
Subject: [PATCH 7.0 009/461] sysfs: dont remove existing directory on update failure
Date: Thu, 28 May 2026 21:42:18 +0200
Message-ID: <20260528194647.114837707@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194646.819809818@linuxfoundation.org>
References: <20260528194646.819809818@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

commit 237557b8a81ab948e8332f7c0058e758f081c0a3 upstream.

When sysfs_update_group() is called for a named group and create_files()
fails (e.g. -ENOMEM), internal_create_group() calls kernfs_remove(kn) on
the group directory.  In the update path, kn was obtained via
kernfs_find_and_get() and refers to a directory that already existed
before this call.  Removing it silently destroys a sysfs group that the
caller did not create.

Only remove the directory if we created it ourselves.  On update failure
the directory remains as it is left empty by remove_files() inside
create_files(), but can be repopulated by a retry.

Cc: Rajat Jain <rajatja@google.com>
Fixes: c855cf2759d2 ("sysfs: Fix internal_create_group() for named group updates")
Cc: stable <stable@kernel.org>
Assisted-by: gkh_clanker_t1000
Reviewed-by: Rafael J. Wysocki (Intel) <rafael@kernel.org>
Reviewed-by: Danilo Krummrich <dakr@kernel.org>
Link: https://patch.msgid.link/2026052003-uniquely-hastily-c093@gregkh
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/sysfs/group.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/sysfs/group.c
+++ b/fs/sysfs/group.c
@@ -188,7 +188,7 @@ static int internal_create_group(struct
 	kernfs_get(kn);
 	error = create_files(kn, kobj, uid, gid, grp, update);
 	if (error) {
-		if (grp->name)
+		if (grp->name && !update)
 			kernfs_remove(kn);
 	}
 	kernfs_put(kn);


