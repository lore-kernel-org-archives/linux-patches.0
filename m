Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2FAF81751;
	Wed,  7 Aug 2024 15:10:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723043456; cv=none; b=shtFLDQPVnTUEr6Of3NbI49m1u4LwhGV9euiPRLkYN210hMP1T4PvJCe9gLCE4rEQ84hrmiTgSYjf1IBPQH1F/UZr+VGvx9Y8v05VtS9Z16HLkamQw8jTWXEf2rHnhzho2u3aiGPratrJjnHnub4rTXoLs7UhfDNx3r+0CTinik=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723043456; c=relaxed/simple;
	bh=D4rmtA902DIbPR0PvGneWkcNPXK21tNDzLnOqdAq7nc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KSuxtJSu/ubK4dRcHaVaG56LzrYm3/hBqSpIZU/+GLDsZzsWxC9UHxgxExJH8PBgyk0mbTfuM083wXsomDXo0JIA2l+uDuxQOmNh7DuRbCxiCCoNRuDp7Wjk2XNLa576r6ZKjHTLCv7C+6FAfUazS/TLyB0awpSSs09qY8qaXMc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PHrVWrzw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PHrVWrzw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74664C32781;
	Wed,  7 Aug 2024 15:10:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723043455;
	bh=D4rmtA902DIbPR0PvGneWkcNPXK21tNDzLnOqdAq7nc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PHrVWrzwcOHTFKdP7Oq9Nd6aFXIZl9qMp/F8xz1Q6YjxwC77iJl57Wc1rOWAIGc7s
	 pv/R4rtOOHWGD8EG5OfJqmwpZidNchcyQoVLOiRVnUSoeRqooZ6ibs/a6Q9dAstNrj
	 Qhk1zfXuOSqG4gHHki9uF51mj7o649bl7Zz7a3uA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Naohiro Aota <naohiro.aota@wdc.com>,
	Boris Burkov <boris@bur.io>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 6.6 098/121] btrfs: do not subtract delalloc from avail bytes
Date: Wed,  7 Aug 2024 17:00:30 +0200
Message-ID: <20240807150022.608295479@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240807150019.412911622@linuxfoundation.org>
References: <20240807150019.412911622@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Naohiro Aota <naohiro.aota@wdc.com>

commit d89c285d28491d8f10534c262ac9e6bdcbe1b4d2 upstream.

The block group's avail bytes printed when dumping a space info subtract
the delalloc_bytes. However, as shown in btrfs_add_reserved_bytes() and
btrfs_free_reserved_bytes(), it is added or subtracted along with
"reserved" for the delalloc case, which means the "delalloc_bytes" is a
part of the "reserved" bytes. So, excluding it to calculate the avail space
counts delalloc_bytes twice, which can lead to an invalid result.

Fixes: e50b122b832b ("btrfs: print available space for a block group when dumping a space info")
CC: stable@vger.kernel.org # 6.6+
Signed-off-by: Naohiro Aota <naohiro.aota@wdc.com>
Reviewed-by: Boris Burkov <boris@bur.io>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/space-info.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/fs/btrfs/space-info.c
+++ b/fs/btrfs/space-info.c
@@ -524,8 +524,7 @@ again:
 
 		spin_lock(&cache->lock);
 		avail = cache->length - cache->used - cache->pinned -
-			cache->reserved - cache->delalloc_bytes -
-			cache->bytes_super - cache->zone_unusable;
+			cache->reserved - cache->bytes_super - cache->zone_unusable;
 		btrfs_info(fs_info,
 "block group %llu has %llu bytes, %llu used %llu pinned %llu reserved %llu delalloc %llu super %llu zone_unusable (%llu bytes available) %s",
 			   cache->start, cache->length, cache->used, cache->pinned,


