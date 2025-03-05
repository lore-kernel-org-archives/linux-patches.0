Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C9212505A7;
	Wed,  5 Mar 2025 17:53:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741197236; cv=none; b=TzOSB0/H4fIQDsAGEp+YOIocE6fMBoxqYyAAt09YgpMfXAgOk7VG3qtP41g5vH8p3AYkgGtFAqRvkU4hERhvpfvi8Uy+bNXId2kVsgZ/qJZ+XsZC19qsqRfYejavUOX7EV4XfGk1asCJSLlWLejSFy3cPb8wDsMmsk3g28candI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741197236; c=relaxed/simple;
	bh=HM5ckCApPQx5U5JZeDJeEdJQMVsMP6bRA6BBDK1zRWI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MiIK5PMmX3M9n0K6ARJ+NH4PMH+Y8NYz8L3R3To+F3kF9I9ZRH+hvviEub3p4zeJjSFc5yCUuwCg51gBq4uvlSFK9CRDOhioXqn3L0z41VB34v0bBgrhcURMWUY+Z/DC00q7VaF9prTz15VrD0yeOceost3O5fljta+0LGD0Nl0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=t2DbT/Nh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="t2DbT/Nh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26239C4CED1;
	Wed,  5 Mar 2025 17:53:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741197236;
	bh=HM5ckCApPQx5U5JZeDJeEdJQMVsMP6bRA6BBDK1zRWI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=t2DbT/NhcbTDATRiwIM7KFkuVyQobq4tyE66EGUEFlgrXSrSRNgrxFHwTOOi/2fOW
	 m2iHHhOKprYdKg15ixOC27m2zKCG+/ElG5s5M9Nso6HPFhpE/WuURk4LWoUNsAgZpq
	 bqnn4yKYKIU8p39ZSxFO1s8y8Og16hgGWRvx+otU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haoxiang Li <haoxiang_li2024@163.com>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.1 086/176] smb: client: Add check for next_buffer in receive_encrypted_standard()
Date: Wed,  5 Mar 2025 18:47:35 +0100
Message-ID: <20250305174508.916751874@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250305174505.437358097@linuxfoundation.org>
References: <20250305174505.437358097@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -5158,6 +5158,10 @@ one_more:
 			next_buffer = (char *)cifs_buf_get();
 		else
 			next_buffer = (char *)cifs_small_buf_get();
+		if (!next_buffer) {
+			cifs_server_dbg(VFS, "No memory for (large) SMB response\n");
+			return -1;
+		}
 		memcpy(next_buffer, buf + next_cmd, pdu_length - next_cmd);
 	}
 


