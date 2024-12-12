Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A64E211493;
	Thu, 12 Dec 2024 17:25:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734024322; cv=none; b=hZLikkD1PuL9zI481GwryiovuKtTQKgeqLoVKbPXGoLKkKhfN++oXK0IU5etvPCg513D4c0L9dZ7ewq4B8npog/CLGl1p8stXWSBOqAO6uRSScNEzG1AsDwEZP5yZOpB4YgIBptfLsQoz2PT9B3ErWmJ8+e+A3NNUwgjrH6EUKg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734024322; c=relaxed/simple;
	bh=zvDYt7eTfBvvYMiXmxhaiXipjK1ti5PoW8yWPFwaKbs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hBgnEYaPyIByxadamNZjsj4PoFOFavr9zzvzPGCC06P+m3ZZDuCE7uQQNUOfpqOprMzi6QReetUOlb1xb7Kt9fGCqykdeOz/89Mzt66DKaO8QqQ5hM8KuLAtcuKj1pGayYiikz1GF7V3MlTCq3XcsMNKXcQQeqq8pb/WO6Os41k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d6x1aZTS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d6x1aZTS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2E08C4CECE;
	Thu, 12 Dec 2024 17:25:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734024321;
	bh=zvDYt7eTfBvvYMiXmxhaiXipjK1ti5PoW8yWPFwaKbs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d6x1aZTS6TR/Tjdk/ia4UWWcjwv/zhW33LlbSLXLiuWUOcLrOOzUR2gZQ+m8hu25t
	 s7U+m3o+Ho8iwSAMThrV+Cm4cjBkIownjfwef5xYk34C/OvYjRbGBK4bedVJUf85MJ
	 HPO66y/MAR2uFJfwYX6jWmeWLj4MX7EILzdwjcSA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+01218003be74b5e1213a@syzkaller.appspotmail.com,
	Yuezhang Mo <Yuezhang.Mo@sony.com>,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 5.10 258/459] exfat: fix uninit-value in __exfat_get_dentry_set
Date: Thu, 12 Dec 2024 15:59:56 +0100
Message-ID: <20241212144303.789695672@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144253.511169641@linuxfoundation.org>
References: <20241212144253.511169641@linuxfoundation.org>
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

From: Namjae Jeon <linkinjeon@kernel.org>

commit 02dffe9ab092fc4c8800aee68cb7eafd37a980c4 upstream.

There is no check if stream size and start_clu are invalid.
If start_clu is EOF cluster and stream size is 4096, It will
cause uninit value access. because ei->hint_femp.eidx could
be 128(if cluster size is 4K) and wrong hint will allocate
next cluster. and this cluster will be same with the cluster
that is allocated by exfat_extend_valid_size(). The previous
patch will check invalid start_clu, but for clarity, initialize
hint_femp.eidx to zero.

Cc: stable@vger.kernel.org
Reported-by: syzbot+01218003be74b5e1213a@syzkaller.appspotmail.com
Tested-by: syzbot+01218003be74b5e1213a@syzkaller.appspotmail.com
Reviewed-by: Yuezhang Mo <Yuezhang.Mo@sony.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/exfat/namei.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/exfat/namei.c
+++ b/fs/exfat/namei.c
@@ -356,6 +356,7 @@ static int exfat_find_empty_entry(struct
 		if (ei->start_clu == EXFAT_EOF_CLUSTER) {
 			ei->start_clu = clu.dir;
 			p_dir->dir = clu.dir;
+			hint_femp.eidx = 0;
 		}
 
 		/* append to the FAT chain */


