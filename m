Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062680;
	b=b2SQoPIQ3Ex/CYINxNAedEa/d8c4+hGAeQmDHQIsUOiAfVBxXoVKrXOjEC8pS9cdfOJx
	 IyHC+Ki0TRk+x69ez/UlwFFs8dBuGhiAvDu9CkHVEsJOFIBln7x/mjL5IzgDDZbJ215lI
	 jeDtpufoGDrnf1sGBUiltIgjIwNX2bpKPgTnF+d0bDSxM66sUWg1pCuG6o+SdOcY8UKBw
	 PkC99A6btxEAZoJ1lXMFuH5enWnvlqi6fXHqU1tnlDa9NxbipDYIOl9pq1kHIuTHKAvLt
	 skly/nYa609tUXaI+pZDxoLqGdf2iPCllJZRsUFWzhcW6JwATNydZ00nztNSNX7L6Ew==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062680;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=IPneMo8EnRzQHx3JGuVC0Lg+fBbnj9lvoOr324qLyJU=;
	b=gVeQUsbDvWa9xzHGL8tX+U9uy3l7FjzeJqBQq30++NeAb236hieJ7Ig9qwknVscUp2T5
	 I/DH6iYOTglwt9zoaJYjagVL+G1tVBR3a5Fc602PgJnGRnWBMqOjNKjfcISFkqyhdpn9p
	 xvWNvKmF++yO6rxdDkjESZFTyQi0K9hfcsQkqSeYDLan8CgVc1Kuq3b0q087rkx8oe8mE
	 YgKHuQR6fUPNnOhTJwMUzFkuaYl9SHhtp51MQSWZQtjzmbPwUfdyC4D0AdEfGPlTRCJw3
	 71lPlUcfBrSHDRxk07dQxPQf/n8wDkOQz5omu2FtaZ99RYwXBXN/PGGaAC4BA/bAnAA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=U6eTcYnA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73216606A326;
	Sat,  7 Nov 2026 14:44:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=U6eTcYnA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B6FF1F0089F;
	Sat,  7 Nov 2026 14:44:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062680;
	bh=IPneMo8EnRzQHx3JGuVC0Lg+fBbnj9lvoOr324qLyJU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=U6eTcYnAaw0Rf4eDjY5BXaynGuqZ+d9e4rcKlQrbeCJ6+NHJx+rE71byoIxuDojfY
	 PHiDvfKY7lD7fNEomwrHXFbTrcGCnfacc1V47mFRKg+uj3/2POsGYBSwn9F/3lwZAw
	 lFqZkVcirvkOVLC4ldF1uEP39kSNw347M0MoLwfo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hungyu Lin <dennylin0707@gmail.com>,
	Amir Goldstein <amir73il@gmail.com>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1530/1536] fs: skip copy_file_range write limits when there is no data
Date: Sat,  7 Nov 2026 08:59:06 -0500
Message-ID: <20261107135040.855442601@linuxfoundation.org>
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
index 430c06993b758..d908478b7e833 100644
--- a/fs/read_write.c
+++ b/fs/read_write.c
@@ -1554,9 +1554,11 @@ static int generic_copy_file_checks(struct file *file_in, loff_t pos_in,
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



