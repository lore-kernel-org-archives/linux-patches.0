Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06ECC227EBD;
	Tue,  8 Apr 2025 11:41:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744112480; cv=none; b=N1iG13FP+C4luI2XxyYiX8T2lNAqJUu1pwWiRcZ6RoEKuuwWZAOB4awj24fjbgzFyz/09+9FG6WljtD246G7r4MZl75H0UUPJtp1jMOYBK+DO1wlO5ekfgL23VduyL/CUdZ5UQuZExark2J6i0BZ8VZco2jWQs8f1fOLLC60atI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744112480; c=relaxed/simple;
	bh=/EOIeSNSq6Jt2jBD7FkK8wKnhNwGrKUzQA0sfbzU5ts=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XgeZ9+g9DqRPfi4BsGf+I4YgJxR5jcu8F73/wjfm2x5ug3eRSbB1hK1h9cQ/L3fk44YNbVtKgLxGRQgWdDg/rxClwNm7duCDRTk9V/TxkwzAyTAwN5qtMMwwdwMOJrx3pNUx0twoJZDYWtwq+b2F1/GzibFD5TCxRm+tMDdJz/8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=v+Wc0bZ7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v+Wc0bZ7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87EC8C4CEE5;
	Tue,  8 Apr 2025 11:41:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744112479;
	bh=/EOIeSNSq6Jt2jBD7FkK8wKnhNwGrKUzQA0sfbzU5ts=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=v+Wc0bZ7GzZ2wowkW67HB2tc4p5+/Zrsgard5BCZ9FmQ5x933kmZOxLRWExa9Q3HM
	 YON+KN4AH5rJqOK9HWCh968R869gFBTdNhavo0qioHQYt5/uJiPUYaDuQ2bStQKlq2
	 JiYO7J/9HxRt5q+rCEeOJNXbyMzZt04cpndz6Pas=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sagi Grimberg <sagi@grimberg.me>,
	Daniel Wagner <wagi@kernel.org>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 044/279] nvme: only allow entering LIVE from CONNECTING state
Date: Tue,  8 Apr 2025 12:47:07 +0200
Message-ID: <20250408104827.569994378@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104826.319283234@linuxfoundation.org>
References: <20250408104826.319283234@linuxfoundation.org>
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

From: Daniel Wagner <wagi@kernel.org>

[ Upstream commit d2fe192348f93fe3a0cb1e33e4aba58e646397f4 ]

The fabric transports and also the PCI transport are not entering the
LIVE state from NEW or RESETTING. This makes the state machine more
restrictive and allows to catch not supported state transitions, e.g.
directly switching from RESETTING to LIVE.

Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
Signed-off-by: Daniel Wagner <wagi@kernel.org>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/core.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index 7f744aa4d120c..6748532c776b8 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -444,8 +444,6 @@ bool nvme_change_ctrl_state(struct nvme_ctrl *ctrl,
 	switch (new_state) {
 	case NVME_CTRL_LIVE:
 		switch (old_state) {
-		case NVME_CTRL_NEW:
-		case NVME_CTRL_RESETTING:
 		case NVME_CTRL_CONNECTING:
 			changed = true;
 			fallthrough;
-- 
2.39.5



