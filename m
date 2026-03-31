Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47F1E31354F;
	Tue, 31 Mar 2026 17:08:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774976890; cv=none; b=M+q2L9d44/vQhCJ0/8KJqXiaUAm0m13HeGZnI5yN4vWTE1HeVa73ytrTfeTK9puhAbcYvTAglU0vuOkz7YvFyaoFk8WQ28k5jNosQ3g8V2fpHxY5Lyd+V06IyPOoEKeAsrJBe3STEjmRUwp6CM19y8YTsJYgn7AQg/c3UsRkqDI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774976890; c=relaxed/simple;
	bh=d6tYJpu7xTyVPZtpZfGcfIberheStj/Z+RReI6s7heU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tGyKnghHrfAaZ9KiyAzE36NORvL1Z/HamRGlqJjP1vfF+KgZAjEtl4EhE18h543o0hE1IBmU37gl8U526UA66OVpaSZy7d72+uEgeN2Yvg0S785bU8oteo/haLGg5scJzyzzrfSm0TD1bbCkoXwEb8o+AA2gWtxfCwroBHll80M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QYRXBG0m; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QYRXBG0m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF6A0C19423;
	Tue, 31 Mar 2026 17:08:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774976890;
	bh=d6tYJpu7xTyVPZtpZfGcfIberheStj/Z+RReI6s7heU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QYRXBG0mdRWTlQDk0PoRTYiNIVw3F1YsT9tuutM3C8iX+lXZmHTDuxbf4uLcYFXiP
	 yZ0feqcA8kLjFKz+QfOUn7fZiJOvUevxa2E3y/OwWTsE87Ej7MWhwu2rD8YYBJcOu/
	 /GgFPiafVD7fSUf+PBsUfBtgCqLXbgnwilQZCg2w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Helen Koike <koike@igalia.com>,
	Theodore Tso <tytso@mit.edu>,
	syzbot+b73703b873a33d8eb8f6@syzkaller.appspotmail.com,
	stable@kernel.org
Subject: [PATCH 6.18 266/309] ext4: reject mount if bigalloc with s_first_data_block != 0
Date: Tue, 31 Mar 2026 18:22:49 +0200
Message-ID: <20260331161803.355887903@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161753.468533260@linuxfoundation.org>
References: <20260331161753.468533260@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -3624,6 +3624,13 @@ int ext4_feature_set_ok(struct super_blo
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


