Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41E10372EF0;
	Sat, 12 Sep 2026 11:58:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789214300; cv=none; b=c/eFFXyAfewl+2Z48nRUpS+r2UKRgyjMZHRHJPpZ9Jpm5uEvSH9KSWhRNFS035DHs1L2xO6qcelUPv/82LnpWdausprK5JuPtAtV3V+xt9ybiVrc5uqe//G68ZJMpw2Qjl4jTMJCg/XPCOvjXjWkv3Pgi4KPSpEay91wXK2k1c4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789214300; c=relaxed/simple;
	bh=2A0aYb247Zf0nWH3us7VnuxXaCNEiWtBcxfQ/oAa1dw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mi1rNxLEEOcJBuD8UYcP++ShvZpZz+hZNzh+2ntvMso7BfzHFob02KGwXBmtlka7DePIN2eEhsx9nvBEo7u6ai6LncO7+WLjgd2JOeTK7K92xNi7KXf+iLG/HjLXBXQLhwbL5l4l+CtZC6Uo2NTO6geQtnT6mQsxSpJiWIGT1ps=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rJz+pvrv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rJz+pvrv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED3AD1F000FF;
	Sat, 12 Sep 2026 11:58:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789214299;
	bh=/GPKgJ5NJD6araiDMhrxmWuoeAQOB5npez0vAdM/0W0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rJz+pvrvDqQYi4HETGdiDqekzBle7gx1kvC9IkQ49n/dXSTtFlla8WckM20aShisi
	 LNm/t+zhJddCEN6pQVC8n27RxqBfYGOLTbnUDYRCz5VD9Umzfiak6nzWi2Gs1Du0RM
	 FoyICiX9LGgtDBl/6qf4Bu7tp6K1XTpCnyPnnNSI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Junyi Liu <moss80199@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0299/1376] ksmbd: fix durable reconnect error path file lifetime
Date: Sat, 12 Sep 2026 08:45:25 +0200
Message-ID: <20260912065614.212162907@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 1fa6e701f817f..a8970ec45dab9 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -3804,8 +3804,19 @@ int smb2_open(struct ksmbd_work *work)
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



