Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BBF728134C;
	Wed, 23 Apr 2025 15:28:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745422107; cv=none; b=QMK15Dgi46WHbB0Gzkt9pIwsY/+db1XY2WShQAO9bLUCoenRpnsiEL6uSt8V2uy6sK7G5fm5AgT/RuCN9CY1PP7K450ZnIZxx/Ol0OIkuvUMQeGnZVlL8r6QyUH0iBRp6DQoz1lLHu2g9Jkl8+YQvAC/2ByZPMh3FwYGS8iWuc8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745422107; c=relaxed/simple;
	bh=UrFTf0StQCCH8X4zeOp0vPn5ZobV2klYsv3KSBOYAZw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lRFr02rBLHEO89Ud47TL5QasLs1fIg+vKAOW8llJQ/dqC1ELRpMfubXWLT0uZxHOVgZu8zmOFMU8/0zZRe87yp6oHey5NaxqMAX5kZlyGYzB5P55zE1wS31I1dvJm7cSq0YUYYwf85bFX0c+ehZFSMOczyhpjN9KzfCOgcO7e+Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=f4JAKzro; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="f4JAKzro"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C97DC4CEE2;
	Wed, 23 Apr 2025 15:28:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745422107;
	bh=UrFTf0StQCCH8X4zeOp0vPn5ZobV2klYsv3KSBOYAZw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=f4JAKzroN4ZA6w7C7gezI5/1l/01uQ3Ll8noTEFaGrVRw71RyBzjw70a/lWJTOxwK
	 iMKQD/ybNYc4L1N88k3+2aRIRHcrw7M7ooc4wgS4UCwIAJQ08ltIe2iXv1oaqzoc5b
	 eU8gtMDa7NakKmucUGMJK8QLXK7LN/WacYoMvGeQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>,
	Jan Kara <jack@suse.cz>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.1 213/291] loop: LOOP_SET_FD: send uevents for partitions
Date: Wed, 23 Apr 2025 16:43:22 +0200
Message-ID: <20250423142633.089296549@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142624.409452181@linuxfoundation.org>
References: <20250423142624.409452181@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -624,12 +624,12 @@ static int loop_change_fd(struct loop_de
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
 
@@ -637,6 +637,7 @@ out_err:
 	loop_global_unlock(lo, is_loop);
 out_putf:
 	fput(file);
+	dev_set_uevent_suppress(disk_to_dev(lo->lo_disk), 0);
 	goto done;
 }
 


