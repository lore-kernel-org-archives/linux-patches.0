Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794065065;
	b=a7tAB24GlCEhVpX01t/injBtGDLazvl2EFe0zeWqa5EqsfQ1xf2RrjCEdmNmHoVcXI6/
	 dFAwE6/idoo0Y6ZwsRjSgJwxcy9C37SVT4mpXVsE69ELG8mJEPGO/mpnTtahW1O4K5lly
	 zPUCZapIDRPtyr4KSJQM1SP2UZrwOzXfvNXrjniT5WYq1TzKGSYSIlmk+n5OXy0ReqrA+
	 NDcuYmgykx8JZyqw2J48ZmJntfAAtZcAVkAouC0j8l31MwzRuFts0TOsEdRY3IeJj5Y+P
	 k4+DrieXCeTV00T/V9IdAO4Qy0JxeGnUVdyl7c1/tIRzEHOn1vQFVKutBuGO29ijLVg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794065065;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=2SvlZUEg9eVdfbe0Hkk4GKypFbav5ti3vN0DFquwb08=;
	b=EoQWEU5VX3NdXvl7oQ9Fe/ayPzLeiJDUwDYuCk4I8GObARlGpYxc/6aJaB5bc7qaCsyH
	 rnyryFkFjsBks58yxJ6lO5sIJWGcQ8grSZmf/1Zw8wZqljg4lAJjQaBaIcHB9xTsG+OCZ
	 /Rvu83hdnHPV0c3NvhurV6oNZktopeJ3kGN4UUTXYHFxlCYDdnXOVMLf9H7aPwBeqLCzl
	 6WL27qvrG5fCpGUFpg8/1x34TzmOhL2NbXBNhn3N+1wOYbbxGsaygupPdK0efooV5ikvL
	 R99CIafZJWN+mB09mHU+EIL/iDmnVlLpNeTKDoq7JZxJlx0xfZddPunNKMZ3amLPmjw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=K1fVa3vM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 811F4606A9C0;
	Sat,  7 Nov 2026 15:24:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=K1fVa3vM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A28491F0089F;
	Sat,  7 Nov 2026 15:24:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794065065;
	bh=2SvlZUEg9eVdfbe0Hkk4GKypFbav5ti3vN0DFquwb08=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=K1fVa3vMyS64qmSmbP24frhkkP+uGrHtd3y5TtqTIkZ0oYiOrxVnxXKEIH5N9XBZY
	 QaIzyHyV6EMMKDplJOLe60o+Z7rlTy+p0umQnLqp6qzbXIyVkiy9LMd+sRSMPYtF71
	 09eUTxee6eOrg6uxfDpMCPoCt8Tol8nHluXdTs5k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hyunchul Lee <hyc.lee@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0908/1257] ntfs: serialize raw MFT updates against folio writeback
Date: Sat,  7 Nov 2026 08:53:24 -0500
Message-ID: <20261107135004.415123133@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

From: Hyunchul Lee <hyc.lee@gmail.com>

[ Upstream commit ec0a5dd2e385e11839e8846dabe1f9f7042ac202 ]

Because MFT folio writeback can remain active until its asynchronous BIO
completes, raw MFT record formatting and allocation must not modify the
folio while it is still used as a BIO source.

Wait for existing folio writeback after taking the folio lock in both
raw MFT update paths.

Fixes: 115380f9a2f9 ("ntfs: update mft operations")
Cc: stable@vger.kernel.org
Signed-off-by: Hyunchul Lee <hyc.lee@gmail.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs/mft.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/ntfs/mft.c b/fs/ntfs/mft.c
index b102e0204eba9..c7577c3224541 100644
--- a/fs/ntfs/mft.c
+++ b/fs/ntfs/mft.c
@@ -2022,6 +2022,8 @@ static int ntfs_mft_record_format(const struct ntfs_volume *vol, const s64 mft_n
 		return PTR_ERR(folio);
 	}
 	folio_lock(folio);
+	if (folio_test_writeback(folio))
+		folio_wait_writeback(folio);
 	folio_clear_uptodate(folio);
 	m = (struct mft_record *)((u8 *)kmap_local_folio(folio, 0) + ofs);
 	err = ntfs_mft_record_layout(vol, mft_no, m);
@@ -2539,6 +2541,8 @@ int ntfs_mft_record_alloc(struct ntfs_volume *vol, const int mode,
 		goto undo_mftbmp_alloc;
 	}
 	folio_lock(folio);
+	if (folio_test_writeback(folio))
+		folio_wait_writeback(folio);
 	folio_clear_uptodate(folio);
 	m = (struct mft_record *)((u8 *)kmap_local_folio(folio, 0) + ofs);
 	/* If we just formatted the mft record no need to do it again. */
-- 
2.53.0



