Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1515A1E3DF9;
	Mon, 21 Oct 2024 10:46:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729507571; cv=none; b=k1mKgIS+RBNkyrBbZeWn1vLn8Mt4fyW9nSI/fBet/aqJCVY1Nd3AwEOqXD1Q3XExybMno33y/300NLi63OnButmfzR8JrFRAem9Rwv3FKWjZ35gbW9cmqYmJi92zLqw8bH2zn7P+knPD+VwlD61+WtbnPKCJJYIRlrIJ+Ox5IV0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729507571; c=relaxed/simple;
	bh=HMYtkSrOgQbonuCg3Q6yxKKp8uEDPi7w7z7IwmXMbu8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aXC/gzNGPY5wCFTTb/4hJaLqm8NtoYBmxBVQeb2Ji6MtRsAYJf8ZwDyEVk9wcqDVSwk9kRr2PKIa0+0tZrGF2040SzfSN7GVg75tfsiLtNJXa63BNc4cDCRG07pWhVXDhvA2j0z2AcHhRP63wzKPUXVNtklDgazDDCHJjrVADkM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KBtdtq5s; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KBtdtq5s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8863CC4CEC3;
	Mon, 21 Oct 2024 10:46:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1729507570;
	bh=HMYtkSrOgQbonuCg3Q6yxKKp8uEDPi7w7z7IwmXMbu8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KBtdtq5sG3gZLqzapEidGwci5Abt07YDNcnjCZYt7NOp0bq7a3UA5mrmjf4Wk8rmN
	 PTxXVnY8ksFNREx8sYIy0TDt3OfCunkbenlCd1a52Zn4sm3wIHoydgIgzbF+9GBuhB
	 YHOM7i8S264aiVNUKiu/0EaRkppE19AIip9QUWUA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
	syzbot+ef0d7bc412553291aa86@syzkaller.appspotmail.com,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 5.15 29/82] fat: fix uninitialized variable
Date: Mon, 21 Oct 2024 12:25:10 +0200
Message-ID: <20241021102248.400378976@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241021102247.209765070@linuxfoundation.org>
References: <20241021102247.209765070@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>

commit 963a7f4d3b90ee195b895ca06b95757fcba02d1a upstream.

syszbot produced this with a corrupted fs image.  In theory, however an IO
error would trigger this also.

This affects just an error report, so should not be a serious error.

Link: https://lkml.kernel.org/r/87r08wjsnh.fsf@mail.parknet.co.jp
Link: https://lkml.kernel.org/r/66ff2c95.050a0220.49194.03e9.GAE@google.com
Signed-off-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Reported-by: syzbot+ef0d7bc412553291aa86@syzkaller.appspotmail.com
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/fat/namei_vfat.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/fat/namei_vfat.c
+++ b/fs/fat/namei_vfat.c
@@ -1020,7 +1020,7 @@ error_inode:
 	if (corrupt < 0) {
 		fat_fs_error(new_dir->i_sb,
 			     "%s: Filesystem corrupted (i_pos %lld)",
-			     __func__, sinfo.i_pos);
+			     __func__, new_i_pos);
 	}
 	goto out;
 }


