Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B0511D0E06;
	Wed,  2 Oct 2024 14:23:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727879033; cv=none; b=sB+pQ3q+GGBmyHBsA9PeIdLkoASr6tKQRLXwlXJjdeMR9nFMitqtKQRMNKbQZkJKwXayTXdpVvb1O5SY4dKHn8GVC3+jumoLOUT0NZlONoHyNZhxxdzQvkSBRGWdfmQMRnq46hwsBVhUZ6BRsYTmE7Kpqnfy1R+l0/AZiNMH0HA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727879033; c=relaxed/simple;
	bh=daR342MpUYwhea1dJqPH97hmYrFAQY6JEdyD2F43bgY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bG+zrKBSVzR0J4I+I7XylwIcusn2SdyPMuxdB0BUD6Rv2XnU9FZkiFcnqN/Q2QAAlckJIX/V9RliRZytcFjffg3vqb7fWoacstObFqIcdFAVnHQ+2UJRtvpbIotoGQnnbw9HNfuAdB2CCQGEjo/T6rOB5WF/7XkBn6vsDbOIuvU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tkyHv1uE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tkyHv1uE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8D29C4CEC2;
	Wed,  2 Oct 2024 14:23:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727879033;
	bh=daR342MpUYwhea1dJqPH97hmYrFAQY6JEdyD2F43bgY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tkyHv1uEqyK8Nt8vjfS3RJ3rvmBv3ncHxZ2p7A02BLQ+/j5Jgb7Ez+cnn/3nL9BvI
	 cSuaGHcNwfsD61qZYOBh2ZkEjZSVNzgFt4/TmF7ydBjiPIr+Wym0VD+6E8cUGjUq+r
	 0CTNEzjcvIYErUAKkQli5u0SJYi9IlIGKB3dKhRM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maxim Suhanov <dfirblog@gmail.com>,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 6.10 616/634] dm-verity: restart or panic on an I/O error
Date: Wed,  2 Oct 2024 15:01:56 +0200
Message-ID: <20241002125835.432465893@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125811.070689334@linuxfoundation.org>
References: <20241002125811.070689334@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mikulas Patocka <mpatocka@redhat.com>

commit e6a3531dd542cb127c8de32ab1e54a48ae19962b upstream.

Maxim Suhanov reported that dm-verity doesn't crash if an I/O error
happens. In theory, this could be used to subvert security, because an
attacker can create sectors that return error with the Write Uncorrectable
command. Some programs may misbehave if they have to deal with EIO.

This commit fixes dm-verity, so that if "panic_on_corruption" or
"restart_on_corruption" was specified and an I/O error happens, the
machine will panic or restart.

This commit also changes kernel_restart to emergency_restart -
kernel_restart calls reboot notifiers and these reboot notifiers may wait
for the bio that failed. emergency_restart doesn't call the notifiers.

Reported-by: Maxim Suhanov <dfirblog@gmail.com>
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm-verity-target.c |   23 +++++++++++++++++++++--
 1 file changed, 21 insertions(+), 2 deletions(-)

--- a/drivers/md/dm-verity-target.c
+++ b/drivers/md/dm-verity-target.c
@@ -265,8 +265,10 @@ out:
 	if (v->mode == DM_VERITY_MODE_LOGGING)
 		return 0;
 
-	if (v->mode == DM_VERITY_MODE_RESTART)
-		kernel_restart("dm-verity device corrupted");
+	if (v->mode == DM_VERITY_MODE_RESTART) {
+		pr_emerg("dm-verity device corrupted\n");
+		emergency_restart();
+	}
 
 	if (v->mode == DM_VERITY_MODE_PANIC)
 		panic("dm-verity device corrupted");
@@ -691,6 +693,23 @@ static void verity_finish_io(struct dm_v
 	if (!static_branch_unlikely(&use_bh_wq_enabled) || !io->in_bh)
 		verity_fec_finish_io(io);
 
+	if (unlikely(status != BLK_STS_OK) &&
+	    unlikely(!(bio->bi_opf & REQ_RAHEAD)) &&
+	    !verity_is_system_shutting_down()) {
+		if (v->mode == DM_VERITY_MODE_RESTART ||
+		    v->mode == DM_VERITY_MODE_PANIC)
+			DMERR_LIMIT("%s has error: %s", v->data_dev->name,
+					blk_status_to_str(status));
+
+		if (v->mode == DM_VERITY_MODE_RESTART) {
+			pr_emerg("dm-verity device corrupted\n");
+			emergency_restart();
+		}
+
+		if (v->mode == DM_VERITY_MODE_PANIC)
+			panic("dm-verity device corrupted");
+	}
+
 	bio_endio(bio);
 }
 


