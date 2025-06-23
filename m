Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B8DD21D3DD;
	Mon, 23 Jun 2025 21:39:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750714750; cv=none; b=r5Cttovew6bmsXcGalP73Fi3Yk1sHLxyeTdvKsVQ1r6r9iaTC/DpYnVe0iWQvZduEMquHe2vB7gQ4EHoCecMOHWicm7ub2frHf1h6btq7HahgI+DO32t7u1bxhM0RJXqI10RX+q1oyfHI/MQ1Fa62Lr1+G0J1K2iXQlQTd9TMPk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750714750; c=relaxed/simple;
	bh=/zCkvgI+/yRvKHerPZ97CV0rdGo3U271FjfFh9Q9msY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aZKG/QdvARmnvws0Od8ckwZIjJAiILXih9nBZqGIDxX2xxjBn7OzIO+CL9bOvDnE49pQfBwiCV1ScNwI0eyxX09jg5M2TnOMzRjJ72CQedxnAJ+ZhTYcvDSFxK+Ug2Wvp5dystTq4sPnrBtaqjD7llmYj+r1w8ItuvlraEqikyY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CY7v8g/z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CY7v8g/z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0145DC4CEEA;
	Mon, 23 Jun 2025 21:39:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750714750;
	bh=/zCkvgI+/yRvKHerPZ97CV0rdGo3U271FjfFh9Q9msY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CY7v8g/zelvmVlpAhOuECNxHrfK1/lamWgC+CtHIlgndwlqoMhW+oqvA5UF15j1ZH
	 7/eocv7RDSEa2XUMFzLuDTZ41838nmxINaRuRW4E2iyox73aELOC5jE70/buoHHV2f
	 SZ8OdLCj+Aa0kQ6x/GDyIzJ7kMEvsWMVVcJkXm0c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Dave Chinner <dchinner@redhat.com>,
	Leah Rumancik <leah.rumancik@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 193/508] xfs: fix getfsmap reporting past the last rt extent
Date: Mon, 23 Jun 2025 15:03:58 +0200
Message-ID: <20250623130650.020097873@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130645.255320792@linuxfoundation.org>
References: <20250623130645.255320792@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Darrick J. Wong <djwong@kernel.org>

[ Upstream commit d898137d789cac9ebe5eed9957e4cf25122ca524 ]

The realtime section ends at the last rt extent.  If the user configures
the rt geometry with an extent size that is not an integer factor of the
number of rt blocks, it's possible for there to be rt blocks past the
end of the last rt extent.  These tail blocks cannot ever be allocated
and will cause corruption reports if the last extent coincides with the
end of an rt bitmap block, so do not report consider them for the
GETFSMAP output.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Leah Rumancik <leah.rumancik@gmail.com>
Acked-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/xfs/xfs_fsmap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_fsmap.c b/fs/xfs/xfs_fsmap.c
index 5039d330ef98b..7b72992c14d94 100644
--- a/fs/xfs/xfs_fsmap.c
+++ b/fs/xfs/xfs_fsmap.c
@@ -529,7 +529,7 @@ __xfs_getfsmap_rtdev(
 	uint64_t			eofs;
 	int				error = 0;
 
-	eofs = XFS_FSB_TO_BB(mp, mp->m_sb.sb_rblocks);
+	eofs = XFS_FSB_TO_BB(mp, mp->m_sb.sb_rextents * mp->m_sb.sb_rextsize);
 	if (keys[0].fmr_physical >= eofs)
 		return 0;
 	start_rtb = XFS_BB_TO_FSBT(mp,
-- 
2.39.5



