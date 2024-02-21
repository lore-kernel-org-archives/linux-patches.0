Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09B2F76C99;
	Wed, 21 Feb 2024 13:58:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708523930; cv=none; b=tfVTleM8/xXTn8xQGdaHpR0wY1EvKn+uergsa+FS4oPM+VrOJhOElScd8IVd568Au7ewRYIj8ZDDsWesXZ/aY2EtJb5bXOfqw/uzDAM4MgCIm5JSuiLgJAY5ugHAYpXv75MEVjrV8gV2hgiTx4DmKG9C0G/bENXms4oic3DNNUY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708523930; c=relaxed/simple;
	bh=OyMAS3JEWztgmpJq2G8uVLhawsGVp9xEmglmU6jrBY8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j30F8z5+tyYnI6tGMM6bpT65EalkXEIhQ7hKcudeRsMIkHprZWFkb+Ge2/SwwSlvALrwgHm9BAL3/0QT8m9XBRXu8dc92HEEKzm2Z+7+YmibuOmrQOmoyYngEUkwbLGd/kzRCFQTH1oxa5B4GMslCQLL6Hqz03UmOyviryV39U8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sjydQO5r; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sjydQO5r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B2CCC43390;
	Wed, 21 Feb 2024 13:58:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708523929;
	bh=OyMAS3JEWztgmpJq2G8uVLhawsGVp9xEmglmU6jrBY8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sjydQO5ronEYAz0A6MUGdqrIH4BvpsQw9xf+If8jHVHGvbrhRm5mqMwq2ovE+h/Fc
	 2FO9TfwI7AOjp9c2HiQCSrcoYEEnWRtR0hMZE7Yj53aFzAykIxNHXLeNSUXOQRZ21+
	 8TrYTvSHSAJsZaRaveDzj6NW5GtGnZ5hRomBmTJ4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+4a4f1eba14eb5c3417d1@syzkaller.appspotmail.com,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Anand Jain <anand.jain@oracle.com>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 5.10 064/379] btrfs: dont warn if discard range is not aligned to sector
Date: Wed, 21 Feb 2024 14:04:03 +0100
Message-ID: <20240221125956.805927686@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125954.917878865@linuxfoundation.org>
References: <20240221125954.917878865@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Sterba <dsterba@suse.com>

commit a208b3f132b48e1f94f620024e66fea635925877 upstream.

There's a warning in btrfs_issue_discard() when the range is not aligned
to 512 bytes, originally added in 4d89d377bbb0 ("btrfs:
btrfs_issue_discard ensure offset/length are aligned to sector
boundaries"). We can't do sub-sector writes anyway so the adjustment is
the only thing that we can do and the warning is unnecessary.

CC: stable@vger.kernel.org # 4.19+
Reported-by: syzbot+4a4f1eba14eb5c3417d1@syzkaller.appspotmail.com
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Reviewed-by: Anand Jain <anand.jain@oracle.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/extent-tree.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -1202,7 +1202,8 @@ static int btrfs_issue_discard(struct bl
 	u64 bytes_left, end;
 	u64 aligned_start = ALIGN(start, 1 << 9);
 
-	if (WARN_ON(start != aligned_start)) {
+	/* Adjust the range to be aligned to 512B sectors if necessary. */
+	if (start != aligned_start) {
 		len -= aligned_start - start;
 		len = round_down(len, 1 << 9);
 		start = aligned_start;


