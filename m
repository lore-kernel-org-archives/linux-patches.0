Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DE8429BDB8;
	Tue, 26 Aug 2025 11:37:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756208274; cv=none; b=dME6Vu+zN6U5AeArB50PnePMoXEMtyK1kyDpWgBCIazcrtbsruN5kas4o7usnB7rT9LXAb+NV90NJILmI06rMeApNUWqrl7wQ+yiijNhvxW35vpPFc+E+5/KiXDMopKNqvCuYArSokoRkbhqezK+Vb76fk0K7NCFvjp6leukcUo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756208274; c=relaxed/simple;
	bh=Q0ZIZKpFhdvLvLylXVaDE5n+urb8uzOEbI+ezKgmG7E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TWPw0rNURh6C8suX4t/ASm7jYfP3ORlFFa52KuJOqunmYvx8thQIy72+IEpcdmW0UvOn19WfHQD3EV2Gkl3ueZwneTuqEeacf9VGaguI1nY79NuWueqxVBA5ll9Ydaj7zEUyylCffkzQGpmy4nBHt8lsTIu91k1s/bbrfVPIXw8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IwhWy0eL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IwhWy0eL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 278C9C4CEF1;
	Tue, 26 Aug 2025 11:37:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756208274;
	bh=Q0ZIZKpFhdvLvLylXVaDE5n+urb8uzOEbI+ezKgmG7E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IwhWy0eLCn73hhGhuBO95NYoRVP5kZbf5HTBskPxJYZwYKtiJno6xDjaeTk1N7zU8
	 48ad9y6ZSxZAo0ySDn89lhtiEw1rCMEWON/h5WmclXYxMsu/xL9wihIeAMNlN9RKqK
	 K8AvXJSIfHFk2o5i72RZLme2zE7JkgE4JUfEYMvU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chandrakanth Patil <chandrakanth.patil@broadcom.com>,
	Ranjan Kumar <ranjan.kumar@broadcom.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 6.12 049/322] scsi: mpi3mr: Fix race between config read submit and interrupt completion
Date: Tue, 26 Aug 2025 13:07:44 +0200
Message-ID: <20250826110916.609078675@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110915.169062587@linuxfoundation.org>
References: <20250826110915.169062587@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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


