Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66BF13AC0FC;
	Sat, 30 May 2026 17:54:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780163654; cv=none; b=ruY37yJ5AkQp8FXwPkeihedz0A75aEV8+o06Ly2rMCWWgnq7lCvKmrsJTGuZt0jqt+M5haWyK1diKIB4zgGcjzUjPJ37FUg4kGsWTkfp11oCUoAS+TBr3u5Q4uJGRgF+0zoVWNxqtH9sE/5Yu3YmX4T/n5cbfN5KhJN88JkswDo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780163654; c=relaxed/simple;
	bh=q9se2IIZ7FETe/hA2avfMeFn+2+P7SZh2zS+uyj7hGo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TWdiDlzQ4/28hkPkWVjcXkV19CKn5uMKrhGUdXMUvzU49PdSuI0+T1bjzW9mrDJn4eJXLY60z8aUFWmOgBuMEt4d/pL8k0ZnUJXKHR3bpCbOaCFYvEXJfCQFLmjJJ3nPp+fsLhFEQWJ3VnIfKVQ+jV2H8ixVr6BwS33QJ3egalM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=y3TBDZzz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="y3TBDZzz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85F751F00893;
	Sat, 30 May 2026 17:54:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780163653;
	bh=SWv71lkGny0WkqVI0uH6s571LQagKdTeYHfzFORz8T4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=y3TBDZzz3EGca7KkduMUXtt2sWYjMhQhq2f6FNt9f9MbbK7bCw2JJ3JhiPCZyb/44
	 K+GkO0aH42uV/MEllFFLKsUQGvTfDd96UCGRs8etawe45NBZhad0l5BdIDGWaWV//J
	 GAe/eAcPd0CSHzASQBXEPOl53QD8o1etPbqicLJ0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.15 295/776] ALSA: usb-audio: Avoid potential endless loop in convert_chmap_v3()
Date: Sat, 30 May 2026 18:00:09 +0200
Message-ID: <20260530160248.186498353@linuxfoundation.org>
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

From: Takashi Iwai <tiwai@suse.de>

commit 6e7247d8f5fefeceb0bb9cc80a5388a636b219cd upstream.

The convert_chmap_v3() has a loop with its increment size of
cs_desc->wLength, but we forgot to validate cs_desc->wLength itself,
which may lead to potential endless loop by a malformed descriptor.

Add a proper size check to abort the loop for plugging the hole.

Fixes: ecfd41166b72 ("ALSA: usb-audio: Validate UAC3 cluster segment descriptors")
Cc: <stable@vger.kernel.org>
Link: https://patch.msgid.link/20260427152224.15276-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/usb/stream.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/sound/usb/stream.c
+++ b/sound/usb/stream.c
@@ -352,6 +352,8 @@ snd_pcm_chmap_elem *convert_chmap_v3(str
 		if (len < sizeof(*cs_desc))
 			break;
 		cs_len = le16_to_cpu(cs_desc->wLength);
+		if (cs_len < sizeof(*cs_desc))
+			break;
 		if (len < cs_len)
 			break;
 		cs_type = cs_desc->bSegmentType;


