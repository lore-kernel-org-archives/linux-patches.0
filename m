Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795622716;
	b=KJN40Mujq79Yw9PBBUQ8Wg9xKm4tou+lVye70F8+n+Ad2TwqwvybscX6E86b1aJV0t56
	 /tq2q9Z9hzCMV85/CVWFoiJjp8sW/GbzqRHjhZET7xCbEiIgNEu72vOlQ0Bf2Z30+oEWr
	 UVym8fcgZouVwwE3U/0R36vKSk+vgD49dIAlyVxI7bon2KWSv5lX005No49Plt8sv713F
	 wmyXTIngKBM8IGcDiklNHWnDHCBKF/OdluZTxUYdZZRz2OGkbPNEwNJ99xsnNR68mDa18
	 G4SvXOEYpIDreGfRSkjOll7BRW+xwK1PvQ/9o1eb+UnDaUC4xHDjS5r3A7mc5+0kgfg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795622716;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Tx9ARF6yR/EamZyRNpz5bprdCzNdzw/hcUrPVuLygKg=;
	b=bqPzskYtX5pu0jvGnEiAKH0Q9ttRaq0/SImzX5Vd2Z3xqwn92Ag0GY2vvvxXb8PQ16Fi
	 8C95BggrMNTw6JFwY1V1JC3lQci3YRBxgv6McP3Egadg2LeHFR/9JHzDKK+JhN0WGdRWA
	 XrMnvcPRultW9L6YAPtnVcc0By+kmbW3hC+sajqlnx1dVFVls3u86jEitB0H2rX+obzbf
	 LdqFcTwFiGeU5xL87c1AXmM7Fi2uJLe7KQcpIhcKsHDqlNxzKpLmgpK3O4fMH4L/JMSdf
	 9/Jc/enhlNuD94VwKyQ2v82SKDP3foB12o/XTLehV+cCGkeIfdPkyUdZ/lFGS+ezNtQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ii8aLUaZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9242606A321;
	Wed, 25 Nov 2026 16:05:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ii8aLUaZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2EBA1F000C6;
	Wed, 25 Nov 2026 16:05:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795622716;
	bh=Tx9ARF6yR/EamZyRNpz5bprdCzNdzw/hcUrPVuLygKg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ii8aLUaZ9bB9Iaot1ib4LLJpUCcOWYnHX01VIhYkGEFTFSQKGCVqI1SPii7/BONXh
	 rjentz1nfj3WO21Jbo2fbPcy9hG/ijZR5iXjod7LWg+d9IMbdGfFik7NvhiXTRiktJ
	 MOES7xAVOmMguiZSntz/7LchQ+pQa5/zMs7NxaEM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dairui Zhang <zhangdairui@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 624/990] ksmbd: fix durable reconnects for root shares
Date: Wed, 25 Nov 2026 15:33:11 +0100
Message-ID: <20261125143836.717420305@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Namjae Jeon <linkinjeon@kernel.org>

[ Upstream commit 25e36df831a47597c03c6239fbc71285e7d714c2 ]

When a share exports "/", ksmbd_validate_name_reconnect() expects
another slash after the share path. For a file at /foo, this rejects
the valid reconnect name "foo" even though the file is in the share.

Compare the requested name with the rendered file path after its
leading slash when the resolved share root is "/". Keep the
exact-root/empty-name check and reject rendered paths without an
initial slash.

Fixes: c8efcc786146 ("ksmbd: add support for durable handles v1/v2")
Reported-by: Dairui Zhang <zhangdairui@gmail.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/vfs_cache.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/smb/server/vfs_cache.c b/fs/smb/server/vfs_cache.c
index b1ee76949a2ea..52389fff3d4a0 100644
--- a/fs/smb/server/vfs_cache.c
+++ b/fs/smb/server/vfs_cache.c
@@ -1377,6 +1377,10 @@ int ksmbd_validate_name_reconnect(struct ksmbd_share_config *share,
 			/* the durable fp is the share root itself */
 			if (name[0])
 				ret = -EINVAL;
+		} else if (share_path_sz == 1 && share_path[0] == '/') {
+			if (ab_pathname[0] != '/' ||
+			    strcmp(ab_pathname + 1, name))
+				ret = -EINVAL;
 		} else if (len <= share_path_sz ||
 			   strncmp(ab_pathname, share_path, share_path_sz) ||
 			   ab_pathname[share_path_sz] != '/' ||
-- 
2.53.0



