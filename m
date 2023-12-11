Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C99ED5101A;
	Mon, 11 Dec 2023 18:29:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eRDpOC6Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 502BEC433C8;
	Mon, 11 Dec 2023 18:29:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702319345;
	bh=XAWtbUBoo7pntgv33dpsO/j3uS+pMNk4x6qaj/rWciM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eRDpOC6QPVerUmEpIJ2IDEjtuHJOL+aC5+jSGK2ZwxEztEgxDxhfTEK0MsudxDAxq
	 3X5ruAXHAPiqndFLGtVgnTP89wTdnBJagksh58NvLgATbZtyiiz4x8JfpMZpEdueeg
	 HJgjpX+JT/DV1qKnB7Pmwzp6bip7aQ79YJipidIU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Fastabend <john.fastabend@gmail.com>,
	Jann Horn <jannh@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 069/244] net: tls, update curr on splice as well
Date: Mon, 11 Dec 2023 19:19:22 +0100
Message-ID: <20231211182048.905196928@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231211182045.784881756@linuxfoundation.org>
References: <20231211182045.784881756@linuxfoundation.org>
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

From: John Fastabend <john.fastabend@gmail.com>

[ Upstream commit c5a595000e2677e865a39f249c056bc05d6e55fd ]

The curr pointer must also be updated on the splice similar to how
we do this for other copy types.

Fixes: d829e9c4112b ("tls: convert to generic sk_msg interface")
Signed-off-by: John Fastabend <john.fastabend@gmail.com>
Reported-by: Jann Horn <jannh@google.com>
Link: https://lore.kernel.org/r/20231206232706.374377-2-john.fastabend@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/tls/tls_sw.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/tls/tls_sw.c b/net/tls/tls_sw.c
index 779815b885e94..27cc0f0a90e1f 100644
--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -952,6 +952,8 @@ static int tls_sw_sendmsg_splice(struct sock *sk, struct msghdr *msg,
 		}
 
 		sk_msg_page_add(msg_pl, page, part, off);
+		msg_pl->sg.copybreak = 0;
+		msg_pl->sg.curr = msg_pl->sg.end;
 		sk_mem_charge(sk, part);
 		*copied += part;
 		try_to_copy -= part;
-- 
2.42.0



