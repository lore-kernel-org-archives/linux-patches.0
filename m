Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795626050;
	b=qKL/TLKZHuyVEZKZYolRggS5CVzR9EOolAmBbuJSfeVSki/zZiUHvR+vMdUSznAFvgvm
	 7Fjjy0+olu+wqcH/Uc4b6cM18nmEjUb0pMITQUE1AmQ/TfmdEKepeT3sWthCTQrLJnWeq
	 DCSr6wvMyTID2aAV76PJrDWqGQNVsCgJzuXBUyazVdKuv37n2sQDsvvuaQ3E+R+S5cWnx
	 Hy0zuZAMdQI97tHgya3dzfl2JNZqOWD98CFuW5ZYE+MV30/NUXWDpc9+JmyIq6q2dLcCx
	 ifMFLy2NY3dAM9S7JQol43yrmPK+VqzH0Ne4WUR7v9GPu3VdF8BvurT1tJ6RibZI/XQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795626050;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/61OcLM0Wlo9rsin1UYJMG9aTAMLHlxAA7n1XFHU9VA=;
	b=Q1PUlibpVBXL2FBNzFjS79jrevgMKG705XRcVI0ur8zab2XC1qIJ7sT0dQA/yotbXDpZ
	 8PufGZf2tB8dK88DrpjvWW2xkmqzNpUuEf9gWpqVYrr3aT36PxI8grHX3i+DYtcSN0Xhp
	 sZEtmuSrkXPfCKFmkkqwCR6lIa5VWkn3plaJkr1LDEc0m8mhZ/nh8a9pKIjFdFIm2W+FL
	 eMyTe4Jp8FoINvk+sRQI9y2EkDCnpY6aCZA0cPOk+eoCgnTFsIUovx8BbHPIIFlznkpIH
	 AjHn2yCqbrhprk+iqSqqR4rPjWhuHGD4f4Zm8Lo8uoxawRtm6AjEZ1lHRoESgV8NTgA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pp5wEHeT;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AC3B606A321;
	Wed, 25 Nov 2026 17:00:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pp5wEHeT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C3731F000C4;
	Wed, 25 Nov 2026 17:00:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795626049;
	bh=/61OcLM0Wlo9rsin1UYJMG9aTAMLHlxAA7n1XFHU9VA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pp5wEHeTVN/IsLY7kEar9wKUG0cCsQsV/sVeyusb0cHpadkVVP8m70S+UvxsZJgKZ
	 e0R4ssnytqBhe1iNCZEMTUPRJvdy9EsLFvXG+TLhFvwdrVFnFW75qW+6TEJV4YtFk/
	 t5CJvAjQ2CND1Fmk0ugrxtQUkPnRua1pHArt++EM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li Youhong <liyouhong@kylinos.cn>,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 6.12 716/816] dm-raid: fix use-after-free in raid_dtr()
Date: Wed, 25 Nov 2026 15:37:44 +0100
Message-ID: <20261125143905.750647795@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Li Youhong <liyouhong@kylinos.cn>

commit 46af2c975958119290ddcd984a98491966123a7b upstream.

raid_dtr() currently flushes event_work only if work_pending() is true.
This is insufficient because once a worker has dequeued the work, the
PENDING bit is cleared while do_table_event() is still running. In that
window raid_set_free() can free the raid_set, leading to a
use-after-free when do_table_event() accesses rs->ti->table.

Flush event_work whenever it has been initialized, so raid_set is not
freed while the event handler is still running. The .func guard skips the
flush for mddev instances where INIT_WORK has not run yet.

Fixes: db29d79b34d9 ("dm-raid: delay flushing event_work() after reconfig_mutex is released")
Cc: stable@vger.kernel.org
Signed-off-by: Li Youhong <liyouhong@kylinos.cn>
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm-raid.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/md/dm-raid.c
+++ b/drivers/md/dm-raid.c
@@ -3332,7 +3332,7 @@ static void raid_dtr(struct dm_target *t
 	md_stop(&rs->md);
 	mddev_unlock(&rs->md);
 
-	if (work_pending(&rs->md.event_work))
+	if (rs->md.event_work.func)
 		flush_work(&rs->md.event_work);
 	raid_set_free(rs);
 }


