Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793211650;
	b=B0jh29jnRTYX9itwMYxdrSKgXOaSl9wwewrAXYHgCop5TOOAIhUq3eTFTJcEHmxTnEL6
	 2tiVnaTYV28SuPjIqkQDJ+gy0wEIOEwHh3b3wuPy0eErx8XQFu6dAG/JkHhaJv0ar67i/
	 zVZFBpqUP+BYHGlJwyw8fkEf94sG2o9SLgMkrL+CJZR2Kd8OAi9IyhoD2YSmfr3pr4ArT
	 jGshWN4wELKJ6liELVc8NV9MvyWNldOCxQRnLMbG7k/opJ7OYngf84VZfHqcXj3N5vrnF
	 D8+5k8Pf2XA/Ir6YmcJRWsOTSg9wAedWc5/NYn1iOezAO/yPesCnW4KDzRqfP8gtz+g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793211650;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=krXzZ64QdgaxO8yrBdkBNojSrIHzj1NmAi+RFIZDzEw=;
	b=ziiWXkOzh9MoythclSfQnXlw66mpcbWc4xYe3SQUdqpDpEuyarzgj4GhJjZLVjDsV1P9
	 nWZ7MaM5isesZHT9Uif4JO1hPy3wdmqNzvl7ZDczWCVJu+NjI26ibj2g7EXmz89yx9/iq
	 ZR1vq0CfOiwFaHfLrtR361P1Ie9f0EN14wlCcL1qvRGK/czeJxV7ASheF0DR3HqKnMmtt
	 WuNJ8lML5J/gKxrfc4KovShMwmEVyJta+FmxN+2KITfILGm0lIbzIYad06VuVz3fB38cH
	 84U/uM6lCOhPdCj0eZ40FkF68n3NCRtunYIaUNnq4adAUKWgz7o9hihNg215KmYGF8Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Q1xneJT+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE5C4606A31D;
	Wed, 28 Oct 2026 18:20:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Q1xneJT+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A8D21F01825;
	Wed, 28 Oct 2026 18:20:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793211649;
	bh=krXzZ64QdgaxO8yrBdkBNojSrIHzj1NmAi+RFIZDzEw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Q1xneJT+u87CrJlC7rDsmlfiSGWq7t9/CP1Ba4ddqtPveIAGbLWvDRbZJ1MXj+Ocn
	 yLIz8r+yyBx8OFo6yV2Y8slcf1yXsPb/RmWNgFNxdC5bvFxtEOgeRiWvbUFLAIbIRn
	 yq7ZZtAZ4Y84hgvTyZIPtbYrXKyMoJn2f9dQF4EE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 451/571] fcntl: refuse F_SET_RW_HINT on an immutable inode
Date: Wed, 28 Oct 2026 17:59:58 +0100
Message-ID: <20261028170018.729106947@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian Brauner <brauner@kernel.org>

[ Upstream commit b0d1022b9bdb1e98aa7fb3244fdd50a58c61766c ]

An immutable inode is never written to so write hints are pointless.
Refuse the hint on an immutable inode the way setattr(), fallocate() and
etxattr() refuse their changes.

Fixes: c75b1d9421f8 ("fs: add fcntl() interface for setting/getting write life time hints")
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20261002-work-mount-fixes-4-v1-3-dd44b89d44ce@kernel.org
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
[ sashal: Moved the check from fcntl_set_rw_hint() into the F_SET_RW_HINT case of fcntl_rw_hint(). ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/fcntl.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/fcntl.c b/fs/fcntl.c
index 14ab4660d0240..cdc13f97d7adb 100644
--- a/fs/fcntl.c
+++ b/fs/fcntl.c
@@ -307,6 +307,9 @@ static long fcntl_rw_hint(struct file *file, unsigned int cmd,
 			return -EFAULT;
 		return 0;
 	case F_SET_RW_HINT:
+		/* nothing is ever written to it */
+		if (IS_IMMUTABLE(inode))
+			return -EPERM;
 		if (copy_from_user(&h, argp, sizeof(h)))
 			return -EFAULT;
 		hint = (enum rw_hint) h;
-- 
2.53.0



