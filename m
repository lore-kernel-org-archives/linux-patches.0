Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD26C35C1A6;
	Thu, 20 Aug 2026 15:16:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787238978; cv=none; b=WxPSEQF+AbWV7sCtf2QXQ1e4Ss0jy/3tBotBZqNdyQlrfpkr5BCeEwNZ7nFtn6L+BBq66jfD4HkUYR1NGvukqMCfajdrOxiJ0eej6ytaTNEwmBdDx2DFalioWQNv5Jh0DEKb/nsAi0t8mCNgSOVKwWpwT991qVioW/6RFoBEduo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787238978; c=relaxed/simple;
	bh=/I7uJqxw5BR30oEptxLvZG8qU3hT2K50DCAFFsNpEKc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ICJvQMrOlFEptBIbx4v8XjaIoxopV7OESu7sqISdSoaJSN+SjNWSnbafTTH/CiWX4q5LNaiMEV7MMY+iSg+OkxgMG2twEExU/Ey0Z4+XoESQ+Lvk24SPGmBfetW03NJCAZtHhWB2xQcJ3pz9e6GWCWJtbrW9CtAjv55/XRZGsEo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rPe7JbZ6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rPe7JbZ6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 091791F000E9;
	Thu, 20 Aug 2026 15:16:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787238977;
	bh=heV9mnIlkhfD7zcAcyh4eVY744Hvdiix20hNuoiE+bw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rPe7JbZ68yQ1LHpeF0YEzCzKUNCI+5xirb26bfwzXPDhzsQM74T5dGoMZUbpQX1RO
	 fz209UyDoDFXrm4aTUUwq3AmBZ35kKNK7kKbNYbZ5s2UWC25dcaP8ohjwUQmcK6Dt5
	 lLV6jAmygzRgbUpCgP3bEH0eEplN8Agxs6ut6IIg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 6.18 106/217] xfs: mark nonzero sb_gquotino as corrupt on metadir filesystems
Date: Thu, 20 Aug 2026 16:54:34 +0200
Message-ID: <20260820145240.929711620@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145237.531699751@linuxfoundation.org>
References: <20260820145237.531699751@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Darrick J. Wong <djwong@kernel.org>

commit b28d23c51635b646784a2a62c71ba99458c07d5e upstream.

On a metadir filesystem, the superblock gquotino field is always zero
because we find the quota inodes through the metadata directory tree.
A nonzero value is therefore a corruption (as pointed out by LOLLM) so
mark the failure as such.

Cc: stable@vger.kernel.org # v6.13
Fixes: 06b20ef09ba163 ("xfs: check pre-metadir fields correctly")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/scrub/agheader.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/xfs/scrub/agheader.c
+++ b/fs/xfs/scrub/agheader.c
@@ -266,7 +266,7 @@ xchk_superblock(
 			xchk_block_set_corrupt(sc, bp);
 
 		if (sb->sb_gquotino != cpu_to_be64(0))
-			xchk_block_set_preen(sc, bp);
+			xchk_block_set_corrupt(sc, bp);
 	} else {
 		if (sb->sb_uquotino != cpu_to_be64(mp->m_sb.sb_uquotino))
 			xchk_block_set_preen(sc, bp);


