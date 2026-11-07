Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063125;
	b=XLLhbceogSZN9dVXF9clhSAspL661MAxRtSL4f86ju0uvwTHsNlr9CTvBYfVl4SQ2QOm
	 tuKXrb/um6Gt0wEhDMWRfA7pshNlz8675nb6H3G3TPqzqHnE6EAiybpQWSHEXchMJzh7S
	 sLJ0E/EMNtcTshKmUa2KRIq4syfEDbHQ9p1Bx6lrro554udZnB5tlgE9fYoL96Tq8TUZz
	 teQw/B7FGIaU+2stGISgneFYR+B/GFOtK82OMNGBDyXbjZA7f4IBuQzVYw5Q6jHF/uW40
	 MLiKtOnzTY/wSfzD5PqAezhAYjTMgt4x7AFEA3MNpFOGd50llt5uSG7MLmZfyIFGewg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063125;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=UIDAsNQ8Y7Nw+EvX0S2+JszGBg/+vZNQlqk9bHq+A6U=;
	b=kTrx7p+yFJVkuceTcoj2lDP9k/HRM33EBSWWvdnar6gmIJ8TOPZzpzHD92//siA8hbmR
	 GAFeRemb8t1nhK3N1aJi9mZ8Dx7hXh7dM66BUF6WRGqqzzvq0j7MHlLVv8GU9AcRgEJZk
	 P4XR0xDmp4S8bNEck9Db7MQMFNPxIHwtUC7XAeq2tBbcnZ3kH5BVESwmOckxWHsJARf1I
	 +611ApDY2SaK7iITcYUcT42MA39xoTH9+++xN19wfr12ioLeQoAfW+7Ojk3TlwSAx66uv
	 NkJ7Y6WfEcaFOzhLanb0neLUhcQkkHx6+TUcc/jVsoJ9ZeX5+5jfuwsclbTWHIrFWxg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TrDLQUx1;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 354D1606A330;
	Sat,  7 Nov 2026 14:52:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TrDLQUx1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6E471F0089F;
	Sat,  7 Nov 2026 14:52:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063125;
	bh=UIDAsNQ8Y7Nw+EvX0S2+JszGBg/+vZNQlqk9bHq+A6U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TrDLQUx1Jv/872YFEklKmaHtIUvTB5ebqzMakcyNTbPVj7X1uQSvpztatuKlNOqED
	 Ay8jPUkGiz1yoofXYCQrmHpGMDRdsv5vDbciPEwloSNFFFBKRmjzHxGI4R05+UqCEv
	 gOSghPpRpWTeVdLVBpivMJU+bnQvretUyhO5asSg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikulas Patocka <mpatocka@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 316/869] dm-writecache: report I/O error if flush failed
Date: Sat,  7 Nov 2026 08:49:58 -0500
Message-ID: <20261107134903.206884321@linuxfoundation.org>
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

[ Upstream commit 78a6afc2999d26e5a30a56db77db34c22b88f5d5 ]

There was a bug that if writecache_flush fails due to I/O error, the
error is not reported in the FUA bio. This commit fixes it.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Assisted-by: opencode:big-pickle
Cc: stable@vger.kernel.org
Fixes: 48debafe4f2f ("dm: add writecache target")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/dm-writecache.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/md/dm-writecache.c b/drivers/md/dm-writecache.c
index 34148aa4df799..1e32053c27172 100644
--- a/drivers/md/dm-writecache.c
+++ b/drivers/md/dm-writecache.c
@@ -1493,10 +1493,13 @@ static enum wc_map_op writecache_map_write(struct dm_writecache *wc, struct bio
 		}
 	} while (bio->bi_iter.bi_size);
 
-	if (unlikely(bio->bi_opf & REQ_FUA || wc->uncommitted_blocks >= wc->autocommit_blocks))
+	if (unlikely(bio->bi_opf & REQ_FUA || wc->uncommitted_blocks >= wc->autocommit_blocks)) {
 		writecache_flush(wc);
-	else
+		if (writecache_has_error(wc))
+			bio->bi_status = BLK_STS_IOERR;
+	} else {
 		writecache_schedule_autocommit(wc);
+	}
 
 	return WC_MAP_SUBMIT;
 }
-- 
2.53.0



