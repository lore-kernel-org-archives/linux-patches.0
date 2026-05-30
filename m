Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71DB319D8AC;
	Sat, 30 May 2026 17:49:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780163344; cv=none; b=e6V15jsaItozn6W4jKyknQZa0FF1Fwq+oxsMtV2gW8qvWyYPIIA6raeINL55eOlhBKKXDhUKYwZbpuLfCnW0beh2YtPQL5RAWERMDCgso0CkCkbjoEzDxIeZocrw7OFxmoSUTuQCZYoijbjImlM3keOqEoELzLauQr2Kx6+TLO4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780163344; c=relaxed/simple;
	bh=eFAi9TwHmFZtJn0ildawts+o49FA8HjyQ8Gcpftxc80=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NrUraoQBMh/XPpwnUNVbdhyx0x0+VUINK6AwFRSbpR8fBNBGBt1hajJoVBeCpVy9WGoxvwlmWy9l0j+7XTwp9MBNvh+DtKMF08jXEvrs7rp2WeUN9djc51JtXzO8KPyTuS8J9A/XlTPOJKggvTaldcUZB2uKFHKrJ/+Rf91ct7M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1YCezCYm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1YCezCYm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79F271F00893;
	Sat, 30 May 2026 17:49:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780163343;
	bh=Dsv0GzrNer3lA4lgHGfklxqMAHUz7GNMfGWKF/zDoHI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1YCezCYmc124DiiZmwdvs3j02U6A1KgFsVzS3yiofOnmSBPlpIdzFnwFkhZAY8sJ7
	 IfC8yIVIIKSpMIAdpZ2fORDyj2h4q6NZ5DljPZaXbThysUXL5fTRKh4rSEOMGSHlM6
	 t03gYv++E+wxIVbdBwhNDSewbETKdM+W61bq6hnY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ziqing Chen <chenziqing@xiaomi.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.15 199/776] ALSA: control: Validate buf_len before strnlen() in snd_ctl_elem_init_enum_names()
Date: Sat, 30 May 2026 17:58:33 +0200
Message-ID: <20260530160245.651827352@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160240.228940103@linuxfoundation.org>
References: <20260530160240.228940103@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1441,6 +1441,10 @@ static int snd_ctl_elem_init_enum_names(
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


