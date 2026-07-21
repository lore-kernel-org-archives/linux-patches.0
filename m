Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F27D3ED3B2;
	Tue, 21 Jul 2026 19:23:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784661830; cv=none; b=MeHG31LYXjdE5zKO1WERFr96wlci0btzx9+VETjRBkqq9IgYqb0PI+O3JZU6NhacJOtgbzLB4qq0YVu9/Zr+fMZXC3YDETjpwx/nMY9LF7qYHETpM9YlMlMQrWemNtfh7xFUpx7csOOl5MF+JTfge54qCNOcSi2WbGbYZdwqonI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784661830; c=relaxed/simple;
	bh=KcEL3BRZ9TdO33VvHYLpD7XEJNntaRafAz7Mmo69gJc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jXQsL+rmdRRhq4bWi3Mg1xBw/BaLMTGp0rkgDKXO7e4Ev6yPPOj9Duu8TkWphkIZNfO5nXducVRdISyh1q+mlr1b5WsU+4sDsUvtB5HwQ+aKNDyL+Zo4pVqG7c9rp9fcBYTt6aX5TYxi1APnOcLt6J6iiqLR0EE/y6YvzeJJeus=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YxjY1wvF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YxjY1wvF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A509A1F000E9;
	Tue, 21 Jul 2026 19:23:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784661829;
	bh=TWOdyViGBSidlIMZ/QQ7vwHnYryC87+Nsi78qRRyu2U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YxjY1wvFpko/N0Hxyy2C60XkAfNO5BhOZI0AjJeDsx7LEgryMQGL6fxI2FVMr+Meb
	 smnxKp6gShqyqzk7c7+pZtsDtAsFxMEKop7/Y7v1bzkrJu8AuulgYmFjCysTCr9eEz
	 z06Iv51k3Gd5sZQEabaITlHk8fqi2hsWgMyqBO3Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bart Van Assche <bvanassche@acm.org>,
	Niklas Cassel <cassel@kernel.org>,
	Damien Le Moal <dlemoal@kernel.org>,
	Hannes Reinecke <hare@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0213/1276] ata: libata: Fix ata_exec_internal()
Date: Tue, 21 Jul 2026 17:10:56 +0200
Message-ID: <20260721152450.852030569@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 43493492792864..db07420efcee4f 100644
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



