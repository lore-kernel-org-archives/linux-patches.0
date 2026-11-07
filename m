Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062393;
	b=M8u2HhxZbl4adhwe/3y58sU5gRieqDvLyR6aGPMvqnYYO1ag2uPod0czOHQV/66Mc3jv
	 ZEer9cNu4NAOx9md/MPdvZnQppfd0cUtBAN2Y3n8SB/r6fyDcz2AtKup0EA8vFYy6LrJt
	 KE5ZY+DEcZ91GxxVI44S+gWvBv4fjPjve4RPeFZVZC+mv5yBKxwgUbqogl+3fWAbXed0q
	 AlLGERBnvAaegOuqixE++6fw01fMcOw3/bop1ijBUNRTAT7txoDISdmsGX1yb/FROxhhA
	 CZJrS46jphPMehGmkUAAf5wWvNLSWyxuSZ0IsoyBtnI4np/jUlBuP0OptKvK72lCrrA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062393;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=JLc5qqXSY3VReE5FnhHhwR5SmXByyeLhI/MUZLsYcDA=;
	b=DDZYcTc3UViCD0MFKnS7uJ11mUtR+NZZrNCH6dMWjxGljAN+UxLjjDZWDi9ggMXfLiCS
	 LK1JP+75nI53EifL4dFEhZX8YbqTHHHunKWcNq/WW8QCIIj1w15Df8DNX12hKhKGf+gQY
	 p3SAUODgR7Kh0KHhN09DwywnGbt/Mm5kW8tzf+LX4WodPVwKG1UQB4SL9iGPLfCaZlJ0G
	 ISeJxv8GeQ+b31Srq26aiAREeiRLxDwGrX7fuBiObCcEz2CK5I7N5Ve1T5EQX5o6gd9lH
	 Bgv11qBDOW4mPhfHkV1I+24NgJVdfPHMq8lt0F++Gm2Cz+9kbB3Pk9Af+WzRyJzM4aA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=es+OhjPi;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A93FB608361C;
	Sat,  7 Nov 2026 14:39:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=es+OhjPi
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 515F01F0089F;
	Sat,  7 Nov 2026 14:39:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062392;
	bh=JLc5qqXSY3VReE5FnhHhwR5SmXByyeLhI/MUZLsYcDA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=es+OhjPidtpKaERkPCWt9NZ+O4tM39kTgdNkqVB6aun6rhyk+4p7uw4dvlQUOE4+A
	 XnaWTQqCPhfIzXzaES6kpVtObzxYfCUSfGlpsF8zYYxday7wHaxJjXi273Zdpwo/Yo
	 0mZc7q7IG9wjjCmH7owYufrgugDEmVHaiR4HCbyQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tal Zussman <tz2294@columbia.edu>,
	Andreas Gruenbacher <agruenba@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1311/1536] gfs2: fix the escaped block copy in gfs2_before_commit()
Date: Sat,  7 Nov 2026 08:55:27 -0500
Message-ID: <20261107135034.619397497@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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
index 314ec2a70167f..f86683abd0f4b 100644
--- a/fs/gfs2/lops.c
+++ b/fs/gfs2/lops.c
@@ -693,7 +693,9 @@ static void gfs2_before_commit(struct gfs2_sbd *sdp, unsigned int limit,
 
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



