Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590264;
	b=PyrQZAwUW0wmNDDGbWY4wsQZFftTaz5hwxMnEjWkE4JvTnmTj3E3Dp82qsup4PvzBIjd
	 Qxmbg9UIojZhTDj4QwpBX4YFoZApc8IBRKlY6p4L7JzRhEyWzfEz1XMDu5TkkjSY47Lmy
	 MCRKpzBxv7KpX6Cs7vX2C5LLL3Dct/ipJtuVNjD1e0GfpUo3vTbeUN2PlMoK1r+elsG1A
	 4Bs5wQrStQ2MS/wGr3uP8sQUYHeXxmWV+6k1X23s5UiwzYLS2f2TqFMf1OP8EPk0e3Oq2
	 DGmkBd9MN6ZSNEj9f2qazcdS15LoSIYFOSi7Nzv9p0Y/Ysrf3Qv/ObkMY0tI2OvoJyg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590264;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=gnpsnckT1jMufiVZcpCIQrVXfjcP+YZEB/efT4DE11U=;
	b=fyO5D6QFcMF9mV5PI/XS1TGkSpzRjaKdhhspnBHiP22ubr25iIUOM2RVHUXAFaMi4oM9
	 WVemlBQNcto7tnX+jD+6c72RaMN4Q3F+J6JQ3HityKLdXrzom4ROlZs7WVs/LBrO8Z4YC
	 G/W6Zo/0qLh9EejVgEQVM//8HLH6l1Vmrd/BOzz3oGU1lvKlyo4mhuli3HJg7nxgxIKWL
	 vxfXDRcSl42Zh5nPhtAAN9IRjBO3tw0cpWM24l6HwlqQNK3lN2zL8uKPzA8cgrG+gT8H1
	 9pi8Huvqk29UNnDNtJ/+TQpvsxR64DpZ5CrTxjmOfFwze73+uXqQ+qc2kn6F0tv15zQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=f8A5BfCg;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 375D760A380C;
	Fri, 13 Nov 2026 17:17:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=f8A5BfCg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCE791F000C4;
	Fri, 13 Nov 2026 17:17:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590264;
	bh=gnpsnckT1jMufiVZcpCIQrVXfjcP+YZEB/efT4DE11U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=f8A5BfCgeUip5QFma8a5Bxu+O3TS6mPM18kSbIwvls1efVNLutvdFfmxP+6DfMjTn
	 39g9PEuJNBh/P8hXdY61tHblb4N+QqwfUKPT/+j4MXUiodb3VLC7cCy3qDxnoLDd/c
	 GDdqYyALlNASxYagIY47XzYAyEXCzf+7lOhwprCk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Rik van Riel <riel@surriel.com>,
	"Gregory Price (Meta)" <gourry@gourry.net>,
	"Mike Rapoport (Microsoft)" <rppt@kernel.org>,
	"Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
	Pedro Falcato <pfalcato@suse.de>,
	"Kiryl Shutsemau (Meta)" <kas@kernel.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Muhammad Usama Anjum <usama.anjum@arm.com>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 257/686] mm/memfd: make f_pos accesses atomic
Date: Fri, 13 Nov 2026 10:46:30 -0500
Message-ID: <20261113153829.741999234@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
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

From: Josef Bacik <josef@toxicpanda.com>

[ Upstream commit 5426cd43a4d28f1041c9ca45955121b921f29548 ]

Commit 9c225f2655e3 ("vfs: atomic f_pos accesses as per POSIX") made
read(), write() and lseek() on a shared open file description of a regular
file serialize on ->f_pos_lock.  The flag that asks for it,
FMODE_ATOMIC_POS, is set in do_dentry_open().  A memfd is a regular file
too, but its struct file comes from alloc_file_pseudo() and never passes
through do_dentry_open(), so it does not get the flag:

  CPU0                                CPU1
  write(memfd, "a", 1)                write(memfd, "b", 1)
    pos = file->f_pos  (= 0)
                                        pos = file->f_pos  (= 0)
    vfs_write(..., &pos)
                                        vfs_write(..., &pos)
    file->f_pos = pos  (= 1)
                                        file->f_pos = pos  (= 1)

One of the two bytes is overwritten.  Two threads writing 100000 bytes
each, one at a time, to a memfd end up with a file that is far shorter than
200000 bytes, while the same program on a tmpfs file never loses a byte.

Set the flag when the memfd is created.  As for any other regular file the
lock is only taken if the file is reachable in more than one way, and
nothing a memfd does in read or write waits for another operation on the
same file.  This cannot be done for all alloc_file_pseudo() files: anon
inode files such as eventfd are S_IFREG as well, and a blocked read holding
->f_pos_lock would lock out the write that is supposed to wake it.

Fix generated by an LLM and sent by Josef Bacik in private.

Fixes: 9183df25fe7b ("shm: add memfd_create() syscall")
Cc: stable@vger.kernel.org
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
[ david: minor description tweaks ]
Reviewed-by: Rik van Riel <riel@surriel.com>
Reviewed-by: Gregory Price (Meta) <gourry@gourry.net>
Tested-by: Gregory Price (Meta) <gourry@gourry.net>
Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Reviewed-by: Pedro Falcato <pfalcato@suse.de>
Reviewed-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Tested-by: Muhammad Usama Anjum <usama.anjum@arm.com>
Link: https://patch.msgid.link/20261031-fixes_core-v3-4-d6437171ecc3@kernel.org
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/memfd.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/mm/memfd.c b/mm/memfd.c
index f7ba1e9dea49a..aa3c948e55738 100644
--- a/mm/memfd.c
+++ b/mm/memfd.c
@@ -472,6 +472,8 @@ static struct file *alloc_file(const char *name, unsigned int flags)
 	if (IS_ERR(file))
 		return file;
 	file->f_mode |= FMODE_LSEEK | FMODE_PREAD | FMODE_PWRITE;
+	/* a regular file like any other: POSIX.1-2008/SUSv4 Section XSI 2.9.7 */
+	file->f_mode |= FMODE_ATOMIC_POS;
 	file->f_flags |= O_LARGEFILE;
 
 	if (flags & MFD_NOEXEC_SEAL) {
-- 
2.53.0



