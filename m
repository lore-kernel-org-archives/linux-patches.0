Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062162;
	b=qSyZokjU3F49QA0zGOPUKjICehFt/6XchWZgYR7Lx21CP/j5iqROEFv4567I7Ey3WBCV
	 6c1mYMAlEoMSUjmhmeUkB43Y8uJIGsihiVcPa6Y2r/Q8NjtarYswr6jlaFmq03Srp5i6z
	 AP5kjB3GbbWNX2ll0azn37pX7GAHAKzhoUInmibzg71ueF+sSKJwCNtKaafGPjYyXetX/
	 jeYC0TvRG4H2nH7VReWZud0jlFGn6uC45T0+7CEXARELTFEI4Dy8QyD3KlRIl0AY3V4PR
	 qrMIeRAxpRfxui+BHwtywsIdxiDWhfkXds5G1Xt3+ef1WKhUBRxpT79qVqHkoSHrMfg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062162;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=sNVAqDE8bZZSGceEFPidUUF5L/NoanlCfgN19G2jmlo=;
	b=arOTWINzbmGtKJDoL7eJ/pBLpyvbL6LRR4GTKR12Hbio3/tZD5CMsatkJIUcbZ7rkMqt
	 oULagHr9fpFlkb4YOmNuAR4lgyPRfAAAoUlydO9BFmKTjOlHzVX951Jw4DYYZkcghiUin
	 5BGPObp7TmLNzkV0/Po/73WBVemxUtmo4uT5PMHRdBetalgZ27/JtrMbfu3fMjexaCmeF
	 jqB+G4hAuhqDLsK4cXJZxwGM4j/du8yfGlZGhPGp7GRzZpnv/mifU187xJgGXm9b4/tV9
	 gKziCIiBvM7dSM2E5LOiTcV9r/uSQYdyhY58GUq1CvapjtYxroPkX0/pPLeQ6JDgN9w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="pY/DNta9";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7D95606A326;
	Sat,  7 Nov 2026 14:36:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pY/DNta9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7604E1F0089F;
	Sat,  7 Nov 2026 14:36:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062161;
	bh=sNVAqDE8bZZSGceEFPidUUF5L/NoanlCfgN19G2jmlo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pY/DNta9U9x6BfNJcfonhwC8ThLjhotwr5jrGMzwVudg0ia45u0obA2yCQ1nOogw1
	 K9dztM5rd3vtbxEmYLVhtzE8RunDcmQ4nYXs8teIxWXwa2KvtCM4gk4QYry6AHkSFL
	 UGMBUIIX/fbSlVpjPJA2HopG1cWeA/6AgcZMq6hg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikulas Patocka <mpatocka@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1125/1536] dm-writecache: fix a crash if we attempt to use non-dax device
Date: Sat,  7 Nov 2026 08:52:21 -0500
Message-ID: <20261107135029.305637381@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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
index be22d5ae696f7..069f104059654 100644
--- a/drivers/md/dm-writecache.c
+++ b/drivers/md/dm-writecache.c
@@ -2509,6 +2509,11 @@ static int writecache_ctr(struct dm_target *ti, unsigned int argc, char **argv)
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



