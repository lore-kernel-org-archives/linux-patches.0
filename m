Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 312B21E0DFD;
	Wed,  6 Nov 2024 12:51:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730897468; cv=none; b=sYil+CHCDRrwzFsHWKexly1PcVNTxSRTWVf5QJGbrX3n+OFbYhBo+am7Nfq39DJjGF0MuzLTsNUfq4QdRXh7PHn61dLRTT8hnGhMlEvjlgUZTEXHBsrj5Ac4qa+4XiqYAjCqNpBsdeYYLmI7KcjPy3r+2+cir+KJtUBvlK7NVs4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730897468; c=relaxed/simple;
	bh=pM9oBtNt7EZoKEQWFvQS7bQleHMEdiAZ7RtSKLt82WE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Norpkw4x23TIvatheqcui1/qDXNT3lw/j9B0RyNXj/q4j/Hq9DZrquxntQtGYgTKEjrudXb52QMSBAykkCxvT9O1UnTS5lOMgeCo1Kn4PeNENaFhEPT9ebYXKmLJoWKQYdRdc5XAv2NP7fabLyKEPiEPN7VEJWyPRsbOqvO8NfE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ySVJsgGT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ySVJsgGT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A937EC4CECD;
	Wed,  6 Nov 2024 12:51:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730897468;
	bh=pM9oBtNt7EZoKEQWFvQS7bQleHMEdiAZ7RtSKLt82WE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ySVJsgGT3RWYQ8JRY5wlagQQ8UXVoX20zSEvNP8AqP4gmGhXHmu4uV4jteHnAqCOo
	 8YhEJ7+hN+6v/mYdj+PPKbA3Kn7F+CRqvkbLgSnKxo2MAJIekoQgcnnGh7c99iiGO4
	 0B8JENmamp/wUbN/uAPMDg2xjoxvqEs2IGf9Pa8I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+9af29acd8f27fbce94bc@syzkaller.appspotmail.com,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 062/151] fs/ntfs3: Fix general protection fault in run_is_mapped_full
Date: Wed,  6 Nov 2024 13:04:10 +0100
Message-ID: <20241106120310.547159245@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120308.841299741@linuxfoundation.org>
References: <20241106120308.841299741@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>

[ Upstream commit a33fb016e49e37aafab18dc3c8314d6399cb4727 ]

Fixed deleating of a non-resident attribute in ntfs_create_inode()
rollback.

Reported-by: syzbot+9af29acd8f27fbce94bc@syzkaller.appspotmail.com
Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs3/inode.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/ntfs3/inode.c b/fs/ntfs3/inode.c
index 20988ef3dc2ec..52b80fd159147 100644
--- a/fs/ntfs3/inode.c
+++ b/fs/ntfs3/inode.c
@@ -1703,7 +1703,10 @@ struct inode *ntfs_create_inode(struct mnt_idmap *idmap, struct inode *dir,
 	attr = ni_find_attr(ni, NULL, NULL, ATTR_EA, NULL, 0, NULL, NULL);
 	if (attr && attr->non_res) {
 		/* Delete ATTR_EA, if non-resident. */
-		attr_set_size(ni, ATTR_EA, NULL, 0, NULL, 0, NULL, false, NULL);
+		struct runs_tree run;
+		run_init(&run);
+		attr_set_size(ni, ATTR_EA, NULL, 0, &run, 0, NULL, false, NULL);
+		run_close(&run);
 	}
 
 	if (rp_inserted)
-- 
2.43.0



