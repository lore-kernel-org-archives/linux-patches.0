Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A66F37C902;
	Thu, 20 Aug 2026 15:06:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787238414; cv=none; b=n41htWhesc3XADEvtKwoDVTu5TSr6DRkBRK+9m6l3+kFIzP4r4WX24rvPnZcCsZHeM5KpxMmIWliswHhgvCJMtk22WOEuMnTg+2kZJpA0W0/nQSPQyhya0KffHmn7oKPTvjqkIx1Dnl3ehbklDc9sNsxKNyeagFvW4ImypYlBQA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787238414; c=relaxed/simple;
	bh=hdN4Gq5dIveSfd2s5Ewm9CdTmgYL5PxNnys60EHmOwA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=db+4R5BurSS+vqmeD5GVEpks3QuWBgMyVDEuFNzKmmnCc6/wJ55pS7uHasjZRwwpqtnusOAWSPLQSfq1Y1yySFLZ3JAgcrHfQAGAEvy594Y2c3hGxoTc3vo7Tkbd7SG4K3oEpChTkyTUo1c3Xsb8A0T6ETggOowOLldInPTadxs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MZFQCz64; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MZFQCz64"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DABE1F000E9;
	Thu, 20 Aug 2026 15:06:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787238413;
	bh=dln6gbStCyBgk+769lsw5cxWFPHUZvYDG9ZpbfjXOTw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MZFQCz64dYp3gtHiSNRoDQ5ap9/SplwxzedPkUPKB38Ob94xQtn4QebZlsbGuee55
	 MhsHdIM4AZJ0gA+t861jwspZLRwmgoCSjQgWzx2KZzM4FwVYf/EDBGIBqtXdV6+8qc
	 1w/ap2NAsmrDB+MUF8xa0k1UVXzHN8zO6Sj4vc14=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 7.1 138/228] xfs: load next_agino from the correct xfarray in xrep_iunlink_relink_prev
Date: Thu, 20 Aug 2026 16:54:40 +0200
Message-ID: <20260820145248.799966193@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145244.450574346@linuxfoundation.org>
References: <20260820145244.450574346@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Darrick J. Wong <djwong@kernel.org>

commit 6b9cd540138a06660a843a519facc147060acbef upstream.

LOLLM notices that xrep_iunlink_relink_prev has the comment "set the
forward pointer..." but then loads the value from the xfarray that
stores pointers to the previous inode in the unlinked list.  That's
wrong, so fix the variable access.

Cc: stable@vger.kernel.org # v6.10
Fixes: ab97f4b1c03075 ("xfs: repair AGI unlinked inode bucket lists")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/scrub/agheader_repair.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/xfs/scrub/agheader_repair.c
+++ b/fs/xfs/scrub/agheader_repair.c
@@ -1626,7 +1626,7 @@ xrep_iunlink_relink_prev(
 		want_rele = true;
 
 		/* Set the forward pointer since this just came off disk. */
-		error = xfarray_load(ragi->iunlink_prev, agino, &next_agino);
+		error = xfarray_load(ragi->iunlink_next, agino, &next_agino);
 		if (error)
 			goto out_rele;
 


