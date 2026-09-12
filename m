Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF4BD470EB9;
	Sat, 12 Sep 2026 10:50:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789210225; cv=none; b=UTdJgcueBIibIYVoG/6xpzlMmnaIpC5CKZzt6PUjEf2qFI6JA1FlEzVA42XDPEhxlIkalkhh1gnAIRoojxR7qKiucuJqq1SDAdSu8CzB8Rt3JuTf+ADkfL/WW6LG3DRhA7X7SK5P/vKVbooSJqFirsQIJDQGjnlZEHkb6M66av8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789210225; c=relaxed/simple;
	bh=amG6Ckpn/V1ILXXqlfGJUsZLxup+/WTLUbTKoewSjUI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OGQARRYQkB67YPeaKRgTUtcI/Z51CHwp7KdUmMY0pjPfDeYUE7yDA5U9oPqfg45W6mgYn+qhG7DopqkVjHwhqjGQvAlD7cZREwNgORmIEUCaFldQ2q8hQbq13tdK/f/cK4ZsIhWivE6nSqo2RZhRpoKFPzLks9u+PpxzgzzIKAk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qrVkupcy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qrVkupcy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64A921F000FF;
	Sat, 12 Sep 2026 10:50:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789210222;
	bh=sy8y590Hc4A6L1BWW4YVMCwbjDui46M+ntSn+94gUjI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qrVkupcyrJF9MbmlSUmWzzA0Y4y3/7Y3AhlftSsbX1En4vWlsbebcqxmKR4T3EtXK
	 18AYM+Te+82Nej9qtaA/FR09rAvtv2A0RGiavGw8aGDa3/zdYSN3bSEQo9KHWvayQc
	 qkVkjZZHUb35scVdynYBcZF2tdJRpiusRj0vV3KQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mykola Marzhan <mykola@meshstor.io>,
	Yu Kuai <yukuai@fygo.io>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0965/1518] md/md-llbitmap: prevent create failure bitmap UAF
Date: Sat, 12 Sep 2026 08:52:14 +0200
Message-ID: <20260912065645.290552759@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yu Kuai <yukuai@fygo.io>

[ Upstream commit 2116c2f0a0e547615886900e2ed8c529c016499b ]

llbitmap_create() publishes mddev->bitmap before reading the bitmap
superblock. This is needed because llbitmap_read_sb() can initialize a
new bitmap and flush it through helpers that use mddev->bitmap.

If llbitmap_read_sb() fails, the old cleanup dropped bitmap_info.mutex
and freed llbitmap before clearing mddev->bitmap. Readers such as
/proc/mdstat rely on bitmap_info.mutex to keep the bitmap pointer stable
while collecting bitmap stats, so they could observe the stale pointer
after the failed create path released the mutex.

Clear mddev->bitmap while still holding bitmap_info.mutex, then free the
failed llbitmap after dropping the mutex. This makes mutex-protected
readers see either a live bitmap or no bitmap.

Fixes: 5ab829f1971d ("md/md-llbitmap: introduce new lockless bitmap")
Tested-by: Mykola Marzhan <mykola@meshstor.io>
Link: https://patch.msgid.link/20260802195038.164272-9-yukuai@kernel.org
Signed-off-by: Yu Kuai <yukuai@fygo.io>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/md-llbitmap.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/md/md-llbitmap.c b/drivers/md/md-llbitmap.c
index dc9b72494a81a..b4738fe6e2463 100644
--- a/drivers/md/md-llbitmap.c
+++ b/drivers/md/md-llbitmap.c
@@ -999,10 +999,11 @@ static int llbitmap_create(struct mddev *mddev)
 	mutex_lock(&mddev->bitmap_info.mutex);
 	mddev->bitmap = llbitmap;
 	ret = llbitmap_read_sb(llbitmap);
+	if (ret)
+		mddev->bitmap = NULL;
 	mutex_unlock(&mddev->bitmap_info.mutex);
 	if (ret) {
 		kfree(llbitmap);
-		mddev->bitmap = NULL;
 	}
 
 	return ret;
-- 
2.53.0



