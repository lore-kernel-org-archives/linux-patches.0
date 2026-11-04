Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793828924;
	b=1Nw0ANuwdt/vk4DLBA7mQHRlQ5nDOlkbYPJEOz8enLgTr6FwO36sC3d8n4EcGthyzd1B
	 THjrrIZ04rIJNv2GuwxxeHRPQZtFp0vnshWCj1Z525iN+3YmiZK0HRZgzwH1IALYGW04z
	 /iBjU2NYUBqUWoLbUe/pTVdKORVAkqG/5pWyEQotTjIBaCGJOn4TpRvkhhPam+Y+3rCW3
	 DoRCb8H9xRTS1zUtZRkQuYJImed8MUhi13X/1T7zXXjwMbosqHa8tfDZ4SUzDPs1VEcGQ
	 HLR/Cqgu7KvkQfTlcVcjjhDN85XjK/bokGSZXOV2kWgbeUeiL1UQON1TurxF4imR7Ig==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793828924;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=6X9vA0GI15Ew1XEDJgGvXSOpAlcrmWLBIQYJxHvHPs4=;
	b=qNemMzmZa3tPS2oA40oEyylG9Is/Xwb/zaTJJ7oe1taEiclpSdhrgpBlBt+ycOwGJptb
	 edpFxZOjO7ZycoBRgBgBgUPYOIF4eL8H5ZTpViXaT0/pRbnkdvVMZeez4V7ViQs4W0k4e
	 AtqiDhBcxdXPdqB4sWt6Ns1L4KxPI+LMfISqoJvJW1ghZhWK9R6ZuGd48cjBHNvX0ehvn
	 9+i3+ckYMHoc6GGN03BG9YaVkIOedzyOqd4ltJhSJidMPbNaZC6uewGFZzSid+OXk0nWY
	 0QACaxpR37SbnkUcBZ7sXmUEasgC/ew0SeqmDxfL+ve+bq5bpsAGzrhfcZWWFHnkKAw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NYJeDJgm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E14E9606EEBE;
	Wed,  4 Nov 2026 21:48:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NYJeDJgm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A61A1F00A15;
	Wed,  4 Nov 2026 21:48:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793828923;
	bh=6X9vA0GI15Ew1XEDJgGvXSOpAlcrmWLBIQYJxHvHPs4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NYJeDJgmBioIRjoEVukYa2eVu3t/5BDzHSx3WtCGikOVMDaR1QwffSSzt4Vuv0oMC
	 Bxqlg0qCFX5yHsgKCl0M+VDLFk8ceih8cr+7F1k+ZSvx5PP5T0lhCxcQ1PIXXR3QTm
	 kzInQXFy6moPaTT6DSJRAkcJIfiaau/h22MTMwPc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 7.3 329/547] xfs: jump out of xchk_bmap_check_rmap if fatal signals
Date: Wed,  4 Nov 2026 16:08:33 -0500
Message-ID: <20261104211047.576800917@linuxfoundation.org>
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

commit 49d300a51442bd64b627645b7b0b1cd66e492905 upstream.

LOLLM observes that we never check for fatal signals inside the loop
that checks file fork mappings against the rmapbt.  This can lead to
lengthy delays in responding to a ^C, so add some bailout checks.

Cc: stable@vger.kernel.org # v4.17
Fixes: 5e777b62b0bcb6 ("xfs: bmap scrubber should do rmap xref with bmap for sparse files")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/scrub/bmap.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/fs/xfs/scrub/bmap.c
+++ b/fs/xfs/scrub/bmap.c
@@ -626,6 +626,10 @@ xchk_bmap_check_rmap(
 	struct xfs_ifork		*ifp;
 	struct xfs_scrub		*sc = sbcri->sc;
 	bool				have_map;
+	int				error = 0;
+
+	if (xchk_should_terminate(sc, &error))
+		return error;
 
 	/* Is this even the right fork? */
 	if (rec->rm_owner != I_INO(sc->ip))
@@ -657,6 +661,9 @@ xchk_bmap_check_rmap(
 	 */
 	check_rec = *rec;
 	while (have_map) {
+		if (xchk_should_terminate(sc, &error))
+			return error;
+
 		if (irec.br_startoff != check_rec.rm_offset)
 			xchk_fblock_set_corrupt(sc, sbcri->whichfork,
 					check_rec.rm_offset);


