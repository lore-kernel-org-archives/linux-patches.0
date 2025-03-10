Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B0C017CA12;
	Mon, 10 Mar 2025 17:45:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741628726; cv=none; b=IwjNXSqBFb2iODH93PtlgzVqpZ/bzv4gNO/OtY/zWTWbtKlhcclIHGnu0oZoNhBKxMs3PjBmzw/NkfT7r9pXDTwvx+sH6N9OlwlxmBNwv3wpt/JiGg3P/40utPXWTOdl/aEUgOYuub66yllTPM3AuGhfd+kuZn1Rac893DsLWtY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741628726; c=relaxed/simple;
	bh=se0BGL2EYNnDEFNdcufzOsiZ5ypvFp8BjDBaO6Xf13E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AusNUgN2XCUR30Mq+DQG86h9TyCrxw2/FjrRqX6vnIozLON8cH1AlY0+uUyLdTnqTGhlSq42Zdzqcr1aKHDWv/6/JN8ptArebN87BUdIX7Ugm9kxxu6u745afnxqGHLBvMBRLzQLknU1YeAHrDBxJQl+QOmMzceue/Y8e1GCGzE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ruemGqq0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ruemGqq0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98E28C4CEE5;
	Mon, 10 Mar 2025 17:45:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741628726;
	bh=se0BGL2EYNnDEFNdcufzOsiZ5ypvFp8BjDBaO6Xf13E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ruemGqq0YlzQ4fCJ0JVyjq009VIUIs4HoJdS2WKxBcHMGUOYP3iHMP71Vqhcy5WHU
	 54fBH8R8fkTWknzibgnBv6aT8X4m4vd4/5SyacNsyBO7ZGTtnwQztK4IJuxmpHHnmY
	 hRtkPxSl8YE7EzUAGldjm2YG1P56TVokACz63yPU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Howells <dhowells@redhat.com>,
	Marc Dionne <marc.dionne@auristor.com>,
	linux-afs@lists.infradead.org,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 016/620] afs: Fix the fallback handling for the YFS.RemoveFile2 RPC call
Date: Mon, 10 Mar 2025 17:57:42 +0100
Message-ID: <20250310170546.220300791@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170545.553361750@linuxfoundation.org>
References: <20250310170545.553361750@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 88ea20e79ae27..b3bc46a112242 100644
--- a/fs/afs/yfsclient.c
+++ b/fs/afs/yfsclient.c
@@ -662,8 +662,9 @@ static int yfs_deliver_fs_remove_file2(struct afs_call *call)
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



