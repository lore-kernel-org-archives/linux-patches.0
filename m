Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27D033A255A;
	Wed, 23 Sep 2026 14:32:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790173942; cv=none; b=JOBhRE1hiUtQNPQ4hOr6c9Cxvkvnnn7DwNCKujYLE5YKB1tf/7SVk9rPWl+aKyIm9H1zQ7BRjzlD1PrcNQdFnQnPDCtMz42Xw2byrEXFk1lJAiNmEQzWQJDIGfwwBNBBPGlmNwtllltWc7Da78X7Euc3MjA8+b7DsY1PKMKGA7E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790173942; c=relaxed/simple;
	bh=zXhSoWgF/3LYnd0julyhEkYvON/uSExVcerWE91fWM4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oD+6lqApq4UstxJxMrnF/y84XAfcjPIC8zR0f3d6nBInkFEYh+7WZH57hFjrQmXxYxP4w0Kx245wTsWp2iB6U6F+o6puirG50E28pW+JY5llys6YtW/DVTr0cS0qVcPMnL+P7w94Q9iFmXMod4wlLXJiUeLcXtagXImwDJqUNHU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lsxOgfyu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lsxOgfyu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72A461F000FF;
	Wed, 23 Sep 2026 14:32:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790173941;
	bh=PuY6D7mM2CIiMsZOVXX4bRfO6n8bBkOCo6wsdcfUCbA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lsxOgfyu7hxV6y3bXguvdrgraZBQlrtBqD1KcfQa7E3yVUvpvOXoIAXbZY5fLUwv1
	 QLugiex5VRDlrTxD6kfSqGnFlcDe6f+7aD0mx2c1kBfFXUvHhm78aWbZrVvcqqjosq
	 N3ZAbsZAyeSif06k5ptyx74sTaR1fdpBD4CR35jA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Lamparter <chunkeey@gmail.com>,
	Shengzhuo Wei <me@cherr.cc>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 7.2 392/438] wifi: p54: require a full exp_if record in PDR_INTERFACE_LIST
Date: Wed, 23 Sep 2026 16:06:53 +0200
Message-ID: <20260923140655.042265893@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140644.756254324@linuxfoundation.org>
References: <20260923140644.756254324@linuxfoundation.org>
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
@@ -812,7 +812,8 @@ int p54_parse_eeprom(struct ieee80211_hw
 			break;
 		case PDR_INTERFACE_LIST:
 			tmp = entry->data;
-			while ((u8 *)tmp < entry->data + data_len) {
+			while ((u8 *)tmp + sizeof(struct exp_if) <=
+			       entry->data + data_len) {
 				struct exp_if *exp_if = tmp;
 				if (exp_if->if_id == cpu_to_le16(IF_ID_ISL39000))
 					synth = le16_to_cpu(exp_if->variant);


