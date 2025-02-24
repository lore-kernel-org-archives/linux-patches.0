Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBA202747B;
	Mon, 24 Feb 2025 15:00:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740409245; cv=none; b=e3e4MCMUnoBlXnRryDjktIBGQNCilBK6Px53h2O2BfE3TDnWVVDQuqhpoWmM8O3f/3on5PqHdBOKFuiqqY9+xcPXd6W7xZUbygX5KniWkjnlwj5Idug79GgqSSkunM3Izb0p4qNIqhuu8i2CwrwO1ZkV4DY8R3/o1S/o6g3P4qQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740409245; c=relaxed/simple;
	bh=hRpCyBx08YAWDBjBehNRezchc+RpafUCUH3nezJ/wKE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kt545Fw/uNhkSs5MXpWheCoVmFq+RM39d8UmM5ODDAQXfjz2gH0QtHRJZTNm8YYWceIIKWNIpuDcY++ATK3TxNyWiojfImKvTKj5NkpxZbHkrkP56TaYdi2BdT78gEn2I1PYSYeAvJeBqjl8cO5iOycJEXkq8Es8Uhy212vssNg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RDYEpZl3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RDYEpZl3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D5AFC4CED6;
	Mon, 24 Feb 2025 15:00:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1740409245;
	bh=hRpCyBx08YAWDBjBehNRezchc+RpafUCUH3nezJ/wKE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RDYEpZl3ICJnWn0EL4IYrYJrt1Axj96brOy+LCo2zPjcI4EaHcnYb5XBVxD+g0ubP
	 mGrZDBhhvEMxTSwATbDOt7UB+joYNUndkc0EEbT0bdDxi+gevR5EATJvzJ6Bb/KkAP
	 Uein3O0H0/9ZX8Nufz3cwQcdg+W6BBcstxgIzN+w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haoxiang Li <haoxiang_li2024@163.com>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.13 129/138] smb: client: Add check for next_buffer in receive_encrypted_standard()
Date: Mon, 24 Feb 2025 15:35:59 +0100
Message-ID: <20250224142609.540647282@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250224142604.442289573@linuxfoundation.org>
References: <20250224142604.442289573@linuxfoundation.org>
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

From: Haoxiang Li <haoxiang_li2024@163.com>

commit 860ca5e50f73c2a1cef7eefc9d39d04e275417f7 upstream.

Add check for the return value of cifs_buf_get() and cifs_small_buf_get()
in receive_encrypted_standard() to prevent null pointer dereference.

Fixes: eec04ea11969 ("smb: client: fix OOB in receive_encrypted_standard()")
Cc: stable@vger.kernel.org
Signed-off-by: Haoxiang Li <haoxiang_li2024@163.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/smb2ops.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -4964,6 +4964,10 @@ one_more:
 			next_buffer = (char *)cifs_buf_get();
 		else
 			next_buffer = (char *)cifs_small_buf_get();
+		if (!next_buffer) {
+			cifs_server_dbg(VFS, "No memory for (large) SMB response\n");
+			return -1;
+		}
 		memcpy(next_buffer, buf + next_cmd, pdu_length - next_cmd);
 	}
 


