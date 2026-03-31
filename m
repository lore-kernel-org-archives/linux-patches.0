Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54B734266BA;
	Tue, 31 Mar 2026 16:54:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774976060; cv=none; b=KbtUc/BQEDAbNaIx5VqToh6KZOryPsy5ZfXYZTRpc00qnYfbdVpM8D30uKp29ajTxslTh3qbbc/Xn4PwA+ITzVI4/LHumjWZuMkztW7y2x2MCNwE2iQ7Hj4tOmCXw93UB3shfM0Z+vAjXaQTjx8rgmloHQRvGQ+gU/IrpPH+/qQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774976060; c=relaxed/simple;
	bh=DbRkXO9/JQpUNvoXJCtt5eXvcFcatmF/lf5Gf+11vx0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q16D4ZdwNJG81qyrzIBiL4CQIOkEPY81yP2it3i6hric5atRGhPixM98OZICvhcQM3nkvIzWWzQ2Z/4RNemAo8dWADSFk85CRPkdGIbAFfDpVSHl75QII+Uj44uIkzXMvlEY+/uXYMv3GHtmejolmjwN1WPkS0IbKejiojKow6g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dPUjjKCG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dPUjjKCG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFD6BC19423;
	Tue, 31 Mar 2026 16:54:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774976060;
	bh=DbRkXO9/JQpUNvoXJCtt5eXvcFcatmF/lf5Gf+11vx0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dPUjjKCGabYvG9jNh0k//xjkqwf8GGMLyKFv9/Yj3GrxYE2+qWHNnqYfJm7kIddPM
	 77xSIP3zaCuqG7F8chlabjqC4OfJ3UHqIrcx3IrUEo8+G1vqo+CxQPHdsXUcx1disY
	 V5pCVhU2r7TIzDx5yZZJ3M9T98z1sRiO0g62dSss=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Helen Koike <koike@igalia.com>,
	Theodore Tso <tytso@mit.edu>,
	syzbot+b73703b873a33d8eb8f6@syzkaller.appspotmail.com,
	stable@kernel.org
Subject: [PATCH 6.12 192/244] ext4: reject mount if bigalloc with s_first_data_block != 0
Date: Tue, 31 Mar 2026 18:22:22 +0200
Message-ID: <20260331161748.843295994@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161741.651718120@linuxfoundation.org>
References: <20260331161741.651718120@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -3631,6 +3631,13 @@ int ext4_feature_set_ok(struct super_blo
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


