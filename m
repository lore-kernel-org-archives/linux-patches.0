Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E74B53CA8F;
	Wed, 23 Sep 2026 14:52:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790175136; cv=none; b=n/K5glrEswJVzKaS7w0OLsKn9T/k6YjQ5ICBgMzItVf8IU2HbeKeDO/DVFbNrA/mbhPLfRvgeSMrQzztc65BOETmZZF+n6yHaufXAquvj9wGmsRV2xR4jYdsJ/jVZmPw+B8EJRLBqGTqBngPpdo4RNZXV03eBk9Do9uoVbHEgF0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790175136; c=relaxed/simple;
	bh=fMMzgCUkvYuZVLPGBwFFTzwJo4pMwWzz35g5PkwKzkc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l2eWsZJUc2IJxqRH2sgmsF4zpt7bgmSIvVjO+3BBA8szxzeypa9wV2xe5BhnNaZAp76ye/GndDmSC0MGyDm5BapFviLk/JFkdzOQyvTi2EwLtZLpvjc2kpw7PnxWghU9xtkUuM1TM/yPvgO09/ZAcWLC6ttDdNnLo8fqo1aI4uA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MtHdyj0y; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MtHdyj0y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7442A1F00893;
	Wed, 23 Sep 2026 14:52:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790175134;
	bh=4uNGvEmdh6iAMp9zkKCZh/cPaFltOA8X1yLc3Dxbklk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MtHdyj0yiDKzu9JYcNODqSS7CWanPHERKovhimSvYRBiEWyZuhHRLMPH+rBT0V+lu
	 vnPfB3n2l3KO4BQbNiyuIRDnWmLrCBkVwGnzD6xuxZexno6s1BKvnf61SjESLAChT1
	 DrWkV2vGtbvH4hVvkY03RKRQc2DmVz8TjRAxhGw4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Lamparter <chunkeey@gmail.com>,
	Shengzhuo Wei <me@cherr.cc>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 6.18 332/398] wifi: p54: require a full exp_if record in PDR_INTERFACE_LIST
Date: Wed, 23 Sep 2026 16:06:46 +0200
Message-ID: <20260923140652.028863973@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140643.441954610@linuxfoundation.org>
References: <20260923140643.441954610@linuxfoundation.org>
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


