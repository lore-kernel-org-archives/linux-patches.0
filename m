Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CD075372DD;
	Wed, 23 Sep 2026 14:34:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790174078; cv=none; b=gYZCKDwlVnYGsLnQouKgfzidjy8qDURUakkWPx8hOonOPfOtQz9utRf1138cmDAQkSNBGXXPKK7+v71h2FNLsS5XT0d+XyhByYHoPlGASjpaF7d+c2xc055R21QD6cx47nqlx+HfTwrWtwWpaSuwoPNubVp8hkB/hdqAhKbAkb4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790174078; c=relaxed/simple;
	bh=3ZUjiJbSPA/uppnM8X7YRP6uJC7sKNSkkD+eEM8oW34=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RU78fc9leIGlGMuGGYm0n3RYI0dk2S8lJ2qVQuJiqpPiTKKvgK89E2ZSwz67N4JFAKMRkHeI7C7sTnAEHsf7UAsmAzUZTCx7GjPWk3s62FagLFUDR9HSAuvJP5rNXwK2kkILsJlj8KZ8ZQyzn+0uz6UYvmp31H/N39giDU5HBx4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GH6Di2eW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GH6Di2eW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FE1A1F000FF;
	Wed, 23 Sep 2026 14:34:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790174076;
	bh=xpersycC1b9cjPp85+WOCLtVKePsU/ez1SdHAw/eBoM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GH6Di2eWQXVN+Xgwwiqlcwp/xAL97Mja6vQ5GxICUxIsdGs94RYxKERGx6hOtqyHH
	 tLhODN7Al0Yl4rFOfiB5DcXwAJ/arUFd4yBRbPMulhstjzt0WlznvUm6T+Cgx541NZ
	 /w11SpmP3xM5aleb9sFaJgO7dTQk2OWS10R8NozM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Sorenson <sorenson@redhat.com>,
	David Howells <dhowells@redhat.com>,
	Paulo Alcantara <pc@manguebit.org>
Subject: [PATCH 7.2 427/438] smb: client: fix missing iov bounds check in parse_posix_sids()
Date: Wed, 23 Sep 2026 16:07:28 +0200
Message-ID: <20260923140655.989047253@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140644.756254324@linuxfoundation.org>
References: <20260923140644.756254324@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Frank Sorenson <sorenson@redhat.com>

commit b09d092eb24ad0110f16a9b7c1ed5d2a0c1733dc upstream.

In parse_posix_sids(), sidsbuf_end is calculated using the server-supplied
out_len without being validated against the actual length of the received
iov (iov_len).

If a server provides an inflated out_len, sidsbuf_end will point past the
end of the iov. This defeats the bounds guards in posix_info_sid_size(),
allowing out-of-bounds reads into adjacent kernel memory.

Fix this by rejecting responses where the calculated sidsbuf_end would
exceed the received iov boundaries or cause pointer wraparound.

Fixes: a90f37e3d7ac ("smb: client: parse owner/group when creating reparse points")
Cc: stable@vger.kernel.org
Signed-off-by: Frank Sorenson <sorenson@redhat.com>
Reviewed-by: David Howells <dhowells@redhat.com>
Signed-off-by: Paulo Alcantara <pc@manguebit.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/smb2inode.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

--- a/fs/smb/client/smb2inode.c
+++ b/fs/smb/client/smb2inode.c
@@ -76,6 +76,17 @@ static int parse_posix_sids(struct cifs_
 
 	sidsbuf = (u8 *)qi + le16_to_cpu(qi->OutputBufferOffset) + qi_len;
 	sidsbuf_end = sidsbuf + out_len - qi_len;
+	if (sidsbuf_end < sidsbuf) {
+		cifs_dbg(VFS, "%s: server-supplied out_len %u caused pointer wraparound\n",
+			 __func__, out_len);
+		return -EINVAL;
+	}
+	if (sidsbuf_end > (u8 *)rsp_iov->iov_base + rsp_iov->iov_len) {
+		cifs_dbg(VFS, "%s: server-supplied out_len %u overruns iov by %td bytes\n",
+			 __func__, out_len,
+			 sidsbuf_end - ((u8 *)rsp_iov->iov_base + rsp_iov->iov_len));
+		return -EINVAL;
+	}
 
 	owner_len = posix_info_sid_size(sidsbuf, sidsbuf_end);
 	if (owner_len == -1)


