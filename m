Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6D043BADB2;
	Tue, 21 Jul 2026 21:12:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784668358; cv=none; b=jzFMg9knJAWMpqBhjhiXYhLi/fxnzv9jcKb82C3bFjWGH+cm/8z3j6ppkN7mE402mQPxhgiowgY/nF2TaTGorB0z53gsNEeWdBfU00bkjdqQXJzYBJjsEzraf58WOsh7yWr1/4Nhp7m15PrmfQjQYswG02iD1VzopEBoAwqJHiQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784668358; c=relaxed/simple;
	bh=aaY33ggzEobalw+tHxaxti95ILXgNnYb08jUl4k30yU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GsMcoU195blo8UW3OH7f0pfCfJrvOWVEMUfIl8BT/s2zNgXiw4L3kF8btGn05XA9TquXfUxCMMNXt82ywSQpoexRzalpS+8O3Lde6domE0XwYfHsx+0PujbTjRtHx4tOV1xM041HV20gfzmOEBBijxlYgP70IPYXHsceFETgLt8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Xg4oqOIS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Xg4oqOIS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 468751F000E9;
	Tue, 21 Jul 2026 21:12:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784668356;
	bh=3FCm0uH2eRUxRCPBf45V98xEIONO0bOzIL5563HGTWs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Xg4oqOISk5cCi7g9nqPdUBWTI4F7Ikkb2oEGaMm+TQLx0q+aVlzkDp3GjUKJwmBn3
	 vBWB7DrBBeojZikMTzGr1ZoDt8uazgLk0Y9zyBRRy1e+yiVdKp1Fh2j2B+DRhVXbX3
	 y+Owiutrb9j/XiZkviaTM0rjgVClJgMU+gvGI3mk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haoxiang Li <haoxiang_li2024@163.com>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.1 0143/1067] smb: client: Fix next buffer leak in receive_encrypted_standard()
Date: Tue, 21 Jul 2026 17:12:24 +0200
Message-ID: <20260721152427.794357197@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Haoxiang Li <haoxiang_li2024@163.com>

commit 1c6267a1d5cf4c73b656f8181b310cbbb3e4767b upstream.

receive_encrypted_standard() allocates next_buffer before checking
whether the number of compound PDUs already reached MAX_COMPOUND. If
the limit check fails, the function returns immediately and the newly
allocated next_buffer is not assigned to server->smallbuf/server->bigbuf,
making it leaked.

Move the MAX_COMPOUND check before allocating next_buffer.

Fixes: b24df3e30cbf ("cifs: update receive_encrypted_standard to handle compounded responses")
Cc: stable@vger.kernel.org
Signed-off-by: Haoxiang Li <haoxiang_li2024@163.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/smb2ops.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -5189,6 +5189,12 @@ receive_encrypted_standard(struct TCP_Se
 one_more:
 	shdr = (struct smb2_hdr *)buf;
 	next_cmd = le32_to_cpu(shdr->NextCommand);
+
+	if (*num_mids >= MAX_COMPOUND) {
+		cifs_server_dbg(VFS, "too many PDUs in compound\n");
+		return -1;
+	}
+
 	if (next_cmd) {
 		if (WARN_ON_ONCE(next_cmd > pdu_length))
 			return -1;
@@ -5212,10 +5218,6 @@ one_more:
 		mid_entry->resp_buf_size = server->pdu_size;
 	}
 
-	if (*num_mids >= MAX_COMPOUND) {
-		cifs_server_dbg(VFS, "too many PDUs in compound\n");
-		return -1;
-	}
 	bufs[*num_mids] = buf;
 	mids[(*num_mids)++] = mid_entry;
 


