Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADE842FE59C;
	Tue,  6 Jan 2026 17:35:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767720913; cv=none; b=FtapnkA53jB3QXXy2/ghQMoOwa/lmK8yDFv4Y6E4zPcSGXilNXSgf5q9g9eAL9dVpZcr/AlOP9QnoYv2BujI8Upjw9yCtlpe534flENMFcs+x9zzaXgzE0VjlgglV9zv/p/4lAhQnDtiZXzs7mhuv8uXMDxukCkMclN1qgMCULI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767720913; c=relaxed/simple;
	bh=Ii8FH9nWUBvu/nfCFBFcCo5AoLWxlIsnN5KqQJu0xCI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fk/UU60VUSPvUhTIbj0MYg5Ejp8h4yu1qz2ggRUbbSQbcsfLi3ASX8NNoDuX7D0nAcZ34OIDI79lkWVVGbbOf6iQL1HgZe+YaagE8tIf+tK0tsUSZ9a2i87iL8R/+nTDvjvlMb0Q9adQTKYZ82bgOvvmL2e/CYKgAjoiGWAEpTE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tEnC4HC2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tEnC4HC2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3221C116C6;
	Tue,  6 Jan 2026 17:35:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767720913;
	bh=Ii8FH9nWUBvu/nfCFBFcCo5AoLWxlIsnN5KqQJu0xCI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tEnC4HC2iMj2t1VK2giU2l5YQXwNBQ8rc5YyuEB0mVj1oXnCBMNF4NulBRpiF/A3I
	 daYpDfU4sMDYvDtmAwBodGbFXFKhv5KvFNGXP61c3mUuF2+1RG/oNIlz36JzZnrwsT
	 IVZAbWMTugREYi/YRTXK0e9QeXUkShqBoCcuMf3o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damien Le Moal <dlemoal@kernel.org>,
	Niklas Cassel <cassel@kernel.org>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.12 378/567] block: Clear BLK_ZONE_WPLUG_PLUGGED when aborting plugged BIOs
Date: Tue,  6 Jan 2026 18:02:40 +0100
Message-ID: <20260106170505.325025074@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170451.332875001@linuxfoundation.org>
References: <20260106170451.332875001@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Damien Le Moal <dlemoal@kernel.org>

commit 552c1149af7ac0cffab6fccd13feeaf816dd1f53 upstream.

Commit fe0418eb9bd6 ("block: Prevent potential deadlocks in zone write
plug error recovery") added a WARN check in disk_put_zone_wplug() to
verify that when the last reference to a zone write plug is dropped,
this zone write plug does not have the BLK_ZONE_WPLUG_PLUGGED flag set,
that is, that it is not plugged.

However, the function disk_zone_wplug_abort(), which is called for zone
reset and zone finish operations, does not clear this flag after
emptying a zone write plug BIO list. This can result in the
disk_put_zone_wplug() warning to trigger if the user (erroneously as
that is bad pratcice) issues zone reset or zone finish operations while
the target zone still has plugged BIOs.

Modify disk_put_zone_wplug() to clear the BLK_ZONE_WPLUG_PLUGGED flag.
And while at it, also add a lockdep annotation to ensure that this
function is called with the zone write plug spinlock held.

Fixes: fe0418eb9bd6 ("block: Prevent potential deadlocks in zone write plug error recovery")
Cc: stable@vger.kernel.org
Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Niklas Cassel <cassel@kernel.org>
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 block/blk-zoned.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/block/blk-zoned.c
+++ b/block/blk-zoned.c
@@ -621,6 +621,8 @@ static void disk_zone_wplug_abort(struct
 {
 	struct bio *bio;
 
+	lockdep_assert_held(&zwplug->lock);
+
 	if (bio_list_empty(&zwplug->bio_list))
 		return;
 
@@ -628,6 +630,8 @@ static void disk_zone_wplug_abort(struct
 			    zwplug->disk->disk_name, zwplug->zone_no);
 	while ((bio = bio_list_pop(&zwplug->bio_list)))
 		blk_zone_wplug_bio_io_error(zwplug, bio);
+
+	zwplug->flags &= ~BLK_ZONE_WPLUG_PLUGGED;
 }
 
 /*


