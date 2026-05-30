Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C48F3332919;
	Sat, 30 May 2026 16:51:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780159878; cv=none; b=PZnqBBVYkEzgoPxhhc69YsbaM/OTo+UkeiYc3HcGWd3y+jZ+GfRQJhhGsDqu09Gh8SP3aaPzMXRq+Arzfptka6UV2huB7btOLy5Y0UoTbqoyPHIEXyrUIo878NBb3MvUYGOVQNYPW/joXRDZMNWdTc3KBerm7aaLsIuR6IAk46s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780159878; c=relaxed/simple;
	bh=dvQgvXOI4/ywIAqosu3JkKdKfhSBTU0fwa6e1jtNmyo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZxOjl8uVY4kX3YgC+JRghUp7SP5BtuWr1bnjo3X29dlHHEdgN7G3WObWqRO+brI1hpeBZhDZfgDE4PrvST4vqEzNceOdc4WMU9ximr7f0HnX+ajg+Apk/0+s+x55gly10hPMYRAQtHNl5IZhnTVJNz1xl0npG/M8p9waH2Q8/Mw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gFFop0hN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gFFop0hN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 025651F00893;
	Sat, 30 May 2026 16:51:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780159877;
	bh=8Rnv8jCengNljbgE/h34VvLOKIXLDVt0w0vidyn/8YA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gFFop0hNQ1xwMOtxw6PL307t7QO3kPH89TpLl3db1BhcWE40KbRN0NAzusROBR8Mq
	 RhDscauTPtHZlbF3w+Wg1tl36Q4T+IrCTd01DrOwjUh4kBanULmDdw8pABP/NQk8GJ
	 Dp/qC5BMgTyYFYC2FD0In9uq0A5ZtIwUyppL+01A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ziqing Chen <chenziqing@xiaomi.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.1 185/969] ALSA: control: Validate buf_len before strnlen() in snd_ctl_elem_init_enum_names()
Date: Sat, 30 May 2026 17:55:09 +0200
Message-ID: <20260530160305.596652290@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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
@@ -1592,6 +1592,10 @@ static int snd_ctl_elem_init_enum_names(
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


