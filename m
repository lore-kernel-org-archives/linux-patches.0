Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793826946;
	b=2zXc7pYSUi7ggANvWUKGCh06EXRBLeTqm9BDf81lhklKu4gsMQPrubA8OzVBCW4PY6sL
	 iXMfKHp4EPRRVP1I6ExaSN3IRBUDYZU+dqK+PkELbTswZzaRbmXmpVXX4p69CieqSgDLD
	 kediE2lpkZHcaDHahmFmonKqhDlPDi1n/WYvxe7B/TO5Y0w5XO/5DEWr7LW6LExR4+tfW
	 jlyBBMqRtnIfpoUpMh8nhyl1z80qM0qlEr9syf1Vs5Bxe923MDVA91jNUnvlawFOg6GSL
	 RA8TRlNe654ZSUfIN4en048irSJsXRePcI1QwHn5jt91asF1bASf8etiZJvT5YVxBJA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793826946;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=BB7cqvWcIp58GO2hgCy5LN6FPtmez9TejzzDohSx/vQ=;
	b=koIto0+M8mj/ZJEySJozMuIcYunaB9HAxpIdUmfh/wXKBRYIwFw1cVIOAELYcSLwcfwr
	 RK7qdfUDydSlSZvCLb+ByrhMGYgCXfd54f2WbPNfh1fqEQQYMhGn3BlWIkF2IseuR7lCD
	 /ksd0x6qQL9PGF+SgU7fC/KjnNh1hEzgjzq6fwkXfS26mc0VyuWSTaVIbu9NVOWmO/vqa
	 TxhVc/ZKs6Gn+YgCK9hM5mQdvCxF34eRlIarx0O3c56R189pSGg5nTs6fh+REiDgakVhU
	 GJ46fg9A5p/Tcn8YSag49CcPQkpI9jcPXb9/iJillCh7qyVpXC7oDwCxIAUvZDsHUHQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Z1RIVhDx;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B347860B5A72;
	Wed,  4 Nov 2026 21:15:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Z1RIVhDx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3ED551F0093A;
	Wed,  4 Nov 2026 21:15:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793826945;
	bh=BB7cqvWcIp58GO2hgCy5LN6FPtmez9TejzzDohSx/vQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Z1RIVhDxNmvugH/SLTo+/KfkfmktMrJnCJp8pZWnMzfTDFvSAS4maQEh93tl8rLGR
	 L0c9ofnkaZjRYOWtiWhGJU4PuDEWAlmp3l6FE7CTNOLSnRILG//Mb3MfSrLCv9UAck
	 L3gt+wt+SSLxhX7QPXxEo0FqdAHZ5BQcrdj46cMQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 7.3 094/547] xfs: fix integer overflow problem when setting large free areas
Date: Wed,  4 Nov 2026 16:04:38 -0500
Message-ID: <20261104211040.897915443@linuxfoundation.org>
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

commit 7e55f84434f3a63d59feb8f89076d280ea9aa8e5 upstream.

LOLLM points out that the min_t comparison in xrep_rtbitmap_mark_free
operates on a 64-bit bitmap word offset quantity and a 32-bit
words-per-block ratio.  Unfortunately, I should have done the comparison
with the (64-bit) xrep_wordoff_t type, but used the 32-bit word count
type.  Oops.

Cc: stable@vger.kernel.org # v6.14
Fixes: 8defee8dff2b20 ("xfs: online repair of realtime bitmaps for a realtime group")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/scrub/rtbitmap_repair.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/xfs/scrub/rtbitmap_repair.c
+++ b/fs/xfs/scrub/rtbitmap_repair.c
@@ -276,7 +276,7 @@ xrep_rtbitmap_mark_free(
 		xrep_wordoff_t	rem;
 		xrep_wordcnt_t	wordcnt;
 
-		wordcnt = min_t(xrep_wordcnt_t, nextwordoff - wordoff,
+		wordcnt = min_t(xrep_wordoff_t, nextwordoff - wordoff,
 				bufwsize);
 
 		/*


