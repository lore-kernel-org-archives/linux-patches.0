Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795021395;
	b=BruVOtCPjxjkNEC7KDIx1ouOg8UiBC+y0ASo2MDCDxCSY2WiZz0v10AUItSPTP+JAmbG
	 LojkVtzdmcELmmerkixZQRDrOUA9rq0ClPFzyaGFtkxwZkUsh08wY7MyhZNXJ4ls2+pSo
	 MONz83y2t/I0ZN8tiiZIgZY7JvlcFoCNOtFOL3CWR+zJJLhlIkG8WcR90FhC8eh1seYou
	 /KiKUVU4KiUs41MVFNO6/74lfsU22by6bux5IAZLv+mnQKxsXqtq5ZCSll5umEOb/Kfeg
	 5fDS4aGsMydpkl6Pjxuq7NkkvW3d7PYtFjj/9lVtiWI0AmUHcbTsuU2Z157Y/zXZ5eg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795021395;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=5nNDRm0nXISLhHJBAQ+IIZoWdUU3GYZ6R6u5BLwBGeU=;
	b=2ccbo136jGMWjEdme4hPm7jmJVk8QGtcU6VbXXSqDv0kKEqMwCmJiD6lcr0do6wcaNmh
	 9zT2vT+GgBrmoV5Ljdkp7Zn/0WVpVbBENnHJvlb3gU/GREwPIAc9NDk4CnCBoZ2LWbDTZ
	 NjvmJWrJdOPxUtxGjVJexKN1BR/tWLvtE9wex64pa6DNSzlaPBI7Y/7niiY86dZ54S5+t
	 oxrglq9WMQQXgKyv5hl0X7h2XHKh6T11s8jlz48LvL0PosTQS660XvXoscw3xFJYmb8ek
	 yaLOQw+XEtkSmGvT2qDtyi6CKRPMyoe3Euoy7BtH47pLEj0gR4TqVnamxU7reKBOSDQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=h4D2czsm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28C71606A336;
	Wed, 18 Nov 2026 17:03:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=h4D2czsm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EC591F000C4;
	Wed, 18 Nov 2026 17:03:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795021395;
	bh=5nNDRm0nXISLhHJBAQ+IIZoWdUU3GYZ6R6u5BLwBGeU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=h4D2czsmEHvdiDmLCp2snk8H2fMGXAIQ5Fob8KsR4OtkPjRT2MpdVJ+DnGySe9oeR
	 u/flcjoqqm4wBFf2VHh9f5YRvgBMQrcTC/e3zjzeBMrJO/qdHtOheZNpbJOVunWyaG
	 Ip/poMo/UkTiFQxVJPj7LDwBmIEniy/GBXzo0MGc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dairui Zhang <zhangdairui@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2292/2651] ksmbd: fix durable reconnects for root shares
Date: Wed, 18 Nov 2026 15:58:52 +0100
Message-ID: <20261118150407.774652120@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index 56f07914197c1..f00d4d81283a8 100644
--- a/fs/smb/server/vfs_cache.c
+++ b/fs/smb/server/vfs_cache.c
@@ -1943,6 +1943,10 @@ int ksmbd_validate_name_reconnect(struct ksmbd_share_config *share,
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



