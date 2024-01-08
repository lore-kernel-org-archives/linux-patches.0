Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D2B452F86;
	Mon,  8 Jan 2024 15:44:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ikitoYvM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58B5FC433C8;
	Mon,  8 Jan 2024 15:44:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1704728647;
	bh=RTBEDmcPauuJQ6qptSEcncG49DTv7VR8GDQIRbc3YNM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ikitoYvMOHXn6GopHIiNp2TqPEUc/7BDCfNADm8IlKcMmjBPKeD6UgdzqAHm8Lzdr
	 P4lC9jy5sGTaDaD+j6TyHWoeDVloAJPGqDRoEzo19lu1f2XzMxBNZtjXQEKPaV7rx4
	 9SEzF7BmAF5bfkFfghmbyE6Kd/2eHwRD/H5xA22g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 6.1 143/150] f2fs: compress: fix to assign compress_level for lz4 correctly
Date: Mon,  8 Jan 2024 16:36:34 +0100
Message-ID: <20240108153517.791733554@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240108153511.214254205@linuxfoundation.org>
References: <20240108153511.214254205@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chao Yu <chao@kernel.org>

commit 091a4dfbb1d32b06c031edbfe2a44af100c4604f upstream.

After remount, F2FS_OPTION().compress_level was assgin to
LZ4HC_DEFAULT_CLEVEL incorrectly, result in lz4hc:9 was enabled, fix it.

1. mount /dev/vdb
/dev/vdb on /mnt/f2fs type f2fs (...,compress_algorithm=lz4,compress_log_size=2,...)
2. mount -t f2fs -o remount,compress_log_size=3 /mnt/f2fs/
3. mount|grep f2fs
/dev/vdb on /mnt/f2fs type f2fs (...,compress_algorithm=lz4:9,compress_log_size=3,...)

Fixes: 00e120b5e4b5 ("f2fs: assign default compression level")
Signed-off-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/f2fs/super.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/f2fs/super.c
+++ b/fs/f2fs/super.c
@@ -615,7 +615,7 @@ static int f2fs_set_lz4hc_level(struct f
 	unsigned int level;
 
 	if (strlen(str) == 3) {
-		F2FS_OPTION(sbi).compress_level = LZ4HC_DEFAULT_CLEVEL;
+		F2FS_OPTION(sbi).compress_level = 0;
 		return 0;
 	}
 


