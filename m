Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86A984E9C18;
	Thu, 17 Sep 2026 17:37:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789666646; cv=none; b=aqHARh1qNcTJHlO3Cyzt3rWPRDDglawRVkeWzDnSysVZx8CwTgjFnBWc0/EvhOfGUTYOPOm81e9ddvSDIpPVj6m7XYtk+xVu/mzb51ZYOufkvhsFFkzZJGGf5CEGTSylZ5Jb2dftfA57z4FwydEq2zubtj99yQAUvn4G8to3xJ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789666646; c=relaxed/simple;
	bh=wTfxfId6KfxZJVAzjoneZGd8s6opF49JHl5ZeE2SYcI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aAA5StINpSo4qkfXIiaq5oX66SEGMlmQaVaNSlw17jV5LJ6yqiIMWR29cS3OgsN19hqHSfdjfRR09cplhG1wbIhMYsegPeHq4ItMUjytpTFjDJvbpmCWPcFM6ZGX9nx8+aPFW+KpZvk+pi8YJv2gyynH4ZqYT1AWz2ChIdEnbwA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Fqx7eF7i; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Fqx7eF7i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3DAA1F00893;
	Thu, 17 Sep 2026 17:37:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789666645;
	bh=hoEQBBkVRTduzykdNcT4M2NhcWR3viAD4/FFPSKC6kc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Fqx7eF7i8nUEDPenm5JdXrn6IHGS7+FdD56cRfKjAnqLR8ZAM8s1Qg1ngOMk+VKPS
	 vUYgm42uKfFI8VHxoGvhrHvwOvSdQBrh7z6Ipc4RatsEJSvS/kTTxjpz+s8mWoJ2ir
	 rMs7SbPTJiAeLKRTVEmeWuj9ba76xiKgiAxMkpQE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot+sashiko@kernel.org>,
	Joe Damato <joe@dama.to>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 6.18 1068/1250] bnxt_en: Only restore LRO if the device supports TPA
Date: Thu, 17 Sep 2026 16:14:23 +0100
Message-ID: <20260917151621.078538335@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

From: Joe Damato <joe@dama.to>

commit 4e17b5007b6664559cdad2b2fe270526cf786b5b upstream.

With a P5+ device with firmware that reports max_aggs_supported == 0, it is
possible to make LRO settable by attaching and detaching an XDP program
even though the device does not support TPA.

Fix this by testing BNXT_SUPPORTS_TPA before restoring the feature bit.

Fixes: f0aa6a37a3db ("eth: bnxt: always recalculate features after XDP clearing, fix null-deref")
Reported-by: Sashiko <sashiko-bot+sashiko@kernel.org>
Link: https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20260828190900.1767611-1-joe%40dama.to
Cc: stable@vger.kernel.org
Signed-off-by: Joe Damato <joe@dama.to>
Link: https://patch.msgid.link/20260902015652.2421609-2-joe@dama.to
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -4900,7 +4900,8 @@ void bnxt_set_rx_skb_mode(struct bnxt *b
 		bnxt_get_max_rings(bp, &rx, &tx, true);
 		if (rx > 1) {
 			bp->flags &= ~BNXT_FLAG_NO_AGG_RINGS;
-			bp->dev->hw_features |= NETIF_F_LRO;
+			if (BNXT_SUPPORTS_TPA(bp))
+				bp->dev->hw_features |= NETIF_F_LRO;
 		}
 	}
 


