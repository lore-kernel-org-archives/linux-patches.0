Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 367E350EC15;
	Wed, 30 Sep 2026 16:36:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790786173; cv=none; b=OI2INeOwXq82Q93403OFjx2zNbXS8mIADbV0m4O4nV2DXgho+AkLaErn5+lPodBp8rQ4EvZrTsLujLYIzp7avXs3ky+mFLEnkTFocWLmvRaM9Xfvira6KD3AR2OcCH71dkggVj5JeuJ/Cy+oHl1W0Ik9J+m2MIF1lDM0zi7haVg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790786173; c=relaxed/simple;
	bh=HJvh88uDmdnCHd1llQfvvDIF6jPlN1OGHG6UNPY2lZY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S3wnBY+vju8GbsWmCahHKt1fvO6SU+VkRIQValB/HDe6t8I5D3RTiWoRI8/Ymo0YwPGUmmZIovPV05FDMmceGN/0Kv+v7KLJS8SOSul3M+KW4engd+YEsHMgEDFb8D8gY70A6uD920tyFeaujpOcdhtgKabSj0EpIkKUHJSDdbQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KgL289aR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KgL289aR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C8851F000FF;
	Wed, 30 Sep 2026 16:36:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790786172;
	bh=HBakjd0MXk/3hnykihY5bK1pQfrn2u6SPd+iGZzbP+0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KgL289aRzcrMflSQigpl57NqWgoCcRKYetDUNyJhO196o8huUOwWI61GS+HBnGQgq
	 6rVB9hjMuPxinknkTQPuX+zNQfCkRdzT9BcClf8lUlKzBYV4rbfpCLk/QTC7IqwYCk
	 0CBwy7Vphy31jXCa1gktbcYk77NGWq5Lo+zMCbjY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Lamparter <chunkeey@gmail.com>,
	Shengzhuo Wei <me@cherr.cc>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 6.1 767/982] wifi: p54: require a full exp_if record in PDR_INTERFACE_LIST
Date: Wed, 30 Sep 2026 17:25:03 +0200
Message-ID: <20260930152433.228867840@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shengzhuo Wei <me@cherr.cc>

commit d8efd84f49379ed28624098821f80e992657d935 upstream.

The PDR_INTERFACE_LIST loop only checks that the record start is within
the entry before reading an entire struct exp_if from it. A truncated
trailing record makes the if_id/variant reads cross the entry boundary
into the heap beyond the EEPROM buffer (verified with a KASAN
reproducer of the loop). The variant also feeds the synth front-end
selection, so this is not only a leak.

Advance only while a full record still fits in the entry.

Fixes: eff1a59c48e3 ("[P54]: add mac80211-based driver for prism54 softmac hardware")
Cc: stable@vger.kernel.org
Acked-by: Christian Lamparter <chunkeey@gmail.com>
Assisted-by: GLM:5.3
Signed-off-by: Shengzhuo Wei <me@cherr.cc>
Link: https://patch.msgid.link/20260831-p54-pda-validation-v2-2-dae566b388c8@cherr.cc
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/intersil/p54/eeprom.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/net/wireless/intersil/p54/eeprom.c
+++ b/drivers/net/wireless/intersil/p54/eeprom.c
@@ -816,7 +816,8 @@ int p54_parse_eeprom(struct ieee80211_hw
 			break;
 		case PDR_INTERFACE_LIST:
 			tmp = entry->data;
-			while ((u8 *)tmp < entry->data + data_len) {
+			while ((u8 *)tmp + sizeof(struct exp_if) <=
+			       entry->data + data_len) {
 				struct exp_if *exp_if = tmp;
 				if (exp_if->if_id == cpu_to_le16(IF_ID_ISL39000))
 					synth = le16_to_cpu(exp_if->variant);


