Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795624537;
	b=e6I+ofRZpECZMDO5aKgrT9lhTkCJq82BqboiE7A24zE0HCpYN+f9351h2zbq3XxwLfsU
	 6P/73MOO3ND94EI/FOB8+4Kxf8QSUoNP/USTLlux5smQ9cjA05miPVdMJaBGIhbTKtBiS
	 +yz9s1Zc3tCNqvZ/j5Z4804deVaiMkty9J8MyMDm0yyrqPVvbmoryzUg/AguBcUrHWlrg
	 3uOgIWzxAGg+8ESvW5Kc1ZnqKbbDR+grDEG3kEgUBfGJyPvrNnHnyj7Tmq8r7+8dzcado
	 NNAg2Z3udJEAsBCWCjuBpFIATCDK4ZxUKtdvgqMkh7Bid/22Zpk0VksKmgPcos8B+Xw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795624537;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=zJj2kjs2uDRmbruADtIgIEx14GbeoeXtk6IvXAWaOHQ=;
	b=RVmAq1L9VyMjQwhquS6M9PaNMjAsifbWdLHjXMc4iC6KXd5Ya1hcY+EYs+4OyE5EecCc
	 To95K3E+6SzDkL/vXlgpdAaPuvzEB+UKSflsd1e0dzt7qtjzjSb4NcaCG3YcJYU5DN9q+
	 sQfEETSkUu+FYmVZn8a5rKaVgD74Oe8LASn+/4zmeYBVOR1yxqHiQ0WGk6/CdN9etjzRY
	 5txNEoLz96ZCyuKNNGwxrieiGQvWS1+6A0lVQhsnm7kBTnkdf0EXN6fumA8HiVjye06ei
	 xhasOtIqiPuvpL9MIJSApjU8+wGS2KqK9FeVbciLxl8cDoJkQYq0+2mrNtDoa+ge4qQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lh2ghixx;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C30D606A688;
	Wed, 25 Nov 2026 16:35:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lh2ghixx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7864D1F000CF;
	Wed, 25 Nov 2026 16:35:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795624537;
	bh=zJj2kjs2uDRmbruADtIgIEx14GbeoeXtk6IvXAWaOHQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lh2ghixxu7/ShyzJTInr/Q+Z9p9ZfOZV1BtHYaXVCPCWBKKv9XP6Ub+j7inEXuKAp
	 XNq2YL6KS04ZwTwZZqvYTsJmIOBJEIALLXwgY6s7KbbsWJiI9rE94QtaXpAiu9qEVl
	 HRN/D/+xMwIACCL6ZQHKR9hvXdznUJwtZlQD/iYI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Jan Kara <jack@suse.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 180/816] ext2: only flush DIRSYNC directories on every change
Date: Wed, 25 Nov 2026 15:28:48 +0100
Message-ID: <20261125143853.358341512@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

[ Upstream commit 3f57fc2c49ed05ccfc56e4dc9eda41be95925bbd ]

Every change of an ext2 directory is written to disk before the system call
returns, whether the directory is DIRSYNC or not: its pages with
filemap_write_and_wait() and its inode with sync_inode_metadata().

Writes which reach the device for 2000 files, and 200 directories, in a
directory without DIRSYNC, with the flusher turned off:

            create   rename   unlink   mkdir
    before    4000     8000     4000     800
    after        0        0        0       0

In a directory with chattr +D the numbers are those of "before", before and
after.

commit bc943f4872a7 ("ext2: Don't flush page immediately for DIRSYNC
directories") moved the flush from ext2_commit_chunk() to the new
ext2_handle_dirsync().  The IS_DIRSYNC() check which was around it didn't
move along.

Fix by putting the check into ext2_handle_dirsync().

Fixes: bc943f4872a7 ("ext2: Don't flush page immediately for DIRSYNC directories")
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Link: https://patch.msgid.link/20261027-b4-ext2-dirsync-v1-1-3dcd012d518d@toxicpanda.com
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext2/dir.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/ext2/dir.c b/fs/ext2/dir.c
index 402fecf90a44b..9bb1c219c048e 100644
--- a/fs/ext2/dir.c
+++ b/fs/ext2/dir.c
@@ -441,6 +441,9 @@ static int ext2_handle_dirsync(struct inode *dir)
 {
 	int err;
 
+	if (!IS_DIRSYNC(dir))
+		return 0;
+
 	err = filemap_write_and_wait(dir->i_mapping);
 	if (!err)
 		err = sync_inode_metadata(dir, 1);
-- 
2.53.0



