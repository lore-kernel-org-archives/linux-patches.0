Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D69B3BD22B;
	Mon, 23 Mar 2026 16:19:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774282797; cv=none; b=LgaGL4l0iuZyTRQk/+SBRqAdjAs5TLtpP3VzX7krVwZQ6R2OA8bv8ZFHK3HE2WDKNQtRpPXfRnJHGdnxio0pNg2/UZUCOrmqhdnlybqRmj/rje2ZfzLRn25zN1zYlr4i95gJcD8V/b/BgapsgngWCbJLoxpBEdKEm76054BSU4o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774282797; c=relaxed/simple;
	bh=fwxIFvcn+H1IbVd2tgHAN00KeCIOG6zRNM9n6KOyvjY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LE7GJfnQ4XbODTvDmO5JzreBnDRxxuuCFJFnFjJ/MOxFOsq50DapKx+c8pGKN4Pjs7+0X8ZY9XUhJ9zDaiax8Q8ZyVRXJx2z9WiU+o0M5jvVyuv3I+s5YMStBRj/lg5/dhM98Drwe0ywAAShB0OBj1DwZv08TxbhennznIGoPXc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=t/PMickK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="t/PMickK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9F36C4CEF7;
	Mon, 23 Mar 2026 16:19:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774282797;
	bh=fwxIFvcn+H1IbVd2tgHAN00KeCIOG6zRNM9n6KOyvjY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=t/PMickKIJcUXW/wpMmwKN0I5VZFr/NQaNr0JqF+/Ua7kFkrSFirk31N/h+5erii+
	 a8ypVW/d1boOEnThWCeR8yIr2SSVfGnVhCRAjiHGvvJpqNdvUT3NhUJVTuQIQnLuII
	 puJLSkUqIDbj3RphdXdgXzfKGpa+ldGBKlR22qqE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hyunwoo Kim <imv4bel@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.1 290/481] ksmbd: unset conn->binding on failed binding request
Date: Mon, 23 Mar 2026 14:44:32 +0100
Message-ID: <20260323134532.177697890@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134525.256603107@linuxfoundation.org>
References: <20260323134525.256603107@linuxfoundation.org>
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

From: Namjae Jeon <linkinjeon@kernel.org>

commit 282343cf8a4a5a3603b1cb0e17a7083e4a593b03 upstream.

When a multichannel SMB2_SESSION_SETUP request with
SMB2_SESSION_REQ_FLAG_BINDING fails ksmbd sets conn->binding = true
but never clears it on the error path. This leaves the connection in
a binding state where all subsequent ksmbd_session_lookup_all() calls
fall back to the global sessions table. This fix it by clearing
conn->binding = false in the error path.

Cc: stable@vger.kernel.org
Reported-by: Hyunwoo Kim <imv4bel@gmail.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/server/smb2pdu.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -1936,6 +1936,7 @@ out_err:
 			}
 		}
 		smb2_set_err_rsp(work);
+		conn->binding = false;
 	} else {
 		unsigned int iov_len;
 


