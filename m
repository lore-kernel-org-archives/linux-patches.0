Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D857914A81
	for <patches@lists.linux.dev>; Mon, 23 Oct 2023 11:04:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZSDus2aD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 541BFC433C8;
	Mon, 23 Oct 2023 11:04:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1698059082;
	bh=EeqZBH3rjtD+n3stPzGBDxX/S9CX3KR4ZlbZ3VFvuM4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZSDus2aDlXVmJFZy57wnBki1QUg9uC21P+rpOCyLz6tzkLnVWLLf6eMkCeJHPvQ+p
	 jc7uk68M2ArMB9r9A228kORuec3z5Ielzbue6vHGoOXPK+9WU05I80K31tbujMc5fF
	 UjfCC0HgD8aem+8UXjzsXMRUSaW5cPL+9tFU+dps=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+53ce40c8c0322c06aea5@syzkaller.appspotmail.com,
	Pavel Skripkin <paskripkin@gmail.com>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Subject: [PATCH 6.5 030/241] fs/ntfs3: Fix OOB read in ntfs_init_from_boot
Date: Mon, 23 Oct 2023 12:53:36 +0200
Message-ID: <20231023104834.663926761@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231023104833.832874523@linuxfoundation.org>
References: <20231023104833.832874523@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pavel Skripkin <paskripkin@gmail.com>

commit 34e6552a442f268eefd408e47f4f2d471aa64829 upstream.

Syzbot was able to create a device which has the last sector of size
512.

After failing to boot from initial sector, reading from boot info from
offset 511 causes OOB read.

To prevent such reports add sanity check to validate if size of buffer_head
if big enough to hold ntfs3 bootinfo

Fixes: 6a4cd3ea7d77 ("fs/ntfs3: Alternative boot if primary boot is corrupted")
Reported-by: syzbot+53ce40c8c0322c06aea5@syzkaller.appspotmail.com
Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>
Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ntfs3/super.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/fs/ntfs3/super.c
+++ b/fs/ntfs3/super.c
@@ -855,6 +855,11 @@ static int ntfs_init_from_boot(struct su
 
 check_boot:
 	err = -EINVAL;
+
+	/* Corrupted image; do not read OOB */
+	if (bh->b_size - sizeof(*boot) < boot_off)
+		goto out;
+
 	boot = (struct NTFS_BOOT *)Add2Ptr(bh->b_data, boot_off);
 
 	if (memcmp(boot->system_id, "NTFS    ", sizeof("NTFS    ") - 1)) {


