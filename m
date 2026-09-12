Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 634D247B439;
	Sat, 12 Sep 2026 17:05:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789232759; cv=none; b=tRzgR58tbTo5Iih4SwjaqsQGlyR9WHvv8xzcuK23eGCINOT+rm2VLtWNJsU6cjRW9E0QmRbN+cl7il5M1xjqCug9sU6JALmhzNv8OSYnyXtvfICLJULh0JBDwzCBQpoXr6N+qCJG1lzMl+qaLWpzT3C92+4ssk/Rltp7JnSEGGA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789232759; c=relaxed/simple;
	bh=Akcs6jTiFtN4vkXksngVlPb1u/Cn8MQdeiCceUGKqlE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ClyeBOep6eLGzN7ddhZz2Lb+AuC9+/8kxl4Btm8bRiiQ0tYfxZSamygnoKQLhXpmXHt723v9m288w+UoWmf6CnkWKafNVARP6+0Xumjj8qa9BrVi3F5BpWE2KdwzuKHcjRTBxS1POb+7KPnOqEw2lQzMQPpd4WU6S+xKybzx+cs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kcWwpH+X; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kcWwpH+X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D77161F000FF;
	Sat, 12 Sep 2026 17:05:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789232757;
	bh=FiiEnHWsYBB2waiK69EdodNwB94fdEaE0ACVmXipiKI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kcWwpH+XjGXU/tYWbBxK5rLiyeEHEczQ3AcEYikbQ/6qY32yATWsRsnWX6VSvT9aK
	 61+s2d2fhxwH9mhBQ0BaDAWJn/KYSIEx5ysfqzMc7/tTjcyseKErxPrU/pY8l0vEKO
	 igFtXiWckwbiF/ymgyNALR07wmRd7Y8eD+ux0mIw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yichong Chen <chenyichong@uniontech.com>,
	Tyler Hicks <code@tyhicks.com>
Subject: [PATCH 5.15 073/935] ecryptfs: show filename encryption options
Date: Sat, 12 Sep 2026 08:51:43 +0200
Message-ID: <20260912065528.508536170@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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


