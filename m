Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C253A330B0F;
	Fri, 17 Oct 2025 15:55:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760716529; cv=none; b=hk5HbospRKGYW0Cn0K/OAdnz9OtXfNU/+rLweczft3QBsrAnHT1L2TGj3fpzl5D1rKztAVzPe0+H4mtelnzjFr0EFxwH9uMX9psLNKI/0OD34Oww7kEKWqBj4GSpLSGxzi0hHFKLPbL+tPpVaUTsZ+yfT0pyT7la/I7XP6sSrVc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760716529; c=relaxed/simple;
	bh=rGIAy78os3Du1QGHlkzYlKmLNQ3cGPikyYUAs9qWtl4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TAeJsqG3G9ku/zMPVWvE/Xqqe4B3Jg/9JKFM287Ei3QxqmAfryRNTZS5Wvc+inlkk78l92F2rAetPkIIRyd4714+rQ363CSh6jxS6VHV1R9MquO/Y+vczwSp+91Rzk9EEK4yMjkbx/6DLrwTtkjX9uImPIpfu6qEQD5CcwYZd44=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iJDHyXZ7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iJDHyXZ7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DC02C4CEE7;
	Fri, 17 Oct 2025 15:55:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760716529;
	bh=rGIAy78os3Du1QGHlkzYlKmLNQ3cGPikyYUAs9qWtl4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iJDHyXZ7oDIKkpu+gUOOdUm0/7MHyTR7LR1lWzMAp5U2TWjjgHwt+ehLF2m1H1ouC
	 YDIyrBFKrdlihdQ5Ko7Y/dD6gHNAfAiHIW7ZFQ/1fJv7RWMxnF5+dBzFa75vtOJuJr
	 vXzLFohxje+K9JvYnclm2RfCCv4ZS1NdzDSZcTEY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Mason <clm@meta.com>,
	Jan Kara <jack@suse.cz>,
	Theodore Tso <tytso@mit.edu>
Subject: [PATCH 5.15 223/276] ext4: free orphan info with kvfree
Date: Fri, 17 Oct 2025 16:55:16 +0200
Message-ID: <20251017145150.603789220@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145142.382145055@linuxfoundation.org>
References: <20251017145142.382145055@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jan Kara <jack@suse.cz>

commit 971843c511c3c2f6eda96c6b03442913bfee6148 upstream.

Orphan info is now getting allocated with kvmalloc_array(). Free it with
kvfree() instead of kfree() to avoid complaints from mm.

Reported-by: Chris Mason <clm@meta.com>
Fixes: 0a6ce20c1564 ("ext4: verify orphan file size is not too big")
Cc: stable@vger.kernel.org
Signed-off-by: Jan Kara <jack@suse.cz>
Message-ID: <20251007134936.7291-2-jack@suse.cz>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/orphan.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/fs/ext4/orphan.c
+++ b/fs/ext4/orphan.c
@@ -513,7 +513,7 @@ void ext4_release_orphan_info(struct sup
 		return;
 	for (i = 0; i < oi->of_blocks; i++)
 		brelse(oi->of_binfo[i].ob_bh);
-	kfree(oi->of_binfo);
+	kvfree(oi->of_binfo);
 }
 
 static struct ext4_orphan_block_tail *ext4_orphan_block_tail(
@@ -638,7 +638,7 @@ int ext4_init_orphan_info(struct super_b
 out_free:
 	for (i--; i >= 0; i--)
 		brelse(oi->of_binfo[i].ob_bh);
-	kfree(oi->of_binfo);
+	kvfree(oi->of_binfo);
 out_put:
 	iput(inode);
 	return ret;


