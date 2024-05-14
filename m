Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19A2384D23;
	Tue, 14 May 2024 10:48:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715683728; cv=none; b=ngvREClMJqeTg6f2fHoang2im3+xF2vYr4Il1tiYyZFlp46pRDodfc6D61ujkmpJ5T5SYwYv27P47OCxF6PNfLPilpm2B9VSGSxuwNO62KXKxORor1OjEEpMKRHvfY7lkxZd3We8RxeMR3tCOPaEwEQS+vatTG4RwkzE5edu2OM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715683728; c=relaxed/simple;
	bh=2i/FiEJi97rv1jjKIQ7Q6bx6jaHJRihGC729yQysATQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M3fdc63pMKGMIBRutVYvU8AbbSwKbtGNsrLO3sCgiTnwkEXzzktsfIsliCbuVr6k5CnOam5utJDM8vUQOiosL1pCF5sktw2V/HtXcLOvmK5gJNm4igpyzU8/FNPgTAAI2iSRtRpN6uETwO35XTLUJBgUoFkDhgmRBgOYP3yaGT4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YAbzi097; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YAbzi097"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2439DC2BD10;
	Tue, 14 May 2024 10:48:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715683727;
	bh=2i/FiEJi97rv1jjKIQ7Q6bx6jaHJRihGC729yQysATQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YAbzi097HIJyA1wF1gCfPDKeDQDjCrhNBfQDjeRV8UAgBTVExEh5SZCt6AshE2gmb
	 5EzOX7tiX80ac991NIbwDQal1mb2Udup5qhVXN2G8cu+JjLB1kvuwcxXPh3g2ldiLG
	 +Do1JK+xy+IcgmBOZDq+IpfYdbx1HThbxIAMf2oM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pavel Machek <pavel@denx.de>,
	Dominique Martinet <dominique.martinet@atmark-techno.com>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 6.8 263/336] btrfs: add missing mutex_unlock in btrfs_relocate_sys_chunks()
Date: Tue, 14 May 2024 12:17:47 +0200
Message-ID: <20240514101048.543948983@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101038.595152603@linuxfoundation.org>
References: <20240514101038.595152603@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dominique Martinet <dominique.martinet@atmark-techno.com>

commit 9af503d91298c3f2945e73703f0e00995be08c30 upstream.

The previous patch that replaced BUG_ON by error handling forgot to
unlock the mutex in the error path.

Link: https://lore.kernel.org/all/Zh%2fHpAGFqa7YAFuM@duo.ucw.cz
Reported-by: Pavel Machek <pavel@denx.de>
Fixes: 7411055db5ce ("btrfs: handle chunk tree lookup error in btrfs_relocate_sys_chunks()")
CC: stable@vger.kernel.org
Reviewed-by: Pavel Machek <pavel@denx.de>
Signed-off-by: Dominique Martinet <dominique.martinet@atmark-techno.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/volumes.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -3456,6 +3456,7 @@ again:
 			 * alignment and size).
 			 */
 			ret = -EUCLEAN;
+			mutex_unlock(&fs_info->reclaim_bgs_lock);
 			goto error;
 		}
 


