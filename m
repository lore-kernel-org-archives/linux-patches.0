Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793828902;
	b=HBSl9gHEWZyVrOPbq7mAgaXuAcuJ10Fke4/XtEFBVJq6cZTM8848uAVQgIVXldTMrMJ5
	 JX2QYorBE7S6fPownw7gmOz86iqvIPcpXvVdCre8SPnMpMuhszDEjyvHJ0ZZny5X8mYmi
	 r8GzM4hodDEE+KaB0B6HkKUMAE80ZD+KhnFRHBTB6G15l8L5L1lx9fyc8oyeuKK8Ui/+Z
	 WnMOAGqfR5qo0juMPXi9O7MVoK9GgqjbKo5OGGnKGjqH60SgiclNBWpH653QEp0t5NJcT
	 ovBepODbW5DqtLn1X40eRKEGzUPLvPyviJYvvmDccBi+I/knWgDW0wGmqnoYa41yjdA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793828902;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=uq/kBJX88M8gVlGp492dCcFkulBT2mZiPTh9HCYFJIs=;
	b=ljdih9deAdgsVP+0qbdOHpxz1MIRuXjwosIbpd4f6Y04me7gRT00g6HLYrcGrTl2i0F1
	 UBQdFRJH7fzgH4jRXdC8y5OA/ZJjVUnFy1EY2dHzZvdnfVdpmZgJKn4aL+/nl3KOkHHpL
	 GJezygK2z5WZzYK/wgeWkhDgBHIFUFeqd87c4hrIqKp7mDgLkZlU2wL++oro/1qesI8uu
	 6SDwOY0OQFeIYdzAK8KucYbXxQ4U5WS9G94qCHnEkYjjYtz/o/p+qNEY0qgK2W+bU8eHa
	 sOcyqGWM1L6JHXjqkqJi6iJ4cRnR1GkSbJixeLjn2pkCtGZVaqu4Y3u19y4BM3MaeZA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TBwjP048;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B0E3606A33A;
	Wed,  4 Nov 2026 21:48:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TBwjP048
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F0AF1F000C1;
	Wed,  4 Nov 2026 21:48:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793828901;
	bh=uq/kBJX88M8gVlGp492dCcFkulBT2mZiPTh9HCYFJIs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TBwjP048VuHBOFH8YB2sW8+NzBGbzmfqntXM4xBcDvc4btdg3GI39Pyo6lx7+7Rqp
	 ykmdZR7JKN0t1g9gBC+lzf2cdSlOPgQune+YNaE+RhDNkO3xBSdfdofe/E1mepeMeJ
	 m/HaPEHfhW+DGy3WNU64HB+VMQyasFTZS34ajPtc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 7.3 315/547] xfs: flag excessive delalloc rt extents as corruption
Date: Wed,  4 Nov 2026 16:08:19 -0500
Message-ID: <20261104211047.163764022@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211038.406938024@linuxfoundation.org>
References: <20261104211038.406938024@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Darrick J. Wong <djwong@kernel.org>

commit 2b47be015a5e54f4a3d62afa636ba593de9b67f6 upstream.

LOLLM observed that we should not allow repairs to proceed if the count
of delayed-allocation realtime extents exceeds the number of free rt
extents because we can't install negative numbers into the superblock.
It's unclear how we could end up in that state in real life, but let's
at least complain loudly about it if we ever encounter it.

Cc: stable@vger.kernel.org # v6.2
Fixes: e74331d6fa2c21 ("xfs: online checking of the free rt extent count")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/scrub/fscounters.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/fs/xfs/scrub/fscounters.c
+++ b/fs/xfs/scrub/fscounters.c
@@ -607,6 +607,13 @@ xchk_fscounters(
 			try_again = true;
 	}
 
+	if (!xfs_has_zoned(mp) && fsc->frextents < fsc->frextents_delayed) {
+		if (fsc->frozen)
+			xchk_set_incomplete(sc);
+		else
+			try_again = true;
+	}
+
 	if (!xfs_has_zoned(mp) &&
 	    !xchk_fscount_within_range(sc, frextents,
 			&mp->m_free[XC_FREE_RTEXTENTS].count,


