Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9EE7346A0C;
	Tue, 21 Jul 2026 20:31:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784665883; cv=none; b=E4UrnlPGxYmsv2dkzotaxHF2Ue9wB5SSztJ2cXaixMqSwVdRuloV9MiqNuerstjxPx99SxEqNk599gH2hjKPFVl+QdaeIWp8E5Sx7p15rkBsDW/d+hNzUoU+e2T7UdBki8XYdv1cIVkn9DrqYsqUopfsBWILCJcpDE/jmFpmAh0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784665883; c=relaxed/simple;
	bh=TEaMAUhw0fvpJgV3uj93LxBaVtbRwGHj/d5A4cY25Ns=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iqpYDPzxdsMFv+9xzqoR/+1e/JuKpG8HH+SIdRfxCpj1/v4a60vE3UK5jPW9Tolroo9hdpLzqKSzuAZ8KOcw6sKu+kL3wA8FjuIAQuksTbv2Od81vqiMCMYfAdEmtw0Rti2Sji1gGBnYlYMmr2ymIFTYgBPGC5utBTFUg4bhASk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UCpAP6rs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UCpAP6rs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B90C1F000E9;
	Tue, 21 Jul 2026 20:31:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784665882;
	bh=dOmwLsDr5RVb+1XaCqF56/E9AizwjqKs6IQtaiL0VT8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UCpAP6rs5OlGFnMbWXfe5oZdg3g2z3ru9SZ7/SXrBGCH6VdLiArwK2xMEGqvn6UEk
	 hBDuhcuEackyUTb2dLk4cmqtjGCUdhmIXLn7dIzCNZcMdmAgnXr/0ObJd//mR4bYIj
	 oGfT4GyFqsF7Ambd+EXazG0A4Oa0nwSnIkcC7D+E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bart Van Assche <bvanassche@acm.org>,
	Niklas Cassel <cassel@kernel.org>,
	Damien Le Moal <dlemoal@kernel.org>,
	Hannes Reinecke <hare@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0473/1266] ata: libata: Fix ata_exec_internal()
Date: Tue, 21 Jul 2026 17:15:10 +0200
Message-ID: <20260721152452.419937950@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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
index 91c6291b01f4e0..07dd04b8d01d16 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -1508,6 +1508,7 @@ static unsigned ata_exec_internal_sg(struct ata_device *dev,
 {
 	struct ata_link *link = dev->link;
 	struct ata_port *ap = link->ap;
+	const bool owns_eh_mutex = ap->host->eh_owner == current;
 	u8 command = tf->command;
 	int auto_timeout = 0;
 	struct ata_queued_cmd *qc;
@@ -1586,11 +1587,25 @@ static unsigned ata_exec_internal_sg(struct ata_device *dev,
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



