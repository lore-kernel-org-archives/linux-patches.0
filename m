Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1647D289373;
	Wed, 23 Apr 2025 15:08:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745420937; cv=none; b=VlQe6O15mLnrGU70/xCMnN5/7QMWavKCmUkSvWdf1M4vQsOhbav+rwbbyTo8faK9y8dh3Cuj370Chp8CqdYfvBiIsYJwGSke0WveCpMhIOonzpP5ajBaIwzNBwK47h5pFIU8FpUaJfDTouuNKhJ9SaEv+ozTCoDWdj4kBdjk/u8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745420937; c=relaxed/simple;
	bh=LYPegRUS9DgwL1xp58swyqk3g7yfaBIEHorz1GjmbWQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=B4Ky9AdAvXSFXUhBi9ZrvAGzcKfIi0ISe5W8gIeB/IJvJQkjl8cmTR9g1/RKIcZBw9+3UnLx4g4V2rv+sJWyJyDaxb563cB/+YbfqBxbTEIw30QMUPwKF/oKqKX1BbGGB7QzPd0FdZ73t7hyUF/bAZjPCKaJJG8kbG84BIRjQ/4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dKoAzxrQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dKoAzxrQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BC90C4CEE2;
	Wed, 23 Apr 2025 15:08:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745420937;
	bh=LYPegRUS9DgwL1xp58swyqk3g7yfaBIEHorz1GjmbWQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dKoAzxrQsubA0OnSjPd69svhdsv1THAO2IrYAS0t6j1XZLOYZGILhkV5QlU7Rpj5z
	 F6nPf4eF7lakt3EpE4fwScdmlUu82dv4AV4gXzhhziVAQLgN2IvMTZakHymUnuQi8h
	 8p9NPoR4BBFW+P14bo0gSAqaOLiHnlcVeyktpBI0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>,
	Jan Kara <jack@suse.cz>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.14 137/241] loop: LOOP_SET_FD: send uevents for partitions
Date: Wed, 23 Apr 2025 16:43:21 +0200
Message-ID: <20250423142626.158887394@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142620.525425242@linuxfoundation.org>
References: <20250423142620.525425242@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Weißschuh <thomas.weissschuh@linutronix.de>

commit 0dba7a05b9e47d8b546399117b0ddf2426dc6042 upstream.

Remove the suppression of the uevents before scanning for partitions.
The partitions inherit their suppression settings from their parent device,
which lead to the uevents being dropped.

This is similar to the same changes for LOOP_CONFIGURE done in
commit bb430b694226 ("loop: LOOP_CONFIGURE: send uevents for partitions").

Fixes: 498ef5c777d9 ("loop: suppress uevents while reconfiguring the device")
Cc: stable@vger.kernel.org
Signed-off-by: Thomas Weißschuh <thomas.weissschuh@linutronix.de>
Reviewed-by: Jan Kara <jack@suse.cz>
Link: https://lore.kernel.org/r/20250415-loop-uevent-changed-v3-1-60ff69ac6088@linutronix.de
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/block/loop.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -572,12 +572,12 @@ static int loop_change_fd(struct loop_de
 	 * dependency.
 	 */
 	fput(old_file);
+	dev_set_uevent_suppress(disk_to_dev(lo->lo_disk), 0);
 	if (partscan)
 		loop_reread_partitions(lo);
 
 	error = 0;
 done:
-	dev_set_uevent_suppress(disk_to_dev(lo->lo_disk), 0);
 	kobject_uevent(&disk_to_dev(lo->lo_disk)->kobj, KOBJ_CHANGE);
 	return error;
 
@@ -585,6 +585,7 @@ out_err:
 	loop_global_unlock(lo, is_loop);
 out_putf:
 	fput(file);
+	dev_set_uevent_suppress(disk_to_dev(lo->lo_disk), 0);
 	goto done;
 }
 


