Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0CA253E0F;
	Tue, 23 Jan 2024 00:42:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705970579; cv=none; b=a+umwzd6kVRAXqaurm8I8fupaDxOiOc1U37NGZHk7+kj7edtzrF0zoEpJJ/UBPzl3fFxAjRbJQroZ++sYICbshVEf6p54aJECrjbE7rFL40Bkqe3Rg2xVYyJlj1H3ho6WUVbejAtfkjT2ld0cOKCPqFptNT2h3dn15SVdQZ4kr8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705970579; c=relaxed/simple;
	bh=zML5+mrFNOv+OAljNzn36ivIkA6kjnfS5rKb90s/Li4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EKlpci8e2Ga9BTNxRFuwRhRdd5rcfjCyXCETHq/vFwLNsiPHtsXEWnQUnM0HZ9SftXWxQqPaL+lzCN4OzDFXTyugXXnU+NWjBCgyKo2+Wl5i5JxUcu1tFZC3cRAO2M2xEUTzHcQ+ezoueOVR+uzzIBPWEWpCXXU+Bq9OkA86x7M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oyK16HMT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oyK16HMT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49460C433C7;
	Tue, 23 Jan 2024 00:42:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705970579;
	bh=zML5+mrFNOv+OAljNzn36ivIkA6kjnfS5rKb90s/Li4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oyK16HMTLhjBk9PS8Zb0nT8py2MwJQ7LSWx5ziw7VT94aWTw402bxgjgPPn4AlX8W
	 IoS2TKfSpDwqpx2SHNIFEK1IpRAkQgrt8V91YMsvw3IHBfiBo49D7a2kO3zsvFkve/
	 yEnYqPEaPvz97d2/yTtqZ5q7tgAFOC8D7OxFoyGQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ard Biesheuvel <ardb@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 027/417] efivarfs: Free s_fs_info on unmount
Date: Mon, 22 Jan 2024 15:53:15 -0800
Message-ID: <20240122235752.499221236@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235751.480367507@linuxfoundation.org>
References: <20240122235751.480367507@linuxfoundation.org>
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

From: Ard Biesheuvel <ardb@kernel.org>

[ Upstream commit 547713d502f7b4b8efccd409cff84d731a23853b ]

Now that we allocate a s_fs_info struct on fs context creation, we
should ensure that we free it again when the superblock goes away.

Fixes: 5329aa5101f7 ("efivarfs: Add uid/gid mount options")
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/efivarfs/super.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/efivarfs/super.c b/fs/efivarfs/super.c
index f5966cd95918..77c7615bba5e 100644
--- a/fs/efivarfs/super.c
+++ b/fs/efivarfs/super.c
@@ -250,10 +250,13 @@ static int efivarfs_init_fs_context(struct fs_context *fc)
 
 static void efivarfs_kill_sb(struct super_block *sb)
 {
+	struct efivarfs_fs_info *sfi = sb->s_fs_info;
+
 	kill_litter_super(sb);
 
 	/* Remove all entries and destroy */
 	efivar_entry_iter(efivarfs_destroy, &efivarfs_list, NULL);
+	kfree(sfi);
 }
 
 static struct file_system_type efivarfs_type = {
-- 
2.43.0



