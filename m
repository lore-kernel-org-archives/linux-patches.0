Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795032881;
	b=sQm+3aAWl+uZzM74B5KGmEBGhQu4hM6y4GQlMlKlWUJ4yDTQv/B0WV/yEr1uWhknKlBo
	 y3zm18MM/OBxx3/A4eWcSpLJb6UHDWiJjALxy079dYJZqRk73XFlLM9YqNwnG/aDAgHPD
	 pJI047QFjD4TVKofoLPInIoyqFAcc71kS8/9y+5L/iN2dreCX/Q5o8rDJoGbAkQvOMCtn
	 KpF2N67aw37v8MRKMLMoep0v1s7Zj3Y5wHp3eUY3+3GNnC6NlKf2EF3qSqnvRf6MzuzYK
	 KbsObPnIIgFIvWhrHOdMezFTrtSfpTotuSLToIXNMdFXCgNUtbHjp7vh8HurIMBLvnQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795032881;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=X0gLy+PuyQouFVH4NMy3LEj15Geh3eNKenrdW3rjqNo=;
	b=c3cu4dqlva7gPXzuQgPVD9icLFoJnDHg5W2TDAugW4T9htA63Ny1RmwG9fpHKHrF4VSt
	 EE38Qc7UVNl8zYIzRYh0I2qHLDW26n5FceBKQwPR+r44+KU7DtDi+v+V7toB8XYzo1DZy
	 nWRHaZYwHAjTfVY7bokN/G1MibB9c1vUMMLLgNKp75uW+AHfV2u537sQL8wDEstoJ65tg
	 h/3z+Qz2LJnzkl18JWUjQ7qPDtJSBj3unAsAU0+wuHPYrZmNteRhbAnMJwIQJw7VZ6rqg
	 2b0i4D6h36EuUuo17GGHlnz7rY4FTfdqZzQx1CV65eOkEEHqFUt/vWuXrVnGAvmXWBQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tx1R+82N;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1141606A33F;
	Wed, 18 Nov 2026 20:14:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tx1R+82N
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFCE61F000C4;
	Wed, 18 Nov 2026 20:14:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795032881;
	bh=X0gLy+PuyQouFVH4NMy3LEj15Geh3eNKenrdW3rjqNo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tx1R+82NvMDqAL/aRB3tZmXRy3+KpfbdzD5RdtKDbg5QCAfHk5gI7pI49No3O68ve
	 6uIWrm2aSxBD9ajLr1TFfdh1nWf6mPRf12kW0g6a7meLzR9FBsXOacV42yXSTxK8GC
	 PjB0Q/pEsrLka8Hrb5TiVkL5XCYK94l15J4nWAgY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tal Zussman <tz2294@columbia.edu>,
	Alex Markuze <amarkuze@redhat.com>,
	Ilya Dryomov <idryomov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1570/1756] ceph: dont clear write_congested when collecting folios
Date: Wed, 18 Nov 2026 16:01:37 +0100
Message-ID: <20261118150112.225544671@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tal Zussman <tz2294@columbia.edu>

[ Upstream commit 77ff2ba4630b9e9e9f73bbaaeb675638b2c20dd0 ]

ceph_process_folio_batch() assigns the result of
is_write_congestion_happened() to fsc->write_congested for every folio
it collects. The code it replaced only ever set write_congested to true
here, leaving the decrement paths to clear it once writeback_count
drops below CONGESTION_OFF_THRESH. The unconditional assignment means
that a sync writeback that runs while the count sits between the off and
on thresholds clears the flag on its first folio, and background
writeback resumes early.

Only set the flag here, as before.

Fixes: ce80b76dd327 ("ceph: introduce ceph_process_folio_batch() method")
Assisted-by: Claude:fable-5.1
Signed-off-by: Tal Zussman <tz2294@columbia.edu>
Reviewed-by: Alex Markuze <amarkuze@redhat.com>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ceph/addr.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
index 3edb0f7097aab..947932a51aa0f 100644
--- a/fs/ceph/addr.c
+++ b/fs/ceph/addr.c
@@ -1399,7 +1399,8 @@ int ceph_process_folio_batch(struct address_space *mapping,
 			break;
 		}
 
-		fsc->write_congested = is_write_congestion_happened(fsc);
+		if (is_write_congestion_happened(fsc))
+			fsc->write_congested = true;
 
 		ceph_wbc->fbatch.folios[i] = NULL;
 		ceph_wbc->len += folio_size(folio);
-- 
2.53.0



