Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795036613;
	b=VsQwsqbPS9aTfLhRWH+9MuGjrSiM3BSIJXox/dIU6GLmoqv0k9zE59YxYgq3l6LjeLbm
	 LLyRF9SWz7Qh77cdzYs9TsFURbTxzZ9nhNEvjQKu6AuFVUHUOhB01pYsX19wItgSAo9EJ
	 C1dmZHSNMT05bphTJhOk7qIfmlGEJOEw/+/xQYjF0VPdZBLEmGUqkwykXXPcoKZwx7aow
	 tvx7HEa1UyAymzpIMXEsDDJmwCslE3SCGbtl2IETqUAz3KMje5R5nOS0HlBA8bsLkL+VQ
	 Xmgcz+P5P5KwfT5hYoqNELt0/upqwoE0Oa8ZMPm9hG7gfaAl4xFQJoGrfERNUcTd7Ew==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795036613;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=kc0DiB3N7q3dqw+bkT4MHkrVZZ6f9KRA9/5ejHAzzGQ=;
	b=W/sDQGnG9oy1tcDZ8+Ge9W7yF/qopou73KaVa1bjBPsQNJl/XEVTVU8jTfHFAwab3bEi
	 t66TZVnriK2flbDiplkw0i7POrW/peQ+tI6FlomBckC6WrbtuIE1ZJgml5e9JI2VyMdwA
	 +j2pz0SN1VHLG91jWsNXNClz4Ur8mLlOw/SqT9WX8MHgac6LNDj6E2Dwr9pUDkaud7gZf
	 U4GHxE7Q6h3mWz+GLZl69BN0jZ/BO0saCYCWpelVWl7qBXRLPr/fgQoTvaLuIJisAXLbb
	 QUnW6eFexX7n8igjdO2hTpt6HBxtLHM4GNWQ+rNsTMpkQ/WxFiBFIyC1esIu1WE/FSQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="z9/Mw7Uu";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DBB9606A320;
	Wed, 18 Nov 2026 21:16:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=z9/Mw7Uu
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95EE81F000C4;
	Wed, 18 Nov 2026 21:16:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795036613;
	bh=kc0DiB3N7q3dqw+bkT4MHkrVZZ6f9KRA9/5ejHAzzGQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=z9/Mw7UuNwTReE56EHRUZGtn25nvhHqNPFviUHQnLkYUqdLnT5Ic8NHVcwTIJ1P7f
	 0H7yG7QCLDfuK6aQYS5Zm4tVuTBHpGboa1qoCvysawruCUIUNilIMcnzvGce9nUv5F
	 3/PsrGRjbDxYJweyGjsILD7kBZSyN8j6V8he5nAc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tal Zussman <tz2294@columbia.edu>,
	Andreas Gruenbacher <agruenba@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1123/3318] gfs2: fix the escaped block copy in gfs2_before_commit()
Date: Wed, 18 Nov 2026 15:29:05 +0100
Message-ID: <20261118150353.724996108@linuxfoundation.org>
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
index 483f698070622..2978952208173 100644
--- a/fs/gfs2/lops.c
+++ b/fs/gfs2/lops.c
@@ -700,7 +700,9 @@ static void gfs2_before_commit(struct gfs2_sbd *sdp, unsigned int limit,
 
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



