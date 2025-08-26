Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14BD9343218;
	Tue, 26 Aug 2025 13:58:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756216685; cv=none; b=S86jogmzvkpswmw0GpoMpu+PC0MTpuVR26534dt+Easq3o6nUMN28vfBWKYYu+yKJg5Rw2vVWgqvR/4JR3j6UGhHYBsi3GS+/A/8lUK+0JLrdXn8WXpcM7RIaJHfqSAJgVV6TObUzYg7X7TsgnZLKtJu8c7+FnupZjclHdvzDtg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756216685; c=relaxed/simple;
	bh=w1hSzjOthFMBe8PLUnAbAwrdtfAzb2dt8GNI0lWziDk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i610vOdLB3gZnJ4U0aeNG7kov6DI+cOuFs61QknaLQI4V/g/7sRj45tx/YvOoW0RvkFolWUOI9gEdpCQvT0PHGPIy6nL6f8/5CTlPX+KbqN/AAinIcyrmCauaKI/q8WZUKa3U4c6W15zkBb1je1kHe8dWqCAVFr8GROtwukGN8A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=g2DHnRMZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g2DHnRMZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97C60C4CEF1;
	Tue, 26 Aug 2025 13:58:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756216685;
	bh=w1hSzjOthFMBe8PLUnAbAwrdtfAzb2dt8GNI0lWziDk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=g2DHnRMZsQdNApOZER2YnNRHQOkBlQqXSH+0kEIgeUZDFc5uLeA3xGMfC7VPRLi8+
	 yuGtteLwnIo3hIvSJShtjakKv5i6ooLOdoY5p/jdVQKOayvJD/U3WvQxArY3M9DhW2
	 CVQ/QlW1dpq8Pdok3uFoxk/ywRN12bG6LwKCfhZ0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chandrakanth Patil <chandrakanth.patil@broadcom.com>,
	Ranjan Kumar <ranjan.kumar@broadcom.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 5.15 473/644] scsi: mpi3mr: Fix race between config read submit and interrupt completion
Date: Tue, 26 Aug 2025 13:09:24 +0200
Message-ID: <20250826110958.204334015@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110946.507083938@linuxfoundation.org>
References: <20250826110946.507083938@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ranjan Kumar <ranjan.kumar@broadcom.com>

commit e6327c4acf925bb6d6d387d76fc3bd94471e10d8 upstream.

The "is_waiting" flag was updated after calling complete(), which could
lead to a race where the waiting thread wakes up before the flag is
cleared. This may cause a missed wakeup or stale state check.

Reorder the operations to update "is_waiting" before signaling completion
to ensure consistent state.

Fixes: 824a156633df ("scsi: mpi3mr: Base driver code")
Cc: stable@vger.kernel.org
Co-developed-by: Chandrakanth Patil <chandrakanth.patil@broadcom.com>
Signed-off-by: Chandrakanth Patil <chandrakanth.patil@broadcom.com>
Signed-off-by: Ranjan Kumar <ranjan.kumar@broadcom.com>
Link: https://lore.kernel.org/r/20250627194539.48851-2-ranjan.kumar@broadcom.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/mpi3mr/mpi3mr_fw.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/scsi/mpi3mr/mpi3mr_fw.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_fw.c
@@ -372,8 +372,8 @@ static void mpi3mr_process_admin_reply_d
 				    mrioc->facts.reply_sz);
 			}
 			if (cmdptr->is_waiting) {
-				complete(&cmdptr->done);
 				cmdptr->is_waiting = 0;
+				complete(&cmdptr->done);
 			} else if (cmdptr->callback)
 				cmdptr->callback(mrioc, cmdptr);
 		}


