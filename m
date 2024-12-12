Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9854823FD1D;
	Thu, 12 Dec 2024 16:15:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734020116; cv=none; b=MQYmxYtsN5Lk+XbuBkuj/nbhDlEovmxp2VjiNhR3CIUtWJp4getuNm4WW7qY6wDJH85uLVHuXfXSQHcF8lbrB0Fv0/WireZbIcA5gHVjKYPQ4Shet39sjyU+jhrFJGbiG5Lx2+axKdqQ9ovImgTnB81wcXdLAS2M9PYkQgCgkSA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734020116; c=relaxed/simple;
	bh=fa9cYrVdgTMiCuoTpzAaZGdV06ocT+nR2VI7U2F23Us=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=taTHulror/VWJ4t1CzQUkgeJ4jCXKSw9itjAv3ITG56kX3NX1kLI4xp9gaLuBvgmxg8JIqkKJsSdsFOh/36cDTKOUxg+QoZRCCwIb7aozOnzhyT+lwg90sT/6+5AeTyqboO9A/iOnhwKb2KHN7Ne1su1HPp8RxD+BuSwICOpEnw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aHv7coAA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aHv7coAA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 758FEC4CECE;
	Thu, 12 Dec 2024 16:15:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734020116;
	bh=fa9cYrVdgTMiCuoTpzAaZGdV06ocT+nR2VI7U2F23Us=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aHv7coAA0Md6RpywmoEW1ygFhbr4cF0nRVvpx9FxFmqR6GPmzTYlSfbEUhRkfKA6y
	 hkyKFZMQ5vAx0kWgyWbxULQIVCbKoNr/Na3COxcq1JlReKWkwaIC10ihx/JzE8wpQV
	 Y7xURGHPGO1ghCfcSMZPQ3836a+NoAO7NDpMw6/E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+01218003be74b5e1213a@syzkaller.appspotmail.com,
	Yuezhang Mo <Yuezhang.Mo@sony.com>,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 6.1 381/772] exfat: fix uninit-value in __exfat_get_dentry_set
Date: Thu, 12 Dec 2024 15:55:26 +0100
Message-ID: <20241212144405.646945701@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -364,6 +364,7 @@ static int exfat_find_empty_entry(struct
 		if (ei->start_clu == EXFAT_EOF_CLUSTER) {
 			ei->start_clu = clu.dir;
 			p_dir->dir = clu.dir;
+			hint_femp.eidx = 0;
 		}
 
 		/* append to the FAT chain */


