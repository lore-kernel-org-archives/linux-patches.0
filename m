Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B12E25E83C;
	Tue, 11 Mar 2025 15:18:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741706339; cv=none; b=fixzxt92kBF7XN8dxesmkKUIeAJylltx1o3AtjJ8XSyLz85fw99kWdtjNsrZlYQQvc6cSZkAp0SEd6aE1C6GTurtjQ+6zB7qN9w1ueR1nzI/M5bNi6a2FR812jcrBDqoKOQZqnkIFXa4JY6+wLlBMYwa0WEUHgMpIJvnhDKSidE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741706339; c=relaxed/simple;
	bh=U2Jazm27t4HK4IHcVBjXOzzTh+Uc9beePo3+39gKWmI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e+qVT/DetRzodBcE7NWhNrDvGevbmfDGSzZQqd4Adt0b33KYjR7NRF/DGgJ+mSHLeH/FqmVXBDkLI6w0rcTSf9aMwhBOh4BxR5P4FCC6ivYoJUcQsufRquPyFXVIpFR5uG/G4YJaWihXYZVwiAjZMKRB9vA9VFF3fAAyBMDe9aU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kubdPM/t; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kubdPM/t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 947E9C4CEEC;
	Tue, 11 Mar 2025 15:18:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741706339;
	bh=U2Jazm27t4HK4IHcVBjXOzzTh+Uc9beePo3+39gKWmI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kubdPM/tsfN9g2FyFIQCXkm2iXzXcB2Q9+HL5+B+IPzbdQg2RVjnZJye5dolhcO/8
	 yC1Isu0MlcG3N5VaBno1VIyeGbkJkZgck47u683D7s9gp2/c5HhAk7wFTS6/8nSJ8h
	 UCvgmkRfCyJ/eozPWYItjx87sVXtbugzk3vkAjR4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Howells <dhowells@redhat.com>,
	Marc Dionne <marc.dionne@auristor.com>,
	linux-afs@lists.infradead.org,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 007/462] afs: Fix the fallback handling for the YFS.RemoveFile2 RPC call
Date: Tue, 11 Mar 2025 15:54:33 +0100
Message-ID: <20250311145758.642598367@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145758.343076290@linuxfoundation.org>
References: <20250311145758.343076290@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 5b2ef5ffd716f..171de355a7e58 100644
--- a/fs/afs/yfsclient.c
+++ b/fs/afs/yfsclient.c
@@ -689,8 +689,9 @@ static int yfs_deliver_fs_remove_file2(struct afs_call *call)
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



