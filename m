Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1F5A2E7390;
	Sat, 30 May 2026 18:21:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780165280; cv=none; b=L3TX36v0BjYYrEXZD3IGn+JdL4i9wA2T5SPFAgv7po9iWIe8jXU0w87t2+oz13SkAaXVVLJgPiuxwOLCljFqVpxV1Pg2j2W8XFQiPB2n3KhIG121lT4RvVvyJBI89ueLWgUGQ5oZbHMG3wXtKWx/G4jidnsG2GEi6cCZd74Kwy0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780165280; c=relaxed/simple;
	bh=LC8nYf3II/3iCH3xypaufJepryUCFcvimGUfmvbZYyo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l2d8NHO+z3b4wpAGaMUYyyC75SFWjUBnyrWFIrykLmsLtPGu294hExh/FRQw3OWjVc/t2a9DsmC8aQ3TjQTutRQqfPYNwBCjRehXlRrbTwVpQfqnK4LeMLiZZILjhAt95Ila5TWJ+y3zi1fiSSKutFPw0ENPnOq3QXB9npWGCJ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=s6xnAUoM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="s6xnAUoM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E4381F00893;
	Sat, 30 May 2026 18:21:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780165279;
	bh=/ijhUwSq/7jqBaIMgBY4Z9ANLQAtq00kontjcj46kNQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=s6xnAUoM5i4HZSNFM7a973hceGUVliaB99yQPa19UIQKmsj6l10Q1ajm2kQeZYrBA
	 MwYeBmDrUzmb/rDVwTC4rM0YG4Cv5IeKsOLsjHKWNENwSyMmK+V8wRVMK7Z+Mli6fq
	 p2zB/J0Yrqttom0JNcqas56cCxV2Rvaa78uf/UFo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Arend van Spriel <arend.vanspriel@broadcom.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 012/589] wifi: brcmfmac: validate bsscfg indices in IF events
Date: Sat, 30 May 2026 17:58:13 +0200
Message-ID: <20260530160224.901479845@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160224.570625122@linuxfoundation.org>
References: <20260530160224.570625122@linuxfoundation.org>
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

From: Pengpeng Hou <pengpeng@iscas.ac.cn>

[ Upstream commit 304950a467d83678bd0b0f46331882e2ac23b12d ]

brcmf_fweh_handle_if_event() validates the firmware-provided interface
index before it touches drvr->iflist[], but it still uses the raw
bsscfgidx field as an array index without a matching range check.

Reject IF events whose bsscfg index does not fit in drvr->iflist[]
before indexing the interface array.

Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Acked-by: Arend van Spriel <arend.vanspriel@broadcom.com>
Link: https://patch.msgid.link/20260323074551.93530-1-pengpeng@iscas.ac.cn
[add missing wifi prefix]
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/fweh.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fweh.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fweh.c
index 1285d3685c4f5..51260a0c8e0a7 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fweh.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fweh.c
@@ -151,6 +151,11 @@ static void brcmf_fweh_handle_if_event(struct brcmf_pub *drvr,
 		bphy_err(drvr, "invalid interface index: %u\n", ifevent->ifidx);
 		return;
 	}
+	if (ifevent->bsscfgidx >= BRCMF_MAX_IFS) {
+		bphy_err(drvr, "invalid bsscfg index: %u\n",
+			 ifevent->bsscfgidx);
+		return;
+	}
 
 	ifp = drvr->iflist[ifevent->bsscfgidx];
 
-- 
2.53.0



