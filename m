Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79F49FBE7
	for <patches@lists.linux.dev>; Mon, 15 May 2023 17:29:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D19E8C433D2;
	Mon, 15 May 2023 17:29:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684171760;
	bh=4lPZSqgKYP1OTvSzvcfeyhcDLndJdaVW6IyNcZ5JejA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=N1g3u4ZiHyg6PMhGsPTHV/JB2dMKNq3RF4HHjfItVfI21dnOCoBAgyK8qbkhiNtXp
	 pJMdoUbYMlBacuRNfLyv+duC6Myk2oY6YSBH6aJvf+OloCnCzvUwqW8Mgp+VLW7XSO
	 7Qb3XhlOlmzL1i0BsVQGjActFCLTjdDBO644RLNI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Howells <dhowells@redhat.com>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 5.15 069/134] cifs: release leases for deferred close handles when freezing
Date: Mon, 15 May 2023 18:29:06 +0200
Message-Id: <20230515161705.453385939@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230515161702.887638251@linuxfoundation.org>
References: <20230515161702.887638251@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Steve French <stfrench@microsoft.com>

commit d39fc592ef8ae9a89c5e85c8d9f760937a57d5ba upstream.

We should not be caching closed files when freeze is invoked on an fs
(so we can release resources more gracefully).

Fixes xfstests generic/068 generic/390 generic/491

Reviewed-by: David Howells <dhowells@redhat.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/cifs/cifsfs.c |   15 +++++++++++++++
 1 file changed, 15 insertions(+)

--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -730,6 +730,20 @@ static void cifs_umount_begin(struct sup
 	return;
 }
 
+static int cifs_freeze(struct super_block *sb)
+{
+	struct cifs_sb_info *cifs_sb = CIFS_SB(sb);
+	struct cifs_tcon *tcon;
+
+	if (cifs_sb == NULL)
+		return 0;
+
+	tcon = cifs_sb_master_tcon(cifs_sb);
+
+	cifs_close_all_deferred_files(tcon);
+	return 0;
+}
+
 #ifdef CONFIG_CIFS_STATS2
 static int cifs_show_stats(struct seq_file *s, struct dentry *root)
 {
@@ -761,6 +775,7 @@ static const struct super_operations cif
 	as opens */
 	.show_options = cifs_show_options,
 	.umount_begin   = cifs_umount_begin,
+	.freeze_fs      = cifs_freeze,
 #ifdef CONFIG_CIFS_STATS2
 	.show_stats = cifs_show_stats,
 #endif


