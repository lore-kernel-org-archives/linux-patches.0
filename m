Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 408F342EEAC;
	Sat, 12 Sep 2026 08:43:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789202591; cv=none; b=Ow6cTnlA1grqR+XOKSqs7vxR41FxN8SOqyu/qOz5yM0RdWFY/1fe26aBqNUL7amTaP8dbT8VKCouEqYrjpPQWQz4BeHEetXC3GHoGmRM4nBlH8NhTHLsf+0tQHcK5Q8wbF2jPst3WOxzu2EBF65hhNxaA3oV7Ac8XyzA2WCcMNk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789202591; c=relaxed/simple;
	bh=QvJUCuLSMFSUXbAwZ7Utxk8lR67j7hFTR+3xWRbNbUo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fEUzWjKhJhAoiQCttQTjrRjomwegMT3xTZIVWTaJzPWxhHGLmuD6qzV719TrmeYHtbp3ZQvkILRO2pjtsBGisKxekQOMhSjMRgb+Hx2WEgMR13vaKJio607rSsOIECOeQcye2HZw6NvSPWbsrcDLlie7mlt7X0LXrOt0s0iLm0E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IgaDGqbi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IgaDGqbi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE1591F000FF;
	Sat, 12 Sep 2026 08:43:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789202589;
	bh=XfNx/7Ct/722wXCGhQmsVfvuBV/h/0x50l5HHZyS+OQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IgaDGqbiDD/Ul5yeRCI7zhugyPYpfMFwvZaPZLxdT7zfJddZk537Lm50Es8ERZZn+
	 TSdBtJgT/vnJu2VzfVVwh3Yak3A1VKQi/t11VTUV8t/FDH72K1c2bQPs+ORLQsulI+
	 xyUppecFkMeX8P5IqkcNPn9ZL44+Q+GZBiRRU8iw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mykola Marzhan <mykola@meshstor.io>,
	Yu Kuai <yukuai@fygo.io>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1191/1815] md/md-llbitmap: prevent create failure bitmap UAF
Date: Sat, 12 Sep 2026 08:49:01 +0200
Message-ID: <20260912065716.970973044@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index 2a2b38c663c3e..8e20a9c6fe27d 100644
--- a/drivers/md/md-llbitmap.c
+++ b/drivers/md/md-llbitmap.c
@@ -1126,10 +1126,11 @@ static int llbitmap_create(struct mddev *mddev)
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



