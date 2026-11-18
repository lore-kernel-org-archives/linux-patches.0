Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795046105;
	b=HzBdG9r029n/EEulXgC6YF2HVuXBlzv5axjdWjO2YMyXTUf2f9CRcCgDurIArh8XRUm7
	 MF+LF6xPvY8DL7pcZC+huJLpiAn3Rb7TcIzXtFyffSVePe5ojM8l/nkRVzzCcZc4kG3Vb
	 nMad5sPDZJlfZ3+XphhcyqK1Y6wup+DU3/vQWGlk9XdBp7V3gATcpYwDPlfRt+g8UIdzc
	 Lz0IupY+Z3gRZIpZ8W3tFICIbGi/d+ec+sRn40FUq+iXkLcU344dj1PizhGqk8PSpUSbN
	 BrUrb/94JkuT4JftcWckWfxEvPF+74GTg4hgiVvifKbIovvW1qxyoRpJU2JR1OkvEtw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795046105;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=3rMBtiQ4x1B0zsWWffuguAyTu94QtzoyV9VwrAq85iQ=;
	b=rIezzSzP100ueQmOR9wRdHd/KTsuDmxUEcxR5UfKO9jgvaMFLtupqlWXeQIJ3IUKDTKP
	 hrLkcbwi5UKO/1FxCSkx/byMpk1I5xwsHCaNgB6JU71MmBbBD0oMg5wwJQ1CVdmnDETcK
	 HqhjWh55+Za/l8ldMnSnN2JUEHoGxfu2Ayb1LxQaOpM7CdFSb6p7NSgsTISU84QmaW9ol
	 rIY/vmruLTSsYHu/OHXmbgsAQVPUw3yNAENYLow36dgepdSb3R+6kRbrjT3mbAuCMzmFt
	 6URWGgjY3IFtsk1GCvA04fZYhYFngUecvTbWBmI19t/RXQaGLxGWzNddtUHL2DFuhNg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ymxl4LoN;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F732606A31C;
	Wed, 18 Nov 2026 23:55:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ymxl4LoN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E44EC1F000C4;
	Wed, 18 Nov 2026 23:55:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795046105;
	bh=3rMBtiQ4x1B0zsWWffuguAyTu94QtzoyV9VwrAq85iQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ymxl4LoNQq9DF13D4/a4Mw4DGCoBDEXbDD37JHI8oITEtu8K2kQ+wah1WDo6pcfuW
	 nMpVgB0JI8Y5ADxjuXOkllyJbXS/hYpY4pKkA2TxIj7VxiCoEmjefohZ4V6cFmO6HB
	 vCx/s/EgvYkWvUVArqz25KWo0b2ZaBRLyv1Pkj0k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1121/2857] xfs: check for buffer overruns when examining local/remote xattr entries
Date: Wed, 18 Nov 2026 15:35:55 +0100
Message-ID: <20261118150241.977808067@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Darrick J. Wong <djwong@kernel.org>

[ Upstream commit 91c41f9524906a8ebd2ae68c98a07b4bd5255ddb ]

LOLLM noticed that the xattr scrub and repair code can walk off the end
of the buffer if the xattr entry record starts so close to the end of
the buffer that there's not even space for the entry structure itself.
Strengthen the bounds checking here.

Cc: stable@vger.kernel.org # v4.15
Fixes: 13791d3b833428 ("xfs: scrub extended attribute leaf space")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
[ sashal: adapted checks from separate local and remote helpers to the combined void-returning xchk_xattr_entry() function ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/xfs/scrub/attr.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/fs/xfs/scrub/attr.c b/fs/xfs/scrub/attr.c
index 6e14c9fc726dd..dba6b6bf8e3c9 100644
--- a/fs/xfs/scrub/attr.c
+++ b/fs/xfs/scrub/attr.c
@@ -281,6 +281,12 @@ xchk_xattr_entry(
 	/* Check the name information. */
 	if (ent->flags & XFS_ATTR_LOCAL) {
 		lentry = xfs_attr3_leaf_name_local(leaf, idx);
+		name_end = (char *)lentry + offsetof(typeof(*lentry), nameval[0]);
+		if (name_end > buf_end) {
+			xchk_da_set_corrupt(ds, level);
+			return;
+		}
+
 		namesize = xfs_attr_leaf_entsize_local(lentry->namelen,
 				be16_to_cpu(lentry->valuelen));
 		name_end = (char *)lentry + namesize;
@@ -288,6 +294,12 @@ xchk_xattr_entry(
 			xchk_da_set_corrupt(ds, level);
 	} else {
 		rentry = xfs_attr3_leaf_name_remote(leaf, idx);
+		name_end = (char *)rentry + offsetof(typeof(*rentry), name[0]);
+		if (name_end > buf_end) {
+			xchk_da_set_corrupt(ds, level);
+			return;
+		}
+
 		namesize = xfs_attr_leaf_entsize_remote(rentry->namelen);
 		name_end = (char *)rentry + namesize;
 		if (rentry->namelen == 0)
-- 
2.53.0



