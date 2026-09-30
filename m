Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F97650B437;
	Wed, 30 Sep 2026 17:20:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790788839; cv=none; b=kYrIV8nhcJ7bw0WDsUxonG67a2UbWSjbP8DM2Ut9cpfzJZep0Ouu7sYxLZ+2jfZO7lTKwFzi6dPTKcp5cKY13KXrLXf2b/RaDhzs2BvzvSfqbQ+Mjkvf8qcJBCcA9zJyDFMxhFH7T/ldsFXOrJ1qYPpFWNiwLWxwjVWOezjFw7M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790788839; c=relaxed/simple;
	bh=RJIY+2DB7Mwf6hfR7o2TAIP36t1+o5ZTq8x2J/N1hPw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P2Xo38OFn+RIvZqT9AZYYFuq/Jun1wSoaZp3BE1hpaSipmW8+IZ5r/uM3iAQ3qGbrO5uQQowcG06oGsKhJdE1nM+d9rT3CqW1AXEYh+OyWRLfj+wl5elMs97++wQl3KinJP34zWwywLL+ENGqfzCNOq3q4CrK7UDwDVdqH2Iezs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1Rfk9moU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1Rfk9moU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B97ED1F000FF;
	Wed, 30 Sep 2026 17:20:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790788838;
	bh=BooxwCAj+z2fsq/DWPrm/IR94jz+74nDqwYbf0aSjpw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1Rfk9moUzw4a9Oe2kvL+rqxZy8N21R6pXCVREIjdiTzu86tykcGTiNWX5elDl9nIV
	 UpXxdjX3pAseK3f5pxbADuKflf+pZHZ/xH0Xbq5gLWVLUdpoF2jctcFC/ArRd+TYKW
	 sdMzCQUmY0lC9GCc4qPoEn9VvkBVzm4cPEoo88Qw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Lamparter <chunkeey@gmail.com>,
	Shengzhuo Wei <me@cherr.cc>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 6.12 267/877] wifi: p54: require a full exp_if record in PDR_INTERFACE_LIST
Date: Wed, 30 Sep 2026 17:19:38 +0200
Message-ID: <20260930152420.485970269@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
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


