Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9408E2528E5;
	Tue, 20 May 2025 14:16:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747750597; cv=none; b=XolH9Jg7Rtjbo/ELqHEF1D/HObiH7RJRbpOeVDOV2RDDfB65LPEGIJXaa6cCxSlbYmvFwxSmEqd/KFZBq8d8TXEtkf05BnLqD7QyluqYW064NLUwKgDGwd16ACpnAWtyyXQ7LCtvAQ58H7UrLQZUeJEF9XRyR3MkAITSD1C07iI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747750597; c=relaxed/simple;
	bh=Bt+1yRnOnOtgaIMjlh2p0mSp9cRbImM6MOnJZIC77lY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cI0L4aOOgOIi6gi0S8eTNCcq/0auXCQ1i3b7Fq2/Nydj6SUY7/DEDptNBWEqzJpqPizd3EB79UVHF5U2mf0Oa+J8pYydmc7MFf8LNWFMkQX/1Chaiv+lg1yCGmSroOr25qwSf0DaxQbj0RHPx75vShFx42k9tb0D8nPUPTpYcsI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=q0yaLAg0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="q0yaLAg0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EB4EC4CEE9;
	Tue, 20 May 2025 14:16:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747750597;
	bh=Bt+1yRnOnOtgaIMjlh2p0mSp9cRbImM6MOnJZIC77lY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=q0yaLAg0+E0hr7aYjfvx4h3S2m7Wy4H0l0VKrnuZ5fawlL7A9nymUPI/pxHs8z83l
	 lMlNllXkeuU8sYbRbiTmFcYBtZtdY5mIcqKW2aoS4AlX/nm11eKu8CWVIBlicdyAPu
	 w9Ca5f9IDQizLzOmrlmF+tmgkNPCKhrIWbplqOpA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 061/145] NFSv4/pnfs: Reset the layout state after a layoutreturn
Date: Tue, 20 May 2025 15:50:31 +0200
Message-ID: <20250520125812.971771613@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250520125810.535475500@linuxfoundation.org>
References: <20250520125810.535475500@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Trond Myklebust <trond.myklebust@hammerspace.com>

[ Upstream commit 6d6d7f91cc8c111d40416ac9240a3bb9396c5235 ]

If there are still layout segments in the layout plh_return_lsegs list
after a layout return, we should be resetting the state to ensure they
eventually get returned as well.

Fixes: 68f744797edd ("pNFS: Do not free layout segments that are marked for return")
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/pnfs.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/fs/nfs/pnfs.c
+++ b/fs/nfs/pnfs.c
@@ -745,6 +745,14 @@ pnfs_mark_matching_lsegs_invalid(struct
 	return remaining;
 }
 
+static void pnfs_reset_return_info(struct pnfs_layout_hdr *lo)
+{
+	struct pnfs_layout_segment *lseg;
+
+	list_for_each_entry(lseg, &lo->plh_return_segs, pls_list)
+		pnfs_set_plh_return_info(lo, lseg->pls_range.iomode, 0);
+}
+
 static void
 pnfs_free_returned_lsegs(struct pnfs_layout_hdr *lo,
 		struct list_head *free_me,
@@ -1292,6 +1300,7 @@ void pnfs_layoutreturn_free_lsegs(struct
 		pnfs_mark_matching_lsegs_invalid(lo, &freeme, range, seq);
 		pnfs_free_returned_lsegs(lo, &freeme, range, seq);
 		pnfs_set_layout_stateid(lo, stateid, NULL, true);
+		pnfs_reset_return_info(lo);
 	} else
 		pnfs_mark_layout_stateid_invalid(lo, &freeme);
 out_unlock:


