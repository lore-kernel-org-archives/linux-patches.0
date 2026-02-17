Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDABB259CBD;
	Tue, 17 Feb 2026 20:49:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771361375; cv=none; b=dNoTW/y1gE8uvp2wtbGnhozRpcO4b94sTi4lJedxMyiJDsst8b9feP4nq6re2YFyGLN6gvG7aZycR0Ar5mYkyi71wFzK09YvWYdq/lsnhytAm6JENldFgfwl56/pHo/iqfHYs7woiEkLhoQljeksHseyCXb+SzaA+EQFtKJMr04=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771361375; c=relaxed/simple;
	bh=llPBtgJ984N0E9RdNOBd4LRk9dt3Lw3nRO9F36grLDs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=luL0DPHkC2CbkenLkHIig662wSHUzEUtLWHglGBz0qfa9NXMtp5NmKd8n5b1xFNNYkOuE4N2w5/L/pGD2z8otgfCqcFsWML7mt3luPID1lt/mLw8sZ+i/vcy3bSx98QqYOGRqgwrpCoizFt9APqW22waiBW/1P5YNzscEgwfK9U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K5kC+Fzl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K5kC+Fzl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3D94C4CEF7;
	Tue, 17 Feb 2026 20:49:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771361375;
	bh=llPBtgJ984N0E9RdNOBd4LRk9dt3Lw3nRO9F36grLDs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=K5kC+FzlJejZy2VI5hdHz0CRq8L4mAabA5FxgKGay3iezG9XCSdIKl/fEqPwO0quz
	 PemBZXXWsvfAUf/MB1iWEGB+ctyeNLyXLGw7ETMTQqMjD4sL+j5r5k2eXBO56azHdj
	 dRbTu+hd7Q7ulV6qU7KBg/3DHhtDKLOYOpmnUTtA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 17/18] f2fs: fix to do sanity check on node footer in __write_node_folio()
Date: Tue, 17 Feb 2026 21:32:13 +0100
Message-ID: <20260217200003.362259729@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260217200002.683975158@linuxfoundation.org>
References: <20260217200002.683975158@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chao Yu <chao@kernel.org>

[ Upstream commit 0a736109c9d29de0c26567e42cb99b27861aa8ba ]

Add node footer sanity check during node folio's writeback, if sanity
check fails, let's shutdown filesystem to avoid looping to redirty
and writeback in .writepages.

Signed-off-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/f2fs/node.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/fs/f2fs/node.c
+++ b/fs/f2fs/node.c
@@ -1751,7 +1751,11 @@ static bool __write_node_folio(struct fo
 
 	/* get old block addr of this node page */
 	nid = nid_of_node(folio);
-	f2fs_bug_on(sbi, folio->index != nid);
+
+	if (sanity_check_node_footer(sbi, folio, nid, NODE_TYPE_REGULAR)) {
+		f2fs_handle_critical_error(sbi, STOP_CP_REASON_CORRUPTED_NID);
+		goto redirty_out;
+	}
 
 	if (f2fs_get_node_info(sbi, nid, &ni, !do_balance))
 		goto redirty_out;


