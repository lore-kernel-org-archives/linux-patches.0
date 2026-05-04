Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BF5A29E116;
	Mon,  4 May 2026 14:20:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777904442; cv=none; b=QI8eXZdLtCQJ5PlLu0Tt8alvhqEwKGWQoiEkxS2eOEXp2IemLagOizBWEr8GsnpxI+xX4RHH6c2VXTV8x9biFdEBGl4bdjYDo+LI/PXK9/xlgmxWYNm6JJKsJkBSxj/aTUD5B3qtEUsb2EKSN2G0SBnvI3H55xwIpfFTPqMcGno=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777904442; c=relaxed/simple;
	bh=zm3ZHPVTAHWJLoJbDGMVCtOWrZbIH7tF+Q4Q3iYl12s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FWX9w1/LBFEOmM5jss7NJpx9+3uLDixBRlsQIFzJAyGAU0/FSPfaorEXnbTTPSDUBbBNUx8E9DX2BUyNx2fo4B8qJFn1og35gnAim77A89DpSPGDEHunc7As0AwV0jBlWbK4bHM9AjCVk+7wKgcnIHf+Ik3Ke/BOvziOSAVdGy8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=v5+/Asnf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v5+/Asnf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21DCFC2BCB8;
	Mon,  4 May 2026 14:20:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777904442;
	bh=zm3ZHPVTAHWJLoJbDGMVCtOWrZbIH7tF+Q4Q3iYl12s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=v5+/AsnfsQ92GZ+HuJeNi0ng+1ufml3q9qSFjlaWcj7XoHje3fJa2UZT3Ab/xsqZj
	 Eyzy7SUkSXk0OoRMCNUgklYNTgkE/UqKFx7pvTcc+xa9xqQcVOU5M3aYTkLLkNs+BG
	 TBc/55L8LcAyckYH3JhCBdEvf02x5EfRg97r+fbk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ziqing Chen <chenziqing@xiaomi.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.12 041/215] ALSA: control: Validate buf_len before strnlen() in snd_ctl_elem_init_enum_names()
Date: Mon,  4 May 2026 15:51:00 +0200
Message-ID: <20260504135131.682571255@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135130.169210693@linuxfoundation.org>
References: <20260504135130.169210693@linuxfoundation.org>
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

From: Ziqing Chen <chenziqing@xiaomi.com>

commit e0da8a8cac74f4b9f577979d131f0d2b88a84487 upstream.

snd_ctl_elem_init_enum_names() advances pointer p through the names
buffer while decrementing buf_len. If buf_len reaches zero but items
remain, the next iteration calls strnlen(p, 0).

While strnlen(p, 0) returns 0 and would hit the existing name_len == 0
error path, CONFIG_FORTIFY_SOURCE's fortified strnlen() first checks
maxlen against __builtin_dynamic_object_size(). When Clang loses track
of p's object size inside the loop, this triggers a BRK exception panic
before the return value is examined.

Add a buf_len == 0 guard at the loop entry to prevent calling fortified
strnlen() on an exhausted buffer.

Found by kernel fuzz testing through Xiaomi Smartphone.

Fixes: 8d448162bda5 ("ALSA: control: add support for ENUMERATED user space controls")
Cc: stable@vger.kernel.org
Signed-off-by: Ziqing Chen <chenziqing@xiaomi.com>
Link: https://patch.msgid.link/20260414132437.261304-1-chenziqing@xiaomi.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/core/control.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/sound/core/control.c
+++ b/sound/core/control.c
@@ -1574,6 +1574,10 @@ static int snd_ctl_elem_init_enum_names(
 	/* check that there are enough valid names */
 	p = names;
 	for (i = 0; i < ue->info.value.enumerated.items; ++i) {
+		if (buf_len == 0) {
+			kvfree(names);
+			return -EINVAL;
+		}
 		name_len = strnlen(p, buf_len);
 		if (name_len == 0 || name_len >= 64 || name_len == buf_len) {
 			kvfree(names);


