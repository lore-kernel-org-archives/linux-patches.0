Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795049491;
	b=QCxpLvxusuvgD4haoAnMIFB3VOYuXlkilolUdhreWh4sIFvUdfreXJNyPDPeCOLPKITs
	 jQhwOi55r6qWTvq/VwrP0lNwGnbnMwwIPrH4e9HJFtF8bH3Rq8sQH+YKthnPuttPQlWCj
	 EyYCO5R+PcRtXeVhQ97SaZ7nreoao9KB8bK91F+k7+Rc+DQ3MtoBGlozlUeM5bOAprBgm
	 PUa6RIY25BZ713AGjFhVTzIdNUEJLNabRLCMDhYF5bzQEZDCsroP7w6Ld+MlFdTeuj1pR
	 fALn8P/Y4G/e6OzTCKVfNefi6XzjRc5mOPkRF0ukH4Zh7JLj4ylkNIx/hr+avQqghgg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795049491;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=yuzUhzOi5Y3CLT2p9hSUC0zOY3SOkLvjI61CUXm8lxM=;
	b=BDnHsat5Z70pOaND4rZA7MhXesAWeXCbgnXhEqrzGee3WvssF0dsf3hYgImky6HC4z4M
	 vAL2WXEhOUy7HwDCVW14P1kwy3ZNtUBrgxOoksgkpYRz8NEoowNBGzCmLafN21kCbvVT5
	 rVd9tNj2RQqALP6tqflAOF7dvnezRJEgPvDU8ANRdf9zPg2d+Yjhvs+bPwvu/hbhfRgp2
	 Z78tCFnlA3s4WX8fBq2C649Rx0ECNlpBA0fXVU496uXFZDla6QfFYLDMRzvLO0KIXaw1S
	 2w+ZKJa0smwSnaU9Up9FQ0lseovPhSeI4/RU5YjW5h664WmHh4MN/iXGDKidDk9utCw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UxfMi74p;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD961606A32F;
	Thu, 19 Nov 2026 00:51:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UxfMi74p
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D77871F000C4;
	Thu, 19 Nov 2026 00:51:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795049491;
	bh=yuzUhzOi5Y3CLT2p9hSUC0zOY3SOkLvjI61CUXm8lxM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UxfMi74p+DoeH89/dDg2iYiM8no4rRg3MsUZVxXJ48U/iUwmbnoGMvpjQ+uCsJdzA
	 emuEP25Vo4ZTAaiUME+B6JMnMY9pttNY9yBg+yJ2Tl9Shd695kyW8buHyW6Si69hVk
	 Zw5sdiC4NhH2qrsV3BEEyvwf44SkOuqIedkXZdqk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2371/2857] btrfs: fix off by one super block end offset calculation when writing super blocks
Date: Wed, 18 Nov 2026 15:56:45 +0100
Message-ID: <20261118150326.890723938@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Filipe Manana <fdmanana@suse.com>

[ Upstream commit 7884a8f3279c28ff990e2eacd5c2479bb1c930d0 ]

We are skipping the write of a super block mirror if its end offset
matches exactly the device's end offset. This happens because we are using
a greater than or equals comparison instead of just a greater than
comparison.

Fixes: 935e5cc935bc ("Btrfs: fix wrong disk size when writing super blocks")
Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/disk-io.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index a71d773d0c3bc..e7b7e852b7aaa 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -4037,8 +4037,7 @@ static int write_dev_supers(struct btrfs_device *device,
 			errors++;
 			continue;
 		}
-		if (bytenr + BTRFS_SUPER_INFO_SIZE >=
-		    device->commit_total_bytes)
+		if (bytenr + BTRFS_SUPER_INFO_SIZE > device->commit_total_bytes)
 			break;
 
 		btrfs_set_super_bytenr(sb, bytenr_orig);
@@ -4124,8 +4123,7 @@ static int wait_dev_supers(struct btrfs_device *device, int max_mirrors)
 				primary_failed = true;
 			continue;
 		}
-		if (bytenr + BTRFS_SUPER_INFO_SIZE >=
-		    device->commit_total_bytes)
+		if (bytenr + BTRFS_SUPER_INFO_SIZE > device->commit_total_bytes)
 			break;
 
 		page = find_get_page(device->bdev->bd_inode->i_mapping,
-- 
2.53.0



