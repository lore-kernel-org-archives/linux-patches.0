Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22DDA24CEEA;
	Sat, 12 Sep 2026 11:02:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789210928; cv=none; b=HMt1ekQsI2/WpO5P3LmffVc8OO1+B5AYc7ilXlpHrpK9DKGNXt1SdxlWvAg9geTqi2YqkKk/WUk9OBbTCBI6gOZpXvwT9vOc+nIDBUquTeDzIDrZHmzd0JF+SI3QOW3wCJMi430+bDa+mi4lYPIEFAePS0xrEzQssXggmUq+Ico=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789210928; c=relaxed/simple;
	bh=8ZMgK6Bv6Vr9n1uAdkQ3BrYXfNmT3Po52knWoNM2Oc4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c05Q94zXJ+T3fmKVMiGxgsw+Wp+Wza7bcUDBA/WJxzrxq4Geh0X/C4FCBBkOzcAMDG1fhf69KOSdjm/K2F8Wlc7rDSh0Vpt88wLA+8W3cnlv4CFjK5ZeRep0wbX0zlpg3Tol1C5ViIK8hAQI9uhC0bioVVXS5mVkaW9uy2nzZfE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oYip5+te; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oYip5+te"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 643EC1F000FF;
	Sat, 12 Sep 2026 11:02:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789210927;
	bh=pS4pjV00qaxPacwI6LmJzBzKU7KIjlTf1wNZyX32OUE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oYip5+teOFHMchmKoCIf3S64swron/OqXmmXwYzCOPHUmVdm1GgzcylOYAcumdMHE
	 7YUSh1LVwa8VrTGEikRTDjEI6hfWOKN1+edy0ISAAtCD3x4yQqbWcalC58BjRlLUN+
	 eZ2Xc6M5iAV4C5jZhSAKSgvi8DO9RygEwLgk8TBI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Breno Leitao <leitao@debian.org>,
	Simon Horman <horms@kernel.org>,
	David Heidelberg <david@ixit.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1126/1518] nfc: llcp: read llcp_sock->local under the socket lock in getsockopt
Date: Sat, 12 Sep 2026 08:54:55 +0200
Message-ID: <20260912065648.926362515@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Breno Leitao <leitao@debian.org>

[ Upstream commit 36812527052c5bfb1ec6c1e292d67a5bf76b750f ]

nfc_llcp_getsockopt() read llcp_sock->local before lock_sock(sk) and
then dereferenced the cached pointer inside the locked region.
llcp_sock_bind() assigns and clears llcp_sock->local under the same
socket lock, dropping the last reference on its error path. A
getsockopt() racing an in-flight bind() can observe the pointer, block
on lock_sock(), and then dereference a freed nfc_llcp_local once bind()
has unwound.

Move the llcp_sock->local read and the NULL check inside the
lock_sock(sk) region so bind() cannot mutate or free the pointer between
the load and the use.

Fixes: 26fd76cab2e6 ("NFC: llcp: Implement socket options")
Signed-off-by: Breno Leitao <leitao@debian.org>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20260521-fix_llc-v2-2-ab44cc09179c@debian.org
Signed-off-by: David Heidelberg <david@ixit.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/nfc/llcp_sock.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/net/nfc/llcp_sock.c b/net/nfc/llcp_sock.c
index b2028016ed971..507447bbceea4 100644
--- a/net/nfc/llcp_sock.c
+++ b/net/nfc/llcp_sock.c
@@ -325,14 +325,16 @@ static int nfc_llcp_getsockopt(struct socket *sock, int level, int optname,
 	if (len < sizeof(u32))
 		return -EINVAL;
 
-	local = llcp_sock->local;
-	if (!local)
-		return -ENODEV;
-
 	len = min_t(u32, len, sizeof(u32));
 
 	lock_sock(sk);
 
+	local = llcp_sock->local;
+	if (!local) {
+		release_sock(sk);
+		return -ENODEV;
+	}
+
 	switch (optname) {
 	case NFC_LLCP_RW:
 		rw = llcp_sock->rw > LLCP_MAX_RW ? local->rw : llcp_sock->rw;
-- 
2.53.0



