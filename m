Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795624215;
	b=g2IT2uozSMJd5+wSfCmB/+fD3RpgccnkyR/gpPLGoLC0jdAz04Q85wIAW25qHu07XfaY
	 /N/BE7YQ2kbaN7eH9+ABKLhaI+SE+Ln7QOfe4660WRPYJuyCxmRHTd8bdnkXjD8mOOMlo
	 1FqKcatbl73Rc75pbiaR8oXQTdpFMUmoM7NnWo0/VhlyE6wMdgxErYcNY6CBpi+gTzKTe
	 L48etOpy/D4gCmBeNFGi+EC0aHkpnRM4h1Z7Vo8nk8yVSR6ABaIsv5FFG1ljIMvHPFYYf
	 aIHsCLuqP7TlMpeED5DTWkoYD+ZfZ+1eRzTHQ2DezXz5PM9SZXgZrLDzg4q8CJFAfcw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795624215;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=JvVJf7+MsJnKf367vnsMcsdolZw4+exDwxOT4UqLHO4=;
	b=2JnFfMVx0R1EGL63HXOxoou7Kfc4IwErNv4QM777DctPMAvojkiaGln3QdNTtCg09i1V
	 S1/Z36R/qNpYOKwlMbCxQ51UZxKSwi5GcZ0ph8FGXpQZgniayJGNYm1fC9FeZR7H5PP5G
	 7E8pkmOkRwxD/dVC7oHBEfyNu6WkJNZo/rePQJVycbWdNVEuHxbjXHZIgRnqYJG1ZyF8U
	 iSNwqeY4F2HYmz3znrUPEJGle5v3YgwSjFq8fxWYtyzxIBF3+tKML2svRpMombdKNie2R
	 QnFMxXrp+2miAC5InEjwJ+puO8mYEjKTP+0GyYUATpxN8ggaCdlFFoUtCzon4gwV4Hw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HllOkyHP;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB55F606A33E;
	Wed, 25 Nov 2026 16:30:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HllOkyHP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69D861F000C0;
	Wed, 25 Nov 2026 16:30:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795624215;
	bh=JvVJf7+MsJnKf367vnsMcsdolZw4+exDwxOT4UqLHO4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HllOkyHPckVarGBmUg4gYn80pfhan/z0XFFDjfC0R3Evcz/ImmQwvbnCknLQx+VSu
	 uEN8roAjUT3P5v5wYqysQhTwkMOCQrcN5nHyeJC4gDhgMxav/hMBa6zU32dVHc9giV
	 QEJ8GlJIZGtXmr4EdGT0c7OSSD1u1FnHLPVDM2Cs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Igor Pylypiv <ipylypiv@google.com>,
	Niklas Cassel <cassel@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 119/816] ata: libata-sata: allow re-enabling NCQ with the same queue_depth
Date: Wed, 25 Nov 2026 15:27:47 +0100
Message-ID: <20261125143851.964929099@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Igor Pylypiv <ipylypiv@google.com>

[ Upstream commit d7c5cc8cc21c1264cce07feb4a51be158688280e ]

When ata_eh_speed_down() disables NCQ due to excessive errors, it sets
ATA_DFLAG_NCQ_OFF without changing sdev->queue_depth. Userspace can
re-enable NCQ by writing a queue depth > 1 to the sysfs queue_depth
attribute, which invokes ata_change_queue_depth() to clear
ATA_DFLAG_NCQ_OFF.

However, ata_change_queue_depth() returns early if the requested
queue_depth is equal to sdev->queue_depth before clearing
ATA_DFLAG_NCQ_OFF. As a result, writing a different queue depth > 1
re-enables NCQ, whereas writing the current sdev->queue_depth value
leaves ATA_DFLAG_NCQ_OFF set.

Since ata_change_queue_depth() already checks whether queue_depth equals
sdev->queue_depth before calling scsi_change_queue_depth(), remove the
early check so that writing the current queue_depth > 1 clears
ATA_DFLAG_NCQ_OFF and re-enables NCQ.

Fixes: 45623d33bfc0 ("ata: libata-sata: Improve ata_change_queue_depth()")
Signed-off-by: Igor Pylypiv <ipylypiv@google.com>
Reviewed-by: Niklas Cassel <cassel@kernel.org>
Link: https://lore.kernel.org/r/20261029184445.1615717-1-ipylypiv@google.com
Signed-off-by: Niklas Cassel <cassel@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ata/libata-sata.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/ata/libata-sata.c b/drivers/ata/libata-sata.c
index 0b6cfdfc27598..263a03e14b115 100644
--- a/drivers/ata/libata-sata.c
+++ b/drivers/ata/libata-sata.c
@@ -1287,7 +1287,7 @@ int ata_change_queue_depth(struct ata_port *ap, struct scsi_device *sdev,
 	spin_lock_irqsave(ap->lock, flags);
 
 	dev = ata_scsi_find_dev(ap, sdev);
-	if (!dev || queue_depth < 1 || queue_depth == sdev->queue_depth) {
+	if (!dev || queue_depth < 1) {
 		spin_unlock_irqrestore(ap->lock, flags);
 		return sdev->queue_depth;
 	}
-- 
2.53.0



