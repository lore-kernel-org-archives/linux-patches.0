Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB7283A35A4;
	Thu, 15 Jan 2026 17:06:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768496787; cv=none; b=oF+qWNNewV2ARmk9+c3Sz/lEAsyRRlZVij87MnOnZ5jt3UCTFi+e6usIP+s/LZLibOWitHZZBqJ2pGBfxCy4INvi8USqMwdk+NonWf1vo1C0dzl2ulse9bw4+S5UkyY3sXmoFQ+hpKVo1c86W2jnqMopGXVbFkbLrDLKu68Q3OM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768496787; c=relaxed/simple;
	bh=5Q2VVg4hL3/I1UET6eH6gcRvhWTdUhKpSiuSXQ7DXWc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IEIV3YYkVgOc0s/FvDH+VzNFOaKv31V9U55f7OpVMpji7/BzyyjN02MkTm0RTOPMIQs16F9epElaKRrczTqJwvX8fQVTd66UogDSs3Sda2S9A3+1DpIkGtdamwEeld89d6dNj5KFkR6wKdNXUCb6EX1qW/OvaK4wFsFOjBc+uMI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=J2TgkvI9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J2TgkvI9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 660D2C116D0;
	Thu, 15 Jan 2026 17:06:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768496787;
	bh=5Q2VVg4hL3/I1UET6eH6gcRvhWTdUhKpSiuSXQ7DXWc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=J2TgkvI9F/otdazGae3g0gUZIzbTDU9u8+nLTpHz/F80Ya21/QHgLhjV7UFlHZclG
	 hOOQbi5GNotLJOrIE9yNwpI9sRMKQbt6Nx7fyIfJ8aWnqB79BeMdJ91LlG9CRiBxz6
	 DkVsh81EXpglLHBoUp2jVQkDEPHYMp8f9OS3iT7s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	ziming zhang <ezrakiez@gmail.com>,
	Ilya Dryomov <idryomov@gmail.com>
Subject: [PATCH 6.6 16/88] libceph: replace overzealous BUG_ON in osdmap_apply_incremental()
Date: Thu, 15 Jan 2026 17:47:59 +0100
Message-ID: <20260115164146.905939644@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164146.312481509@linuxfoundation.org>
References: <20260115164146.312481509@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ilya Dryomov <idryomov@gmail.com>

commit e00c3f71b5cf75681dbd74ee3f982a99cb690c2b upstream.

If the osdmap is (maliciously) corrupted such that the incremental
osdmap epoch is different from what is expected, there is no need to
BUG.  Instead, just declare the incremental osdmap to be invalid.

Cc: stable@vger.kernel.org
Reported-by: ziming zhang <ezrakiez@gmail.com>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ceph/osdmap.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/net/ceph/osdmap.c
+++ b/net/ceph/osdmap.c
@@ -1979,11 +1979,13 @@ struct ceph_osdmap *osdmap_apply_increme
 			 sizeof(u64) + sizeof(u32), e_inval);
 	ceph_decode_copy(p, &fsid, sizeof(fsid));
 	epoch = ceph_decode_32(p);
-	BUG_ON(epoch != map->epoch+1);
 	ceph_decode_copy(p, &modified, sizeof(modified));
 	new_pool_max = ceph_decode_64(p);
 	new_flags = ceph_decode_32(p);
 
+	if (epoch != map->epoch + 1)
+		goto e_inval;
+
 	/* full map? */
 	ceph_decode_32_safe(p, end, len, e_inval);
 	if (len > 0) {


