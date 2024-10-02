Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E98729CE7;
	Wed,  2 Oct 2024 13:52:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727877130; cv=none; b=Ycuk48ki/nYbHQPaWEDnBcW2yroaz/Vbs6TBWXEe4YtgoQwk8q5zjf42wl5IMBQvhlB+hcx+1djZpSjAEzn6wJE9Hyul02GJ/EKgLM6tsYxAvoiUByixCde7X5L8PBF/qtmy/XB91/bhr2O7Dj5GUuQ8AzrvoohJMHdMCBUG1QU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727877130; c=relaxed/simple;
	bh=Hle0mokEM49FrXSAACxZ9TpBVoUkGvJhA8HYhBXNmC8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GZIG/TTikeJ+wAW6kQn5ZR6epbqzw5g1uiPw4MWS4T0fH83J70Nbcz8T/rSOk0upYl4O36iZSYDl+DIbcVkfblWbBFU1v+4UKr2af+2EwRnydmf4m2Pfo+pJrDHAW5cLEJgQy+blD2AoQzFAUgM7gL8iR6jXaZaBwqQvXOLkwwc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UuIVi3Ju; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UuIVi3Ju"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8465C4CEC2;
	Wed,  2 Oct 2024 13:52:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727877130;
	bh=Hle0mokEM49FrXSAACxZ9TpBVoUkGvJhA8HYhBXNmC8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UuIVi3JuMRwoGogIDRxG/h68girYJodDBAywCsdZAy8z9We4tNWgkA4V4TjftBWcA
	 wO67Cl/whY+FHehYcFFdAVoJGC+wFnEGpu1iR35hADTI3K94DGOG0xCWq7XFAWjSUG
	 KhGHShq6hSqqN+Tp4LcO8ZIlS6GOsWMjrzQaV9V4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maxim Suhanov <dfirblog@gmail.com>,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 6.11 675/695] dm-verity: restart or panic on an I/O error
Date: Wed,  2 Oct 2024 15:01:13 +0200
Message-ID: <20241002125849.459294148@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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
@@ -272,8 +272,10 @@ out:
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
@@ -596,6 +598,23 @@ static void verity_finish_io(struct dm_v
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
 


