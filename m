Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063127;
	b=hIPjMdj1NgC2+MUxikdSo3PI2Eza/qp6aMTnge2F4xGXmRzLRTf50GkZzYYceG3gXgJt
	 332md8IONnvwqZYs87IvoxG6UoVSoiqPI8vm9p39N4WpvBVKvBn8lOL3UAa9BiAsjtKVY
	 Zb96i5dKtytM+5dgFp74ZSDVtbDubSwJBLSjr38lWzfSjPx/WbXqiLGqm+87THwGyJQf8
	 T6gPtlFDM+e+pjrlf1rjb6n5AQrKpkQyd8qYL5pCBNc55650+/S9T62JOb14wOhZYA33F
	 +7K2qAvgHndPiRA6mYz6RKuQ2yJTLzBEHrOXn7C78lAJcqIGtSg+Fd3LhGu5bmRme+Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063127;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=YD+7dxHZzX5bpQnC+v6pnlhIFZOPLghGcpII0z6y5zU=;
	b=sk7kVRleC8+yQ7dn0U/qd8FT5aNp7h7T9t21xLNkP920Li3D9DmYdWsUYa1hf7ZZWZS4
	 8fapug+NBPbeDqd1+95gLEl/KiDIPyCWkRxZ1G5E5C6GFtAUaTBfHcxxmmUVdhaTKr/22
	 wZ163GP7Yif1TXLxO1oemFRmLNdWILMYOTc4FWr82QmvX7qtwQ4GfZsnI7uDgvaPJEWC/
	 A1m+/oBW10OCEyIjaYawKtBIW+vPbbBV0pCgpSkHijpgHOTrKBO2gC3f5Hs+xF0xJvzm7
	 lXTELq19P9hdRwUUi7k0634idOv1RIHJVzKiwX3FR0CCqzmS6BzOQStDJuqkxd1kdcQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Kp+SXQil;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4524606A330;
	Sat,  7 Nov 2026 14:52:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Kp+SXQil
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F9E61F0089F;
	Sat,  7 Nov 2026 14:52:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063127;
	bh=YD+7dxHZzX5bpQnC+v6pnlhIFZOPLghGcpII0z6y5zU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Kp+SXQilMqKzOxDOLtjk5c0BV9zs+z8Q/JBUDDBlqo3UOdyINRSWH79hz01ljnd3G
	 Lx8AmTyphjyeLc/qomEBU6wifT2ckZvWRswq7o3sb8EJQxso3QCvCm4I18Nbc08P8S
	 NV8biUY7RX/pbJnqeK+P8fWoYLGe8w4K2eH5KNOg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikulas Patocka <mpatocka@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 318/869] dm-writecache: fix a crash if we attempt to use non-dax device
Date: Sat,  7 Nov 2026 08:50:00 -0500
Message-ID: <20261107134903.266237425@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index d29f6b3abce4d..d3f93a871a142 100644
--- a/drivers/md/dm-writecache.c
+++ b/drivers/md/dm-writecache.c
@@ -2511,6 +2511,11 @@ static int writecache_ctr(struct dm_target *ti, unsigned int argc, char **argv)
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



