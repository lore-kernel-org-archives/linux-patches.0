Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F0F773178;
	Tue, 23 Jan 2024 02:03:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705975434; cv=none; b=InEQcoCt4/A9uQCPyy01u1JQjBJFubYRQHvkL8DRVdyplsEWyDu4lXSXLwEoPQDuuFHXQBOPwokoFd0US00SL/x5yoC1GW24SxpSFopvgq8ArC+H165j7Wxqg8BqnEJWMAe5fGBxvViYy6ZAiA4N8LHHeXE4Sayd6UpcYKjGpL8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705975434; c=relaxed/simple;
	bh=ABgqYTCdi8ttw4QYsFbH6C3tqWTO6bhVCH+14YeV0YE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jRnF4F+eqzpTdDN5ONNVAp+JpK+a28oWaxU2n3xmBlRezmNmPaFhHfxaigrYbc9CjM1XTQtgzM15T2h4n3WBEEXek1oUwhxD76LlYamkt/JT3aVsyMfsE6Nw5cZRnN41B0Fap81yyLnpzcsekTtwxmAStkjs7IMJ5tanhezBfX4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NbmI9Jkn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NbmI9Jkn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 467EDC433C7;
	Tue, 23 Jan 2024 02:03:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705975434;
	bh=ABgqYTCdi8ttw4QYsFbH6C3tqWTO6bhVCH+14YeV0YE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NbmI9JknSb+g7x0h+ieqVwkrYP2qg1ZzPtpyJmL9oJikaVaXCM1tx0y1xzi6hc81+
	 dh23gbHKh89zSwYa3OY0pmC2iRUzTqnYilgzsjt0ZBZqiVwXFCvTFXc5zWaCDR2PHj
	 ppJtY9QRWU/vaVRygC36rIj1jM0uDqXLlUR0DPi0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.6 385/583] ksmbd: only v2 leases handle the directory
Date: Mon, 22 Jan 2024 15:57:16 -0800
Message-ID: <20240122235823.780602751@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235812.238724226@linuxfoundation.org>
References: <20240122235812.238724226@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Namjae Jeon <linkinjeon@kernel.org>

commit 77bebd186442a7d703b796784db7495129cc3e70 upstream.

When smb2 leases is disable, ksmbd can send oplock break notification
and cause wait oplock break ack timeout. It may appear like hang when
accessing a directory. This patch make only v2 leases handle the
directory.

Cc: stable@vger.kernel.org
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/server/oplock.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/fs/smb/server/oplock.c
+++ b/fs/smb/server/oplock.c
@@ -1191,6 +1191,12 @@ int smb_grant_oplock(struct ksmbd_work *
 	bool prev_op_has_lease;
 	__le32 prev_op_state = 0;
 
+	/* Only v2 leases handle the directory */
+	if (S_ISDIR(file_inode(fp->filp)->i_mode)) {
+		if (!lctx || lctx->version != 2)
+			return 0;
+	}
+
 	opinfo = alloc_opinfo(work, pid, tid);
 	if (!opinfo)
 		return -ENOMEM;


