Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794065611;
	b=NLRRmYZsEaHUJmBFl0OpmV/2VfQ/5SA9lQYESoJBJlLdVQghQe4OCFzoMgUxmzrACqFu
	 AXGe2ffn7nDIO3AOVmSkWIiGLsndulsOdksPRiZAgUDVKDRmNua39P3Ag2Bl279JnvHn5
	 6iBTsn72rlBeMFcFxvN4c33WN2zQNoIkpx5awBpW0bBFWqwnuhx0pLXpbgGREMAkc8mnz
	 9CY4yAuX9oAHOoBN29yWDgys8NWDhAdzP3whc3CzPg68MrsFBNvWeJIWFGXhLJ/41thzH
	 wHCIcsuiCXvPcfF0A9CTPwLebz3s/1a24AKAIaF+E9I04A5pdz75iB6XcnCDy4yL8Pw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794065611;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=kAB4YffPIqdftE9XmCxr1gRsghEam1u2Dwy5K6VisWU=;
	b=Z7pbuVEooWIMacgh2Bx40tvx+xkYhsCgou0Nu18nJkjYKOG9+2iTdaOPD1sb+PJ6RB4T
	 5J0ElNq+ktlCtftk+oG3ZyVOQFrcy/poWq19h2CAANvva45yjl9GZguoLeN1n10SI3Ot4
	 1ZfVwsUHvc//mN86oGj84yhDdfrvtFMwt0betNWBGeeChu5rXPLt5rGf1EljTCgebYvEY
	 1eKrSbc9p0NviSrVCzx/4ZHf3mmXj6nIano56qnF+bn60m1Tc08ia74Y6vqz4GFqHd4NV
	 wIuTmMLo0HCUCGD7Gz9MESKsVhFIdyg8b5xhjE7pTOqEHrhiqdoQqZFyIV0Ky/xowyg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yN2CuZI+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 271E4606A330;
	Sat,  7 Nov 2026 15:33:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yN2CuZI+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EE271F0089F;
	Sat,  7 Nov 2026 15:33:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794065610;
	bh=kAB4YffPIqdftE9XmCxr1gRsghEam1u2Dwy5K6VisWU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yN2CuZI+J9m4bpzyfjscGtmQs5s7jv2YW75kfRuwJ/SiT8H1WEJYn1ecIgBrUWGC1
	 8DwZ03CSmXXsZhcT3SfA864cIC6TP3YsFJ2Vx47AhwF6qTimn2d6BJJvcyXS6hX3FF
	 QKXWi2avw//KGdl9wwNItNKYbKksv/ofeJwEjXaw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hungyu Lin <dennylin0707@gmail.com>,
	Amir Goldstein <amir73il@gmail.com>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1251/1257] fs: skip copy_file_range write limits when there is no data
Date: Sat,  7 Nov 2026 08:59:07 -0500
Message-ID: <20261107135013.868710816@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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
index e8c14e2760b20..ccaaa454dce02 100644
--- a/fs/read_write.c
+++ b/fs/read_write.c
@@ -1531,9 +1531,11 @@ static int generic_copy_file_checks(struct file *file_in, loff_t pos_in,
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



