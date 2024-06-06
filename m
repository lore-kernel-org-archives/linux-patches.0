Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E3BB198A16;
	Thu,  6 Jun 2024 14:10:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683052; cv=none; b=UyE0MvmqE/DcoRq+rlDuYouSt64aq94b+OvxJT7I8g/tfRRta+mREHCwJ0j9EBWx2BaUs++IV6kaNhXOdcpWhjC/aFKQcuMbfpL0T6LyYT+QW2lBeOhP+1VPTZHdIVaokhQwrUJuKwurMVPxyFa/5rGdIB3Q/9SmOgh+UcQtjBc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683052; c=relaxed/simple;
	bh=sQ3cMM86IKeaGdDnND1eHZfDUBiKsjBekt4ksrtrFPc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H9Pb+IZgDfBpdZFuq2FpNuxTUdVf5jex4DfM+nbzEUJkfleBfcxxTeBSNob46SQvwS9i7SSqKiiS7Z+uUz4aT3EGMs6nIDCdw77Zu2XzmfNfxFEGd4O5T7dKtGpi6r2JVay0AqdvztWJzuk++m6BWBCJbNv0lhPNolosb9l/WEQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mk7lEjij; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mk7lEjij"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F32F6C4AF19;
	Thu,  6 Jun 2024 14:10:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683052;
	bh=sQ3cMM86IKeaGdDnND1eHZfDUBiKsjBekt4ksrtrFPc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mk7lEjij7Jy/2lw/DDg6+JccYFaiZNY6R3J8Hzepzgd9IgIyfFUGBPdavnKETl/6X
	 FPM9w25aHjYewJaF7+FYMa8wH6zfIwrKhCu3jd5znYC8l1JPzOmuuxfp2O0z+K0v6w
	 zOy0nUQb9Cn2A4R3KtFaO+X/pGHCpyBefjpOc9/k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sagi Grimberg <sagi@grimberg.me>,
	Christoph Hellwig <hch@lst.de>,
	Chaitanya Kulkarni <kch@nvidia.com>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 293/374] nvmet: fix ns enable/disable possible hang
Date: Thu,  6 Jun 2024 16:04:32 +0200
Message-ID: <20240606131701.693141828@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131651.683718371@linuxfoundation.org>
References: <20240606131651.683718371@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sagi Grimberg <sagi@grimberg.me>

[ Upstream commit f97914e35fd98b2b18fb8a092e0a0799f73afdfe ]

When disabling an nvmet namespace, there is a period where the
subsys->lock is released, as the ns disable waits for backend IO to
complete, and the ns percpu ref to be properly killed. The original
intent was to avoid taking the subsystem lock for a prolong period as
other processes may need to acquire it (for example new incoming
connections).

However, it opens up a window where another process may come in and
enable the ns, (re)intiailizing the ns percpu_ref, causing the disable
sequence to hang.

Solve this by taking the global nvmet_config_sem over the entire configfs
enable/disable sequence.

Fixes: a07b4970f464 ("nvmet: add a generic NVMe target")
Signed-off-by: Sagi Grimberg <sagi@grimberg.me>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/target/configfs.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/nvme/target/configfs.c b/drivers/nvme/target/configfs.c
index 7fda69395c1ef..dfdff6aba6953 100644
--- a/drivers/nvme/target/configfs.c
+++ b/drivers/nvme/target/configfs.c
@@ -676,10 +676,18 @@ static ssize_t nvmet_ns_enable_store(struct config_item *item,
 	if (kstrtobool(page, &enable))
 		return -EINVAL;
 
+	/*
+	 * take a global nvmet_config_sem because the disable routine has a
+	 * window where it releases the subsys-lock, giving a chance to
+	 * a parallel enable to concurrently execute causing the disable to
+	 * have a misaccounting of the ns percpu_ref.
+	 */
+	down_write(&nvmet_config_sem);
 	if (enable)
 		ret = nvmet_ns_enable(ns);
 	else
 		nvmet_ns_disable(ns);
+	up_write(&nvmet_config_sem);
 
 	return ret ? ret : count;
 }
-- 
2.43.0



