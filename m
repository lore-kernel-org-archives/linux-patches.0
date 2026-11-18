Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795053811;
	b=JSJYsZU64dn+b+msFdwdLFRZzD7TKXl8k+QOwZZvb76t+WwgyMdacJSsTRpn52AfeuHv
	 yXgotGzZzWr3+STsrLGREtWNSw/yxfiAhoJ6tfep1TP9O+cpqCjhRJeoy/n4ckwR+TqRs
	 3Ep53ehFcKZcjy0taPyr37pfd8kO89r9SNMwQh5UaF/G3K5OMXud8iBGi9cXyMikQoNGL
	 aNXvQO3Vww+ERDK0pYHWDMD6YxTmhUnC0CIPrdCkzAvRVaEA1s7fclbf8Nsj2oFYQMKTM
	 LPjdyiewW/tEZcp2peRJ50NM4iY8BFhyChfGGFavrMJ7gLBg7bHykoT5xEVkqQU9d1Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795053811;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Z1bbCCFNB/dgTIGrUXWwpnsNltwj121zG2joH+gSnu4=;
	b=EphrcKULAdG5Dtbsv9C/hiHHx6dmKSHcC3r5K90sTfj5ZdCVyzh8ZmI8+YNt069FE83C
	 EP91ZdfgL6u2nLkhBnF8ZUW+k7Nul+P90qGPdNpeMXX3kmYxa1q8h8313XhMcvz1jo7WZ
	 Vgeb0xZ4xfokMXdupBv3dbLbuOnOvOL7yOCy1lk069/4WRAS+L7R5S8TjlcDdkH2T2RoV
	 f5t7mSaHCEgBkJJlfGu9WLeJOMzSM6Oy94gZl6i42PNR9DOBnAHU/Z35R+5pmhBX3LqZg
	 Pm0cSsyeg4gGF3ry6zepof2TIw+RO27p4FXuWJySYhrDh7NfMVcAOvEfnsCayn64nTg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Fa2qoyLZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C461D606A320;
	Thu, 19 Nov 2026 02:03:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Fa2qoyLZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C81F21F000C4;
	Thu, 19 Nov 2026 02:03:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795053811;
	bh=Z1bbCCFNB/dgTIGrUXWwpnsNltwj121zG2joH+gSnu4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Fa2qoyLZEgFzCXyYj8dRLSllNIpJ7Eux0qNteu7duBVYbmTUPhjoiOclqd1tJsw92
	 M7CjcWC0QXf7vRzznZHZXrEmxkMEtvLTIrVEgnns5uWvnc8qIdCnqbkhY/8aY6zCrQ
	 ZUSHI+W158XwhEZUJvrhlfcOY9EfcEuclz6OR3j0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daehyeon Ko <4ncienth@gmail.com>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1024/2214] splice: avoid stale f_pos writeback on error
Date: Wed, 18 Nov 2026 15:45:00 +0100
Message-ID: <20261118150053.317352179@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

From: Daehyeon Ko <4ncienth@gmail.com>

[ Upstream commit 79b496ebe382866e3a05090b7dc9ae95e85e65b2 ]

do_splice() snapshots an implicit file position before calling the splice
helper. Since splice does not take f_pos_lock, another operation on the
same open file description can update f_pos while the helper is blocked.
If the helper then fails, the unconditional writeback restores the stale
snapshot.

For a directory without ->splice_read, a file-to-pipe splice fails with
-EINVAL. A concurrent directory mutation and getdents() call can advance
f_pos and refresh the filesystem's revalidation cookie before that failure
restores only the old position. The next ext2 readdir can then trust an
offset inside a directory entry and copy data from the adjacent page to
userspace.

Only update an implicit file position when splice returns a non-negative
result, matching read and write. Keep explicit offset updates unchanged.

Fixes: 7995bd287134 ("splice: don't pass the address of ->f_pos to methods")
Cc: stable@vger.kernel.org
Signed-off-by: Daehyeon Ko <4ncienth@gmail.com>
Link: https://patch.msgid.link/20261018051708.2422394-1-4ncienth@gmail.com
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/splice.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/fs/splice.c b/fs/splice.c
index 70008e08998f5..3630fd18a12e8 100644
--- a/fs/splice.c
+++ b/fs/splice.c
@@ -1107,10 +1107,10 @@ long do_splice(struct file *in, loff_t *off_in, struct file *out,
 		ret = do_splice_from(ipipe, out, &offset, len, flags);
 		file_end_write(out);
 
-		if (!off_out)
-			out->f_pos = offset;
-		else
+		if (off_out)
 			*off_out = offset;
+		else if (ret >= 0)
+			out->f_pos = offset;
 	} else if (opipe) {
 		if (off_out)
 			return -ESPIPE;
@@ -1127,10 +1127,10 @@ long do_splice(struct file *in, loff_t *off_in, struct file *out,
 
 		ret = splice_file_to_pipe(in, opipe, &offset, len, flags);
 
-		if (!off_in)
-			in->f_pos = offset;
-		else
+		if (off_in)
 			*off_in = offset;
+		else if (ret >= 0)
+			in->f_pos = offset;
 	} else {
 		ret = -EINVAL;
 	}
-- 
2.53.0



