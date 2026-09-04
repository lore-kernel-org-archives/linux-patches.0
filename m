Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A00B83F23DB;
	Fri,  4 Sep 2026 05:17:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788499036; cv=none; b=KJLztqHxHOLWRTlEIhutQaE/TkP8k0HyfoJcJ31NF5+6cJuRngqDn8gMr8422+50N1J5kwX47FKDchJhDJ+KJNgS9bISCdwqlDnHKPvg5xLOZssxgKvBjDCuWI9nDpdi9yMcsSlS+3HyVC1f4ukeLxiX+CWcY1pl5HmMZg26TSc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788499036; c=relaxed/simple;
	bh=YLFBzmFnwUipCzlvwyxbpjZWgLJvqye091QiO6zmPzE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Kz5eFAsuHbpd3ezPi+PYKInlUTPd0nqjSicQ1bJ4nEOUcREgUThQdUblw070H7mdXVkAhbfRRH44kOGHdCsXmHQvaZezUhdk9GGEgreG1ext8+4iVBJevOm6MejdLgm7HVgbOzCxzKhBC/XtRfAqvfL9dnjklIo12yzDvHCaZfA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZjL55PDN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZjL55PDN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9B951F00A3D;
	Fri,  4 Sep 2026 05:17:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788499035;
	bh=D1JZP+FGc9/VDAvq2zANzwDjj4Kfwl2kSbEUpLKooZk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZjL55PDNB4giu5tanFUJIWSBwsdacps2jUiQhSJ6V9QQdl/L7bwDo3OjGXwpeZ7HH
	 mf+CGAzTFwHjgyszpOffCsYeDZWdbYw4qfeAoQAG6iJlwbU/clmtezjKOHJydiX/0+
	 gJLWPVyySoMzRdi2VtfLQWhYhag5GttEZaZ82QJQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yichong Chen <chenyichong@uniontech.com>,
	Tyler Hicks <code@tyhicks.com>
Subject: [PATCH 7.2 276/713] ecryptfs: show filename encryption options
Date: Fri,  4 Sep 2026 06:54:04 +0200
Message-ID: <20260904045810.027419836@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045803.810145556@linuxfoundation.org>
References: <20260904045803.810145556@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
@@ -150,6 +150,13 @@ static int ecryptfs_show_options(struct
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


