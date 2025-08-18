Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CF8B2206AF;
	Mon, 18 Aug 2025 13:42:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755524536; cv=none; b=QXAc3IP4FZgvDip9FR4pqTbHBo7LQdHNfgbxB8bQqT9NlQC5kh4vkt8V7mPeXXm1l+i1SYkXanxa/nzTlp/WF9s60trqXcx1aNl043OrbjkyRZfRGeMGHC8Ha2135ejlsqMr7EAjQI39hSKvv7Vtfae2CeCPOchNQuiftXaHv94=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755524536; c=relaxed/simple;
	bh=4x7eWrwJ4zmn+cOI3n2P0+FNf6aPsKxWgHea9i/UmTQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hHxmsuFmxcN/4uvMFqj5We6QAlRbGR2CJw99QF9fq+jChVCmKM5HbxvIhSTtE9KKCMKfmGTCXkthaGY4QeGh+8yyHY6sUwuZrfxq3vdKQBLDNeBHdRqX4NGBiQAo9yREVnB0uQozech0MMO+JRTKPC87OiOh6OZdjTwPwdx05ok=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GBtLsXbX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GBtLsXbX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF68DC116B1;
	Mon, 18 Aug 2025 13:42:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755524536;
	bh=4x7eWrwJ4zmn+cOI3n2P0+FNf6aPsKxWgHea9i/UmTQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GBtLsXbXEqN8YnZfqzoImEt1+HBOuH0aoWjDXs3dM5git2kCtqtvDcLkxudDyGGJ1
	 4fuc5ZIZy8RkMsr5L1OtEBJwagNOtLcqzIfuNdRoPv/sUiWJIHFUZhoRiEtuuMWVyG
	 OOudObCWMSqg7t9uTonFeAkQh33c15smKT8MWeGI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Caleb Sander Mateos <csander@purestorage.com>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 6.15 471/515] btrfs: dont skip accounting in early ENOTTY return in btrfs_uring_encoded_read()
Date: Mon, 18 Aug 2025 14:47:37 +0200
Message-ID: <20250818124516.553493382@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124458.334548733@linuxfoundation.org>
References: <20250818124458.334548733@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Caleb Sander Mateos <csander@purestorage.com>

commit ea124ec327086325fc096abf42837dac471ac7ae upstream.

btrfs_uring_encoded_read() returns early with -ENOTTY if the uring_cmd
is issued with IO_URING_F_COMPAT but the kernel doesn't support compat
syscalls. However, this early return bypasses the syscall accounting.
Go to out_acct instead to ensure the syscall is counted.

Fixes: 34310c442e17 ("btrfs: add io_uring command for encoded reads (ENCODED_READ ioctl)")
CC: stable@vger.kernel.org # 6.15+
Signed-off-by: Caleb Sander Mateos <csander@purestorage.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/ioctl.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -4832,7 +4832,8 @@ static int btrfs_uring_encoded_read(stru
 #if defined(CONFIG_64BIT) && defined(CONFIG_COMPAT)
 		copy_end = offsetofend(struct btrfs_ioctl_encoded_io_args_32, flags);
 #else
-		return -ENOTTY;
+		ret = -ENOTTY;
+		goto out_acct;
 #endif
 	} else {
 		copy_end = copy_end_kernel;


