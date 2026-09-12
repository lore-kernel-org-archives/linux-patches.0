Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1AD9320CD3;
	Sat, 12 Sep 2026 15:29:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789226965; cv=none; b=RCunYXaJcFCAQxOa0DZnEI4PObYYhHTOZcJnH8kutdex5Ku9iaOE1aA37wgyZZRw7eGiJmge9HC42C/sJHUAyQIeJyq3W6cW6p6mcDtFyH0rab6Q1IcNIb8n++j2kfo/YdHZhHGT3txtivrbB5zZS1NnBPg3pIJq8IYzMM32r1M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789226965; c=relaxed/simple;
	bh=7CYDAa3k1NeHeLmYX3LYouTqZSeJOk76Lf8jOYLr5tI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kX089F6A05QpFWaLKr3cTyorJ9tn+DlMJ5rhWqeFYqn6YvpjSaq9lozlja8EaZMG5vE1HqhPuhboKiwLBmhLFwowduk/0mX1UBpwHZbIq0gousq8SmxdbFmh6QER3Zl6ySfcKdw3mw16dLomlHYStgFEnZ8uRa7uU3tqCy8Lj+I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0lT38nau; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0lT38nau"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A5071F000FF;
	Sat, 12 Sep 2026 15:29:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789226963;
	bh=DXk2cnP669ij6YKF3i1ux3OxClEIca/183gyIoIcj/I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0lT38naum6Rw6F/umPUNnIi6M6unbVZ5VC8FQlpXuBAS3lIrCJEtn6SCJTosW39U5
	 hq0ZpsmRqy4EHRTuuSR0VeYS2WZGmTOx8tYZ+MeZU0rEIPDmDhkY7mRDcaznh2IzJh
	 sq43xvYJZxRn+EL1xWKjCPCCeIiEdTT5gsHNstvM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yichong Chen <chenyichong@uniontech.com>,
	Tyler Hicks <code@tyhicks.com>
Subject: [PATCH 6.1 0084/1191] ecryptfs: show filename encryption options
Date: Sat, 12 Sep 2026 08:46:52 +0200
Message-ID: <20260912065550.064051160@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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


