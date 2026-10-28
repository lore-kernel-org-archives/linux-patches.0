Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793210644;
	b=Nl8VjI0xBIwBsmn0tEgXgYeeXWqd2RWb2JUPO+MzMxeZXRYc20wUmAL1038xHNXKoAbC
	 a7a19Klz4xT5UDjSTru2UsjkSko6YNCsI/jAWb5AtU3jcn0wTKildqpZWjyxKevEpAG9+
	 0tOc6Xz2I0P1uVIpM7aukMggNh7gV7Oh/EfvFxKEYb2MYEe5DRR8y+4dftXMBU5oUamDb
	 5ZKae8AYhS+gZ5CZYmqbZMPhPzK6pCikhE2buJc3TvULshybu6/y4zdrTkpouuBDnDsGE
	 ZA7XEmUGWghiPoLYxFBYjcYmk8DgFyy5duMB9WlbUb+DmFNyE4PABQ0osuo6DRS7KVw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793210644;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=LxUnQjKI/i2UF4CbTpzrrYUCkGQcB+Xn/cHadg2KQFs=;
	b=zOSPJUZQglaV7z3LMvm2rgTOUN5vnKVldKI80iD3uyFnNDgzX8MJ6Gan6mkHJHs7YLgE
	 jU9fLXX62MD9KKW/ltz1Ok2zCnpQ5QdbojBT4yOerUjjdHMGR55tEUqqAGKPwPdYBPIr/
	 vvSzW7cZlLqnDU946Tdo8Kaag0npIJgTDi2/IDFLGugAmeNnfra5iYGwEQy6KPNki2ccV
	 XnHtg0coSHSW4Mv0S8vrH7RbEMnoX/9LfyIovrjJ1wYLKITn9BO0Yhh67AYSuYhJ+RfQ/
	 LwVCl8L1b5YsrkfkzrgFeFF3j6N1i8/yitwVulpL8L6/s/wsQp20czpDocHTggjMYbQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=z1Pex3+P;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFFEB606A31A;
	Wed, 28 Oct 2026 18:04:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=z1Pex3+P
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C28D1F01825;
	Wed, 28 Oct 2026 18:04:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793210643;
	bh=LxUnQjKI/i2UF4CbTpzrrYUCkGQcB+Xn/cHadg2KQFs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=z1Pex3+PA4PaVXcYvoOE3XlHdZ5I+doy1ks9swOar8oI3q76E0xCECtpenIGfXW6y
	 xnujj4YcGypoOmZg3WDyMF2xdzMjEnPla1ft93vVnmW8HN9aj44h5z5FPOjLVeil+k
	 mdXJikB63EvZcOkZY4Pczvbef1AyhVZRgNlDL7u8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Hongling Zeng <zenghongling@kylinos.cn>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 099/571] btrfs: take commit root semaphore when iterating in mark_block_group_to_copy()
Date: Wed, 28 Oct 2026 17:54:06 +0100
Message-ID: <20261028170010.371853328@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hongling Zeng <zenghongling@kylinos.cn>

[ Upstream commit 0594e3423f4ba3137c734371169491f9a98e9af4 ]

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
[ changed path->need_commit_sem assignment from true to 1 to match the older unsigned bitfield representation. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/dev-replace.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/btrfs/dev-replace.c b/fs/btrfs/dev-replace.c
index aa03f2bbcc11c..d19260ccb1c34 100644
--- a/fs/btrfs/dev-replace.c
+++ b/fs/btrfs/dev-replace.c
@@ -516,6 +516,7 @@ static int mark_block_group_to_copy(struct btrfs_fs_info *fs_info,
 	path->reada = READA_FORWARD;
 	path->search_commit_root = 1;
 	path->skip_locking = 1;
+	path->need_commit_sem = 1;
 
 	key.objectid = src_dev->devid;
 	key.type = BTRFS_DEV_EXTENT_KEY;
-- 
2.53.0



