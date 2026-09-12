Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A3EF20ED;
	Sat, 12 Sep 2026 15:05:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789225518; cv=none; b=s57M4L7s6xRGefwhZYW2Jm7RTmD3a0WdAtkm5rNpfb1JxBG+BziLU9HDZmf4IoLk//rd2Ft9/t8GPgAeAlxyKV7Ia/T4sqHzQuExPRd3eeYHZw+zCeKfPJ2+i3C5+eQLdNEP0W1o1YpWAtn05K8KGsweaG7h7Xw7EuijA/wJY/Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789225518; c=relaxed/simple;
	bh=AYd8AoEtWbYNgRHDSgE2oAzgcsLKImzjFkbpe/JOLKI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AVdKV1K8spMZnD1m0kYGdZj76DC+vuyKyHetJQ+/OzkNmlVJfiwC0ycRD/aYfPXiKCg9DqLN+1xL6WdUrcSVubJV3c5b9a3uHNpuSpgJvVceaUiP5eN5Py8ofSVlYn4Hy5bMir1QdZ5uuElbqyuIxfqSfVABKJ+Xs2orUlp5oZs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gPYdxfYq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gPYdxfYq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10A561F000FF;
	Sat, 12 Sep 2026 15:05:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789225516;
	bh=7BcqCPH5NKKKPYgczMaza6Kfm7H3BSkf0r+7L9thjuE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gPYdxfYqWMLpLLLHEeuMEk2j+4meAoOjpmU+LYIS4v8bvnr9cb3oFY6WoMYSNPTsZ
	 ig4Mx6WEJKgCSr77iol/Jvq8KWBPmq2kEOkN2l3UCbYU62hrjmYJLU3QfV62rB4Prj
	 b13HKzI9TZ1rKwL6MoLv50z/QQZN57K1C3AlFUps=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrew Halaney <ahalaney@redhat.com>,
	Bart Van Assche <bvanassche@acm.org>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1213/1424] scsi: ufs: core: Remove unnecessary wmb() after ringing doorbell
Date: Sat, 12 Sep 2026 09:00:45 +0200
Message-ID: <20260912065634.450744589@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Andrew Halaney <ahalaney@redhat.com>

[ Upstream commit d3fb9a24a6023c744d498f5b4d575517726a42b4 ]

Currently, the doorbell is written to and a wmb() is used to commit it
immediately.

wmb() ensures that the write completes before following writes occur, but
completion doesn't mean that it isn't stored in a buffer somewhere.  The
recommendation for ensuring this bit has taken effect on the device is to
perform a read back to force it to make it all the way to the device. This
is documented in device-io.rst and a talk by Will Deacon on this can be
seen over here:

    https://youtu.be/i6DayghhA8Q?si=MiyxB5cKJXSaoc01&t=1678

But, completion and taking effect aren't necessary to guarantee here.

There's already other examples of the doorbell being rung that don't do
this. The writel() of the doorbell guarantees prior writes by this thread
(to the request being setup for example) complete prior to the ringing of
the doorbell, and the following wait_for_completion_io_timeout() doesn't
require any special memory barriers either.

With that in mind, just remove the wmb() altogether here.

Fixes: ad1a1b9cd67a ("scsi: ufs: commit descriptors before setting the doorbell")
Signed-off-by: Andrew Halaney <ahalaney@redhat.com>
Link: https://lore.kernel.org/r/20240329-ufs-reset-ensure-effect-before-delay-v5-10-181252004586@redhat.com
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Stable-dep-of: 720d8b2f2457 ("scsi: ufs: core: Set task state before io_schedule_timeout()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ufs/core/ufshcd.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 3bbe1088b7e49..82d83a2f1a4e1 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -7117,10 +7117,7 @@ static int __ufshcd_issue_tm_cmd(struct ufs_hba *hba,
 
 	/* send command to the controller */
 	__set_bit(task_tag, &hba->outstanding_tasks);
-
 	ufshcd_writel(hba, 1 << task_tag, REG_UTP_TASK_REQ_DOOR_BELL);
-	/* Make sure that doorbell is committed immediately */
-	wmb();
 
 	spin_unlock_irqrestore(host->host_lock, flags);
 
-- 
2.53.0



