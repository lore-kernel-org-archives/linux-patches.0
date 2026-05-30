Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 662483B3C01;
	Sat, 30 May 2026 17:47:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780163243; cv=none; b=eu44JMhmzkjoGvb20v/Y3v+vwhSqdI72H6O4GGpDZ5Xm7c0skfPbfzYTKekE51pk5Iz0YDGAK5MfKwlAv/JKljZ5fAdmnaB9CZCKy5uMq4ZUJerWGm23zpkrm3exydWlxVdK3Ah9emx7wX5kWe1MekzeKoiAfFB9MqwnEej4EtA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780163243; c=relaxed/simple;
	bh=hzKSYUQ2BmnN5eDbkb91yirb5PINX+lwXYdwIcQM3Zw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JfvLMZ5foNQK0DMab6ZeY4l/RsOcaCbnKzTt6h+csInXyaE0/bbjhh+KrvIJ+tUZB5+A909BQ8IciK0LHnVszJy36EWU4xmFARqzANWyIJ6FZ8q20jRIJUYtdRVSl1yUyUcTNEOpbmp3DZRblP5T5qElNp6PiBiRQLmCRKjLejk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wysRI/u0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wysRI/u0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F21A1F00893;
	Sat, 30 May 2026 17:47:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780163242;
	bh=wV8cfKZ9UrccuaLMQ91xQJaUD5cTgx5+xQ8Idz17ALk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wysRI/u0kbT6IlJVJyjQST9wk22cw0J7B9Cd+QVqpdawQ0mdTt6RxKHxlxFVOUtVC
	 TG3Wbv7a3rOlTqq4FzW9eTdl7s0W0vNQhuT73zxwQ4P/iWzjvI7S8nlGhgVlr/Gg9c
	 jWc9dxu0ltJ0XGM9zIX3RKOieTbf2kfQhQ7nQHIg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hyunwoo Kim <imv4bel@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Alva Lan <alvalan9@foxmail.com>
Subject: [PATCH 5.15 166/776] ksmbd: unset conn->binding on failed binding request
Date: Sat, 30 May 2026 17:58:00 +0200
Message-ID: <20260530160244.780383408@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160240.228940103@linuxfoundation.org>
References: <20260530160240.228940103@linuxfoundation.org>
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
Signed-off-by: Alva Lan <alvalan9@foxmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ksmbd/smb2pdu.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/ksmbd/smb2pdu.c
+++ b/fs/ksmbd/smb2pdu.c
@@ -1949,6 +1949,7 @@ out_err:
 			}
 		}
 		smb2_set_err_rsp(work);
+		conn->binding = false;
 	} else {
 		unsigned int iov_len;
 


