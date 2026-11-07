Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063413;
	b=KjcgPy1jGnNNqoRYjOPCbl8mvrenhqjCLjsFRm87MUF58SoMr2WxOiXWHEhushbDwtvI
	 ESpKDbJ9P+m4uaJIMecfFJnG1ijB+b0/ECVEYlwuUd2xJr3ZYDsr4wtU1l2/i69PsQrue
	 GvWMe0nsLdYI3iO9/dH52lrFiE8uswM1WVpXzDYXH8Df9oqOd+8keMUfIi82F7e4rLNU0
	 nNr0GG1ymSnR+o6dwi7pPYNsl9i1jRbWvt5On9KwCo9Oujy+L7uzeizlPdkJmggaGLiFv
	 GdPU0xaRpPiSwqSCmlOjI7CvN50hiYWNxIjw1KdB1o3opE+UQq5DNZhUiGQAUAwGCVw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063413;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Zv/CDdg4b0YPNDwpnc0B1ZfeNdlvqeFd9eno7YtAT4Q=;
	b=H9Oh/V1MjbE6L/UjsjsPSg+YlcFLnbiB4319tUcryczXNPCYzba6NEJsZK/Hi11pW2Y0
	 +tCC3tsaXu6tl9/BhG0MayXOQCe3zpFHN+V7+K1sqCb6O7lJiLKfbJNMfTaTS8sQS2hKz
	 oafs36w+rAT6F7YDpv3m/GJBKh7Hu1flXaJ8TRJPod14Xx+Jppa+4WLO6dNXz041shcH/
	 BnrKQj/xMW+2g0b5d+PcRq3DMD9Tu++bSk5oe4ftr0uNm7w/LZXD4A1iU25sYIL7DsBoj
	 MsGKo0arenZYAw+koNWXwsA6GQ+7NXkwWQJBU8Fw9WgbSb9g8Myb2EB5Wl53/N5Qq5g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VONJVfaw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CE94606A33B;
	Sat,  7 Nov 2026 14:56:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VONJVfaw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 983101F0089F;
	Sat,  7 Nov 2026 14:56:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063412;
	bh=Zv/CDdg4b0YPNDwpnc0B1ZfeNdlvqeFd9eno7YtAT4Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VONJVfaw1gy4vXrxm13BQGqjFuzrMz0oi0QVGFfmQdjqit3rnsuXPp/rw1X7WU5Km
	 +WvpmcmSi+YUfYeaeOSkqVG3yC04AEmIuG3KTxnWMvRpccPLtBvDq5D5e9SBWc8uI7
	 7wlCRWO41z1mLunaXhPdxK2x5i7OAAPWy1g0qKyg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tal Zussman <tz2294@columbia.edu>,
	Andreas Gruenbacher <agruenba@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 581/869] gfs2: fix the escaped block copy in gfs2_before_commit()
Date: Sat,  7 Nov 2026 08:54:23 -0500
Message-ID: <20261107134912.878154352@linuxfoundation.org>
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

From: Tal Zussman <tz2294@columbia.edu>

[ Upstream commit 1a4aeb6d6a08af1a2e2c52c84170561625819377 ]

Commit d68d0c6c3fc7 ("gfs2: Use memcpy_{from,to}_page where
appropriate") made the escaped buffer copy read from the mempool page
it had just allocated instead of from the buffer, so the block written
to the log is whatever the pool page last held. If the journal is
replayed after a crash, the block is restored from that and the file's
data is corrupted. Only escaped buffers are affected: jdata blocks
whose first four bytes match GFS2_MAGIC. Copy from the buffer's folio
instead.

Fixes: d68d0c6c3fc7 ("gfs2: Use memcpy_{from,to}_page where appropriate")
Cc: stable@vger.kernel.org
Signed-off-by: Tal Zussman <tz2294@columbia.edu>
Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/gfs2/lops.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/gfs2/lops.c b/fs/gfs2/lops.c
index 0ed81a685fcd0..59e3d295a2a17 100644
--- a/fs/gfs2/lops.c
+++ b/fs/gfs2/lops.c
@@ -690,7 +690,9 @@ static void gfs2_before_commit(struct gfs2_sbd *sdp, unsigned int limit,
 
 				page = mempool_alloc(gfs2_page_pool, GFP_NOIO);
 				p = page_address(page);
-				memcpy_from_page(p, page, bh_offset(bd2->bd_bh), bd2->bd_bh->b_size);
+				memcpy_from_folio(p, bd2->bd_bh->b_folio,
+						  bh_offset(bd2->bd_bh),
+						  bd2->bd_bh->b_size);
 				*(__be32 *)p = 0;
 				clear_buffer_escaped(bd2->bd_bh);
 				unlock_buffer(bd2->bd_bh);
-- 
2.53.0



