Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1815F1D04BB;
	Mon, 21 Oct 2024 10:28:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729506495; cv=none; b=VNhWMWJie6nVfmxdVd5gC1ceuaiCwbZUAGKzuK1aKZLrLQaq36iaj/QQJ/PdRFpXlS3lHoUkIBe5E/7gnANPusEZ49EmRLD2b50G/cpDqnsEqPJc7aBudpBv+5Ci7DK+iUROovvouaARWhhSLEt/MSEW5wt4ukOOQcnU3N9HoXc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729506495; c=relaxed/simple;
	bh=JpNOACSaB4OZlUcNHjqgLA0YoiKhMqJHEfrG0kenxIc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Jeczu0fXZ2PCI2HNQONcx48r5tvBkCIryXSur4YH0X6d2AF5voITS9jW9DPfYWm/x8yorVJP/abH4IHa+JsfymraEB62TE/xx7asxiBW40UJG24WytomsC/ounbebdAqrHn4xooSsaAQiETffMvY6OLWYsP0T9u3m3NGhUTl3Go=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aLGOmF4c; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aLGOmF4c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FE9BC4CEC3;
	Mon, 21 Oct 2024 10:28:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1729506494;
	bh=JpNOACSaB4OZlUcNHjqgLA0YoiKhMqJHEfrG0kenxIc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aLGOmF4cbiqCGZSHWYQ+8AxiOT75jtB02Y1s38qeZEbU5xCKIEoip9M5bEIc+iXMF
	 BwKi2q9e+ZKdcxcISDhZvFvdJGyhlP1s0B48IdhLziLBaoQfb9+j/tTnJBkoX3i9XB
	 AjmtadTzg4z/OzKeQwnSwG53yv6XtS+/eq9FfZQM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
	syzbot+ef0d7bc412553291aa86@syzkaller.appspotmail.com,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.11 023/135] fat: fix uninitialized variable
Date: Mon, 21 Oct 2024 12:22:59 +0200
Message-ID: <20241021102300.244952284@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241021102259.324175287@linuxfoundation.org>
References: <20241021102259.324175287@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1037,7 +1037,7 @@ error_inode:
 	if (corrupt < 0) {
 		fat_fs_error(new_dir->i_sb,
 			     "%s: Filesystem corrupted (i_pos %lld)",
-			     __func__, sinfo.i_pos);
+			     __func__, new_i_pos);
 	}
 	goto out;
 }


