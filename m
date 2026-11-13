Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794591076;
	b=qjEmQsqI3bQz+8NLNu4Yr3dpxE0xehEf6H+WIFaTOXymJRLi7vG8MZtc9JxfP8XvRstl
	 d2LCp9sRIxKO2aOxnupUpWahLYCN1LDPt1AF/SFIob3NvRif0g1A9optlHJa1Y82VYtpl
	 5LCgLYR4fw7c7RS1TtSLsRa0/kZfkw11FbAwCtYe6r5DxZATJNoI/qheUPkfm8BGVIncB
	 UOvbmKcUSgCaZFtZzKKqoWcBYbbg3HC7ol5caqZWGixJYjAGblh+2Ju17aMiV+OZyvQzC
	 eUlVIROLfMvwJpbTbsNCtvXEuzTErG3TZiaD4P2k+U37h8EsxpGrzitn/zFpMV+lFqg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794591076;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=PvNUh7Dd/xUmikx4hqNBfyy9l2f0bM27iYHc0O7Y7LA=;
	b=yh11X4Ai2yJOthc4kjk0sVhI1Zcdjm6H1NtaQaNFhAaO/GzX9JsYJHnAGc76xv6pGI//
	 6xXcW44D34hSAFVqTcRGH9AQ2FClKN7H/c9to3SZi3qzLvdOmgCvl4ofKwGXUcnebgyiN
	 XdMYS66k4pR1wMU3vhcfXeZT6ljGZdiqGebTpV5XgsnGiV3PwlXVebxC6OV/YXnbi2dEF
	 YE8L8w5qn/4WJS5Bh9v6eG4amyfXg1bHeGu7yKcKUmXVlHj0FG6ZpvKiT7+2oYJMZ5LLR
	 W6LTthZ9K/dU8D9EcAIKvScGsdntwvGyXKbsvVgVLJ83jpyIyeuejP6XS9I6iSl4jJw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aBaFhL5n;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1E936073212;
	Fri, 13 Nov 2026 17:31:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aBaFhL5n
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 522CA1F000C9;
	Fri, 13 Nov 2026 17:31:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794591076;
	bh=PvNUh7Dd/xUmikx4hqNBfyy9l2f0bM27iYHc0O7Y7LA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aBaFhL5n4WTginEGbL22vS833omNgR38RurU7CKNgRkmRtkzSZhxa5xhu5BmEKzc7
	 Cb///j8bfp/Yr3+63J0j0X4u6rGkzZeeEqJCqOukKyTfl0AdWu6xQJrIMwdHVt6Rj1
	 TpLenZ9BIzLhm5mhThy86H+ejbC2iQ1LiymwwTyU=
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
Subject: [PATCH 6.12 232/670] mm/memfd: make f_pos accesses atomic
Date: Fri, 13 Nov 2026 10:46:36 -0500
Message-ID: <20261113153819.731018600@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
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
index 3e5a014fdacc0..e41dd806ac502 100644
--- a/mm/memfd.c
+++ b/mm/memfd.c
@@ -465,6 +465,8 @@ SYSCALL_DEFINE2(memfd_create,
 		goto err_fd;
 	}
 	file->f_mode |= FMODE_LSEEK | FMODE_PREAD | FMODE_PWRITE;
+	/* a regular file like any other: POSIX.1-2008/SUSv4 Section XSI 2.9.7 */
+	file->f_mode |= FMODE_ATOMIC_POS;
 	file->f_flags |= O_LARGEFILE;
 
 	if (flags & MFD_NOEXEC_SEAL) {
-- 
2.53.0



