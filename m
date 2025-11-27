Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B36C334C08;
	Thu, 27 Nov 2025 14:58:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764255506; cv=none; b=eWJtFZyxtwxacy/WNAU88JFoqw4uet21nhwOnWo0fMX5BCibQrVuYnMQkIdmwP66Rev4abky7ER89iG+nzJdM50ksRAclYKk7EIRKvnVhGgyC0IV2ab5WzJ8jEYB/iR41MPG8m02dOcxiomJFems3C4CuqAhiUM1lp5gpS84yGY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764255506; c=relaxed/simple;
	bh=0y8xJsAeLAOws52ZVNTXwo6v9gnfcFSB2N3d/Ow04Ro=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kS3ItlI/DFBqnDUzaI5xHkNbWrCYPQWs+rxN/6QBy0rJ9kzNjebuWKFxQmnKYnAy7drBPgyh+MfcF9YbPo1m7G9awYMuOSqcTOSevPTrKPUNLT1Xv25VfaiAWkBnKwzynbfhzCuZECwaptVs+uoJavrWY+Uw/+d3rzpyiKsuqsk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xvQDC0Iu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xvQDC0Iu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BAD7C4CEF8;
	Thu, 27 Nov 2025 14:58:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764255505;
	bh=0y8xJsAeLAOws52ZVNTXwo6v9gnfcFSB2N3d/Ow04Ro=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xvQDC0IuHuFhh9WwS6ihEfyRFHZI9nq5CRSS3P2ipBnvfAyfcfqFiyIl7XKIyvx3H
	 GhwCUQgHfC+sPrFMxruw3ZHLVoBacQRJ8cCV5l4omLE1XzTX4wsBPDeuue99ihdjV5
	 aBMaBArZryT47hMfrgx7ywLQODy0SqcKc7ebVy9o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Kara <jack@suse.cz>,
	Christoph Hellwig <hch@lst.de>,
	Yongpeng Yang <yangyongpeng@xiaomi.com>,
	Christian Brauner <brauner@kernel.org>
Subject: [PATCH 6.17 017/175] isofs: check the return value of sb_min_blocksize() in isofs_fill_super
Date: Thu, 27 Nov 2025 15:44:30 +0100
Message-ID: <20251127144043.587552022@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251127144042.945669935@linuxfoundation.org>
References: <20251127144042.945669935@linuxfoundation.org>
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

From: Yongpeng Yang <yangyongpeng@xiaomi.com>

commit e106e269c5cb38315eb0a0e7e38f71e9b20c8c66 upstream.

sb_min_blocksize() may return 0. Check its return value to avoid
opt->blocksize and sb->s_blocksize is 0.

Cc: stable@vger.kernel.org # v6.15
Fixes: 1b17a46c9243e9 ("isofs: convert isofs to use the new mount API")
Reviewed-by: Jan Kara <jack@suse.cz>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Yongpeng Yang <yangyongpeng@xiaomi.com>
Link: https://patch.msgid.link/20251104125009.2111925-4-yangyongpeng.storage@gmail.com
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/isofs/inode.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/fs/isofs/inode.c
+++ b/fs/isofs/inode.c
@@ -610,6 +610,11 @@ static int isofs_fill_super(struct super
 		goto out_freesbi;
 	}
 	opt->blocksize = sb_min_blocksize(s, opt->blocksize);
+	if (!opt->blocksize) {
+		printk(KERN_ERR
+		       "ISOFS: unable to set blocksize\n");
+		goto out_freesbi;
+	}
 
 	sbi->s_high_sierra = 0; /* default is iso9660 */
 	sbi->s_session = opt->session;


