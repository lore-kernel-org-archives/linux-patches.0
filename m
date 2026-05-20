Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CDE6366075;
	Wed, 20 May 2026 17:17:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779297458; cv=none; b=OegAxBuKS42CWuu5S022wLuZx8OxFIswVSc43ESxZIatpZ6pVSAGfZfLG7QLiVfHjH5Mq0IB5a9rbgvqRJk6C2N9Wz8gExo+Lgkj6laHdsRfR/uoUff/MeD26ij7tdQ3rv3zfaJBfLH+I6aBXhNlDoTNsgTRC+cGFl4/yzJS0FM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779297458; c=relaxed/simple;
	bh=3zlyOYt9Iqe5zF7DhrzGKt4aVgGq2axF2B2JAlUvPZA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=EYG/1FiZgshZ/vbRi5ST9Zew4DkBIGm8sUnOWKsfC1oSiOSRJyd5Pm10HPLndxxSrcKzQjXRXS846X3IbJyxAC/C+m5Vl5uSuE8WEEBUMNRkb2FGR8NQQlDfuEQVQBiJoooHdsTXlcHSFCtVKhGC04iYo3ZkBoQAecexL+Z1YmA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=STCxvGjV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="STCxvGjV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA6C61F000E9;
	Wed, 20 May 2026 17:17:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779297457;
	bh=5kaomaYlcHvRKFFOD7ePvt2lJ+B2WAIV9PHkaVL591Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=STCxvGjVQcoxfcn7E0uM2k6y+QauaSxmHwhrGllndXErDWHlwPvi2xWDDKXbKGg3d
	 B8sfrzuWgEq8E3pKYF4SP1FvasX9s9XRxkl2vVINxGF9H8gxmUThC7dkosCbCrSasW
	 pOjNW0GuJ9RyNE/othuWB0cBmsSNa1MWszgeh+9U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Christoph=20B=C3=B6hmwalder?= <christoph.boehmwalder@linbit.com>,
	Christoph Hellwig <hch@lst.de>,
	Andreas Gruenbacher <agruenba@redhat.com>,
	Bart Van Assche <bvanassche@acm.org>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 005/957] drbd: Balance RCU calls in drbd_adm_dump_devices()
Date: Wed, 20 May 2026 18:08:08 +0200
Message-ID: <20260520162134.679912275@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bart Van Assche <bvanassche@acm.org>

[ Upstream commit 2b31e86387e60b3689339f0f0fbb4d3623d9d494 ]

Make drbd_adm_dump_devices() call rcu_read_lock() before
rcu_read_unlock() is called. This has been detected by the Clang
thread-safety analyzer.

Tested-by: Christoph Böhmwalder <christoph.boehmwalder@linbit.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Cc: Andreas Gruenbacher <agruenba@redhat.com>
Fixes: a55bbd375d18 ("drbd: Backport the "status" command")
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Link: https://patch.msgid.link/20260326214054.284593-1-bvanassche@acm.org
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/drbd/drbd_nl.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/block/drbd/drbd_nl.c b/drivers/block/drbd/drbd_nl.c
index b502038be0a92..0ddbf71286a91 100644
--- a/drivers/block/drbd/drbd_nl.c
+++ b/drivers/block/drbd/drbd_nl.c
@@ -3378,8 +3378,10 @@ int drbd_adm_dump_devices(struct sk_buff *skb, struct netlink_callback *cb)
 		if (resource_filter) {
 			retcode = ERR_RES_NOT_KNOWN;
 			resource = drbd_find_resource(nla_data(resource_filter));
-			if (!resource)
+			if (!resource) {
+				rcu_read_lock();
 				goto put_result;
+			}
 			cb->args[0] = (long)resource;
 		}
 	}
@@ -3628,8 +3630,10 @@ int drbd_adm_dump_peer_devices(struct sk_buff *skb, struct netlink_callback *cb)
 		if (resource_filter) {
 			retcode = ERR_RES_NOT_KNOWN;
 			resource = drbd_find_resource(nla_data(resource_filter));
-			if (!resource)
+			if (!resource) {
+				rcu_read_lock();
 				goto put_result;
+			}
 		}
 		cb->args[0] = (long)resource;
 	}
-- 
2.53.0



