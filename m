Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52D011DF257;
	Wed,  6 Nov 2024 12:20:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730895600; cv=none; b=lfcnH5VGm0yEEmPhplAACI0w20hkDCL4nhvnDmKq1hwsJy4b01E6oLKYnQDU0BX8gzSNNv4qJh3KfHiWpjWoT0tcSrxzfPpbRCOdqAvz3fXX6CpOFiKYVggnGVD6AT3V2/Dx5AbIHWzqwwFJ6g7Jmm6ntKd8EVFgpDvnXzObHi4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730895600; c=relaxed/simple;
	bh=q4TwM7Th4cmo2u0YcA+pYME2W1tIA2H+9ehBJM4jaqA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LulaLC6W5alAIDDwbw8jUNh7SPsVK2OLnki2JojT0hw1rjlMOzDfXDJgalec37JFFsCQGENAPf/Nac5lN/Vx07OENbDAG8oVDGT3YDrfhqf8XnU+SPkLf94pgz6Pm8xqgJ+DCZg43s5RuqXhAEjy11XnZFr2Sv7uarcOzH+oABQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yE7SJHnt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yE7SJHnt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBDE6C4CECD;
	Wed,  6 Nov 2024 12:19:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730895600;
	bh=q4TwM7Th4cmo2u0YcA+pYME2W1tIA2H+9ehBJM4jaqA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yE7SJHntwXyC2foKq1XBVO6sJi8pD3THrJfWlDbGRLKfh10FIAr+HpdqLw8Y+NzQ9
	 uyc+BXjy8xDzffIV9yPlmdt0IhMJAfZtSwpbGAJpYW8ysAH9snU/IIw3T+xpFGbmhS
	 vdkk12JbAPPS3IffiyCA2I6TIUjxtSFkQO1pHIa8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
	syzbot+ef0d7bc412553291aa86@syzkaller.appspotmail.com,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 4.19 272/350] fat: fix uninitialized variable
Date: Wed,  6 Nov 2024 13:03:20 +0100
Message-ID: <20241106120327.600699946@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120320.865793091@linuxfoundation.org>
References: <20241106120320.865793091@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1018,7 +1018,7 @@ error_inode:
 	if (corrupt < 0) {
 		fat_fs_error(new_dir->i_sb,
 			     "%s: Filesystem corrupted (i_pos %lld)",
-			     __func__, sinfo.i_pos);
+			     __func__, new_i_pos);
 	}
 	goto out;
 }


