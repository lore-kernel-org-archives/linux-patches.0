Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F4281D90C8;
	Tue, 26 Aug 2025 13:04:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756213472; cv=none; b=bRlRH3JbtsWWRrydWcxZ7G9ZuDKxB43B3OIoQ5KldrQiuRmoClFuLdCX4M+bHNpzOY281pt+exWnsA1TRm95xJKoVu4FrDxl9nc7mn2N8GflZZ0PxJA3Z/xa7ZMyvhb9Wq7DzFoYTmstSvCqsMvw2qUPFam1wE2/0I8kxEIrqeg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756213472; c=relaxed/simple;
	bh=QReEHvCOdP+fTzXyJdX8//vSLtkr2SSaNy5KOrj2yVg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fAV9bLAN72X0/ypjWexfNi5T5u5DPbjJr8QNwhYNVSg9NkUliYnJ0ogqZSdin2rgrvxhrQZdlbzKtg2nj3+iVjMv8nyFo1S9arjcjMENapO9xsKBuYP4wQCD1KWAyab9xUH3/eAa2yP1e+f0uXflLXqYEb8fxr9ib3XGDR0EBWs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1dzDp7ZB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1dzDp7ZB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC2AFC4CEF1;
	Tue, 26 Aug 2025 13:04:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756213472;
	bh=QReEHvCOdP+fTzXyJdX8//vSLtkr2SSaNy5KOrj2yVg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1dzDp7ZBUvp+SxxnYrjzpC91UOlB5a4aKE9SKB6hDz3HkNkZlw0HDxVqEqZkIkabL
	 2uBdId+yFDgqslr6IkQhF6U07tcAh7PDGHsc7KURSEiWdCjxYmAB2zl9mJHU5jDx7d
	 gpZqk6qcxADOX23uFlMiC7gwiSTBgpzVl9ISngLk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chandrakanth Patil <chandrakanth.patil@broadcom.com>,
	Ranjan Kumar <ranjan.kumar@broadcom.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 6.6 360/587] scsi: mpi3mr: Fix race between config read submit and interrupt completion
Date: Tue, 26 Aug 2025 13:08:29 +0200
Message-ID: <20250826111002.069713589@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110952.942403671@linuxfoundation.org>
References: <20250826110952.942403671@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -411,8 +411,8 @@ static void mpi3mr_process_admin_reply_d
 				       MPI3MR_SENSE_BUF_SZ);
 			}
 			if (cmdptr->is_waiting) {
-				complete(&cmdptr->done);
 				cmdptr->is_waiting = 0;
+				complete(&cmdptr->done);
 			} else if (cmdptr->callback)
 				cmdptr->callback(mrioc, cmdptr);
 		}


