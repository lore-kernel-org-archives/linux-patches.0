Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B415113C9C4;
	Wed,  5 Feb 2025 13:58:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738763921; cv=none; b=TIvoIlE6mHGYcqng6Cm5t08Cri/ggOzAfJ4wwcaJS7nz57jjm7sAtvqwCgcy1jGVu+TsoZUj8QSEtIBZSLlwoSHF78XuPh9Rb3Z3G27IHpfaMr+/9gb4WHzIxbEK4M8cUMWDHiujjgNxNHGgvyGiqg6Cyt8GtTxeEvpSFqsiMXE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738763921; c=relaxed/simple;
	bh=GuQYsNOibIXK6+TPxFiBjsTwRIE+OWsCMANWTf8yHsg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mySiIHdOQpvkJRz/X7oNwbhYE4nVoeYkCIiC219cy+vm9qdO1nD6rHpG+7NDvyciqrW9yOtr3Pdukuoyu1zwSJSh+TZcBwG5eGGMHQVN5kWTP8ETQQKRhyj2jmiLRaYDtX/HyQXNabykjBENVPFjnS4WwIUoooqbk9q7ZBxwJTc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FTKs9X4u; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FTKs9X4u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA0A5C4CED1;
	Wed,  5 Feb 2025 13:58:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738763921;
	bh=GuQYsNOibIXK6+TPxFiBjsTwRIE+OWsCMANWTf8yHsg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FTKs9X4uAClhNvB4Kd3T19gEmatD5wQYcovtGPUWUzFbu/Qg98aPLs2gOeYPkONO1
	 ztfgFmY/sqRiGbr7cP8y0dI6rsKGZGTqUtlRnQQ3kD+NyLi8CLqbgperlyRRoMPKFG
	 x4Tsr+sNiNnoVuPtoCFUixJw1rcEQ3IixU0B4nZ4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Howells <dhowells@redhat.com>,
	Marc Dionne <marc.dionne@auristor.com>,
	linux-afs@lists.infradead.org,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 030/623] afs: Fix the fallback handling for the YFS.RemoveFile2 RPC call
Date: Wed,  5 Feb 2025 14:36:12 +0100
Message-ID: <20250205134457.380599490@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134456.221272033@linuxfoundation.org>
References: <20250205134456.221272033@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Howells <dhowells@redhat.com>

[ Upstream commit e30458d690f35abb01de8b3cbc09285deb725d00 ]

Fix a pair of bugs in the fallback handling for the YFS.RemoveFile2 RPC
call:

 (1) Fix the abort code check to also look for RXGEN_OPCODE.  The lack of
     this masks the second bug.

 (2) call->server is now not used for ordinary filesystem RPC calls that
     have an operation descriptor.  Fix to use call->op->server instead.

Fixes: e49c7b2f6de7 ("afs: Build an abstraction around an "operation" concept")
Signed-off-by: David Howells <dhowells@redhat.com>
Link: https://lore.kernel.org/r/109541.1736865963@warthog.procyon.org.uk
cc: Marc Dionne <marc.dionne@auristor.com>
cc: linux-afs@lists.infradead.org
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/afs/yfsclient.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/afs/yfsclient.c b/fs/afs/yfsclient.c
index 024227aba4cd5..362845f9aaaef 100644
--- a/fs/afs/yfsclient.c
+++ b/fs/afs/yfsclient.c
@@ -666,8 +666,9 @@ static int yfs_deliver_fs_remove_file2(struct afs_call *call)
 static void yfs_done_fs_remove_file2(struct afs_call *call)
 {
 	if (call->error == -ECONNABORTED &&
-	    call->abort_code == RX_INVALID_OPERATION) {
-		set_bit(AFS_SERVER_FL_NO_RM2, &call->server->flags);
+	    (call->abort_code == RX_INVALID_OPERATION ||
+	     call->abort_code == RXGEN_OPCODE)) {
+		set_bit(AFS_SERVER_FL_NO_RM2, &call->op->server->flags);
 		call->op->flags |= AFS_OPERATION_DOWNGRADE;
 	}
 }
-- 
2.39.5



