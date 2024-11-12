Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 639C222DAAF;
	Tue, 12 Nov 2024 10:38:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731407915; cv=none; b=SPiwNEV2ortxHE2C0B8bWwghoNpL0a7ij0cF4vVfqOBYofrkFrda82mSZXLd4ooPuT0/wNgmGe+F89sKDVLarL7MZAHYxKGqrDLEsfcsJxWG7ctU+46JGdgr3FeoSrqGg7ksF4vTfex8Ht7HleSlCOyd6UyjF4eIsw9zmsQlXzc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731407915; c=relaxed/simple;
	bh=PoMSSZQc3HEgCS9mXz2Em0s+H9nNvwW2RP02zOII+Ew=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TsISQlUShjXTODoPCjH14GGe7tGKlq8wBGTRIu8a2Vjia0OpK8KI00E/x+vKuuElzH7pgNMX93T8cquIc5WFH50hR3bOcFN7WZVdFgd/ax7EOA7GaG9yb/vEybPBr58HPZeci3hoHVHFeFYNtmbteBxEJOKYTdQcVWBfKrdaf4w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TL4prutQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TL4prutQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C50EEC4CED6;
	Tue, 12 Nov 2024 10:38:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731407915;
	bh=PoMSSZQc3HEgCS9mXz2Em0s+H9nNvwW2RP02zOII+Ew=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TL4prutQjIE3kZZgzFrHEFUCavNxXJD4KZRDwtyqDn3Esb/Zm687hqA0RxmvdpNnw
	 EwnRyJRw79AaWyQMd8ujfsYiwZgO3ziSZkAlsP3TUSqYs6Sk9OiTDc1AldXzc3oMrZ
	 WCr0o/RPWqVmRM/jZ3Lb+Kw8oChDAChx3GU7Wnhk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 6.6 097/119] btrfs: reinitialize delayed ref list after deleting it from the list
Date: Tue, 12 Nov 2024 11:21:45 +0100
Message-ID: <20241112101852.426717942@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241112101848.708153352@linuxfoundation.org>
References: <20241112101848.708153352@linuxfoundation.org>
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

From: Filipe Manana <fdmanana@suse.com>

commit c9a75ec45f1111ef530ab186c2a7684d0a0c9245 upstream.

At insert_delayed_ref() if we need to update the action of an existing
ref to BTRFS_DROP_DELAYED_REF, we delete the ref from its ref head's
ref_add_list using list_del(), which leaves the ref's add_list member
not reinitialized, as list_del() sets the next and prev members of the
list to LIST_POISON1 and LIST_POISON2, respectively.

If later we end up calling drop_delayed_ref() against the ref, which can
happen during merging or when destroying delayed refs due to a transaction
abort, we can trigger a crash since at drop_delayed_ref() we call
list_empty() against the ref's add_list, which returns false since
the list was not reinitialized after the list_del() and as a consequence
we call list_del() again at drop_delayed_ref(). This results in an
invalid list access since the next and prev members are set to poison
pointers, resulting in a splat if CONFIG_LIST_HARDENED and
CONFIG_DEBUG_LIST are set or invalid poison pointer dereferences
otherwise.

So fix this by deleting from the list with list_del_init() instead.

Fixes: 1d57ee941692 ("btrfs: improve delayed refs iterations")
CC: stable@vger.kernel.org # 4.19+
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/delayed-ref.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/btrfs/delayed-ref.c
+++ b/fs/btrfs/delayed-ref.c
@@ -615,7 +615,7 @@ static bool insert_delayed_ref(struct bt
 					      &href->ref_add_list);
 			else if (ref->action == BTRFS_DROP_DELAYED_REF) {
 				ASSERT(!list_empty(&exist->add_list));
-				list_del(&exist->add_list);
+				list_del_init(&exist->add_list);
 			} else {
 				ASSERT(0);
 			}


