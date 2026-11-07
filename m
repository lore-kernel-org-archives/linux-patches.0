Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064341;
	b=mI/J7SO/G9MJuGJICN2pq1CCWPvZvKf/YsHz/HhTu83YzlHgpi58DRVTx/lsZkneQSiL
	 zEUOmq4KqvPrso0K2evvtyAGeqoiaTyyw+iZk+FVkuDOYvGtXZzeQSfXoKxR3wD2F6Tuu
	 6JE6VAxsDpQRUdA5TVgPbpag1EGJqdA2dw3dRTb467NMP4BV+h0mCxE5mOtpmCFLOfNNY
	 D/wUBwWG+YEr8PYdcHAOhO7LAlQqwos0muBiBW2pvEVvV7bG3KxRvMtICU4lqNRhtV6LZ
	 HNQdbObkXPD+ZpeLfsifbFiECjtdkJWuRgKJCwMsmZqkKqzhEVhuyRakk41D91qRowQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064341;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=qtt8iszu6t9GBOv6uPds3kqREccuyRZuOBi3nKr/H60=;
	b=HVJlv+7rojiZunqUe/+31UReLa9PETBDY69FX7BJMrvEPa758ECQX7JPJBeA/Q9rKVMN
	 g9f48X+YNHa9Ts4nyQJA8j/R5rh/MbWGLUjR4Lb9Zy/KJmyQa/ahotmy9H3xJ/vq4Ft9q
	 3oQXUY6llzKvTsRulmVa7/8eOoT0krz2ZTvRE0TnAT1sF4RNZyOdANqOQO80QH17GWvjP
	 KFZE52ErWv8MfRf/tctmyltvzHwOch5DdDUMf4ttPDmSPBWJ/91yZP0qx87xajo6Rgw0i
	 D7pOC7aWxdTJVh6QknWrJuPHp72luxgvrcd467h5ZyHODAHrtOfHZt7sJF7px0HuBcw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SQZHR4tN;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45DC0606A33A;
	Sat,  7 Nov 2026 15:12:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SQZHR4tN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E26C21F0089F;
	Sat,  7 Nov 2026 15:12:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064341;
	bh=qtt8iszu6t9GBOv6uPds3kqREccuyRZuOBi3nKr/H60=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SQZHR4tN3nWK25uL+PMxY7Q2BPz61efOsZNfX0hhDgXX5xKz7bMVdVpRjn1gzzafx
	 i1QicYHJh/2lFPE6UX9qJ9abrJTGIpuuOeGorZZdABbxVnYD9SPVC7SxfZGO2dIOL/
	 Ba97baUKv1qha3y1mo8Q/bONFS1QRoZsv9KEPGlc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikulas Patocka <mpatocka@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0419/1257] dm-writecache: fix a crash if we attempt to use non-dax device
Date: Sat,  7 Nov 2026 08:45:15 -0500
Message-ID: <20261107134951.076527965@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mikulas Patocka <mpatocka@redhat.com>

[ Upstream commit b15dc73f60ebf02410bc7014ce34fb7fd1040045 ]

If we specify a non-DAX device as a cache device in the 'P' mode,
dm-writecache crashes on NULL pointer dereference inside dax_synchronous.

Note that this is not a security bug because only root can trigger it.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Fixes: a46624580376 ("dm writecache: reject asynchronous pmem devices")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-opus-5
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/dm-writecache.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/md/dm-writecache.c b/drivers/md/dm-writecache.c
index e4559d1de3dde..6ec3e20553174 100644
--- a/drivers/md/dm-writecache.c
+++ b/drivers/md/dm-writecache.c
@@ -2502,6 +2502,11 @@ static int writecache_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 	}
 
 	if (WC_MODE_PMEM(wc)) {
+		if (!wc->ssd_dev->dax_dev) {
+			r = -EOPNOTSUPP;
+			ti->error = "Cache device is not a DAX device";
+			goto bad;
+		}
 		if (!dax_synchronous(wc->ssd_dev->dax_dev)) {
 			r = -EOPNOTSUPP;
 			ti->error = "Asynchronous persistent memory not supported as pmem cache";
-- 
2.53.0



