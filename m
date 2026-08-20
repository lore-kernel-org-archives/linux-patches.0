Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A395377A82;
	Thu, 20 Aug 2026 16:36:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787243799; cv=none; b=ux2AnPZ2YiLrKZGVu7oWCAEWAtgkI0atQzKw88hygKVEWGl3moEZaQEhGQGhK9pkQZdwfJerXu4zgLU1waemz+IocSzKeZs2zKaDvIOoHa+4lv4ODeEOeMGLxrkSppS93NRUO2zvX9elfG+Bl1jc8kEpXRS89fIRzRPrQnHhd70=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787243799; c=relaxed/simple;
	bh=j53EUQjB3YwWG/vCKgOjW+kewL/R/WoZ/eSCe7VxOIo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t5FCN0wvxYHVwhVhno9kllIPoE2YgRPwM0rZ9MST8ulJ8WSs9Ox140RRrmA5W5fZ27zM5HLLZaCYdmSB+qlvEO0Uq+TsxcaXuFbw4ksKfGqwO9hT8nqKeod7DNbRPUvrhAjLZxzBR5swmwXLLN4w+GlpQ1blFhIAbYBNoNiZ7vg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lfrFFKky; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lfrFFKky"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64BDD1F00A3A;
	Thu, 20 Aug 2026 16:36:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787243797;
	bh=Epq/ntW/RyXtdIwPHl5Cy05sO6ZK/ix2p2pM1SwQ4oo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lfrFFKkyfy3r1gzS2HxI+Bod6nS+37Mx+Ec+vfxbXOocZW7domTCJs5vJAVJprEN8
	 E9OOHzzM/vZPbvrPfkhdOt55FS6+BPO9c8BbegbOqKheBp4IvHr8P1J84Y2J8TyJcp
	 +W/7bjyETnqVRdd/tcavPfO6Yh6qR0gnx9YiRcC4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Howells <dhowells@redhat.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	ChenXiaoSong <chenxiaosong@kylinos.cn>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 219/272] smb/server: fix minimum SMB1 PDU size
Date: Thu, 20 Aug 2026 16:56:43 +0200
Message-ID: <20260820145238.173546367@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145231.229664293@linuxfoundation.org>
References: <20260820145231.229664293@linuxfoundation.org>
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

From: ChenXiaoSong <chenxiaosong@kylinos.cn>

[ Upstream commit 3b9c30eb8f5aaad4a54cdfa470b74c0467cc71e8 ]

Since the RFC1002 header has been removed from `struct smb_hdr`,
the minimum SMB1 PDU size should be updated as well.

Fixes: 83bfbd0bb902 ("cifs: Remove the RFC1002 header from smb_hdr")
Suggested-by: David Howells <dhowells@redhat.com>
Suggested-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
Reviewed-by: David Howells <dhowells@redhat.com>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Stable-dep-of: cfc0b8e5080a ("ksmbd: validate minimum PDU size for transform requests")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ksmbd/connection.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/fs/ksmbd/connection.c
+++ b/fs/ksmbd/connection.c
@@ -305,7 +305,8 @@ bool ksmbd_conn_alive(struct ksmbd_conn
 	return true;
 }
 
-#define SMB1_MIN_SUPPORTED_HEADER_SIZE (sizeof(struct smb_hdr))
+/* "+2" for BCC field (ByteCount, 2 bytes) */
+#define SMB1_MIN_SUPPORTED_PDU_SIZE (sizeof(struct smb_hdr) + 2)
 #define SMB2_MIN_SUPPORTED_HEADER_SIZE (sizeof(struct smb2_hdr) + 4)
 
 /**
@@ -365,7 +366,7 @@ int ksmbd_conn_handler_loop(void *p)
 		if (pdu_size > MAX_STREAM_PROT_LEN)
 			break;
 
-		if (pdu_size < SMB1_MIN_SUPPORTED_HEADER_SIZE)
+		if (pdu_size < SMB1_MIN_SUPPORTED_PDU_SIZE)
 			break;
 
 		/* 4 for rfc1002 length field */


