Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6C7143302F;
	Tue, 21 Jul 2026 19:58:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784663933; cv=none; b=l8cyE+N2EeUWAj9R4V0FJVhaTQUvrxRcMV9VaZK2WrapDujsKuwYHlRegd70A/LzmYrNBFbAvhG6xz1SQyr50k6wMujYZHcuvuAh1LicqxENYjGQv6l2Iw+IkK3NC/uxZ9GcU9c1rYPtjsL3NU8BpDjY3nrfVsdljgWcqi01htI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784663933; c=relaxed/simple;
	bh=DpZaAVplqv8xzhn0yXuQT/mpt42G0S+oxvfOR0bSTjM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KqeC/uuMxojMbTq2kLidm5EqeJ1dKNBXD8vt8Sy0cvTqrUtrWnS9EaJmzl9pqj0E92fUxHzB9MLGnAzkJ22HFYPvgbIWqnJ8GF8akxcAdUqHDu1BasFh2okFwsANnzLkCbgKO/ixmwAgRLYhRjdEpev/jP4bbEoVPn6uTmxac3o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ot80JHfT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ot80JHfT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1884A1F000E9;
	Tue, 21 Jul 2026 19:58:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784663932;
	bh=2sFPY+TKLwWKIZtbihf8vRy4yDHLzVU7ZcINJZFXFfI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ot80JHfTUgLKui5Iv8dw75LvmspuKt/jXQvnuzWc4d5yqnZX1JpdOXziz1GTGaeQt
	 sE/g3YnWlciTMAgAkLfRV8VocxIdUkZ8JHyLygMwTJ/IpDKM29+MQgZpDrohH1RYfj
	 dY+y6TF8bxsWquOYyvCfjSPmlHOlTGwr8OZ/5CM0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 6.12 1008/1276] dm_early_create: fix freeing used table on dm_resume failure
Date: Tue, 21 Jul 2026 17:24:11 +0200
Message-ID: <20260721152508.564487632@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

From: Mikulas Patocka <mpatocka@redhat.com>

commit 366665416f20527ff7cad548a32d1ddf23195740 upstream.

If dm_resume fails, the kernel attempts to free table with
dm_table_destroy, but the table was already instantiated with
dm_swap_table. This commit skips the call to dm_table_destroy in this
case.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Assisted-by: Claude:claude-opus-4.6
Fixes: 6bbc923dfcf5 ("dm: add support to directly boot to a mapped device")
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm-ioctl.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/md/dm-ioctl.c
+++ b/drivers/md/dm-ioctl.c
@@ -2340,7 +2340,7 @@ int __init dm_early_create(struct dm_ioc
 	/* resume device */
 	r = dm_resume(md);
 	if (r)
-		goto err_destroy_table;
+		goto err_hash_remove;
 
 	DMINFO("%s (%s) is ready", md->disk->disk_name, dmi->name);
 	dm_put(md);


