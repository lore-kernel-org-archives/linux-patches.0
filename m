Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795036215;
	b=axCaf4/UED46eVgPy+jJYzPenLT21YD9uGMA0al+kw0uu/UlFciFXgdcTzjSh2cufdh3
	 TY/TJPmu6k06b6qpqyAGcknKF+fvAFG5ybYioOa6MC2GqUo6zYe/ZsVk8qODLzj7EmUbG
	 H8ECETazZlh3w2BHntJtYDG0VRZKtqdxBgmQwf1nCP2WU3MrKgvBqRsNde5kMz/QZkeus
	 lYWSiKu/tfiQCpVEEtNxsPmFGAPAXgzIiR7Op8fWttfvVc9lkgzEMu7DVe82DGnbDDyGL
	 vkytOz/Q6Sy6WR99mWPEiCUoFZG+mVM2PbbhDfrjL9z3egDCqfV/UmMp++gVgqIaepg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795036215;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=A8wtE+c0M0WVYpjDOwy6Gzgc0hYepl7bD/KWvxSHp2Q=;
	b=lq1hUGIJ/LE/rps29osWxkkQRJOKbhd3YvY+hS7uOZBLJrw9tOV0BWuHLr+hOXwAcO3b
	 6UazfuV5cr070yY6qEd/yzVxEWWs11x7WQ8A51x5cgKMFqA5MFwU0/2G4hrsLYfiDXC33
	 oRrxZ6C1DLHmrdbWLb9LetS3vlcxWic5f3K5//TdyJWLX0RX1xKa2qYAUvqdKrGA4S+dN
	 KjgLznObPdSmJFE6pwb38P+kL09wYxgfGglT1VuR0TQTCM0HoEcL08BZffGW/R0GKNFX3
	 IGuLDSV0EiHVVzT+brtvllOGv0sjUnGnKd9joVVDz6klO/w1pypPB9cPA8WR2UoS3ng==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ruPd4mCX;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AC3F606A33A;
	Wed, 18 Nov 2026 21:10:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ruPd4mCX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE84A1F000C4;
	Wed, 18 Nov 2026 21:10:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795036215;
	bh=A8wtE+c0M0WVYpjDOwy6Gzgc0hYepl7bD/KWvxSHp2Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ruPd4mCXTwRXDgRAK9p3O7lMaW1dxjTzxmowCAZUc0IobH2v8Ifdg/50Y7mNrLqdN
	 kW9t73j6SmFp/qoNbBHhF7c6QSysXzNxOVeSW3dRc7+vU9u/vstagUk+TseS9G+uKU
	 daq7pDGkfKNhK6vObzDqvFJbML+6T7Xq7XQ3oJpI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikulas Patocka <mpatocka@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0981/3318] dm-writecache: fix a crash if we attempt to use non-dax device
Date: Wed, 18 Nov 2026 15:26:43 +0100
Message-ID: <20261118150349.182716201@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 5110b352036a2..e2c81dd236419 100644
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



