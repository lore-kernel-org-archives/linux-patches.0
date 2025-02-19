Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 864A71AF0C8;
	Wed, 19 Feb 2025 09:29:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739957376; cv=none; b=hXU/FwVi5Nl4bWA5caHsPO3qOG01axQjY5VhEIKPOMBGJMUnz5jLvMa1ejpb3Z5BE/eaxWtMcpLSabjM+jwb0Eq2NIEFaxIMXiuLjaBpw7bnGyQzyammvLgaIBdo/1acIXJWaO0hL3MQFCeQO5wrU3oRw2tHMGJR2PyjtFlzadE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739957376; c=relaxed/simple;
	bh=O0G8fL7+QsOja7wl8GHH8MWSGAejd0yvEM8H4EPM358=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tpVXJ9RvPiDQ4HXunP6K3FMxzq9u23WlLnXpNVuj165+q91tf3ukizLNkRCUVvqh4GkPB/vgWOP7BYLYR5i0I9dC4x9HAgR2zC004S6SQ69eWiC3cqPIoBkADjiJbHp4VmQP8aMrFGXhUho6OOupv7Og/NZUBxK9qKqhMlqMHas=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yV/AVo00; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yV/AVo00"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D4D1C4CED1;
	Wed, 19 Feb 2025 09:29:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739957376;
	bh=O0G8fL7+QsOja7wl8GHH8MWSGAejd0yvEM8H4EPM358=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yV/AVo00eqCDqVr9NrqNVZCp3J0LhdcAV/p0vFxn4X+wdWK0/gYWHao/G4JXu/gVA
	 Q1Plejc6149LQygyl9dwHwSRW9HO9T5pmGEzSXLv8PWgyYxLl9XSWxKUm2VFOtqB83
	 dW2F2UHEcMskeFdHjBxjIWrUTpuEQJWfi1OyYJ9A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guixin Liu <kanie@linux.alibaba.com>,
	Avri Altman <avri.altman@wdc.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 487/578] scsi: ufs: bsg: Set bsg_queue to NULL after removal
Date: Wed, 19 Feb 2025 09:28:11 +0100
Message-ID: <20250219082712.158552297@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082652.891560343@linuxfoundation.org>
References: <20250219082652.891560343@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guixin Liu <kanie@linux.alibaba.com>

[ Upstream commit 1e95c798d8a7f70965f0f88d4657b682ff0ec75f ]

Currently, this does not cause any issues, but I believe it is necessary to
set bsg_queue to NULL after removing it to prevent potential use-after-free
(UAF) access.

Signed-off-by: Guixin Liu <kanie@linux.alibaba.com>
Link: https://lore.kernel.org/r/20241218014214.64533-3-kanie@linux.alibaba.com
Reviewed-by: Avri Altman <avri.altman@wdc.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ufs/core/ufs_bsg.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/ufs/core/ufs_bsg.c b/drivers/ufs/core/ufs_bsg.c
index 87d89136cab90..ead55e063d2b5 100644
--- a/drivers/ufs/core/ufs_bsg.c
+++ b/drivers/ufs/core/ufs_bsg.c
@@ -181,6 +181,7 @@ void ufs_bsg_remove(struct ufs_hba *hba)
 		return;
 
 	bsg_remove_queue(hba->bsg_queue);
+	hba->bsg_queue = NULL;
 
 	device_del(bsg_dev);
 	put_device(bsg_dev);
-- 
2.39.5



