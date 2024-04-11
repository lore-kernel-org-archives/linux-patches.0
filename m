Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90CA82EAE5;
	Thu, 11 Apr 2024 10:05:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712829941; cv=none; b=PgwFLIZKFbEx8b2DVbr0sfg451vag7cSt5+z8I/lI4GFbRbrH2ABNWrDB0BLDW5n7ACFZdELW785DiyzMVgS2qZD56ADTF06EYcE0vvTi6z7OEzcRPE10PKKoWP8IIvcYg8iI5p6Zyl8P3sV5SZlcahtZjDVEW0dnGx7MvDSTS0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712829941; c=relaxed/simple;
	bh=5k5WGojMyqqDgmgtUBBp08rL8LW8KjTuP6RXGoiX2No=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jrrPy3wRKQVWRoXo98/4SO7SzBjboD5VydEYvHDvNqKjiRq305EmLB3No8LavOVQFCUEUuVdaphuq5/4n/TELuPDOBBr7xKCzSAlOLzwTQ1WxjQs0FdGn4XuwLMNBPdF1l14+zRGvxoWm4OfftWw2ghFZmELuX1MFMwCeqKA2J4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LdVyuhSr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LdVyuhSr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 172A7C433C7;
	Thu, 11 Apr 2024 10:05:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712829941;
	bh=5k5WGojMyqqDgmgtUBBp08rL8LW8KjTuP6RXGoiX2No=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LdVyuhSryhGeOloZY8Np0p2+DdMosH018EjgB7Z9+80egJY7vULwJXFxNqOM6YfLo
	 4SaStaCv7Hp1CccJN2Ql/xwBKXkjJH1sThPetp6MUAaoGabl5OsaY5QFH9bigtz9zf
	 QNTjf2dMFhUX70s8sQM/hYfPhrfHRcZRzGUHHLGg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Henrie <alexhenrie24@gmail.com>,
	Jan Kara <jack@suse.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 156/175] isofs: handle CDs with bad root inode but good Joliet root directory
Date: Thu, 11 Apr 2024 11:56:19 +0200
Message-ID: <20240411095424.261842595@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095419.532012976@linuxfoundation.org>
References: <20240411095419.532012976@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Henrie <alexhenrie24@gmail.com>

[ Upstream commit 4243bf80c79211a8ca2795401add9c4a3b1d37ca ]

I have a CD copy of the original Tom Clancy's Ghost Recon game from
2001. The disc mounts without error on Windows, but on Linux mounting
fails with the message "isofs_fill_super: get root inode failed". The
error originates in isofs_read_inode, which returns -EIO because de_len
is 0. The superblock on this disc appears to be intentionally corrupt as
a form of copy protection.

When the root inode is unusable, instead of giving up immediately, try
to continue with the Joliet file table. This fixes the Ghost Recon CD
and probably other copy-protected CDs too.

Signed-off-by: Alex Henrie <alexhenrie24@gmail.com>
Signed-off-by: Jan Kara <jack@suse.cz>
Message-Id: <20240208022134.451490-1-alexhenrie24@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/isofs/inode.c | 18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

diff --git a/fs/isofs/inode.c b/fs/isofs/inode.c
index 6e4e2cfd40b9e..aec11a7676c9e 100644
--- a/fs/isofs/inode.c
+++ b/fs/isofs/inode.c
@@ -910,8 +910,22 @@ static int isofs_fill_super(struct super_block *s, void *data, int silent)
 	 * we then decide whether to use the Joliet descriptor.
 	 */
 	inode = isofs_iget(s, sbi->s_firstdatazone, 0);
-	if (IS_ERR(inode))
-		goto out_no_root;
+
+	/*
+	 * Fix for broken CDs with a corrupt root inode but a correct Joliet
+	 * root directory.
+	 */
+	if (IS_ERR(inode)) {
+		if (joliet_level && sbi->s_firstdatazone != first_data_zone) {
+			printk(KERN_NOTICE
+			       "ISOFS: root inode is unusable. "
+			       "Disabling Rock Ridge and switching to Joliet.");
+			sbi->s_rock = 0;
+			inode = NULL;
+		} else {
+			goto out_no_root;
+		}
+	}
 
 	/*
 	 * Fix for broken CDs with Rock Ridge and empty ISO root directory but
-- 
2.43.0



