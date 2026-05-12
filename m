Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83D2E3DC871;
	Tue, 12 May 2026 17:46:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778607988; cv=none; b=oexd43ttjnudiUG+4zl0VjZkSJ0Y80b8UJuUEcYlGLs9mnzVDN7qysELPj3b+3vghtMhOc4mHv9H9+lQvlE/dCOkHZ6iXyExHy/2kmJ2I6+7jK4ATsu6bAz5SDM+e2vGEAxcAFUxsGC+asdYmlPxb4D1J4Oarw0BUiHhFH7l4Q0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778607988; c=relaxed/simple;
	bh=uWRxLGQ6JyVpLH8AGxrT8weoEkYgtIEMoetAYoSkcqE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jkyikUtcjTeDfUvHBQuw0XEm+Hd7BumGfrpYi5MZGeZEwT74sTYhiitk5ocY+z7jPsOJmypgWpOSZM5e+JEeDUmBW7zejSp9MM3Tgb5RttrkgX+0+6K9GObyrhXiedJiTGt2CDhKaRqsnO1CKNXyTadmI/y9TKCC1hnMX+pY3r0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W0OF70PT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W0OF70PT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAA74C2BCB0;
	Tue, 12 May 2026 17:46:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778607988;
	bh=uWRxLGQ6JyVpLH8AGxrT8weoEkYgtIEMoetAYoSkcqE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=W0OF70PTxPZNXnPFx932z/k06owKCXbIMdU9Qj+QACSqFR6QcZkVUBaxyvSG7iR0i
	 yCZEgMb4PG2yC4+WD5FFrDAqJs7V+GROzztYB9ektHut5oADN1X05cmmfja5LlUgsp
	 UYtA+SVDIHUdtYvtnCXjhYVZXnhIVtKraJ1O13xQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	Guangshuo Li <lgs201920130244@gmail.com>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 6.12 114/206] btrfs: fix double free in create_space_info() error path
Date: Tue, 12 May 2026 19:39:26 +0200
Message-ID: <20260512173935.269297701@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260512173932.810559588@linuxfoundation.org>
References: <20260512173932.810559588@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guangshuo Li <lgs201920130244@gmail.com>

commit 3f487be81292702a59ea9dbc4088b3360a50e837 upstream.

When kobject_init_and_add() fails, the call chain is:

create_space_info()
-> btrfs_sysfs_add_space_info_type()
-> kobject_init_and_add()
-> failure
-> kobject_put(&space_info->kobj)
-> space_info_release()
-> kfree(space_info)

Then control returns to create_space_info():

btrfs_sysfs_add_space_info_type() returns error
-> goto out_free
-> kfree(space_info)

This causes a double free.

Keep the direct kfree(space_info) for the earlier failure path, but
after btrfs_sysfs_add_space_info_type() has called kobject_put(), let
the kobject release callback handle the cleanup.

Fixes: a11224a016d6d ("btrfs: fix memory leaks in create_space_info() error paths")
CC: stable@vger.kernel.org # 6.19+
Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/space-info.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/btrfs/space-info.c
+++ b/fs/btrfs/space-info.c
@@ -296,7 +296,7 @@ static int create_space_info(struct btrf
 
 	ret = btrfs_sysfs_add_space_info_type(info, space_info);
 	if (ret)
-		goto out_free;
+		return ret;
 
 	list_add(&space_info->list, &info->space_info);
 	if (flags & BTRFS_BLOCK_GROUP_DATA)


