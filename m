Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44A4F2FDC30;
	Sat, 12 Sep 2026 14:11:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789222269; cv=none; b=CVk6TvUuzGJRQiL3RSMtiX6FvaJOYltarUWN4RJoeQ5xXokUeXI3p+eTZRCAZEIsc2TBgrV5bEPcOP8UXBGeVWw6k0q5Hue5EhJQXb5YagKeEFwVctfj6dMAJdcik7S9Y4jy7k7hq1KT7ZwA7ZEcUaLxAieUz59Wrlu8cvDEFUc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789222269; c=relaxed/simple;
	bh=jlsANdMapdiUsq4/c9EAjZh62AmLmbgtom0fu47ZdD4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cEAugcRa1ilf1N7yTilTn9YIZzLVzSg5HoorEZssyEZm/6wx5za6i76kgkmadZ1fdB7LC1nheAAiLOLKPiifSWByMkDFSmcOAIqOFbvpiRSRzbm8dN0AADE9m7PQUicSe+ciVE90b2VjmOP7fiwJUpsWl5jRtVjswRqgpNsz7vM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DoC6dU7b; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DoC6dU7b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1720D1F000FF;
	Sat, 12 Sep 2026 14:11:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789222268;
	bh=y5dbfq9iNPTpWBp0DTTW/ALxqkTNnhxXE1HaUSx1mdo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DoC6dU7bA7ROeA1q+ZRrIZqzhaTDPAnlSilGWhy3ul+6xRh4GhG9UgBAjiesRh9CF
	 1J2DU/reSnHJlJYi22h3on9iZKvfNodjni4Ra1C0svoDqJvp8KS1WdTAPm+Fesl8K6
	 yW38aeKCbfKscYRNqBF65rQyxGS5hjX38VUR8ATg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Junyi Liu <moss80199@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0553/1424] ksmbd: fix durable reconnect error path file lifetime
Date: Sat, 12 Sep 2026 08:49:45 +0200
Message-ID: <20260912065619.686423261@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Junyi Liu <moss80199@gmail.com>

[ Upstream commit 3515503322f4819277091839eed46b695096aca5 ]

After a durable reconnect succeeds, ksmbd_reopen_durable_fd() republishes
the same ksmbd_file into the session volatile-id table. If smb2_open()
then takes a later error path, cleanup first calls ksmbd_fd_put(work, fp)
and then unconditionally calls ksmbd_put_durable_fd(dh_info.fp).

In this case fp and dh_info.fp are the same object. The first put drops the
reconnect lookup reference, but the final durable put can run
__ksmbd_close_fd(NULL, fp). Because the final close is not session-aware,
it can free the file object without removing the volatile-id entry that was
just published into the session table.

Use the session-aware put for the final reconnect drop when the reconnect
had already succeeded and the error path is cleaning up the republished
file. Earlier reconnect failures, before fp is assigned to dh_info.fp, keep
using the durable-only put path.

Fixes: 1baff47b81f9 ("ksmbd: fix use-after-free in smb2_open during durable reconnect")
Signed-off-by: Junyi Liu <moss80199@gmail.com>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/smb2pdu.c | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index b61b97bb21cd7..8d04f64cb0830 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -3782,8 +3782,19 @@ int smb2_open(struct ksmbd_work *work)
 		ksmbd_debug(SMB, "Error response: %x\n", rsp->hdr.Status);
 	}
 
-	if (dh_info.reconnected)
-		ksmbd_put_durable_fd(dh_info.fp);
+	if (dh_info.reconnected) {
+		/*
+		 * If reconnect succeeded, fp was republished in the
+		 * session file table.  On a later error, ksmbd_fd_put()
+		 * above drops the session reference; drop the durable
+		 * lookup reference through the same session-aware path so
+		 * final close removes the volatile id before freeing fp.
+		 */
+		if (rc && fp == dh_info.fp)
+			ksmbd_fd_put(work, dh_info.fp);
+		else
+			ksmbd_put_durable_fd(dh_info.fp);
+	}
 
 	kfree(name);
 	kfree(lc);
-- 
2.53.0



