Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795018087;
	b=eQVxMb4lj9io7RygJbAYL7ZPBviLfWVo3O4LFBpXvdm0DSvV3bSibCoSD8oHt/akrOAO
	 6CGIfWziPKQxW8vEplscmwbaBgRfqTGWEmR84lSDZY07zKyPxioegt4bGQw6tmg8RuINJ
	 vCUMtzv7sWbyrs/RKJGddBFI+61dOUnXs9Sc6HiIF87zKCYLvS+/kIxGHKEs5m065wlOw
	 oUQHeqB9W5YlyKT/vUli4fcN2rMKmAdvVRDmY7U5r8D+Pz6XWdAKZyFOR74vCkXYBZuMv
	 BOLtQ43LzKRC8JI/SKC0YYE/+srEY1noHH/nPAQYzQ2ooR/8SqZJTvzSBW7bnfMBXcQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795018087;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=kHvENBbuL5Kk/XizUlCT6FliX7rdWAtWNg/4P1V4IFI=;
	b=10oTulXt+tIRgP5jBO3DxDxZMlRJj/hjEEH40tsUHaNxkSENqEfz5KpETDRIEMgE0T24
	 IGlgjlHd7lg7YBuhl7CA/eaCdLYfX9/srU8cX1EiOkkasp7B4cRTUk6un1XoxaMYwwz5J
	 xpLnqvyiD4KVG6Kh3MCQflCpixE2LMEJ7ri7B96DsQexNz1GQ8idGE4JiyrSAjtpHo48U
	 bdHpuRqjOXEX6g6NgykSB0AS7QHOnp3MbmmPSfR92QFijKoEuOb4bL2SgLpXrEyvhLU/C
	 R5T1IOV67mLX0RyuibYo0QSfs1lGKPrgHAS0Tja0puFP/zu/i3CyQUvK7poEzHHpwKQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mjCpzNdi;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BBA3606A32C;
	Wed, 18 Nov 2026 16:08:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mjCpzNdi
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F56B1F000C4;
	Wed, 18 Nov 2026 16:08:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795018086;
	bh=kHvENBbuL5Kk/XizUlCT6FliX7rdWAtWNg/4P1V4IFI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mjCpzNdiqa/oQbw35AUyAMUkkvuH9aljNR/j1IHF9dfQH4k3E7mVxnVnMVSPeJ5VD
	 eoQCERqJUCfItzMpMCReQ7fipmCyLp5tJ/jQ1cRRyTCoz7T67QdBIP3n8qswsgF2rE
	 MLpGrpRisn6JqAhQrzyC6ysMMxJLC77UxY4KWMMg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexandra Winter <wintera@linux.ibm.com>,
	Julian Ruess <julianr@linux.ibm.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1091/2651] s390/ism: Zerorize dmb at allocation
Date: Wed, 18 Nov 2026 15:38:51 +0100
Message-ID: <20261118150327.277726198@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexandra Winter <wintera@linux.ibm.com>

[ Upstream commit a0227fa24e8a2a0397cc4eb669731ff8d9161bbd ]

Sashiko reported [1] that 'Missing __GFP_ZERO in folio_alloc() causes
uninitialized kernel memory to be exposed in the receive message buffer'.
An ism dmb is receive-only, so the data is not leaked to a remote peer.
In general the smc kernel module (dibs client) will only push newly
received data to userspace. We still should not have uninitialized data
in a receive buffer.

Since
commit 750afb08ca71 ("cross-tree: phase out dma_zalloc_coherent()")
dma_alloc_coherent no longer required the __GFP_ZERO flag, but when
commit 83781384a96b ("s390/ism: Properly fix receive message buffer allocation")
switched to folio_alloc(), it should have added back the __GFP_ZERO flag.

Add __GFP_ZERO flag and state in dibs.h that register_dbm() provides
a zerorized buffer (dibs_lo already does).

Link: https://lore.kernel.org/linux-s390/20260903143746.A5CC41F00A3A@smtp.kernel.org/ [1]
Fixes: 83781384a96b ("s390/ism: Properly fix receive message buffer allocation")
Signed-off-by: Alexandra Winter <wintera@linux.ibm.com>
Reviewed-by: Julian Ruess <julianr@linux.ibm.com>
Link: https://patch.msgid.link/20260928151420.383105-1-wintera@linux.ibm.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/s390/net/ism_drv.c | 3 ++-
 include/linux/dibs.h       | 6 +++---
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/s390/net/ism_drv.c b/drivers/s390/net/ism_drv.c
index 035b233abb4e9..405abd99c820e 100644
--- a/drivers/s390/net/ism_drv.c
+++ b/drivers/s390/net/ism_drv.c
@@ -256,7 +256,8 @@ static int ism_alloc_dmb(struct ism_dev *ism, struct dibs_dmb *dmb)
 		return -EINVAL;
 
 	folio = folio_alloc(GFP_KERNEL | __GFP_NOWARN | __GFP_NOMEMALLOC |
-			    __GFP_NORETRY, get_order(dmb->dmb_len));
+			    __GFP_NORETRY | __GFP_ZERO,
+			    get_order(dmb->dmb_len));
 
 	if (!folio) {
 		rc = -ENOMEM;
diff --git a/include/linux/dibs.h b/include/linux/dibs.h
index d3e0777f25ae0..0c10c224bccad 100644
--- a/include/linux/dibs.h
+++ b/include/linux/dibs.h
@@ -261,12 +261,12 @@ struct dibs_dev_ops {
 	 *	@vlan_id: deprecated, ignored if device does not support vlan
 	 * Upon return in addition the following fields will be valid:
 	 *	@dmb_tok: for usage by remote and local devices and clients
-	 *	@cpu_addr: allocated buffer
+	 *	@cpu_addr: allocated, zerorized buffer
 	 *	@idx: dmb index, unique per dibs device
 	 *	@dma_addr: to be used by device driver,if applicable
 	 *
-	 * Allocate a dmb buffer and register it with this device and for this
-	 * client.
+	 * Allocate and zerorize a dmb buffer and register it with this device
+	 * and for this client.
 	 * Return: zero on success
 	 */
 	int (*register_dmb)(struct dibs_dev *dev, struct dibs_dmb *dmb,
-- 
2.53.0



