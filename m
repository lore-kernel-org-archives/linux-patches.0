Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A4BE2D0C7E;
	Mon, 13 Apr 2026 16:34:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776098071; cv=none; b=QsOvqanivo3tktjBZ9UsIvRsCF03h8aZk0nOQwUoWCYqHrfC7S6dcsKmIjT57FoOyuDCMCXYIq5p2Rve7uuVd2+JKq6EuRA4sIP0lgf1Suv/RTKAwyYDXPFfbLU8N+oOUK0duE6JI7otTKJRkISv+Z4RYCaJjYwSfoqC+kUSn2s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776098071; c=relaxed/simple;
	bh=xZ+lXcWlinqdxPwqM2ury6LLJQixqjg+PJIwhjaL51A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gfusDmsppko5ScLET80+TMcUYPRbvTaBvRDa4zOS+YDKxl7Elv8mZNZnFZsarcHdsIQ5Ln0icmKwKsEmnJPr6OtSCrzU8pqvMQnMYNNTVoaa81x4mddXG+TCZSC7YVH2xkMOs1b/wcXy9miXwHMATl0A4szg3dmqo36YdqvFVUM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=T2nSP8oh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T2nSP8oh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9887C2BCAF;
	Mon, 13 Apr 2026 16:34:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776098071;
	bh=xZ+lXcWlinqdxPwqM2ury6LLJQixqjg+PJIwhjaL51A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=T2nSP8ohso1eXxMNoMX9WPdqwvvBZdK217bV8hekpttcJIekvLpWveaMc2pMR4lw4
	 1QYpngE6SfIh77irn+vHIOqIS8HH9GhCnoFstVo5pJMWOhrZ3dRApNqKIYM3/6nZYx
	 Df5KbbTQqJOIKbE2R4GF4Sjo7TeWVxa7ctMNLylo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Helen Koike <koike@igalia.com>,
	Theodore Tso <tytso@mit.edu>,
	syzbot+b73703b873a33d8eb8f6@syzkaller.appspotmail.com,
	stable@kernel.org
Subject: [PATCH 5.15 383/570] ext4: reject mount if bigalloc with s_first_data_block != 0
Date: Mon, 13 Apr 2026 17:58:34 +0200
Message-ID: <20260413155844.825725733@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155830.386096114@linuxfoundation.org>
References: <20260413155830.386096114@linuxfoundation.org>
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
@@ -3214,6 +3214,13 @@ int ext4_feature_set_ok(struct super_blo
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


