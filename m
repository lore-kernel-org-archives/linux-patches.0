Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F92F78C9C;
	Sat, 12 Sep 2026 19:28:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789241299; cv=none; b=WkHc5quLil3fdqU/NCT4g6PJ2lESWCgGcwKcLcPBA8xL/SSpKP6K1JVsj/JsLCoWPloKOH20EbHo3QWsjUORxa6ih7goQ1pSyfWAn0R/E1Glc6G5f5mD5siUF4S6ZdTUGG1Xtsd7eUmQb5g0/yTXawzlEkgWW1KFN7UW6r1J2OU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789241299; c=relaxed/simple;
	bh=ZYmo61BTRiOVfxXXRPr2JUeEoXoqfqZa72Di8DJAoFg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bk+6/rAvvdaDYnnA4GebXEB6tgJfP4vZcvvZIT2za8XjbBGa33oICGb9Heq7eOuBRZxfvM1hU8/GBbsf0DLPCjqztOYSqxGrL+d3ambVUvCxU9Gh/BjHjZktWe1mCAaly2rrwwQj3G2VFRXpc+JKukfvVADpUVOCNK3wyeaO218=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mPVrTEFZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mPVrTEFZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD48A1F000FF;
	Sat, 12 Sep 2026 19:28:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789241297;
	bh=CCQLuwqh3nvpiDJTl8SK9o92GNMe3FbU954t51j3FwI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mPVrTEFZ8OmHBMJWWVmYth4wDkFCEFSL3GMZ8XL2RYepu9MPbnRlf/TW7ahQCX4fq
	 QKcNjRn8pG/evXMT2fJCjy+0PmL7rrkiDwwc5Zxfse5wbFWUykifW6ioMvpNzjBoFC
	 /UigKNxMBvHiSarMhNiUqo7/Vz3EmZfDW32WAUAU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yichong Chen <chenyichong@uniontech.com>,
	Tyler Hicks <code@tyhicks.com>
Subject: [PATCH 5.10 064/798] ecryptfs: show filename encryption options
Date: Sat, 12 Sep 2026 08:54:52 +0200
Message-ID: <20260912065518.432464391@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yichong Chen <chenyichong@uniontech.com>

commit 496ec2d0852a02d2e631771b5c439130b9c7dce7 upstream.

ecryptfs_show_options() prints most user-visible mount options but
omits the filename encryption cipher and key size.

Print ecryptfs_fn_cipher and ecryptfs_fn_key_bytes when filename
encryption is enabled so that the displayed mount options reflect the
active filename encryption settings.

Fixes: 87c94c4df014 ("eCryptfs: Filename Encryption: mount option")
Cc: <stable@vger.kernel.org>
Signed-off-by: Yichong Chen <chenyichong@uniontech.com>
Signed-off-by: Tyler Hicks <code@tyhicks.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ecryptfs/super.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/fs/ecryptfs/super.c
+++ b/fs/ecryptfs/super.c
@@ -153,6 +153,13 @@ static int ecryptfs_show_options(struct
 	if (mount_crypt_stat->global_default_cipher_key_size)
 		seq_printf(m, ",ecryptfs_key_bytes=%zd",
 			   mount_crypt_stat->global_default_cipher_key_size);
+	if (mount_crypt_stat->flags & ECRYPTFS_GLOBAL_ENCRYPT_FILENAMES) {
+		seq_printf(m, ",ecryptfs_fn_cipher=%s",
+			   mount_crypt_stat->global_default_fn_cipher_name);
+		if (mount_crypt_stat->global_default_fn_cipher_key_bytes)
+			seq_printf(m, ",ecryptfs_fn_key_bytes=%zd",
+				   mount_crypt_stat->global_default_fn_cipher_key_bytes);
+	}
 	if (mount_crypt_stat->flags & ECRYPTFS_PLAINTEXT_PASSTHROUGH_ENABLED)
 		seq_printf(m, ",ecryptfs_passthrough");
 	if (mount_crypt_stat->flags & ECRYPTFS_XATTR_METADATA_ENABLED)


