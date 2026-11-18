Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795045926;
	b=Alr2WJY7SIbtijI+l3nhe8RpOMRa/brGucy8XShZs3/4fmlqFN9BmIXLzdHVhvbyPPA+
	 h/3R1Jqb+r6AXGe61v1ILXpXy84hE4AP6xmVpxpFSnN4jciYPjAht3ayoa0cU77HGiCHL
	 oWWwdejdav/IxAv2iuVphRmtC3vI5fgyEoQe1CdcyUIqxcelJEU5+tgUobv9ceHZKXK4Z
	 QDMyR7zbpAzwGGuyT45P8qxfQR86vOQBwm4vmV4IQ3yHw3MUeiw1/qIxMfi2Fa166Yt8C
	 s1WvnGnp5rrpqVmeAvSHLgXq0Z/mqxIqvO+NiIryyDh660I+hmXqIw0WSeuC06LIqgA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795045926;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=aHw8zBZJVL9DH5Iote1Fq0e4cSE7QmkmH7BfbpOxK+w=;
	b=a3vDkQlz/dbGsidKC5rklDEhsLSxqcqm7WkInkC5VT/IHSs6yUlSeMOwFdlkWiOy0O8q
	 Ib0fU77HRe+AkfwE92O6V5auESTSwwwMY65G5TR4rZRpEyzwrEO9jws/VZLaNeoZejKmF
	 kAWGnoQNGFBfNeHav5b/0dAYjBBZ9YJ3l2oF5Se2jy0rQ6ZUPb1WPAP1fTnp5SOeoj7S5
	 6/ddriYGescWuNakfMJ2fAtHFjOUyK7/LURYrWq+xYOL/73ivxTfOJKJNYNjijLQYqE8O
	 jNmGjgHnFVKLIj9mlhqqgKacEk2snqsqlBOqW/1x5w9m/+tci/BsW7dVca3T7xx9cfg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dDht6783;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 515E6606A31C;
	Wed, 18 Nov 2026 23:52:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dDht6783
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA0411F000C4;
	Wed, 18 Nov 2026 23:52:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795045926;
	bh=aHw8zBZJVL9DH5Iote1Fq0e4cSE7QmkmH7BfbpOxK+w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dDht6783esPogU1mFwEhDgUW6k3BZupn9zSBYcHYUmK4MuDI+EkHl6lK4dGrdJur2
	 fPGtBRZxrG9OJnJboS4xHFYlQW3saAfZbxKf+09rth4u7J2q0iv7eMPJtlvwvSHKJS
	 Y06V/eWNS20bm5Hd82m8YnZE5hzoITrtQNWNnI0I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hungyu Lin <dennylin0707@gmail.com>,
	Amir Goldstein <amir73il@gmail.com>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1098/2857] fs: skip copy_file_range write limits when there is no data
Date: Wed, 18 Nov 2026 15:35:32 +0100
Message-ID: <20261118150241.170833392@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hungyu Lin <dennylin0707@gmail.com>

[ Upstream commit 81dfa035891f0502674332ee97db348a16486de0 ]

generic_copy_file_checks() reduces count to zero for a source offset at
or beyond EOF, but still checks the destination write limits. If pos_out
is at RLIMIT_FSIZE, this sends SIGXFSZ and returns -EFBIG even though
there is no data to write.

For example, GNU cat copying a 1024-byte regular file to another regular
file with RLIMIT_FSIZE=1024 copies all bytes and is then killed by its
next copy_file_range() call at EOF. A zero-length request can fail in
the same way.

Check write limits only when count is nonzero, as the ordinary write
checks already do. Keep the other copy validation in place.

Fixes: 96e6e8f4a68d ("vfs: add missing checks to copy_file_range")
Cc: stable@vger.kernel.org
Signed-off-by: Hungyu Lin <dennylin0707@gmail.com>
Link: https://patch.msgid.link/20261026015738.46230-1-dennylin0707@gmail.com
Reviewed-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/read_write.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/fs/read_write.c b/fs/read_write.c
index 7a2ff6157eda4..e0f5debf89f50 100644
--- a/fs/read_write.c
+++ b/fs/read_write.c
@@ -1454,9 +1454,11 @@ static int generic_copy_file_checks(struct file *file_in, loff_t pos_in,
 	else
 		count = min(count, size_in - (uint64_t)pos_in);
 
-	ret = generic_write_check_limits(file_out, pos_out, &count);
-	if (ret)
-		return ret;
+	if (count) {
+		ret = generic_write_check_limits(file_out, pos_out, &count);
+		if (ret)
+			return ret;
+	}
 
 	/* Don't allow overlapped copying within the same file. */
 	if (inode_in == inode_out &&
-- 
2.53.0



