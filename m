Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5963425B0AA;
	Thu, 20 Aug 2026 15:24:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787239480; cv=none; b=WY4ODHfHZAZIKvdDptR4SiClKNIMQ7EPi4alZJnHk26cuSH+YAYYA6cz7aIlvuUKxJivuxWOa4UhXZ0sRto1veV97HZtsFNjjbucqunpc/9qhTF6PN1BseE5whnU/tyi8J+wdH49H6A4GzOvuqa+iiKuV4ssJnLbxCrtFqzHoz0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787239480; c=relaxed/simple;
	bh=S2YnSix5WrKo5GADFlj95zszWixUJK77l1G8TD/e1/4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uwTWT25EiwMLf0ZiOHClWwIvWo6yQ1c6X+6vqIB3U7fSG/4PR1kk9is/0GjGGF/f1GQUORtLamXB11NmoVkD7FgGnrlFsRpyLajq123E+kPr72D3kJvcUcIDXuPFhc4FPXi86jUWY3adD5/4l0ZbQWpTX6sEszsjFmulZj5FHXI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aElDQ5Ks; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aElDQ5Ks"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 713441F00A3A;
	Thu, 20 Aug 2026 15:24:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787239479;
	bh=t5Et/VPG6pC0O2xB15SJlKeOliYzAECvDMtjwlRJF4Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aElDQ5Ks36mVEqEjhMgGUpO8PPAo20FzRqqPPtlZySVqOThMzjn7DcwQMtMEfMq+O
	 xdfORcUAbR0eLgr+prWIp8KxO2Qtanp/Sk5cEfzhjYUt0WfSxc1cjgUmJRANGKIL91
	 rH0uA3+3pmqedjD2bhRjxWgwk9vXPQpD+z6NCYCA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Erni Sri Satya Vennela <ernis@linux.microsoft.com>,
	Simon Horman <horms@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Hamza Mahfooz <hamzamahfooz@linux.microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 013/220] net: mana: Fix EQ leak in mana_remove on NULL port
Date: Thu, 20 Aug 2026 16:53:23 +0200
Message-ID: <20260820145223.893784336@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145223.480031205@linuxfoundation.org>
References: <20260820145223.480031205@linuxfoundation.org>
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

From: Erni Sri Satya Vennela <ernis@linux.microsoft.com>

[ Upstream commit 65267c9c4f28199985505977bc2c628c82fc50ef ]

In mana_remove(), when a NULL port is encountered in the port iteration
loop, 'goto out' skips the mana_destroy_eq(ac) call, leaking the event
queues allocated earlier by mana_create_eq().

This can happen when mana_probe_port() fails for port 0, leaving
ac->ports[0] as NULL. On driver unload or error cleanup, mana_remove()
hits the NULL entry and jumps past mana_destroy_eq().

Change 'goto out' to 'break' so the for-loop exits normally and
mana_destroy_eq() is always reached. Remove the now-unreferenced out:
label.

Fixes: 1e2d0824a9c3 ("net: mana: Add support for EQ sharing")
Signed-off-by: Erni Sri Satya Vennela <ernis@linux.microsoft.com>
Link: https://patch.msgid.link/20260420124741.1056179-6-ernis@linux.microsoft.com
Reviewed-by: Simon Horman <horms@kernel.org>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
[ hmahfooz: resolve conflict in mana_remove() due to missing commit
  3b194343c250 ("net: mana: Implement ndo_tx_timeout and serialize
  queue resets per port.") ]
Signed-off-by: Hamza Mahfooz <hamzamahfooz@linux.microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/microsoft/mana/mana_en.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/microsoft/mana/mana_en.c b/drivers/net/ethernet/microsoft/mana/mana_en.c
index 476f7ff0648ea..70fe4d837a0b6 100644
--- a/drivers/net/ethernet/microsoft/mana/mana_en.c
+++ b/drivers/net/ethernet/microsoft/mana/mana_en.c
@@ -3011,7 +3011,7 @@ void mana_remove(struct gdma_dev *gd, bool suspending)
 		if (!ndev) {
 			if (i == 0)
 				dev_err(dev, "No net device to remove\n");
-			goto out;
+			break;
 		}
 
 		/* All cleanup actions should stay after rtnl_lock(), otherwise
@@ -3039,7 +3039,7 @@ void mana_remove(struct gdma_dev *gd, bool suspending)
 	}
 
 	mana_destroy_eq(ac);
-out:
+
 	mana_gd_deregister_device(gd);
 
 	if (suspending)
-- 
2.53.0



