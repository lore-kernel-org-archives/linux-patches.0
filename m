Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 449F33E1D1A;
	Wed, 30 Sep 2026 19:27:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790796472; cv=none; b=T9iNLlhrUEVJWc++zxZtFPQl5zAs07H9rnRbfXDMU2Fj9X50aj/BhU66MVn/7eX47s3puYIIwt6SE2xZYBr6qkcrS4RUvKM9D0RgiJWq1BfVubFOlaLcWrOYoqu5djsQazQI9TqkIR1KRFJCWT6c5ngNP6kTVW0aX4xYkozVV/g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790796472; c=relaxed/simple;
	bh=c06rA3vHpeGLSGZ3gLdZSbOeVVg04QspXKa+iJJ1TnA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HTTcR9EZEP1F7q7X65+4j6ecXTO2NTTmGKvuLGsNLvE3gohjCxM1KX3380zDINYVNxL6XqbSYMv+NnMT4vqxN64efrx0+PeSh9WnUDB4n2OPHkze70ouQZyGRB0oMZxC71imEeBKsEvtWX7dSWgNjdTy8W8gfh+NK9vAY9Azljo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RW2MCnNV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RW2MCnNV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F9261F000FF;
	Wed, 30 Sep 2026 19:27:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790796471;
	bh=hBK0WDrSWZ800js6C70HtY8ppLcNLLYJnyWNZeRR29c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RW2MCnNVhYLVPlu0eFeJomU0ViAFkcVTCCMt3P5JPRtsxwNXWWvUmc6jz36+EXG7p
	 b2cFqS+NMp+eXBeZlNMksATJBQFURrjVe37QmsLTLM99TBHC9c7vfzarQzgj6X422Z
	 rExqRwXijzLitEUtwxpaeAjh+tmdpITULLEEGVuw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Lamparter <chunkeey@gmail.com>,
	Shengzhuo Wei <me@cherr.cc>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 6.6 0925/1193] wifi: p54: require a full exp_if record in PDR_INTERFACE_LIST
Date: Wed, 30 Sep 2026 17:26:49 +0200
Message-ID: <20260930152454.792509374@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


