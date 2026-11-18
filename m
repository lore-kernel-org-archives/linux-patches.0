Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795033189;
	b=OK2HhrVnAzZ+ghlv3LLfuJM0W16rpjpvA/zEZC6jdnItDqm4KF219CDVubX5ldyO8dxN
	 YCkh6Gr6krTTMVPrzPO713T97nKcfn8wQN989i6h2KEuURbn+DTLlnoUBu4NPkP5xSmj4
	 EgaaxCXKGzZqJLW5E2rXNunbnfWSQtlo1L8eHyhqfbcryokYM7cTrrd6ixjzXCdzGZ3Of
	 bOySlxHuiCuzLjQMZWcYaHomYrrnE5Hi+rSU51zq/MajbiUmMvDVwcZvvcxHHeoxKKrwj
	 EHQq0TMcNzQJRHv06hPyMVc/gUunpklJWQP4O53J57SnvgTULxKACp+vrhIVMj1KIOw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795033189;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=i4F9EdjlOYXQZuihGjCIVhqbA5C8eRvL3Pz2zkb5eME=;
	b=3AzWf5wTEkCZU4nCBeHegzSJvVKqkQAkpkYvZtEQNQHXE/0m8UDvjIjccOnM0mDUlVUS
	 8CEsZMccLGjK/z58CaN+ENLbvWKgbQcVbZ7L6uiOLxTimLKKECmepjP+23/KZizO53Awd
	 mXfQkeN5Us23DG7MKtOiBB1FJZP3aBHj6VL13HbAa+5BhGTcQmyPTfYVVtpI0KU6wmdjd
	 4/Jdshrdaan9JsXWx2LxhlYgUJcXnztVf10KTlcUPcQmf0j0bzXiLEJgyvnJPsJVm36Wa
	 PWXr4z/Yh1f/gZ9QjnJJwThg09Hp/gnWQNNjkiFjgwkcxAJ4Te6fFf7JDd5JlXSj3/Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZWNZTBrH;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FF10606A333;
	Wed, 18 Nov 2026 20:19:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZWNZTBrH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 285861F000C4;
	Wed, 18 Nov 2026 20:19:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795033188;
	bh=i4F9EdjlOYXQZuihGjCIVhqbA5C8eRvL3Pz2zkb5eME=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZWNZTBrHTGtR4nAcpQMnDEPFqo8PM7Qga6nRq0KQxdk5ee+VKhiIHzzZuEPRsKlJN
	 EZLMYWbPu2xmkDJc0Wzln10KggEQ5UC3w/YC+oVYSbM1LwAc6mHGAzL35Oj7VvrZiz
	 xsNMv/rdPfcinGBBbSAJddl5/ecQE2nExCB8SF5E=
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
Subject: [PATCH 6.12 1678/1756] drbd: take req_lock to skip the initial sync as peer
Date: Wed, 18 Nov 2026 16:03:25 +0100
Message-ID: <20261118150116.508473932@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index f85ebdc3cff6b..1f3760bbf15d1 100644
--- a/drivers/block/drbd/drbd_receiver.c
+++ b/drivers/block/drbd/drbd_receiver.c
@@ -4284,8 +4284,10 @@ static int receive_uuids(struct drbd_connection *connection, struct packet_info
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



