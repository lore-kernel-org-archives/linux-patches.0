Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795704688;
	b=RsfuRawOnf1Qf54Bmv9BWklCfMxRJjppZZFmaKy5YzxvfXjeU+flrXKINcftqz9bDhBd
	 C6dWcfZD0AAGSLZ93M8dJeagdu/i2kKP8UwRpt5R/3I1DQf/glTOsWCHha6HdbKkiyxKt
	 Hzm8L6h8rRtCNpbM2lBIZhD9mMffJ6voDjOhlv/6NrMHiIrVZ4NzK/JolZFrxUWSxK8Ni
	 nD+L7N18SGTnzQ15RTjFIII42jwaTYKmvAzHgRBrHTwOdGMHGtdnSIoyBGYxH2JPZlEUi
	 SaLNnYI0BfGx0OFH7mGZmfUzDtfc60lKctUtKL2C6Jcmgmvc+FlHiCKf69QVvWAvB4A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795704688;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Epz4Zntb6QK1MwPmkZyyaK+3ZgbiJPiJ795n8fzG8L4=;
	b=N1VfRmM7hriMnolz0QCxKkJoy88nOsBbMInsYXdBREzJtan/bJ9WNF2XirHBDndOdRX/
	 BlIEVdj8S1LJODK+DL8EZgsk7YeSnCVxc12+VC1VxdtDPbUbmoQbu16l57DXfzgQBjZ/C
	 168qlR9tHekSvUe7N1Yi8qH02MKE8+Gq5aZ/P8GeeVEzNMcIizQCWblokII1STdC1trra
	 qJqThbL4K5a6/lAwvfueZOmo2GP6M9391nQb4dX+81T65Uqe+J9GEBnpMNy0PjSMQ4OVF
	 WkHh8TZtdyax/ybgIamIPeNmeVygeDbPTNwXg8zG1GyiABJskWKKgyWUeG5cIZ9FX7Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hT8FtdXa;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D773606A31C;
	Thu, 26 Nov 2026 14:51:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hT8FtdXa
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C66681F000C4;
	Thu, 26 Nov 2026 14:51:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795704688;
	bh=Epz4Zntb6QK1MwPmkZyyaK+3ZgbiJPiJ795n8fzG8L4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hT8FtdXaH2syaCYUEUXh1YZxADek+xHxRubK9FB6l7S4ThvEj3UNgOQQBwYVzo6iH
	 6ZM4nTOGzUkvz4Ow1vsIe0LJlm17PLU3h9NIRIszzC3GPoOCYpQf34hpuQ4BBL0zVx
	 g7WYtRndpY41eWlfrRfj2iDvPKyrqgwThLG9fRZs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 5.10 210/265] dm-cache: fix ending a cursor that never began
Date: Thu, 26 Nov 2026 15:39:00 +0100
Message-ID: <20261126143619.915541899@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126143605.076581697@linuxfoundation.org>
References: <20261126143605.076581697@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mikulas Patocka <mpatocka@redhat.com>

commit 421420758be348cb90715bfaa26e1211a12ff1d0 upstream.

If dm_bitset_cursor_begin fails, dm_array_cursor_end(&cmd->hint_cursor)
is called. However, cmd->hint_cursor was only initialized if the variable
hints_valid is true. Thus, we must also destroy hint_cursor only if
hints_valid is true.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Assisted-by: Claude:claude-opus-5
Cc: stable@vger.kernel.org
Fixes: 629d0a8a1a10 ("dm cache metadata: add "metadata2" feature")
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm-cache-metadata.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/md/dm-cache-metadata.c
+++ b/drivers/md/dm-cache-metadata.c
@@ -1444,7 +1444,8 @@ static int __load_mappings(struct dm_cac
 					   from_cblock(cmd->cache_blocks),
 					   &cmd->dirty_cursor);
 		if (r) {
-			dm_array_cursor_end(&cmd->hint_cursor);
+			if (hints_valid)
+				dm_array_cursor_end(&cmd->hint_cursor);
 			dm_array_cursor_end(&cmd->mapping_cursor);
 			return r;
 		}


