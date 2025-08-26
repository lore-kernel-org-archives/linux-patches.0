Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7006A312803;
	Tue, 26 Aug 2025 11:19:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756207145; cv=none; b=ukgjaWXZYMm1bf3lI0XqZAdKT/x6owTL9lm1ein08dd5V6UwUK7f9z8+2Xdnit2Imr5k2YqIpLoN0/oroIjV8po4VXyHUblLbWy3HS3S1Nnv54IGgxDUYBiHLBRRhPwc2imQgd7RRQg6BP9AtE9QJZS/qBQscZXmLcukEXc6mqM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756207145; c=relaxed/simple;
	bh=HXydgQXvtUaRjnox1Iw/nD5W3HaIBLxiuCfXYJsTy9Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B2Ak80hZPaIeplQScFqf71ZZl07QJk7/Kq1K88GwgtPovRQMAHsDnkLgQkZZQufY2iilZfrE9veaKZFcYIyK8r+VZEGatYahGDFiAhY73QbaG6aEXlpooAW6n3Q48Ev1ZkTPmtNt6ALQSX8QlcfLjJWPzUbiFD6V8c3e41nBryk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bJCFgYHJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bJCFgYHJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67CEEC113CF;
	Tue, 26 Aug 2025 11:19:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756207144;
	bh=HXydgQXvtUaRjnox1Iw/nD5W3HaIBLxiuCfXYJsTy9Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bJCFgYHJGe2HPcWXi+SG5fI/XH0aGyiPxzd6z3Suw825SkB8w++Cm4EWGK/SWYBkC
	 B7Wy6s4I5JEq1HnZdby8OSbqpkTxEgplMPrAxzFnXtJVkYpWSM2ayAO70wpGKoCun/
	 GZIQij+02h+CGyNkXGxtaRTnnlPSIko8VAw9288I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chandrakanth Patil <chandrakanth.patil@broadcom.com>,
	Ranjan Kumar <ranjan.kumar@broadcom.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 6.16 067/457] scsi: mpi3mr: Fix race between config read submit and interrupt completion
Date: Tue, 26 Aug 2025 13:05:51 +0200
Message-ID: <20250826110939.021160032@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110937.289866482@linuxfoundation.org>
References: <20250826110937.289866482@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

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
@@ -428,8 +428,8 @@ static void mpi3mr_process_admin_reply_d
 				       MPI3MR_SENSE_BUF_SZ);
 			}
 			if (cmdptr->is_waiting) {
-				complete(&cmdptr->done);
 				cmdptr->is_waiting = 0;
+				complete(&cmdptr->done);
 			} else if (cmdptr->callback)
 				cmdptr->callback(mrioc, cmdptr);
 		}


