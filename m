Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97BC2286415;
	Tue, 25 Aug 2026 14:01:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787666468; cv=none; b=m03QWbvXJCQMuMy/1VKVO6bftcKZlI+KNyqo3MXfF9eegmy7P//m0vZtQvfqMNeIjiss/qw5i8iRUwla1HqcWavAWMYtwnPrUvDXV9ZBFU4X8xXEX1Y2eA38FhEXnZ7t4qQUwKJ2W6iYpLvRSn4W5Y8g0sG8bqrHyoYtIYGDYPc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787666468; c=relaxed/simple;
	bh=+ilYHHNn5cc5KTWgSBl+3/CE7s2pl15ygKof8ejGyP8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uhmEKhQuDqHOCLurhJhqEITQ+6WfuHk8okbTD76eKDYrZGWIzh5L1H5fTK4TjlcH7dR5+vz9Wfu9sPNmGf3QIKa53Iia8P2J2zmK0mj4AQZZiiAPdmLw3llkkwaeLTQNlzd5eulGTd1WeENpRfxcbPcYDp4P9OBqHswym6pzE3g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aUKTwgJm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aUKTwgJm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEE8F1F000E9;
	Tue, 25 Aug 2026 14:01:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787666467;
	bh=owFqV/IWN1rD6htezfVyw8MipKp4QGez51Khdz0hSaI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aUKTwgJm5lksgcjjkegmXW7rEUgnzNrfTx3C/Q2hFGOeLy2xHAsuapNEj9a+9jEvs
	 7rvHF/B30J0P6ythwLB8kvcEnxRjqvDlWiPj3VmuOoYwA2342nlVZ7xYp17FhD28H0
	 hZn1VXqqmAceJqOASwn7Sh8Pq/LvHaSpw9s/9aoE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Farhan Ali <alifm@linux.ibm.com>,
	Matthew Rosato <mjrosato@linux.ibm.com>,
	Eric Farman <farman@linux.ibm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 51/57] s390/vfio_ccw: Free all memory if cp_init() fails
Date: Tue, 25 Aug 2026 15:27:13 +0200
Message-ID: <20260825132543.339474535@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260825132541.342390421@linuxfoundation.org>
References: <20260825132541.342390421@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Farman <farman@linux.ibm.com>

[ Upstream commit 74186c2968f8f756ac3226b545b598457c910c75 ]

The routine cp_free() is called to unpin/free any memory once an I/O
is completed successfully, or if cp_prefetch() fails. But if cp_init()
fails, and cp->initialized is not enabled, the same routine cannot be
used to free all the memory.

An attempt to address this exists in ccwchain_handle_ccw(), where a
single call to ccwchain_free() is made for the currently-processed
CCW segment. But this will leak other segments (created as a result
of a Transfer in Channel) that had been allocated as part of the same
channel program.

Address this by performing the cleanup outside of the recursive
ccwchain_handle_ccw()/ccwchain_loop_tic() logic.

Fixes: 8b515be512a2 ("vfio-ccw: Fix memory leak and don't call cp_free in cp_init")
Cc: stable@vger.kernel.org
Reviewed-by: Farhan Ali <alifm@linux.ibm.com>
Reviewed-by: Matthew Rosato <mjrosato@linux.ibm.com>
Signed-off-by: Eric Farman <farman@linux.ibm.com>
Signed-off-by: Christian Borntraeger <borntraeger@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/s390/cio/vfio_ccw_cp.c | 22 ++++++++++++++++++----
 1 file changed, 18 insertions(+), 4 deletions(-)

diff --git a/drivers/s390/cio/vfio_ccw_cp.c b/drivers/s390/cio/vfio_ccw_cp.c
index 4da85df9f7816..1b6d0be12a7ae 100644
--- a/drivers/s390/cio/vfio_ccw_cp.c
+++ b/drivers/s390/cio/vfio_ccw_cp.c
@@ -446,9 +446,6 @@ static int ccwchain_handle_ccw(u32 cda, struct channel_program *cp)
 	/* Loop for tics on this new chain. */
 	ret = ccwchain_loop_tic(chain, cp);
 
-	if (ret)
-		ccwchain_free(chain);
-
 	return ret;
 }
 
@@ -477,6 +474,23 @@ static int ccwchain_loop_tic(struct ccwchain *chain, struct channel_program *cp)
 	return 0;
 }
 
+static int ccwchain_build_ccws(u32 cda, struct channel_program *cp)
+{
+	struct ccwchain *chain, *temp;
+	int ret;
+
+	ret = ccwchain_handle_ccw(cda, cp);
+
+	if (ret) {
+		/* Cleanup if an error occurred */
+		list_for_each_entry_safe(chain, temp, &cp->ccwchain_list, next) {
+			ccwchain_free(chain);
+		}
+	}
+
+	return ret;
+}
+
 static int ccwchain_fetch_tic(struct ccwchain *chain,
 			      int idx,
 			      struct channel_program *cp)
@@ -650,7 +664,7 @@ int cp_init(struct channel_program *cp, struct device *mdev, union orb *orb)
 	cp->mdev = mdev;
 
 	/* Build a ccwchain for the first CCW segment */
-	ret = ccwchain_handle_ccw(orb->cmd.cpa, cp);
+	ret = ccwchain_build_ccws(orb->cmd.cpa, cp);
 
 	if (!ret) {
 		cp->initialized = true;
-- 
2.53.0



