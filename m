Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63ED4377561;
	Tue, 17 Feb 2026 20:52:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771361524; cv=none; b=hKbMB3lL6ympswEy9EHinI0KtWRWx3bpPjk8Q550zdL3s1K/EWnnV3B3nCupiIEiyxOqeuYYz3ykGmgyqNfd22esG8rd4z4JosEy1rV6j3cQ1z1lgCotVYcNoX4kQjMSwJyKWABQ6nsOoXlsAl0R33B8+pHVSJUefRk7B9qS9Vk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771361524; c=relaxed/simple;
	bh=USxx6DBwGx9h6RxxKkoku1BT24kiMIJQpoSkW/zb8K4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sKWC86EXw1ne8+iib720VZKvjbYXDctSYlpYF7thVFNiMcqznWiXJFpCpR4kyYFGHdgzC+dEHgu3/EERbT82zAvB/wpCElYt1MyyT2j2asgbBB9+k0wBXqm/XvsJKlJEyxikt3RCcY8ge62UAifbpRqmA7QvyE9FsdgUhJnXXr4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mPBLuMT8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mPBLuMT8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5181C4CEF7;
	Tue, 17 Feb 2026 20:52:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771361524;
	bh=USxx6DBwGx9h6RxxKkoku1BT24kiMIJQpoSkW/zb8K4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mPBLuMT8XCpmPRCOF8Ar6HjYQjH8zS5CYR8j0OvA9moiEJ3/P3J8bIuZ6Fyr5kQTq
	 BBNzk6PM1TQgZXNLViPFDaf5JV78IEfcyMM53mRzMmUYr3vPlmU2O+H5jST+NjFcj/
	 11J2+WyICHKYjYnbgS9l0s5ujpCyADnNQIXB9Y1U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 42/43] f2fs: fix to do sanity check on node footer in __write_node_folio()
Date: Tue, 17 Feb 2026 21:32:22 +0100
Message-ID: <20260217200008.078007648@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260217200006.470920131@linuxfoundation.org>
References: <20260217200006.470920131@linuxfoundation.org>
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


