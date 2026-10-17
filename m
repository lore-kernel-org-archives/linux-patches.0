Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E57903451DA;
	Sat, 17 Oct 2026 17:56:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792259796; cv=none; b=qXDz5u/RSZXWAyxxVKDmf9iHTVjgi68dIQAfped0aW6ebwFgJYhhbnGIiOgnyElMLuhKlYr8akG9BO/dhpZlot+Dn409pUCEN2kLe/HEJtZPUMXeyWEsRtRra38Yf84uDyhd7t6ORPiEHcwE3Z2nGkCrrwKjdNiLNELPC7/4qck=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792259796; c=relaxed/simple;
	bh=8YBEmqEJ0spSyq0sP6LtmxBt+enyYa1uZu2AUn5YgEo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mpNHXnohvqpwYtNDt4ObEDy174jkQGn/VRaVHnxhLuXFHffa8ZA1LdQs394jhl+JEoIGtL33EZp8hCz7JZICC3RNdPw8rQwFUHu2Ixv3/vKnhmzSZKQ/CkkgZBq03Scf3Z9nuD9CwrUmDhU3JiJ2pp+xLvGM8H8BJo5p3KLv9lo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EsmZ42/Q; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EsmZ42/Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 492C81F000C4;
	Sat, 17 Oct 2026 17:56:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792259795;
	bh=F5ZvUwRBRsvCUaTS8WUw5j6C9aMWzbhfCg2oEuqKRa0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EsmZ42/Q5UbBhb/0DPyR4/DbiJxBXcWJaJzFElRbMUiCnL+UBCiOdtub+0iwn1hoc
	 GCKK3M232RerAMItnbAZ+Qig0lt2HBBVHO7xipPDJdAWqwf29aZI8J8DikgL6heJDU
	 7UQfj/Hm0TrWmP9FeXNwv9SzjAq8p0Hze0tWNQ5I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cheryl Babcock <cheryl@renat.io>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1334/1674] ksmbd: zero pipe read compound padding
Date: Sat, 17 Oct 2026 18:00:06 +0200
Message-ID: <20261017160505.387060559@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Namjae Jeon <linkinjeon@kernel.org>

[ Upstream commit 73f860489e3be2245598d1819226304fc5b87291 ]

Compound response handling extends the last response iov to an eight-byte
boundary.

smb2_read_pipe() allocates only the payload size, so the alignment padding
can expose up to seven bytes of uninitialized kernel heap memory.

Allocate the aligned size and clear the unused tail before pinning the
response buffer.

Fixes: e2b76ab8b5c9 ("ksmbd: add support for read compound")
Reported-by: Cheryl Babcock <cheryl@renat.io>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/smb2pdu.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 90186e062257a..71156b94b85d2 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -6798,13 +6798,18 @@ static noinline int smb2_read_pipe(struct ksmbd_work *work)
 		}
 
 		aux_payload_buf =
-			kvmalloc(rpc_resp->payload_sz, GFP_KERNEL);
+			kvmalloc(ALIGN(rpc_resp->payload_sz, 8),
+				 GFP_KERNEL);
 		if (!aux_payload_buf) {
 			err = -ENOMEM;
 			goto out;
 		}
 
 		memcpy(aux_payload_buf, rpc_resp->payload, rpc_resp->payload_sz);
+		if (rpc_resp->payload_sz & 7)
+			memset(aux_payload_buf + rpc_resp->payload_sz, 0,
+			       ALIGN(rpc_resp->payload_sz, 8) -
+			       rpc_resp->payload_sz);
 
 		nbytes = rpc_resp->payload_sz;
 		err = ksmbd_iov_pin_rsp_read(work, (void *)rsp,
-- 
2.53.0



