Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0458F33120E;
	Tue, 31 Mar 2026 16:46:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774975570; cv=none; b=aFfx6JKLyLhw+3/AdRdkkZs8tm7sgGW10ffogHtzQbJ20n06n4UsQccw2y3V0TnvF9VicHqlutaGYOIeRxaWXXfjLmqwTXqA6H8w6S3l5SIjnpfiXSzletO7vocb4EEPGyRWIrvheHCHBnwLyIBMORcXK8tV0KinuUGaUSwa8MY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774975570; c=relaxed/simple;
	bh=59vFYsnCx9uN0btH6i5makyLh2Snl1SF4BfxTtHcRWo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E0kqs8aVzTePIwIEQ+b077nfcn9y/0WAwR8bXaPmqvgel4/0eAG1od2wegCYYoVHuFZD+DHYoZ6IjC8dFYM7gEhUQYU8/JqzzkGKnoVC5QTgZpHVaDPdspMkoEYjfo8hY3pNfZMI+xwI7GOg96VoT/Tmf8qzLfL+zFhwhxXg1wY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JRtVmXHB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JRtVmXHB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9496AC19423;
	Tue, 31 Mar 2026 16:46:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774975569;
	bh=59vFYsnCx9uN0btH6i5makyLh2Snl1SF4BfxTtHcRWo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JRtVmXHBBVvjABIuzzXcoBqjxaW4jghd5umFw1NJ4CMcq6Uc1b8q4u4bjcZBA1/OM
	 mhYnOkiFgPtllIIk2pC2kjFzfaoU8h/VzBOISJ/72mRQnTKBQz/SKYa6C4kuL37Sm+
	 eDQlWDq2WF2Dz7r+DJx8DwYD+9vNTxPXuDU71sSg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Helen Koike <koike@igalia.com>,
	Theodore Tso <tytso@mit.edu>,
	syzbot+b73703b873a33d8eb8f6@syzkaller.appspotmail.com,
	stable@kernel.org
Subject: [PATCH 6.19 302/342] ext4: reject mount if bigalloc with s_first_data_block != 0
Date: Tue, 31 Mar 2026 18:22:15 +0200
Message-ID: <20260331161810.040934544@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161758.909578033@linuxfoundation.org>
References: <20260331161758.909578033@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Helen Koike <koike@igalia.com>

commit 3822743dc20386d9897e999dbb990befa3a5b3f8 upstream.

bigalloc with s_first_data_block != 0 is not supported, reject mounting
it.

Signed-off-by: Helen Koike <koike@igalia.com>
Suggested-by: Theodore Ts'o <tytso@mit.edu>
Reported-by: syzbot+b73703b873a33d8eb8f6@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=b73703b873a33d8eb8f6
Link: https://patch.msgid.link/20260317142325.135074-1-koike@igalia.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Cc: stable@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/super.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -3625,6 +3625,13 @@ int ext4_feature_set_ok(struct super_blo
 			 "extents feature\n");
 		return 0;
 	}
+	if (ext4_has_feature_bigalloc(sb) &&
+	    le32_to_cpu(EXT4_SB(sb)->s_es->s_first_data_block)) {
+		ext4_msg(sb, KERN_WARNING,
+			 "bad geometry: bigalloc file system with non-zero "
+			 "first_data_block\n");
+		return 0;
+	}
 
 #if !IS_ENABLED(CONFIG_QUOTA) || !IS_ENABLED(CONFIG_QFMT_V2)
 	if (!readonly && (ext4_has_feature_quota(sb) ||


