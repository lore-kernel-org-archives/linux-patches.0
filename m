Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60674143C5F;
	Tue, 23 Apr 2024 21:46:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713908764; cv=none; b=Jvz+dKV9O3xhJSJ3rwEjLpS1HhFJo7m/sIJ9JwPJ+Pa2J1iG7/XEADZTsv3uHbyV2wcMXFXkrkklpJ5ewA/BS1q7p1h963Zb3aegKVEI0684CZV5Gy2mxxDWZrEVKJltZDlwaPhWztifLGGdssdc6+Mzv04s2Ifjby9j1Cu8vs0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713908764; c=relaxed/simple;
	bh=1ad4jDzjrACBsYrSBU110bfTqLygXNsw6AD6aFj8BGM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UVAchh4LZSZJN74AKjqMbmpzGEk0JRDN04AQEbUAdkOrIKj2gBh9huDK0YxQrNVOpC0QijtsDXMJUjCspSH9TcjFAZIhkQ9HWhji9FFDG0KAezLTWNhI0rtzvE5xC+yASO6vP//Yry383k8QeJnAdShZdUIjpIye6VfDgcxIBpg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OO5sNxMQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OO5sNxMQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36BE0C32781;
	Tue, 23 Apr 2024 21:46:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713908764;
	bh=1ad4jDzjrACBsYrSBU110bfTqLygXNsw6AD6aFj8BGM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OO5sNxMQftKZneqDt3Ayd2HlxSdqwqxmUGlfJfJMXfvqT2QDJeqwPSvGbCVt0InhM
	 7d9Gv9jYaYkFdzuHPQ2v08ldaiC6UCBmm7LLO7CiSR/2tpnY5vv4NHfH3uDpOsGLXt
	 W4AttQta6+JOuAOihe0kXRJKZfweSmLUP08DQ+Cc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.1 138/141] ksmbd: validate request buffer size in smb2_allocate_rsp_buf()
Date: Tue, 23 Apr 2024 14:40:06 -0700
Message-ID: <20240423213857.703342723@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240423213853.356988651@linuxfoundation.org>
References: <20240423213853.356988651@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Namjae Jeon <linkinjeon@kernel.org>

commit 17cf0c2794bdb6f39671265aa18aea5c22ee8c4a upstream.

The response buffer should be allocated in smb2_allocate_rsp_buf
before validating request. But the fields in payload as well as smb2 header
is used in smb2_allocate_rsp_buf(). This patch add simple buffer size
validation to avoid potencial out-of-bounds in request buffer.

Cc: stable@vger.kernel.org
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/server/smb2pdu.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -534,6 +534,10 @@ int smb2_allocate_rsp_buf(struct ksmbd_w
 	if (cmd == SMB2_QUERY_INFO_HE) {
 		struct smb2_query_info_req *req;
 
+		if (get_rfc1002_len(work->request_buf) <
+		    offsetof(struct smb2_query_info_req, OutputBufferLength))
+			return -EINVAL;
+
 		req = smb2_get_msg(work->request_buf);
 		if ((req->InfoType == SMB2_O_INFO_FILE &&
 		     (req->FileInfoClass == FILE_FULL_EA_INFORMATION ||


