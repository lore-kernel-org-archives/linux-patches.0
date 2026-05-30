Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 262363AFB13;
	Sat, 30 May 2026 18:28:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780165685; cv=none; b=CeDqkm/oKQoXA3s+b7wBI2yvpfBvJTme7TDDWbR2DYivqiMG2x2TOhC1rcfz4Kgy+IS0Sv+pYD4HV3m0pwCogZdBGCc/mIjf/upJKi7dQAZgl/zhD1G/LcXcBIpxavt/h7RYdV7cXJEDNC8SenvIq8cBZxerSnEeYqiPLmCDuoc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780165685; c=relaxed/simple;
	bh=oLh8POd7fSQ73s+Agjj5amPuUZ9BFfeAwckK5is4frE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c1OpO828hoUvcsD1uKev4DFSFOHOrzzVonp6j09HNGv0JhHEjkAEW4UxaSvxsL/Cn9Li5cGN07d+tTTAo+djIjo7Lk0hxmW6v0rP0wOk1vpW8H1o2ZXEOlzcQsXzFL4n0cHQagU3DAVPKgplCCBEAwY6z5qgsZ4oEfQI+/bTAtc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GzPHR8qq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GzPHR8qq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6ED941F00893;
	Sat, 30 May 2026 18:28:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780165684;
	bh=nuExfUXSWwjg9TyvWghTfbdy+hXxNywoHREauPgvQt0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GzPHR8qqQwIrGskmyV0hSWCnL8lTTdce6wUpYln2WXEEkmNhP2xtsaXkRoKJ2lpjE
	 atPoduHgirfadmyIEIbzDylbZfy/hVWu17/dP/s4yhCUY1colJsZJFYCZOSI/Nc8pB
	 odmPBa//0iI72T/R+xYX3q2OrpsxdP4ohnqT5+Q8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ziqing Chen <chenziqing@xiaomi.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.10 152/589] ALSA: control: Validate buf_len before strnlen() in snd_ctl_elem_init_enum_names()
Date: Sat, 30 May 2026 18:00:33 +0200
Message-ID: <20260530160228.783768135@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160224.570625122@linuxfoundation.org>
References: <20260530160224.570625122@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1387,6 +1387,10 @@ static int snd_ctl_elem_init_enum_names(
 	buf_len = ue->info.value.enumerated.names_length;
 	p = names;
 	for (i = 0; i < ue->info.value.enumerated.items; ++i) {
+		if (buf_len == 0) {
+			kvfree(names);
+			return -EINVAL;
+		}
 		name_len = strnlen(p, buf_len);
 		if (name_len == 0 || name_len >= 64 || name_len == buf_len) {
 			kvfree(names);


