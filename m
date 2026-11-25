Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795621142;
	b=WtdgfnxdY7i0y+MeMqAs4hKq5PeTtmUSsQLuqoGNgdlvktdg/2jr9hFE6AYdqDB74Sos
	 ZkKQH655fgQPA5pv/ycQ7/IijbG2JAZBeTCMcAj5fB4Cr/P9gmElbqAhP2DVQ/gKbL0D/
	 PiUbqrZFKVqnZcGYqwugf70pFUOlTucwfGCeCEGfcxWhZ7dd6YzdIU5psStQGF+PE5O2T
	 +PwI46BxDCsv33D/e0b46UifVvULF+rUh2Fv07j4OOgrqwoZ8MU+l1yjmhDjAduWjP3cm
	 EZL941wraWaiHMuw02TQhR+tlGkmZt6NBMsPyMrgPEpD51nDZlt8wgFRajerTntpLiw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795621142;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=FfXRDpQxkRBheMSQ+ov/iFNil+ESI8rnPpKEKZYGOz4=;
	b=aIlzA1mevQFtVKpUvPbUiziai2esFKUgwO6rJs7ivtzendPMmmjcThg5BkYYm7VO2BNL
	 iNiRjfH/mVBONXBZ0PUqZVjhv3JdmtNZsWrn38rRqdNfyijgI3PFLWgkwnFLLxxZq2d9X
	 aW5jrYNKWZ5Ua9CmtNHUqiEeyVF6V/D/HtsOGI1nVTqKXniw7Is1Oxhvp5OvL+g69f+tS
	 +q4SNUj9/5TQ5V8CPScsf+ufrC/MnGZZI39e5b1886aa6TI11G/r4/nvzRz9CQ1/EhJZE
	 S28y8qPi7JEfhnUx0pKogJJcRBGCfJrhWRTkDF+DcjnyOBPW5Oyi1JnSJzdh7kP0QOw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EXc4rJpO;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23B07606A323;
	Wed, 25 Nov 2026 15:39:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EXc4rJpO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BC261F000E0;
	Wed, 25 Nov 2026 15:39:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795621141;
	bh=FfXRDpQxkRBheMSQ+ov/iFNil+ESI8rnPpKEKZYGOz4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EXc4rJpOBC1cFIzs4tZc4zINOCSCWIbFwoelUPzPj2fFYJ4mPxer+rWumjS+7NXxf
	 FnRZDdRd61VFczaw4NCakX0W6yL7gVpbqufs5y9Qr9jpgJBTpxBj6XvoMnDDX1exMv
	 kQOZDWGjDdg8B5n01EcIK9tMaPIqPl++S419nJ38=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Igor Pylypiv <ipylypiv@google.com>,
	Niklas Cassel <cassel@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 135/990] ata: libata-sata: allow re-enabling NCQ with the same queue_depth
Date: Wed, 25 Nov 2026 15:25:02 +0100
Message-ID: <20261125143825.247026187@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 9b374e8f99384..9eb28dab46195 100644
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



