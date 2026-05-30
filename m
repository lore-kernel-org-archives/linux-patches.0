Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 007C739478D;
	Sat, 30 May 2026 17:44:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780163046; cv=none; b=Lcxv5aiKl0RGU776uiqwix+lTMSCPhBqVmxs3R9FV13tVDrOKPjnpOg5IpbItvXJSQ/jFOxTG/DJp53CULb1kpnQJSocyMxVvoXUzv22YnKz7xQ2aOSWQN4fCz7M4ODdJql+GY/rVZfqO6qOG77WRKFaNijOpbtqqSbJWoIQ0dM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780163046; c=relaxed/simple;
	bh=pr2ZymOMax4LKrMzDxDIOKulKME9gwe6YLRPjgII9m4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Po+rixIr+JATMJd75blzxEC4eDL0LfLlRGqDoZvPjSmHX5RWd+zoMOOTsqeVyXpbtm/Wqo/8isktvUrrLUiLB/P624NY0mJ/Z3bRuIWwPXcYNhs2HzRWEvDNa470hyi7ctAN6oumtatR408Dsom+xvAvozrwq3bUMUChHp4gMJE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=c5FN2cz6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="c5FN2cz6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43EE11F00893;
	Sat, 30 May 2026 17:44:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780163045;
	bh=VzSukuvppDZQLdF5XCJyePVQxS+OqKAPPyl7wlbiOIo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=c5FN2cz6ChWONNq4rg/jxwGNd/Kh/yBHBkRCjq57WkRSYISp3lm39EFevhat5Uz4P
	 NEVAsPo/zXy5b0yjtCmy25y0iUBwQpNWh2P1FPfbCTcETu75ll2+cJUu1EoLR1tNOs
	 aUVtqE/uXzohuDgfDPIwu/SszRwAN7u3tn7h6SN0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org,
	"stable@vger.kernel.org, Zilin Guan" <zilin@seu.edu.cn>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Brauner <brauner@kernel.org>,
	Robert Garcia <rob_garcia@163.com>
Subject: [PATCH 5.15 139/776] binfmt_misc: restore write access before closing files opened by open_exec()
Date: Sat, 30 May 2026 17:57:33 +0200
Message-ID: <20260530160244.005514598@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160240.228940103@linuxfoundation.org>
References: <20260530160240.228940103@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zilin Guan <zilin@seu.edu.cn>

[ Upstream commit 90f601b497d76f40fa66795c3ecf625b6aced9fd ]

bm_register_write() opens an executable file using open_exec(), which
internally calls do_open_execat() and denies write access on the file to
avoid modification while it is being executed.

However, when an error occurs, bm_register_write() closes the file using
filp_close() directly. This does not restore the write permission, which
may cause subsequent write operations on the same file to fail.

Fix this by calling exe_file_allow_write_access() before filp_close() to
restore the write permission properly.

Fixes: e7850f4d844e ("binfmt_misc: fix possible deadlock in bm_register_write")
Signed-off-by: Zilin Guan <zilin@seu.edu.cn>
Link: https://patch.msgid.link/20251105022923.1813587-1-zilin@seu.edu.cn
Signed-off-by: Christian Brauner <brauner@kernel.org>
[ Use allow_write_access() instead of exe_file_allow_write_access()
according to commit 0357ef03c94ef
("fs: don't block write during exec on pre-content watched files"). ]
Signed-off-by: Robert Garcia <rob_garcia@163.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/binfmt_misc.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/fs/binfmt_misc.c
+++ b/fs/binfmt_misc.c
@@ -816,8 +816,10 @@ out:
 	inode_unlock(d_inode(root));
 
 	if (err) {
-		if (f)
+		if (f) {
+			allow_write_access(f);
 			filp_close(f, NULL);
+		}
 		kfree(e);
 		return err;
 	}


