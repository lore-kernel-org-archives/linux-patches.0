Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795055068;
	b=y5wyskMmTYPq8Q5FJVVl2kw++CquTvMqc9OFvOHh43+woh6GwIh3084mQy9qUZ3BMTXP
	 UqdT8I+QvepcHISDP79789Bqox4RDcskKxZCJOxw+R+es7idOxlJtAxjf2zujofSKXglh
	 K3sq1X9/7r4y9Ff9Hg3dOnEcLNBUxflqGR0wPpfEr1OSQWXYcBavRLXvNBQDpV5dB2XwI
	 FPhWiDbaP8MVPrD6Mgl8YswNeHBg4//CC5a/mk8hzDTzrA2kAFUQi+Z42X5F8cQGu0/Me
	 ZjcQT8KG2gPaBxVR05olWvr95vjlT9/7iQFORTh9FWR0JQHUU4kxbCJJ8WpTXFCy7jw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795055068;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=DYk3DnFZmFj8qAoqUWTDY7CAOzMWB2ptRNhpZT9va0c=;
	b=p6ugpdCt4il59RYRnYtJ8Qp7/98KfTMP2dJlFUcoGWlMlppH87AyUFNj48t+qwVx3V1C
	 lmr5qiFFoXjn7PzYS/ORYdw7DS725/krh7aFtEhVsIUac6NStN29XPbyuWCWcQaSXlT3R
	 rlavBnvuUDu12W4spK3ELAWZnQUWF6HUY0alaUnRtemAoQiDbngYffKUCiMJcZ2U2KB1/
	 YGCaphuBumSwttul6zNEd995J6U+6tgoaSbTLbl8pYdgurTtBGd16YH5JeeFjrGdbmx4O
	 2GindcUy5l1hEoF6YGhyAOrpvSNxYqb5cpDAtrS0BfDFxTOrspxTR6DJ3wWTZp4278A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=D0mAdw0y;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDAE0606A325;
	Thu, 19 Nov 2026 02:24:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=D0mAdw0y
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 525C71F000C4;
	Thu, 19 Nov 2026 02:24:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795055067;
	bh=DYk3DnFZmFj8qAoqUWTDY7CAOzMWB2ptRNhpZT9va0c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=D0mAdw0yNIx4+5TphoO/WjUg9li5byECsuGm1wP9yxtOA8ht/9NvY5Y3k4iKgbGkB
	 PZWMYqkrJkaJ02oi4f9FQYfHedPlOY5xDSraiMbMmTccXwfT1k2J87I54ZDrselvQX
	 NWmVU3ksytwfvA1Qaqz2Q5uQdYksPMOsmVyw9M3g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiang Mei <xmei5@asu.edu>,
	Weiming Shi <bestswngs@gmail.com>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1498/2214] fs/ntfs3: zero frame pages on read error
Date: Wed, 18 Nov 2026 15:52:54 +0100
Message-ID: <20261118150111.598056726@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 07e6ebe736da3..c358e3d632977 100644
--- a/fs/ntfs3/frecord.c
+++ b/fs/ntfs3/frecord.c
@@ -2701,6 +2701,8 @@ int ni_read_frame(struct ntfs_inode *ni, u64 frame_vbo, struct page **pages,
 out:
 	for (i = 0; i < pages_per_frame; i++) {
 		pg = pages[i];
+		if (err)
+			clear_highpage(pg);
 		SetPageUptodate(pg);
 	}
 
-- 
2.53.0



