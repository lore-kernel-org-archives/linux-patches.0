Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061538;
	b=rx/tFFfGYsEBn3hoJPgk1WhDQwQqMgFtgIUMoLJUYo3BupcmRZHqo/4mQIamQdB0lEIb
	 mgsMRJnSFyrCiF05qsEAa3qXTUJrhQdDZWdWpc+sXxpblrpNdeJR3td3WAw4PP8CK7ykD
	 Spl2Ne6QtZxdnSzrBAv55xupuXhdGzXF4ADC/8mpgWq2McUH+aOhckVp+eL/xvdigpMja
	 oOx9inmdY7un6AzhkRr/e+FskvCHOKw2k5mFO0JJYKLMiEue0S+Zky9t0I7sfU1MHVh1t
	 5qi6zydzV+/LQXxI7iQyEttKlXFyvK+ymZuGzTwwB2YhEpHhky8FKKDThCmY1fMnPJA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061538;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=oy/K1GZz4mTXS+Gg/Anuhf8p+mZjAcJHzC65jQjEZsQ=;
	b=BQjyt0V/twdNeMihs8IKklwICzF4tVSrlxAPuCz+AkMG0fX4bEFXCkWLUb1XV0TesV9g
	 sgKbxc8ISXtWYXyYseSTlFeI05FeWWQFSwa7Oo70A3m5oI754FwOQWfPsltzowI36zMVw
	 IeP9B+c3nYp7rLVk/uoVV9K3tFCVpUNGzk72yZY9Pju2F9DCGAU2I+mGBT/GkwnV7EzRY
	 c90o2vlLBL1G87nHTANvhZeoi9zIJQtpVsk/NTHoOVQEvBnw0FYbt0tHDpK/iETsX5qsY
	 3LC1FNWUiS7KWWG9ImUN53JtHhwNqhnO3isSkzjEfGqyAxNWi/P22TskfwAn9CiYi2Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Z+zqSztr;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E8B6606A326;
	Sat,  7 Nov 2026 14:25:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Z+zqSztr
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E092B1F0089F;
	Sat,  7 Nov 2026 14:25:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061538;
	bh=oy/K1GZz4mTXS+Gg/Anuhf8p+mZjAcJHzC65jQjEZsQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Z+zqSztroecIWIGYsabbKXiLHje//6ua8epoOYoww9JYkpTTL9FfzJajAuZCDZOw9
	 wHTGI90B+i1nBEgbnVYVplenKwaVFbTO0ByPoezET9RsTE4UxbgQvWxptTdrfvwqXP
	 zJh5pk01m/GIDJeXmyby/34Es40oCG9OJ2tmh+Ek=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dairui Zhang <zhangdairui@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 6.12 0585/1536] ksmbd: fix OOB read and cross-share confusion in ksmbd_validate_name_reconnect()
Date: Sat,  7 Nov 2026 08:43:21 -0500
Message-ID: <20261107135013.972940934@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dairui Zhang <zhangdairui@gmail.com>

commit 783a7fc454991544bf92268d8f2413af1a7c7eb8 upstream.

ksmbd_validate_name_reconnect() indexes
ab_pathname[share->path_sz + 1] without checking that the path is
longer than share->path_sz + 1 (d_path() fills the buffer from the
end). A durable fp is not bound to its original share, so a client
can preserve a file from a short-path share and reconnect it on a
long-path share, making strcmp() read past the PATH_MAX buffer -
with a long enough share path this oopses the kernel, and on a
mapped page it also gives a byte-equality oracle on adjacent heap
(the reconnect succeeds exactly when the out-of-bounds string
equals the requested name). A same-share variant with the durable
fp at the share root reads 1 byte past the buffer
(strlen(ab_pathname) == share->path_sz).

Check before comparing: the path must be longer than share->path_sz,
it must start with share->path, and the next character must be '/'.
The share root itself is accepted only for an empty name.

Fixes: c8efcc786146 ("ksmbd: add support for durable handles v1/v2")
Reported-by: Dairui Zhang <zhangdairui@gmail.com>
Assisted-by: LLM
Cc: stable@vger.kernel.org
Signed-off-by: Dairui Zhang <zhangdairui@gmail.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/server/vfs_cache.c |   18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

--- a/fs/smb/server/vfs_cache.c
+++ b/fs/smb/server/vfs_cache.c
@@ -1339,9 +1339,21 @@ int ksmbd_validate_name_reconnect(struct
 		return -EACCES;
 	}
 
-	if (name && strcmp(&ab_pathname[share->path_sz + 1], name)) {
-		ksmbd_debug(SMB, "invalid name reconnect %s\n", name);
-		ret = -EINVAL;
+	if (name) {
+		size_t len = strlen(ab_pathname);
+
+		if (len == share->path_sz && !strncmp(ab_pathname, share->path, len)) {
+			/* the durable fp is the share root itself */
+			if (name[0])
+				ret = -EINVAL;
+		} else if (len <= share->path_sz ||
+			   strncmp(ab_pathname, share->path, share->path_sz) ||
+			   ab_pathname[share->path_sz] != '/' ||
+			   strcmp(&ab_pathname[share->path_sz + 1], name)) {
+			ret = -EINVAL;
+		}
+		if (ret)
+			ksmbd_debug(SMB, "invalid name reconnect %s\n", name);
 	}
 
 	kfree(pathname);


