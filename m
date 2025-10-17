Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78EF12F12C2;
	Fri, 17 Oct 2025 15:45:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760715907; cv=none; b=pGcg7JFnnCv0Mb4XsJJu9Tsjnss9WZL+U5umHvC7eBiVAUqXZhWeCsDL+W0FIrUG/UN7IcrejY7h652qfr+4F5iRF0V2ia/4fNVDcHKCL1Ls/y+tZAmxRtkcv+3cL2UgD7Ou3CPo1kUjPDyppOw39GJFaUVLGJ0u1k9VsaSxT+w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760715907; c=relaxed/simple;
	bh=bM/I2MXpFBbKDyWg9aGE5QtrfkuouZRXuMMcEXy9GN0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kfFjslnK1lsVLSH0FyRJCuxUc74bp4Z3GYj7B88rHK6BqtxLMc+Qgy11XJOR7sTYY7IqomXjbMGirdcWrtwaHYv3J4GJzdVGBB8lnn6b4YPYkuSxj+JZYtbCaFB9hEOkP6DpfEiYBF/P78u5ddv9Q4kh7N8BkgdVrtF7OBbHy+o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KRx7tQeW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KRx7tQeW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2ABDC116C6;
	Fri, 17 Oct 2025 15:45:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760715907;
	bh=bM/I2MXpFBbKDyWg9aGE5QtrfkuouZRXuMMcEXy9GN0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KRx7tQeWVNfbq134NFqRdoE7plPvmvDmGvmIGqKwN1ho/q6jg3OnZW8GW3ae+Tj57
	 DOyE8d58HRSi0JHPHC54it0HFwg90pfxObcKBsjY+/OrlDzx4x6LocPYljNdJQmtSt
	 q1HF+X+pU4Gq/aKI0dptY3mCGn2qqj1jd8yzfguA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Mason <clm@meta.com>,
	Jan Kara <jack@suse.cz>,
	Theodore Tso <tytso@mit.edu>
Subject: [PATCH 6.17 348/371] ext4: free orphan info with kvfree
Date: Fri, 17 Oct 2025 16:55:23 +0200
Message-ID: <20251017145214.670106263@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145201.780251198@linuxfoundation.org>
References: <20251017145201.780251198@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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
@@ -637,7 +637,7 @@ int ext4_init_orphan_info(struct super_b
 out_free:
 	for (i--; i >= 0; i--)
 		brelse(oi->of_binfo[i].ob_bh);
-	kfree(oi->of_binfo);
+	kvfree(oi->of_binfo);
 out_put:
 	iput(inode);
 	return ret;


