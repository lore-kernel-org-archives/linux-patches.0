Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 516EF350A29;
	Tue, 16 Dec 2025 12:03:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765886616; cv=none; b=RIYN6wyK+nRqV6QvULOeZ4jvZJUcn3Kf30AKTV/2Px4aMnWxvoeJpdFfyJ2h59Ky2lP2NmjbSB/xXDan3d4iFU1kz3mY0zc2bQoZ2Z2R1FCC4IQEaEcUPPYRwUmaCYQuutVwstvsXM/OAusLBmCNC2UhkhAk5eOILaJZrit0xMQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765886616; c=relaxed/simple;
	bh=ie1GEIqs+NxXYOme8skIP9f98Gd+eYHKyvOwe2JSk04=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Vz8VzZAxoEV+KD6kbHL4APaIEl+eOxilmV4MeMYJB7vSITrdbIKVDzb0rZ0NGzPqSsneR/E2EBlkBxX7ap20Rhg2Pp+URjRcoVOMA8IhcrH3QUDRPycBHiZ2G8wQN4vmJBuMzMDmJlfz7ZDNuklvNkaulNsgDKM4W/4HN+OBtqY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=F+RnJlMg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F+RnJlMg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6553C4CEF1;
	Tue, 16 Dec 2025 12:03:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765886616;
	bh=ie1GEIqs+NxXYOme8skIP9f98Gd+eYHKyvOwe2JSk04=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=F+RnJlMgYyh+f9NAXiUOLxUh7fS5ZoOirElvOKRIUOJtMMwX+GtDCGVme5IaFN/nL
	 hpyED6OeLDnHJflXidBaCiKQko1J8UVHTxpVU3xrWOExXMwJh29u62ij5aYcqfTggM
	 0ze2sBWy+fPykxLUkh3kBFX3EQovNwUvCNEF7wNk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haotian Zhang <vulab@iscas.ac.cn>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 488/507] dm log-writes: Add missing set_freezable() for freezable kthread
Date: Tue, 16 Dec 2025 12:15:29 +0100
Message-ID: <20251216111403.119198642@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111345.522190956@linuxfoundation.org>
References: <20251216111345.522190956@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Haotian Zhang <vulab@iscas.ac.cn>

[ Upstream commit ab08f9c8b363297cafaf45475b08f78bf19b88ef ]

The log_writes_kthread() calls try_to_freeze() but lacks set_freezable(),
rendering the freeze attempt ineffective since kernel threads are
non-freezable by default. This prevents proper thread suspension during
system suspend/hibernate.

Add set_freezable() to explicitly mark the thread as freezable.

Fixes: 0e9cebe72459 ("dm: add log writes target")
Signed-off-by: Haotian Zhang <vulab@iscas.ac.cn>
Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/dm-log-writes.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/md/dm-log-writes.c b/drivers/md/dm-log-writes.c
index 679b07dee2294..1f8fbc27a12f8 100644
--- a/drivers/md/dm-log-writes.c
+++ b/drivers/md/dm-log-writes.c
@@ -432,6 +432,7 @@ static int log_writes_kthread(void *arg)
 	struct log_writes_c *lc = arg;
 	sector_t sector = 0;
 
+	set_freezable();
 	while (!kthread_should_stop()) {
 		bool super = false;
 		bool logging_enabled;
-- 
2.51.0



