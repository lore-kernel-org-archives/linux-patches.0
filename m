Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795620319;
	b=XKDUcoMFt9hhtOP/8qataVkwgwe8CFHWpOVLN5oMZNAEft5j84Cm5+8PSAHDmELyvHZi
	 9R86Fn4OSQYU5oA9VNU8yjWq2mJSYkHgGNP2EosewF5L16BbYDW/lDQT4nQTlFZBeymGk
	 R28rSBffWNbt2AfnWpw1KHjFS1iGE0bIRGoMvPdlXYTEmCP0DnOTpjIbhCrUIp2fco5++
	 PXoFhfmM2PT/JM9wQ9qHudFunVvw7BltGsrJ7UTponf2rpvRogPhkKmTGoYKPeMrVl7qO
	 3daiy0GDgeJ12vxM1IEHAu9SeYrk3zX3E9OeeKwZwfLDOUdn1klFcMhLdjZhHRXiS5A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795620319;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=sBWWl/4xJ/VlpSkSDp4bl5feTnJcAZSlD0o/LO9RbwY=;
	b=Zcwy7mwM5LI88YBMIN4ywmlmznWo6msH5MT0SGlKh6K+3l8fr0IB1iyQOti6K/XfjV8t
	 Hujmku4+026mFxzjqta0c9H4DTtahXLYt3DCX6Nku/ORq/o6WXUG9booKxi1WeDqwL+kB
	 yVohUTVZ8Ic4tCLPlyH7vopSiZNscxzMEQIQ6Nwx3kK5OlUdNW45xaBnICbOSi4VHA0Oo
	 LFRGjRYMl3GROHwbg8uuZyPDowwfcknYzQ9aIWWtr9HnOEkL0VdcC/00Zu22aFzF/oh87
	 /Jhyg2w7N0096P+mDMChh+RykvAktsY3fVNzGG8hiHbUlT//sJ8KI9KTSpOVzo6rHcA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2fyloUax;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 318FB606A321;
	Wed, 25 Nov 2026 15:25:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2fyloUax
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F7511F000C0;
	Wed, 25 Nov 2026 15:25:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795620318;
	bh=sBWWl/4xJ/VlpSkSDp4bl5feTnJcAZSlD0o/LO9RbwY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2fyloUaxXsalUePzIFiACgBljdmm289AHJs2p15JHwIPs/pUDY9vS6A+ALyUJHV2R
	 xuMO5UuWaDRWGVV+cF4gpaembqDVEzvGZnZPWhgmqbkKBQ+jdVdmYTFB0dQ8/0qTfr
	 Nai0yleGdm7zKchHKrX3yNgxX8PLeIFwky3/Wg5A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 7.3 0876/1005] dm-cache: fix ending a cursor that never began
Date: Wed, 25 Nov 2026 15:36:54 +0100
Message-ID: <20261125143842.225964982@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1433,7 +1433,8 @@ static int __load_mappings(struct dm_cac
 					   from_cblock(cmd->cache_blocks),
 					   &cmd->dirty_cursor);
 		if (r) {
-			dm_array_cursor_end(&cmd->hint_cursor);
+			if (hints_valid)
+				dm_array_cursor_end(&cmd->hint_cursor);
 			dm_array_cursor_end(&cmd->mapping_cursor);
 			return r;
 		}


