Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD1C22DE702;
	Sat, 12 Sep 2026 13:34:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789220065; cv=none; b=u5UjdNokO0aLsVNc+xC8c60/Pz6/zAOR0Cz6dZEi5kGZbn7i+SSL0rrhj3UVXKEw1KQoqvdqGrKVv/VtzwZj8QO1tHR4cdb9GmeSnAPXs3qylrDJiwNhd2CZHbXk6GprPAsTHkdPG61E3X73mzIDlRnk5q+rzuL5mEAx/qBxrlQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789220065; c=relaxed/simple;
	bh=5JqvNuYKhNczy000YshYe4yIRbDNntIziQ1MfApBWME=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZWoT6R80tf5x4rNFkAdytMbB/yJ8Qj2b18nwGRpwhQ1LrnARMvKLPuFkiiRb/Cyh6Gqs8It7C04yQLusATTKRSbSInTNIJSjp54ujImFW5/pmi+FjdOdz96U5dGh3O34uEkWz36CCT9Y0SG3oUkFAtaLE/eyRZ9nwlmCDJe9ma4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iRhT2EFH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iRhT2EFH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36DE71F000FF;
	Sat, 12 Sep 2026 13:34:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789220064;
	bh=5F0XmCG5K4FSR0FjzZfz3994qccIVAs6vmQI1f9bPdE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iRhT2EFHjQnf8phVxxM7W96locYvqD0MQ8NNzTpN2EFuapLf2oDE8BqsAQ6lCrfBb
	 cjXX9gbTU2PVLvLN7tLvxJje5qrHGoTzN/gaBk1vz6ncwZWMSMNGBKIDuymPyUkVBx
	 KTRyB0XJnXqHM+nGivEDjm4F23ZfNXG8PbXLAIVA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yichong Chen <chenyichong@uniontech.com>,
	Tyler Hicks <code@tyhicks.com>
Subject: [PATCH 6.6 0100/1424] ecryptfs: show filename encryption options
Date: Sat, 12 Sep 2026 08:42:12 +0200
Message-ID: <20260912065609.545474361@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


