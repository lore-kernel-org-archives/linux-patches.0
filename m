Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794060844;
	b=eCC6b2OZ/o1krMtawjFg5i56KV6SrwqM3hM2+lyLOaz3QXa73FLAqG5PSrlcrVlimJeS
	 lX2R/WHHckDZJ5+p7NaZoc8vuHVT8V4R7zBpZH/vczVdOq8HAjXY8G/eNHImv8R0enBW9
	 CStf21A00onp9/TyGN0Hba8Su+OyohVJDfNImnKsKQVtecpv1BhxPiebjbvhUIDprITgq
	 mEk1phvUpjO9icPPu+h/VDPw5UMA9zXJ2sjA4TEUOiO/w4aj6nchHIMNUMm0TJk5Xfxoh
	 /0x05pOVo2P5+D2Fhg24blPyrTv7bONICPcPj6ijXgvYFQmGs5NHw8ENU8D66Qh3zQA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794060844;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=7CLNIrsXCkV6M/iqzFDEix9XrDIXTedi2Em4ymJ/CT4=;
	b=sJgauiiNky2uq0nMWHPgqSMoUNIKZJgofn5jdv2nNEA79b4qKpHJ0xVuEpt09wwz0byx
	 5OuFnHe9g0pQpvhmYU6cbQ0KHIPWSbwXAWaZWSeEE+G/XcRQfioYMuPptZ8qWEnuUsg5q
	 fIANd3Js8hvMclCS78UVN5mVVlDoC5PKgiD+5wLEJ+RPybVW3wvPUsSYEFWedyN3SZVFw
	 qoKqN1TdBoHlbzW9IQu2GEUORl5OVppo/BDVciojbCDLu3fzBZ7CkiFogiiUMircK+AS4
	 Tj0D32rW+pVdHn7EcmoOnO3NdJcEjyl/nsD3WH3/4N8Sm6AR+SnKSC1eFPapsamn05A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TPqikrDO;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CF95606A330;
	Sat,  7 Nov 2026 14:14:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TPqikrDO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E9121F0089F;
	Sat,  7 Nov 2026 14:14:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794060844;
	bh=7CLNIrsXCkV6M/iqzFDEix9XrDIXTedi2Em4ymJ/CT4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TPqikrDOwuHEPMkOI5RighMOMIi1UQ1aPDurQd/slF7GWMwWPNmFhkULFLw+RC29c
	 CjlfI7D4pyQk7WTqh3V1mv3hD809I/295hI3zoxkYe1oXm7M1D8ZCGA2L6CAjWkoeI
	 6rWN0KK6QOx01mrWnvtYah5B8qXmzR08aYYGc78A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0233/1536] fs/ntfs3: Fix memory leak in indx_find_sort()
Date: Sat,  7 Nov 2026 08:37:29 -0500
Message-ID: <20261107135004.217144347@linuxfoundation.org>
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

From: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>

[ Upstream commit 194491be54e1c9e4d29d3ee777b05ff031c4b670 ]

When popping a level from the index lookup stack, indx_find_sort() frees
the struct indx_node but not the index buffer it owns. Every call that
descends and then pops a level leaks that allocation.

Free n->index before freeing the node itself.

Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs3/index.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/ntfs3/index.c b/fs/ntfs3/index.c
index edfcd28573ef9..03ae5a817c1b4 100644
--- a/fs/ntfs3/index.c
+++ b/fs/ntfs3/index.c
@@ -1325,6 +1325,7 @@ int indx_find_sort(struct ntfs_index *indx, struct ntfs_inode *ni,
 		/* Pop one level. */
 		if (n) {
 			fnd_pop(fnd);
+			kfree(n->index);
 			kfree(n);
 		}
 
-- 
2.53.0



