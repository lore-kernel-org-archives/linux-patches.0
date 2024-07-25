Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFE60F519;
	Thu, 25 Jul 2024 14:49:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721918988; cv=none; b=UyD1EFszOW+vlwkzO/ADi61aY5T+DuP8CFJjsDdc8yrPFRVO8zmqc1uVUkSbo3t+O4Qir93m/r4xV5WZJj5Oif7CHbhYOT8nHPNbW0qhzDt8NNAMOiSeg80avL6oZOlthmYxyTaoPXANW2VuUZm8Q1xLaYRz8KYUHydm/kvIccM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721918988; c=relaxed/simple;
	bh=gc8tjztTI9bNOwX5lOLYyf59f6MoF68QngOLaU1ADxk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cSyzMAdUHodMyxfOFABpRBNLpVN6I4bFehPzEUMfD0VGFD+IQ7AhzLAQkqBgAMZjdpFng5fTCsVb83AQMZVXp7q0J+qCicGTkW8SdLnaSr5mJBtMmjmXqf1VA0vcrmXDPFUY6jNz+vPljtvHuQl1sLM+HqowMfhSqRX1+adc7l8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b6QMGE5y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b6QMGE5y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4206CC116B1;
	Thu, 25 Jul 2024 14:49:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721918988;
	bh=gc8tjztTI9bNOwX5lOLYyf59f6MoF68QngOLaU1ADxk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=b6QMGE5yeQp8ywynfJkTxlLqCHo5W52cfrunAlbGsO/zauUiGxoh88zWuJVJyL2AQ
	 7Li1rvdTByKVtUh1imVHbcfytZgx1MKYNiW8upcPh80n6aDfGfjNQAfJdQ2DgUv5Tc
	 VB6mwYIYCY6d62yePW6TReCFAeEFkUMCcM1bqveQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gabriel Krisman Bertazi <krisman@collabora.com>,
	Theodore Tso <tytso@mit.edu>,
	Ajay Kaher <ajay.kaher@broadcom.com>
Subject: [PATCH 5.10 49/59] ext4: fix error code saved on super block during file system abort
Date: Thu, 25 Jul 2024 16:37:39 +0200
Message-ID: <20240725142735.111052711@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240725142733.262322603@linuxfoundation.org>
References: <20240725142733.262322603@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gabriel Krisman Bertazi <krisman@collabora.com>

commit 124e7c61deb27d758df5ec0521c36cf08d417f7a upstream.

ext4_abort will eventually call ext4_errno_to_code, which translates the
errno to an EXT4_ERR specific error.  This means that ext4_abort expects
an errno.  By using EXT4_ERR_ here, it gets misinterpreted (as an errno),
and ends up saving EXT4_ERR_EBUSY on the superblock during an abort,
which makes no sense.

ESHUTDOWN will get properly translated to EXT4_ERR_SHUTDOWN, so use that
instead.

Signed-off-by: Gabriel Krisman Bertazi <krisman@collabora.com>
Link: https://lore.kernel.org/r/20211026173302.84000-1-krisman@collabora.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Ajay Kaher <ajay.kaher@broadcom.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/super.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -5887,7 +5887,7 @@ static int ext4_remount(struct super_blo
 	}
 
 	if (ext4_test_mount_flag(sb, EXT4_MF_FS_ABORTED))
-		ext4_abort(sb, EXT4_ERR_ESHUTDOWN, "Abort forced by user");
+		ext4_abort(sb, ESHUTDOWN, "Abort forced by user");
 
 	sb->s_flags = (sb->s_flags & ~SB_POSIXACL) |
 		(test_opt(sb, POSIX_ACL) ? SB_POSIXACL : 0);


