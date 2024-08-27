Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E56E31C578B;
	Tue, 27 Aug 2024 14:44:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724769852; cv=none; b=YTyMJ4R5jJfjkOVSar6254M4iJZ5YxeIBYkobuiHNjN/1MArS4UKPfvt1MQPVx2HGHF+g+S02PJoLkm/DsQI9mZI4uegWrRPB+FY86ViX+xvvL/uIStMNnVJOxr0zGgojnxqAUsShDC15RXV7yLV89zoD8irZf4kb/kluiPmdEI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724769852; c=relaxed/simple;
	bh=bgfAZFz7h6AHe9aVUgfTF8er2JLIntSH4s7ckMq640Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JlCEbgQxze5VnvKzT8EaIKx7m4vr8EgtryxGxZJgS1YVxxblqMWNbvq8uXcLTVhRIx6FTAT42QimReYvVygNM4Nx51FxPJID4WY5vT9l8kOZjPigc8K2ivD8axeKR2GoobixI07EqyLRcc6WQaUUP8GysuwqOA4HULUmM22NHg4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=A4loMoEh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="A4loMoEh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01A81C6105D;
	Tue, 27 Aug 2024 14:44:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724769851;
	bh=bgfAZFz7h6AHe9aVUgfTF8er2JLIntSH4s7ckMq640Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=A4loMoEhpQipaaGgfM4qdxCnb8vM1L7bwrtgFaZbO6YcS+fMHQLZIPowgr43Sju2y
	 F7bwtEZ3r27j/PSQb/SjUjnuvPXv/a6Tg5HlLxZ5IyhFoaBwTCxgf7Qd5sNg+sozki
	 FLSWp8ROr5jxJAYyTPbl0LAsPpHcIlgNYiyaWBS8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikulas Patocka <mpatocka@redhat.com>,
	Khazhismel Kumykov <khazhy@google.com>
Subject: [PATCH 6.6 023/341] dm resume: dont return EINVAL when signalled
Date: Tue, 27 Aug 2024 16:34:14 +0200
Message-ID: <20240827143844.290656858@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143843.399359062@linuxfoundation.org>
References: <20240827143843.399359062@linuxfoundation.org>
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

From: Khazhismel Kumykov <khazhy@google.com>

commit 7a636b4f03af9d541205f69e373672e7b2b60a8a upstream.

If the dm_resume method is called on a device that is not suspended, the
method will suspend the device briefly, before resuming it (so that the
table will be swapped).

However, there was a bug that the return value of dm_suspended_md was not
checked. dm_suspended_md may return an error when it is interrupted by a
signal. In this case, do_resume would call dm_swap_table, which would
return -EINVAL.

This commit fixes the logic, so that error returned by dm_suspend is
checked and the resume operation is undone.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Khazhismel Kumykov <khazhy@google.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm-ioctl.c |   22 ++++++++++++++++++++--
 1 file changed, 20 insertions(+), 2 deletions(-)

--- a/drivers/md/dm-ioctl.c
+++ b/drivers/md/dm-ioctl.c
@@ -1181,8 +1181,26 @@ static int do_resume(struct dm_ioctl *pa
 			suspend_flags &= ~DM_SUSPEND_LOCKFS_FLAG;
 		if (param->flags & DM_NOFLUSH_FLAG)
 			suspend_flags |= DM_SUSPEND_NOFLUSH_FLAG;
-		if (!dm_suspended_md(md))
-			dm_suspend(md, suspend_flags);
+		if (!dm_suspended_md(md)) {
+			r = dm_suspend(md, suspend_flags);
+			if (r) {
+				down_write(&_hash_lock);
+				hc = dm_get_mdptr(md);
+				if (hc && !hc->new_map) {
+					hc->new_map = new_map;
+					new_map = NULL;
+				} else {
+					r = -ENXIO;
+				}
+				up_write(&_hash_lock);
+				if (new_map) {
+					dm_sync_table(md);
+					dm_table_destroy(new_map);
+				}
+				dm_put(md);
+				return r;
+			}
+		}
 
 		old_size = dm_get_size(md);
 		old_map = dm_swap_table(md, new_map);


