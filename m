Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063774;
	b=uTSV5H+m6qxb3Ak+lu5yQvmhOvqHQCTcmDimu9ZUDbV84Cje3wpvBnzWY94lqYW4Pixq
	 kKUQCCbJlHmeZe+QwY1CCu758R+wbDas5idxvY6eFyhJTtyo7LIPtVZN6aOagnDGKZofk
	 1Vue7/I49lJK9080xn67gA67PsWMtkhoW1o+kUDBz5GstdAEAsEpkZAVyLcfRycWhcEU1
	 sqoN84kFpJapvVNtgAtQb1b4aiS/6tV6o/iaeORshVWWHPi3uL+ZYCWx0pcODVnf8jbLG
	 6JvLyubZPh1eWxFw9oiVsvckpoKxaiXWQERaQ3R19HAGt7fL0ANVnb1jnsB3WV9AYew==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063774;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=RAxu54Lt0c44tgqqkCDwBSbpEkLw/g5uQBqUXzDf9fs=;
	b=iDKIvk5v/gMa0zovPp4QlwKFcgDX4h7GU6r6i4STsdL02SnYAKWWTrbuBvy/pWeIavaq
	 JguZsdM9M3WH6N8JPpPlUbv8Ahi2y2+wOOUzPpgvIbQVTuzdIzcALki5J9Wh6Bu+X9JBI
	 QVN/380IpBdzgYJk7EvpXex06vWwJy1ViTMNe8B8MMSvLDE5QSw3vZDWVmdz8S+GOewaA
	 FNY1BbBjipKAQADpygLcuzmiG4sR6eWqHPj88Q4dCgJTECCSqGcZoNkk9us95FSeFiG6K
	 K/ZvwOfpKipkLJznBytShDAzbNkoUXT/KX0lqPrqzHVtZ25Ux16YJLiYCWevvBKV1Hw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sCeL0UAS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1077960A2615;
	Sat,  7 Nov 2026 15:02:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sCeL0UAS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B03541F0089F;
	Sat,  7 Nov 2026 15:02:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063773;
	bh=RAxu54Lt0c44tgqqkCDwBSbpEkLw/g5uQBqUXzDf9fs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sCeL0UASEm4tr69DN/S13u2kaPScj3IWdSG6dMJZWL5T4YtZ8hl3VtMr2e/lN3zbm
	 K/eAAMBPNC5Fk10NdxorznR6mGN1f3Dfe6IwHXFPCu1kyzabepKdw3BVs1OEDAMHh6
	 C1Kuz2mGXAnPE3RRDSPdzmxtCdCg05GhQvVR3qww=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hungyu Lin <dennylin0707@gmail.com>,
	Amir Goldstein <amir73il@gmail.com>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 864/869] fs: skip copy_file_range write limits when there is no data
Date: Sat,  7 Nov 2026 08:59:06 -0500
Message-ID: <20261107134922.109239239@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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
index 833bae068770a..011fe55c94cdb 100644
--- a/fs/read_write.c
+++ b/fs/read_write.c
@@ -1530,9 +1530,11 @@ static int generic_copy_file_checks(struct file *file_in, loff_t pos_in,
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



