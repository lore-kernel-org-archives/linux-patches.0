Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57708305678;
	Fri, 15 May 2026 15:57:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778860663; cv=none; b=A4g7Q0g8pWDO6jK64ui1QiIwFlWtpwSv7+CAejCQJ1EW8wWoeoq/PLl35tDFEPUWkjQN/o2bFzty8AJQ5WWTXSTYdyJGok1JtR2fwMMuahSb3G+eRs1exKmwSo8uGyWaSfXOfMMlm+IrIgPZAyFHrA7SrJEaljtL3GZqMF+7veY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778860663; c=relaxed/simple;
	bh=pNMQ+qqIRwXOqBzTYzSp7orRdPqNSKJ24aCUUu0TCI8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iL2+CHrUC9dH6Dr9QY+gbhN9U+s4apNZlO3NrVMXRkvAqyLpfAXM7G6uTQDwLAWKJWDwHteAMmDoJw9yQfENC0ABC2z1QMTcUjZZrdl0N/fQO+5wlcCrP9DDk57xmM4ak8evTpNsvseGwWZ57Dno2+OLlui16luLk5b/QeU51vM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=H1ffyUzb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="H1ffyUzb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1095C2BCB0;
	Fri, 15 May 2026 15:57:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778860663;
	bh=pNMQ+qqIRwXOqBzTYzSp7orRdPqNSKJ24aCUUu0TCI8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=H1ffyUzbp/0Tv8pfUv5FK83x7a1PCoWVGqmjNFjSMQQ8/D+0JMH4SgwSRJrShBERm
	 c7VqZ7KIbJ7LXHPaHqx+P67bqpzHMrV78WWE9pGOmvUHI+gTpiBZLgANQlCjOwiiRe
	 E2gOz9VPP6HFH9bjqLsvSjHyjGumARs73VmGdnDc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ziqing Chen <chenziqing@xiaomi.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.6 032/474] ALSA: control: Validate buf_len before strnlen() in snd_ctl_elem_init_enum_names()
Date: Fri, 15 May 2026 17:42:21 +0200
Message-ID: <20260515154715.744688106@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154715.053014143@linuxfoundation.org>
References: <20260515154715.053014143@linuxfoundation.org>
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
@@ -1672,6 +1672,10 @@ static int snd_ctl_elem_init_enum_names(
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


