Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F91146D093;
	Tue, 21 Jul 2026 17:49:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784656198; cv=none; b=usaHTqXzk3OSPCdhh0+SPDpZc94GqrVpea+7LIAeutWaWYuO5HsY7wlQfHbcGqTzcljemGu4ZB+ZuttZBJiaAN57/KeZQsdiwmgymIY7yl8aJgrZ7IzGYygLNw5GbC/KFSIsnKBgoB7OkKQZJv6Mobd9lurbleuoZoooqbXtTwM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784656198; c=relaxed/simple;
	bh=70uOxjmbPyMrJrW2/kZhH9mCH1BzKipCStQUhV8qstI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GiUwt2/2DUTw8oxUeRV9eyEH6GDNbYqYzLHM5vq2nwhfPO9HyER/9B7TD+g3aH4fPy/7cLkfhSV0t6UMMSydtwAN+Eykceu5mMJ/uIgDSGKBW0+l+PKWx+ARO6X08DwMpM68kofpZ1+/dNXEKU0POvZwEejVqk69ddq6dXiWQdc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oIuMdWPU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oIuMdWPU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 820271F000E9;
	Tue, 21 Jul 2026 17:49:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784656197;
	bh=sYGI7rP4SWZiRBO/zKlTu+UlGTQzDZqajlcVYTVeMyo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oIuMdWPUaW4ZlmlqtMlyVv+hOMz7ZjlIDC2mvM8oXUepCV7kTg47uuWj3PyfOO8nR
	 3jM0aNopGu6sUgBHw/ypBIOJIRs5/BnDetAQVtFZaF/UrgxQc4Um4eF/ZXClibiK+l
	 NaeV8uoD3PaNomPRQPHnhrJ37vkLQIMfN+omwRG0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bart Van Assche <bvanassche@acm.org>,
	Niklas Cassel <cassel@kernel.org>,
	Damien Le Moal <dlemoal@kernel.org>,
	Hannes Reinecke <hare@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0297/1611] ata: libata: Fix ata_exec_internal()
Date: Tue, 21 Jul 2026 17:06:53 +0200
Message-ID: <20260721152521.752070821@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bart Van Assche <bvanassche@acm.org>

[ Upstream commit aa0ae1c35f7b3e9afed2324bed5f5c87ad55b92c ]

Some but not all ata_exec_internal() calls happen from the context of
the ATA error handler. Commit c0c362b60e25 ("libata: implement cross-port
EH exclusion") added ata_eh_release() and ata_eh_acquire() calls in
ata_exec_internal(). Calling these functions is necessary if the caller
holds the eh_mutex but is not allowed if the caller doesn't hold that
mutex. Fix this by only calling ata_eh_release() and ata_eh_acquire() if
the caller holds the eh_mutex. An example of an indirect caller of
ata_exec_internal() that does not hold the eh_mutex is
ata_host_register().

Fixes: c0c362b60e25 ("libata: implement cross-port EH exclusion")
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Reviewed-by: Niklas Cassel <cassel@kernel.org>
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Hannes Reinecke <hare@kernel.org>
Signed-off-by: Niklas Cassel <cassel@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ata/libata-core.c | 19 +++++++++++++++++--
 1 file changed, 17 insertions(+), 2 deletions(-)

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 5ee4adc623427c..501330e91f9d37 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -1526,6 +1526,7 @@ unsigned int ata_exec_internal(struct ata_device *dev, struct ata_taskfile *tf,
 {
 	struct ata_link *link = dev->link;
 	struct ata_port *ap = link->ap;
+	const bool owns_eh_mutex = ap->host->eh_owner == current;
 	u8 command = tf->command;
 	struct ata_queued_cmd *qc;
 	struct scatterlist sgl;
@@ -1603,11 +1604,25 @@ unsigned int ata_exec_internal(struct ata_device *dev, struct ata_taskfile *tf,
 		}
 	}
 
-	ata_eh_release(ap);
+	if (owns_eh_mutex) {
+		/*
+		 * To prevent that the compiler complains about the
+		 * ata_eh_release() call below.
+		 */
+		__acquire(&ap->host->eh_mutex);
+		ata_eh_release(ap);
+	}
 
 	rc = wait_for_completion_timeout(&wait, msecs_to_jiffies(timeout));
 
-	ata_eh_acquire(ap);
+	if (owns_eh_mutex) {
+		ata_eh_acquire(ap);
+		/*
+		 * To prevent that the compiler complains about the above
+		 * ata_eh_acquire() call.
+		 */
+		__release(&ap->host->eh_mutex);
+	}
 
 	ata_sff_flush_pio_task(ap);
 
-- 
2.53.0



