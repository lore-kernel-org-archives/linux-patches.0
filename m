Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 728B2250C0C;
	Tue, 29 Apr 2025 17:48:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745948930; cv=none; b=d1o0sfx6eapT4muiIvq2anRhUCnLotuNVoaeo/nHq36xTdYrf7owM2sAuL9vjHW4liZdwjhtR/oi0/WoCZD5c0nMkN2faaNjZUZ8Eua9BlqwvWkkye1GUJCv0eFkSQbxADAEk8h57r26uM/WMt4wNIwpe/SocIZC4ei65hKVq40=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745948930; c=relaxed/simple;
	bh=5QgWuHkr7CidkNeQPKi+k+5++pZWOz3Uqq1TvBZJ1EM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Hmbg7d1wkPotuR7MBlJhpyvpoIzWlM/rAJa5wrwMXW9a4aj5WzGpNqPsNe9K6fnDHnoMXyGmjUuNydbcXxwba49j8c1kbNILvDpcszBNggJdT4xQPKVXcLY8vfWgP7SKVtQKr+hlL6vcCxD55vO+1z8kbS+0GR1Og6BF78YFcuo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PX9a5Jxh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PX9a5Jxh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EC39C4CEE3;
	Tue, 29 Apr 2025 17:48:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745948929;
	bh=5QgWuHkr7CidkNeQPKi+k+5++pZWOz3Uqq1TvBZJ1EM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PX9a5JxhU4VAXyzKMDFtzpO4CD6dTKxvN3S5oB6ZDkDdzdjDXY+KOGgR5g8a4XWFN
	 zNaCRAYk0DsWQdXYE+PnWwVsxRz5SJT40KgmbOORYm7mUvbE2z0vE4WRsQQJ1dwlZY
	 Ejls/36JOa78AmHTkzQ2vENTmwHRRBoogudeVHxA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>,
	Jan Kara <jack@suse.cz>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.15 168/373] loop: LOOP_SET_FD: send uevents for partitions
Date: Tue, 29 Apr 2025 18:40:45 +0200
Message-ID: <20250429161130.084941522@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161123.119104857@linuxfoundation.org>
References: <20250429161123.119104857@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -792,12 +792,12 @@ static int loop_change_fd(struct loop_de
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
 
@@ -805,6 +805,7 @@ out_err:
 	loop_global_unlock(lo, is_loop);
 out_putf:
 	fput(file);
+	dev_set_uevent_suppress(disk_to_dev(lo->lo_disk), 0);
 	goto done;
 }
 


