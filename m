Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C25C1DED55;
	Tue,  8 Oct 2024 12:12:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728389567; cv=none; b=l4McyIgfX9yyZhG4B5ZYoI+kZU5cAVOhesBkUdSkRj/ith94/UtWv/3CEjj5d1MwHCL7nnE0iIAbLy7ZLMp+k+WqwGqN0YTSQ79akBZ7ZDc5HqLmFiQM0+GDx0gXI0YzrVkfGH7JRWHBYooIfESymnmHsJzPgohUD5Ema1nxOFI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728389567; c=relaxed/simple;
	bh=aKWqSk2ieg72daVUfO8rP3nvlkFLX6V3crJZVOoH/E8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DjUuKiZs5EubtFOYCtsZKg0TQ4N0DQjxyQ9dkF2LRUpTQYcgW6/x5oVa3jYP5vXEv5Tu8V1lGAD3X+w78qtQO4YWGS57MSX5ZIbkUKvM2irth7yD2+xcJkw3lDk199mOi51zDi13KTGDjUEm7r1LKC5GBEmz3NM68qRo9hl4ikA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wp508uDi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wp508uDi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDED5C4CEC7;
	Tue,  8 Oct 2024 12:12:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728389567;
	bh=aKWqSk2ieg72daVUfO8rP3nvlkFLX6V3crJZVOoH/E8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wp508uDiCjUv2XO3/mmQ77CaE9BAwQ0EqIEZH4tEdgYv3GO94A9tFnieX7+P0ucvm
	 VBS9gVj9mE3PW3OfOeRDuB1pHBZb1DqRhK2/FySh8FZ8DFc/yEUixPbk5Mfd2wK07X
	 ijWqhDvn4Jphae7YvYnqsEdMbRP6HN7yux4zhkH8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Howells <dhowells@redhat.com>,
	Marc Dionne <marc.dionne@auristor.com>,
	linux-afs@lists.infradead.org,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 032/482] afs: Fix the setting of the server responding flag
Date: Tue,  8 Oct 2024 14:01:35 +0200
Message-ID: <20241008115649.564237250@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115648.280954295@linuxfoundation.org>
References: <20241008115648.280954295@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Howells <dhowells@redhat.com>

[ Upstream commit ff98751bae40faed1ba9c6a7287e84430f7dec64 ]

In afs_wait_for_operation(), we set transcribe the call responded flag to
the server record that we used after doing the fileserver iteration loop -
but it's possible to exit the loop having had a response from the server
that we've discarded (e.g. it returned an abort or we started receiving
data, but the call didn't complete).

This means that op->server might be NULL, but we don't check that before
attempting to set the server flag.

Fixes: 98f9fda2057b ("afs: Fold the afs_addr_cursor struct in")
Signed-off-by: David Howells <dhowells@redhat.com>
Link: https://lore.kernel.org/r/20240923150756.902363-7-dhowells@redhat.com
cc: Marc Dionne <marc.dionne@auristor.com>
cc: linux-afs@lists.infradead.org
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/afs/fs_operation.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/afs/fs_operation.c b/fs/afs/fs_operation.c
index 3546b087e791d..428721bbe4f6e 100644
--- a/fs/afs/fs_operation.c
+++ b/fs/afs/fs_operation.c
@@ -201,7 +201,7 @@ void afs_wait_for_operation(struct afs_operation *op)
 		}
 	}
 
-	if (op->call_responded)
+	if (op->call_responded && op->server)
 		set_bit(AFS_SERVER_FL_RESPONDING, &op->server->flags);
 
 	if (!afs_op_error(op)) {
-- 
2.43.0



