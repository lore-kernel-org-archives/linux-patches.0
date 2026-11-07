Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062679;
	b=RKvPKhG1QzxpDdOAvtukK7QGV0onOXmf5LbgBYC17ICmso76H2jMxo7PoOiooNMdE8Py
	 a9td/BQ8FKSw+Q3DDyimSQzWWhaypXvOL3fAweYFQIQ7TXpwJ2878CwkZJsd7mRKyA8gy
	 xbWLG6+l4DXWDO/S0jqou8CkOdtSGQZFCGwuN2qPYnquRWJNG+nBxCoXMjoLXLr8BlPNC
	 j9WJRLs3NJNZgyh7C4xtjf0nQ2R8QlXGjEMBmLAg+sVy5C32DJeKbE8DWQra/wQNJZcUb
	 E5apvDrheq0DbqxKm8O/7aMHCBmTZuVp1HpplmZKDpSwujzG47oc9EDSyUx5OYZC13A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062679;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=GEvFAk1DY3IKyN4wP8YlzQNoLhtRcPPdEqfQsY+nSlQ=;
	b=4IVqln4KeQp6qYCqJSeE8Xa8nf3jrPcNxJbNJZo/qBAZ8a7Bst3ysrnphw9UZ4SYKUTb
	 DaPe61ajF1MnlZ5VMUySdYuwUBFs0s5sjNIGbm3BJlNZLVc5sQQFRT+JGKwJY0MtOVu+9
	 1ELaonp3Ar/fdHgCoDLHCGzzCGZ+qO8wsMJ8BdG0QGb/wnRW1fNAiTQAstpCdGucuYJLX
	 sVu+9I6w1oszv5q6iw6lmE4EmxiPmU0ysC41cL22Rb3UafZOh+PyVYttudJ6mI/1nalV9
	 6KtZcv2EooMWbvFYbeRS15c0t0EuSZjRB2Q5iFGYJFnFAn0BGm9bS9niksroI0qY8vA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jRryPkY7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D045606A326;
	Sat,  7 Nov 2026 14:44:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jRryPkY7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDCA51F0089F;
	Sat,  7 Nov 2026 14:44:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062679;
	bh=GEvFAk1DY3IKyN4wP8YlzQNoLhtRcPPdEqfQsY+nSlQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jRryPkY7Zq4ClsiioFQ+o+uzYJ0iNM4muo3YS4yZxRdToVzAsTcCWP23DT4clD9I3
	 FhAu1jzKsCH62IStWuvm1YcPZzpDMVads/taKGFvybmbpSudeQrh2qLSjWy4KfSD7B
	 wKfC2kpVQ1NaZJkVmNV1ZmRm0IxdPiw22xyYRFRE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daehyeon Ko <4ncienth@gmail.com>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1529/1536] splice: avoid stale f_pos writeback on error
Date: Sat,  7 Nov 2026 08:59:05 -0500
Message-ID: <20261107135040.825868957@linuxfoundation.org>
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
index ed8177f6d620f..a8f4ec2b7de10 100644
--- a/fs/splice.c
+++ b/fs/splice.c
@@ -1357,10 +1357,10 @@ ssize_t do_splice(struct file *in, loff_t *off_in, struct file *out,
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
@@ -1381,10 +1381,10 @@ ssize_t do_splice(struct file *in, loff_t *off_in, struct file *out,
 
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



