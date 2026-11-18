Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795039737;
	b=2ItbJMVBChBrOyZkJnY770h6V0YppnyE31hX5itmVBs6WUZ88ZElIrBEwKUEZxaVKKKT
	 lqa1N3NI7CfjG7KwR3/noGLZ2QLriR6NDLR0LxC/qNhr7BELIcMspWo076dj+yOSKyyWI
	 ajcBjQbl0J3eotfvH98+VgrCArbV/VaGMeoBtS0TzNAmDBO5K1rKIDaggFNo4ppLy1lc4
	 pbQiiR41os+5VFUVq6UWccfG+l9nJo6DreUuR+CZKgjHnGx4NtnO48VWy1Oa0h4JTrF49
	 hy62X7xKBMQmHvch2Au9ncj1WpSzX0KffaXf7s6plJAdGDxnYfDQLu2x5l+ccNZVpVw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795039737;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=sTsOSZYTC9rhJfqFpYyz1iwU736j5wseewktTFDM3XU=;
	b=Y1hfwpM2OSBgDnaxntSsHXQZWO5+9EXbysH25OKq5Y5qmhbmd0pABOysxYEsQGYiu4mX
	 luW4VsnF/wCxrzLW/WJadBU2IAIN79RjufdeC16UPB15tFK97XJIm9hDuhcvBsqI0egFC
	 HL7R4iNS4nn+5LpDZkB3VL87dlLxlx4JsqdDVkjvLW8HuRhdllgfxXVSLgdkwY8Xr1Nzh
	 DtY4erl3eAkEvIDuqq3PjUT1kkCz82zi9GGef+zx75ShkUqku/SbZV4hFrbJeUeaKCcOp
	 GWn66X3pOxeQ6IpqdTYsLQNe4KFVoNP5gWMm6pXOZkrHT3ixdDl/oVcu0tMtn4n8hMw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=m1sXHapv;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F8C1606A31C;
	Wed, 18 Nov 2026 22:08:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=m1sXHapv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D38EE1F000C4;
	Wed, 18 Nov 2026 22:08:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795039737;
	bh=sTsOSZYTC9rhJfqFpYyz1iwU736j5wseewktTFDM3XU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=m1sXHapvEl/g+m4bdvdLPzbpTvXaGkErHEa/b0HNuOb3ZE/1BucHXYwojIc1xJhGO
	 45lhx0Q1jIFi2iu3YaY5b03GkS7+Wy4z2MOtWTCArGY/+ttJjHsJafiMoES8oQUr6l
	 n8aee8dwbfdEXnDLYJMT9s4GhBZor2dW9YyXVWYY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiang Mei <xmei5@asu.edu>,
	Weiming Shi <bestswngs@gmail.com>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2207/3318] fs/ntfs3: zero frame pages on read error
Date: Wed, 18 Nov 2026 15:47:09 +0100
Message-ID: <20261118150428.131160666@linuxfoundation.org>
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

From: Weiming Shi <bestswngs@gmail.com>

[ Upstream commit a32e893a077a4b0d3b04c86cb7f69e354a187995 ]

ni_read_frame() marks every frame page uptodate at the 'out:' label
regardless of the return value. The pages come from ntfs_lock_new_page()
and are not zeroed, and several error paths reach 'out:' before anything
is written to them (e.g. a failed decompress_lznt()/decompress_lzx_xpress()
on a corrupted chunk, or an allocation failure).

A page marked uptodate is served directly from the page cache, so a later
read() of the file returns the uninitialized page contents to userspace.
On a crafted compressed image this leaks kernel memory, including pointers.

Zero each page on the error path before marking it uptodate. The success
path is unchanged.

Fixes: 4342306f0f0d ("fs/ntfs3: Add file operations and implementation")
Reported-by: Xiang Mei <xmei5@asu.edu>
Assisted-by: Claude:claude-opus-4-8
Signed-off-by: Weiming Shi <bestswngs@gmail.com>
Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs3/frecord.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/ntfs3/frecord.c b/fs/ntfs3/frecord.c
index 32317e127f5a9..3e3c9caaddf54 100644
--- a/fs/ntfs3/frecord.c
+++ b/fs/ntfs3/frecord.c
@@ -2757,6 +2757,8 @@ int ni_read_frame(struct ntfs_inode *ni, u64 frame_vbo, struct page **pages,
 out:
 	for (i = 0; i < pages_per_frame; i++) {
 		pg = pages[i];
+		if (err)
+			clear_highpage(pg);
 		SetPageUptodate(pg);
 	}
 
-- 
2.53.0



