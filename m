Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42FA847010F;
	Tue, 21 Jul 2026 17:59:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784656746; cv=none; b=BNZJODw/SfErakF5GvMtAbEgPvQNg3Vymss+6WCS7qbd3y8aqwSg0sggDKfVjJi+xapaEuGizIU27zyo7CleoArlvv8ICEKzEtwCt+J8tJkzTwjPK+LQaDlzpCOT4ZKV7SNFdcXhOab6o99L5/NA8aMtAREGhzi79JNiSUl8rvw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784656746; c=relaxed/simple;
	bh=KVBYGfHx7aUQpv7IWQiBld88jxURrXTo7Ga8QX20sTs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GdtXqtxDG3ZTJsz4yIOqV985xXyDm8JHOosYgdHoSlXPqpcE6GUybKqbwBagtzofoP2dhszj9KxiewotXgrpsAYnFvU93WkSmc1X+Elutnx2Uv8hVGeIatn5uwVQIOjQ3Bzf82D6f8D59a+S4cwSIFsUeOXm9OM55Ny1AyrWAVY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jY+zfM4Y; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jY+zfM4Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3A241F000E9;
	Tue, 21 Jul 2026 17:59:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784656745;
	bh=TveCyXSUPF35efViFoeBYID7R/YrV2WtkVkjfr+s2kI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jY+zfM4Y2O8ujSJCx8iRw5Tk5x90CVgsojgzOtQnqz7IclXf2rIMv94qhG25T25eb
	 8IrMrjKLbD9FvbEm/ojQYntC5o61z6PaHEXfzbCM+clhvvUpgFHHsRAru0m6zannrH
	 kPQqFXm2ZPw1FLCP2x8N0hawAhFJPbWXbGxpIQlA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Hannes Reinecke <hare@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0502/1611] handshake: Require admin permission for DONE command
Date: Tue, 21 Jul 2026 17:10:18 +0200
Message-ID: <20260721152526.636818147@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit 81246a65303d9635266b1334490142caaf86a11f ]

ACCEPT and DONE are the two downcalls of the handshake genl
family, both intended for use by the trusted handshake agent
(tlshd). ACCEPT already requires GENL_ADMIN_PERM; DONE has
no privilege check at all.

The fd-lookup in handshake_nl_done_doit() only confirms that
some pending handshake request exists for the supplied sockfd;
it does not authenticate the sender. An unprivileged process
that guesses or observes a valid sockfd can therefore submit
a DONE with HANDSHAKE_A_DONE_STATUS == 0, leaving the kernel
consumer to proceed as if the handshake succeeded. A non-zero
status on a forged DONE tears down a legitimate in-flight
handshake before tlshd can report its real result.

Fixes: 3b3009ea8abb ("net/handshake: Create a NETLINK service for handling handshake requests")
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Reviewed-by: Hannes Reinecke <hare@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Link: https://patch.msgid.link/20260609141831.90694-1-cel@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/netlink/specs/handshake.yaml | 1 +
 net/handshake/genl.c                       | 2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/Documentation/netlink/specs/handshake.yaml b/Documentation/netlink/specs/handshake.yaml
index 1024297b38513a..ffec12b467597d 100644
--- a/Documentation/netlink/specs/handshake.yaml
+++ b/Documentation/netlink/specs/handshake.yaml
@@ -125,6 +125,7 @@ operations:
       name: done
       doc: Handler reports handshake completion
       attribute-set: done
+      flags: [admin-perm]
       do:
         request:
           attributes:
diff --git a/net/handshake/genl.c b/net/handshake/genl.c
index a5fa8b27f22423..7ec805ae3d7d6f 100644
--- a/net/handshake/genl.c
+++ b/net/handshake/genl.c
@@ -37,7 +37,7 @@ static const struct genl_split_ops handshake_nl_ops[] = {
 		.doit		= handshake_nl_done_doit,
 		.policy		= handshake_done_nl_policy,
 		.maxattr	= HANDSHAKE_A_DONE_REMOTE_AUTH,
-		.flags		= GENL_CMD_CAP_DO,
+		.flags		= GENL_ADMIN_PERM | GENL_CMD_CAP_DO,
 	},
 };
 
-- 
2.53.0



