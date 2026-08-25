Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD6A847CC80;
	Tue, 25 Aug 2026 13:30:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787664626; cv=none; b=m7RzOMDc7wHkMwPj7ZmaK5y5GSsQreXGc+KV4WPN+W/mE+xuOEnLhZzqH4kEwUxu9Hz6Ldfo6pCEeD2IGkxJG6AK5zNNIGMSXM3wiqQzzBUP53Ta5v3Mxx7VRQSsAYcgwzkHOK3mNW3g0yQUlbpMEPYwztxzeeZHIgo1Dg8+C/c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787664626; c=relaxed/simple;
	bh=jftf7UPsvNeTxlxWObcPVpp7ih5WyroXDh4rz4WGknc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HqGhHxZBjF1cx8Hi20dyya+5jN13ZW27z3RLpiLi6sbVo4x8YgE8T9Q47hoP3C4+eGASX0aft9F4hcYKpYZ5Y+SJwf8+AgNllL0vGQiRWFL+Elz/LIFZQ3Hnjn3DfH/jalN57vSocR7yLu4UzE3KBSkYsj4gZAcv+lfElKR9YL0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ksfiS+Yl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ksfiS+Yl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E95951F000E9;
	Tue, 25 Aug 2026 13:30:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787664624;
	bh=KI5MJ19KuXVuulN5Vy07DGNSKB687WOrJsNis22aRrw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ksfiS+YlcV97D7VOg2FPLaZ9JJUAQCkfD6KVj05Q4IDsYiyo/ui/xSlknYKYwS6IX
	 +c6QTs/1g3t0z6XgRAKL+PRr8fOulYbEazbVM+MABMz/fC0JNDum3zlCUfrE3xpDUe
	 wLgxZY45k+Qh+C9xxiYNLobGg+g60eMSq74XsJxc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiazi Liu <liujiazi@amazon.com>,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
	Theodore Tso <tytso@mit.edu>
Subject: [PATCH 7.2 31/82] ext4: fix incorrect function call when initializing s_resgid
Date: Tue, 25 Aug 2026 15:25:18 +0200
Message-ID: <20260825132542.729568805@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260825132541.560541185@linuxfoundation.org>
References: <20260825132541.560541185@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiazi Liu <jiazi.liu1984@gmail.com>

commit c87abbab6147dcc5aa1fd8f2a61734d58d8b99ec upstream.

In __ext4_fill_super(), s_resgid is initialized by calling
ext4_get_resuid() instead of ext4_get_resgid(), resulting in the
reserved GID being set to the same value as the reserved UID rather
than the value stored in the superblock.

Fixes: 12c84dd4d308 ("ext4: add support for 32-bit default reserved uid and gid values")
Cc: stable@vger.kernel.org
Signed-off-by: Jiazi Liu <liujiazi@amazon.com>
Reviewed-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
Link: https://patch.msgid.link/20260727104103.28916-1-liujiazi@amazon.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/super.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -5369,7 +5369,7 @@ static int __ext4_fill_super(struct fs_c
 	ext4_set_def_opts(sb, es);
 
 	sbi->s_resuid = make_kuid(&init_user_ns, ext4_get_resuid(es));
-	sbi->s_resgid = make_kgid(&init_user_ns, ext4_get_resuid(es));
+	sbi->s_resgid = make_kgid(&init_user_ns, ext4_get_resgid(es));
 	sbi->s_commit_interval = JBD2_DEFAULT_MAX_COMMIT_AGE * HZ;
 	sbi->s_min_batch_time = EXT4_DEF_MIN_BATCH_TIME;
 	sbi->s_max_batch_time = EXT4_DEF_MAX_BATCH_TIME;


