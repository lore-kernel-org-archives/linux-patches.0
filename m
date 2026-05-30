Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DE0E3B1EC0;
	Sat, 30 May 2026 17:56:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780163779; cv=none; b=G+F0V45Vu1GgBNDIht+RO1juTPiIg+kye7iXUwmA8qBV9gpv1IM8WE5GNCvYvv/AV878gSkNRa+D8O+Ogwn6uIRVUg/6LbUc1OJNGr1oaiaRSdjdk/61I2DYrOB1ikD6rkwgyERXdYTBr70mfNy2qH3TVPnzoPev/S+2/rUOkA8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780163779; c=relaxed/simple;
	bh=4YU7RE7k5ASxxfwz9dt2LXPudw92+JErIwVcILZWc90=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tghwzw5nn8I0KBzfq6qjpARPfPWuXbt1ir/CxjnJ+FXnSRAW7M7JzMEaSvTzo1Ndc25Ps8cbG4k02vm5h3jNz7auEGlQg9UqHqC/pQCW8WRB6143BHIVeRbuB7dH0ojLfrdK+cYg8XjcnK5ksMf63KAnAlE4zrkMLQyJBRybClA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b/ZF4O2D; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b/ZF4O2D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1AA41F00893;
	Sat, 30 May 2026 17:56:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780163778;
	bh=vi7OfAjkGJRkARfgC4796sh6lpIiefcPzJug201eUvI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=b/ZF4O2Dong7+MsxC9nBBkBHcuM4ZSovAKx13AY7FDtCpDMUJEXDokUQ1PONY1mqq
	 iWA5IaCODuRdc5P4gwrEDGNDB6i+Wpd2Jyf/tIjdFdijTL6Kj5+fnsHwF/6B2JTnGq
	 J9JkuRyuragvoEb8HJ/NktuzSbnJ45MgGfBlFTw4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikulas Patocka <mpatocka@redhat.com>,
	Zdenek Kabelac <zkabelac@redhat.com>
Subject: [PATCH 5.15 328/776] dm: dont report warning when doing deferred remove
Date: Sat, 30 May 2026 18:00:42 +0200
Message-ID: <20260530160249.049752288@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160240.228940103@linuxfoundation.org>
References: <20260530160240.228940103@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mikulas Patocka <mpatocka@redhat.com>

commit b7cce3e2cca9cd78418f3c3784474b778e7996fe upstream.

If dm_hash_remove_all was called from dm_deferred_remove, it would write
a warning "remove_all left %d open device(s)" if there are some other
devices active.

The warning is bogus, so let's disable it in this case.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Reported-by: Zdenek Kabelac <zkabelac@redhat.com>
Cc: stable@vger.kernel.org
Fixes: 2c140a246dc0 ("dm: allow remove to be deferred")
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm-ioctl.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/md/dm-ioctl.c
+++ b/drivers/md/dm-ioctl.c
@@ -367,7 +367,7 @@ retry:
 
 	up_write(&_hash_lock);
 
-	if (dev_skipped)
+	if (dev_skipped && !only_deferred)
 		DMWARN("remove_all left %d open device(s)", dev_skipped);
 }
 


