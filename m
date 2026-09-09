Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82E124F55A5;
	Wed,  9 Sep 2026 13:48:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788961734; cv=none; b=eklHCjd9kqDearvTTHvr49Gu2918uPo4Dmg05w00m5x4bmfqJ4ikSdmtXf3ixGpypQicL7DUOlFM/ZVMlBj0R4i3rOyWikH6J5YJgtVA5mAXKWX4s7ShUXMNbN4cHH+CDKs+eBtpuBLPSkn5RsdcBFkiiIXxMFaQQOiI2uAdfGE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788961734; c=relaxed/simple;
	bh=BacD3PNHngXu41RDDyEyoAg04ylkciJMVIIQMr6aEC4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pcoqEq8CIV1IvOsdIpubUTOp3ns+YBjTOy0lQfLncsSGrlUBPBrGe04Xy1/w2Bs2Lf6/q4GdsFcNP+L5UFwWZB1kXc+JI72/2xlKsBs37IB/5UISTXDye7Hn9mQqxCruqrCuzJ+UBXs2wCbphrF/CziPlbZ7WnraCz9nSpy49to=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bxxnJful; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bxxnJful"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC6791F00A3D;
	Wed,  9 Sep 2026 13:48:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788961733;
	bh=7tFfL2Qi+qizVc6aatPmp6Q7e3cJ8dS6AGdYSbqff48=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bxxnJfulV1o98YDMB0gB1X0qFtD5NqLLa9rBil+wbd7tJCn2cpt4Lf3jcJ2IKvOG4
	 MLfwU6m64FZIkxo35oAB2wmYgd8VFu8zqoKswoEK7Zfef1UqFQ4A07i+gwYuCvKz61
	 tVS2Bp89B7sx9upZ7nF/QQVRKOUj3/g0NSnAXlmc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Muhammad Bilal <meatuni001@gmail.com>
Subject: [PATCH 7.2 050/556] staging: rtl8723bs: fix OOB read / stack overflow in rtw_get_wps_attr()
Date: Wed,  9 Sep 2026 15:35:30 +0200
Message-ID: <20260909134232.238926607@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134230.441546314@linuxfoundation.org>
References: <20260909134230.441546314@linuxfoundation.org>
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

From: Muhammad Bilal <meatuni001@gmail.com>

commit 99aa998dec83ba180822f70e6d48a514fc81c20d upstream.

rtw_get_wps_attr() walks WPS attributes inside a WPS IE taken from
a wireless management frame. For each candidate attribute it only
checks that the fixed 4-byte attribute header (2-byte ID + 2-byte
length) fits inside the IE:

	if (attr_ptr + 4 > wps_ie + wps_ielen)
		break;
	u16 attr_id = get_unaligned_be16(attr_ptr);
	u16 attr_data_len = get_unaligned_be16(attr_ptr + 2);
	u16 attr_len = attr_data_len + 4;

attr_data_len (and therefore attr_len) is read directly from the
wire and is never checked against the remaining bytes in the IE
before being used as the size of:

	memcpy(buf_attr, attr_ptr, attr_len);

Since attr_len is fully attacker controlled (0 to 65535+4), this is
both a heap OOB read of wps_ie, and, more seriously, a stack buffer
overflow at several call sites where buf_attr is a single-byte
stack variable, e.g. rtw_get_wps_attr_content()'s callers passing
WPS_ATTR_SELECTED_REGISTRAR into a stack "u8 sr"/"u8
selected_registrar" (drivers/staging/rtl8723bs/os_dep/ioctl_cfg80211.c,
drivers/staging/rtl8723bs/core/rtw_mlme_ext.c). A crafted WPS IE in a
beacon or probe response processed during scanning can therefore
smash the stack of the parsing thread.

rtw_get_wps_attr_content() itself has no independent length check
and simply trusts the attr_len it gets back from rtw_get_wps_attr(),
so fixing the bound here also fixes that caller.

The "attr_ptr + 4 > wps_ie + wps_ielen" header check above was added
by commit 1463ca3ec6601 ("staging: rtl8723bs: fix OOB reads in
rtw_get_sec_ie(), rtw_get_wapi_ie(), and rtw_get_wps_attr()"), which
bounded the fixed header but never extended the check to cover the
variable-length attribute data that follows it. Add that missing
check before attr_len is used as a memcpy() length or accepted as a
match.

Fixes: 554c0a3abf216 ("staging: Add rtl8723bs sdio wifi driver")
Cc: stable@vger.kernel.org
Signed-off-by: Muhammad Bilal <meatuni001@gmail.com>
Link: https://patch.msgid.link/20260728125456.32359-2-meatuni001@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/rtl8723bs/core/rtw_ieee80211.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/staging/rtl8723bs/core/rtw_ieee80211.c
+++ b/drivers/staging/rtl8723bs/core/rtw_ieee80211.c
@@ -737,6 +737,10 @@ u8 *rtw_get_wps_attr(u8 *wps_ie, uint wp
 		u16 attr_data_len = get_unaligned_be16(attr_ptr + 2);
 		u16 attr_len = attr_data_len + 4;
 
+		/* Reject attributes whose claimed length runs past the IE */
+		if (attr_ptr + attr_len > wps_ie + wps_ielen)
+			break;
+
 		if (attr_id == target_attr_id) {
 			target_attr_ptr = attr_ptr;
 


