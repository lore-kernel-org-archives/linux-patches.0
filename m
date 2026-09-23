Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 062844EC64E;
	Wed, 23 Sep 2026 14:25:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790173553; cv=none; b=fgLjB437E6+jtHfiW+WEPiH733mbaVYsbxkIueI6UxjIsPlIGksDiMxMo5ZsfnDQqja87IeYoXzObRol+vLPEkdi+57fZymtakeW6JdkELcE4meaKVyGvhW09Ja3g28IVK3zEZFUL3C7TZ4DdV1BxrxXjDYsgjCS7NBGlsLrF1A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790173553; c=relaxed/simple;
	bh=TT72R7I4jq96EMEP52uEEey6kkOUbXv9OrTKsQTbRxk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eXkcmVlL6MCfHxspOt+Icty8GOdBrzaI/toSK8yBr/ss//V9/tmUrSQi3LrO67zxWIIeVw7F6Wmmr4L4ZBy9z0OHHnjV6nor70XNOjnxeqMqA437zze6plGkNNXsb13hfFQpugzPjAR39XGHnkJbg+DU9/3tZCqPjECL410kYwM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qXm8DdoG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qXm8DdoG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D1D81F000FF;
	Wed, 23 Sep 2026 14:25:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790173551;
	bh=DhXswKBCoKrwLJ6u6itmVTAUk53syiyqNZ6Fbq9MpD4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qXm8DdoGDOrMSvi9kwFbmGiqK8qgvg/s6tihdH71pArrg9sBjhSVFhI67yKv/nGC3
	 57JJ90u99ZqpkijapAhgyDnpUstTzcJ5AfKq8HGgiAIUFrc9N2D3YLp8fxJpj4MRx+
	 PjCewM25ZZ8Ixc9FZ5mIOadQrlL5dem5eKysu5Zc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Hongling Zeng <zenghongling@kylinos.cn>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 7.2 282/438] btrfs: take commit root semaphore when iterating in mark_block_group_to_copy()
Date: Wed, 23 Sep 2026 16:05:03 +0200
Message-ID: <20260923140652.083453986@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140644.756254324@linuxfoundation.org>
References: <20260923140644.756254324@linuxfoundation.org>
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

From: Hongling Zeng <zenghongling@kylinos.cn>

commit 0594e3423f4ba3137c734371169491f9a98e9af4 upstream.

mark_block_group_to_copy() iterates over the commit root with
skip_locking=true. A concurrent transaction commit can swap and free
the commit root during iteration, causing use-after-free when
accessing extent buffers.

Fix it by using path->need_commit_sem to protect the commit root search.

Fixes: 78ce9fc269af ("btrfs: zoned: mark block groups to copy for device-replace")
CC: stable@vger.kernel.org
Assisted-by: Codex:gpt-5.5
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Signed-off-by: Hongling Zeng <zenghongling@kylinos.cn>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/dev-replace.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/btrfs/dev-replace.c
+++ b/fs/btrfs/dev-replace.c
@@ -493,6 +493,7 @@ static int mark_block_group_to_copy(stru
 	path->reada = READA_FORWARD;
 	path->search_commit_root = true;
 	path->skip_locking = true;
+	path->need_commit_sem = true;
 
 	key.objectid = src_dev->devid;
 	key.type = BTRFS_DEV_EXTENT_KEY;


