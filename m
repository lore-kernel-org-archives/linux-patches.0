Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5D973AE198;
	Fri,  4 Sep 2026 05:24:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788499447; cv=none; b=OnkG7+loTttg1eII/jmoftuC9UAI+cDt7HM9ztAi4aR3RVy10IpoL7DXrRaWjv+3IJiAu5EiKffx7NaPLSEW8SFlxmJuAAbiWkKFxXP07z6D+zM1kT7FK3bqf6pUedc3oVcBd81V3AeFEDYqQly7H2z7HOKBzheY2vYujmZj1ec=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788499447; c=relaxed/simple;
	bh=SSbFbPMOBajGKKnlp9q34PTSmG2A4tyfrafYjM2a0yQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bZw4IjYKtc8P4A84odFVnXwB3MqAM6y7owyIEAgLgyEQFHnJWDZIsoIV4/jn47bTfzvZplDDSYRJRPDHbGAVH1aOBWWNRv04LC9Mny4/05gSq/mKeYL7Bs4NmTINSRoy0krCemJ5mu9yO+2UYIf2xSxAPeWqev/kgKyne5MqzwQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uA5+rdXo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uA5+rdXo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A67F1F00ADF;
	Fri,  4 Sep 2026 05:24:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788499445;
	bh=qe77EeOoVY+vLynbJ04hZEKPEowbUOqwRnYOYc3QrQM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uA5+rdXozmrAFePG/NvRQkxtlWSHvH/CroS1hRPORi7iu6e/5TUfE1Kzjdu8L9hqj
	 puuMDg2fRYNdo5O5Iauy1HX1STUGEvF0J9GYFgIC5Bswsm0FL03joJC+hj5RTeRFs9
	 TMYC36Nk6J1yIm8WYD+dX/3N2UAWGiOI6P01sk9Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linkai Gong <gonglinkai@kylinos.cn>,
	Karan Tilak Kumar <kartilak@cisco.com>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>
Subject: [PATCH 7.2 420/713] scsi: fnic: Use GFP_ATOMIC for VLAN alloc under spinlock
Date: Fri,  4 Sep 2026 06:56:28 +0200
Message-ID: <20260904045813.245830235@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045803.810145556@linuxfoundation.org>
References: <20260904045803.810145556@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Linkai Gong <gonglinkai@kylinos.cn>

commit 9639c6324524ea3f934908bd51f02430000954ab upstream.

fnic_fcoe_process_vlan_resp() allocates a VLAN descriptor with
kzalloc_obj() (default GFP_KERNEL) while holding vlans_lock via
spin_lock_irqsave(). GFP_KERNEL may sleep, which is not allowed in this
atomic context and can trigger a sleeping-from-invalid-context warning
or deadlock.

Pass GFP_ATOMIC so the allocation is safe under the IRQ-safe spinlock.

Fixes: 098585aa8aca ("scsi: fnic: Add and integrate support for FIP")
Cc: stable@vger.kernel.org
Signed-off-by: Linkai Gong <gonglinkai@kylinos.cn>
Reviewed-by: Karan Tilak Kumar <kartilak@cisco.com>
Link: https://patch.msgid.link/20260731073820.16449-1-gonglinkai@kylinos.cn
Signed-off-by: Martin K. Petersen (Oracle) <mkp@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/fnic/fip.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/scsi/fnic/fip.c
+++ b/drivers/scsi/fnic/fip.c
@@ -139,7 +139,7 @@ void fnic_fcoe_process_vlan_resp(struct
 			FNIC_FIP_DBG(KERN_INFO, fnic->host,
 				     fnic->fnic_num,
 				     "process_vlan_resp: FIP VLAN %d\n", vid);
-			vlan = kzalloc_obj(*vlan);
+			vlan = kzalloc_obj(*vlan, GFP_ATOMIC);
 
 			if (!vlan) {
 				/* retry from timer */


