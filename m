Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795022241;
	b=Gx1o3FsUnEUKb73J0jQoL4gsaoBISnwpPC0QrLV6peqyifBq3KOeskib+RL9+tDnv8GH
	 BJMTphxy6uS7cNIsnUtcEKFEi7LuxhlmDo6gUz6LeJoX9uQQ6WzqnQBwvCB9KFp1Z2IlR
	 Qyt4LVhqqlu6Upu0dc5Gv18vMQsrgiijP0H0Gz6edvr5r2toJOh35ufwsvIB+qCITj6S4
	 kdWeh1or1u+aY8ZBKozwS0QT6w8uxJgQefK158sDsrMadpXxYpciVZ8ule8K27QnLfxTq
	 f0h5Marzyng9SUifhgm8e6iKNweby7f/HFFikM2sb+43S90q2cKp4DMK/pAOcvbcC2Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795022241;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=vcpGagi84JJhzbwvmOrz+n65Xt8fecPVPUKr3oypDOA=;
	b=r7v2k1oyGLBT1YX4b6nCsho9maQol6PE6iJpdwhtNwWcmX7VIbIMFoEdk8sVHtJT9fh7
	 ptskNTk6a5Z9ZDAU9tHEE6PtJxYQhp5h+u8zMTMCSSgbGkjcHsXzMJWObcS0DAak4ED99
	 hfHV2QePM2PtwQAI3K75CzqYsQTe1jj8YyUgXtJKaQWa2R1deyHiHe1jkppuXfhqoU60F
	 c6WeWua5NGkjRg0K4MGfv06txIt92XnXDmLXX6nH+943CD2oOFAGsr5F1RIf8b4fStHdA
	 ePhAIXhsEyCVp/+uvIcSkFHvbs7QTnFKOFQccg+r/fHXvERDHrqyb9YiEgbJjKb+tAA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tBZ+DsRT;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB768606A320;
	Wed, 18 Nov 2026 17:17:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tBZ+DsRT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2363C1F000C4;
	Wed, 18 Nov 2026 17:17:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795022241;
	bh=vcpGagi84JJhzbwvmOrz+n65Xt8fecPVPUKr3oypDOA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tBZ+DsRTCoZ/lnLlVqOTzIHXcbcKMMw7v19S3L7/4nrCzICmEjmrdEKDNSzu2Bj4g
	 3Ed7tv67xLuaC5zJUkfCVMyfWYX4PO7EHgxk9jB4jZRPMvTciLnxrTmCNeDY1OvT0t
	 zz4lVYPnQNRDaqupyVB4hF1LBdXQ8jDqqUL7kkWs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Philipp Reisner <philipp.reisner@linbit.com>,
	Lars Ellenberg <lars.ellenberg@linbit.com>,
	=?UTF-8?q?Christoph=20B=C3=B6hmwalder?= <christoph.boehmwalder@linbit.com>,
	Josef Bacik <josef@toxicpanda.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2593/2651] drbd: take req_lock to skip the initial sync as peer
Date: Wed, 18 Nov 2026 16:03:53 +0100
Message-ID: <20261118150417.605183904@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Josef Bacik <josef@toxicpanda.com>

[ Upstream commit bf7fff620c890a7ee0b444f1c7e9f0d1263a30ac ]

_drbd_set_state() must be called with req_lock held. drbd_adm_new_c_uuid()
does, receive_uuids() on the peer doesn't, so a concurrent state change
gets lost: the device is Secondary again, or its failed disk UpToDate,
while the work for the lost change is already queued.

Fixes: b411b3637fa7 ("The DRBD driver")
Cc: Philipp Reisner <philipp.reisner@linbit.com>
Cc: Lars Ellenberg <lars.ellenberg@linbit.com>
Cc: "Christoph Böhmwalder" <christoph.boehmwalder@linbit.com>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Link: https://patch.msgid.link/20261028164415.1262013-15-axboe@kernel.dk
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/drbd/drbd_receiver.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/block/drbd/drbd_receiver.c b/drivers/block/drbd/drbd_receiver.c
index 2135c14354a85..a405ccdf919e4 100644
--- a/drivers/block/drbd/drbd_receiver.c
+++ b/drivers/block/drbd/drbd_receiver.c
@@ -4096,8 +4096,10 @@ static int receive_uuids(struct drbd_connection *connection, struct packet_info
 					BM_LOCKED_TEST_ALLOWED, NULL);
 			_drbd_uuid_set(device, UI_CURRENT, p_uuid[UI_CURRENT]);
 			_drbd_uuid_set(device, UI_BITMAP, 0);
+			spin_lock_irq(&device->resource->req_lock);
 			_drbd_set_state(_NS2(device, disk, D_UP_TO_DATE, pdsk, D_UP_TO_DATE),
 					CS_VERBOSE, NULL);
+			spin_unlock_irq(&device->resource->req_lock);
 			drbd_md_sync(device);
 			updated_uuids = 1;
 		}
-- 
2.53.0



