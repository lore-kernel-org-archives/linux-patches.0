Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 987B63DA7D7;
	Mon,  4 May 2026 13:56:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777902971; cv=none; b=FwE2VLr8XcTVxBdWL9domFw5WjyEtE2XDAKqkI3NbCaRjW2vy2vczPR0T69n3pvTx6uGfqd3LJGCnWT9uvhoV00dVfGogAl93nyKdV5nYqcJqcTstLkYcn5KY83ga1YIoW4zJHgWzUQqTdWJvS4bp1a79YfnaSkc6BlIKgqa7MM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777902971; c=relaxed/simple;
	bh=FNv/nWvLESziXShTne8eJmQo0QSYwosMU6JYRJUBVZ0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MJx4k6/Q/3Zr1sAoSCv2sgWDw5oy4LQON/XMJXsyMdV3Xvl2F17aQZtk4ILcJwYMvA05/Yc9G22BAzPpVPdCjOI1HrpIamRsMItEqF2K6/Ch2TMFNrXo5deZKqZBl7F31Ry2LhHqlwa2LcLBllpI4Ftu+PP8Zcif7NDq8Bo5nN4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZCGHGRCd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZCGHGRCd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E29FC2BCB8;
	Mon,  4 May 2026 13:56:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777902971;
	bh=FNv/nWvLESziXShTne8eJmQo0QSYwosMU6JYRJUBVZ0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZCGHGRCdi5qSRMZ+M12VG+88vHs2r0Wl6s+mFiI5fwy5QBqESTKUixRMfB3xhuMLn
	 w6JphfLMX7SCXc2zJS1sY6qinnLWE9GuS+9UQoiYs0UI2nGBSyR92mk1b6wwJol9IA
	 Gc2iAt6rXM9YImhe6FrAZJNn+s01n+S/p6zbOjXs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ziqing Chen <chenziqing@xiaomi.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 7.0 053/307] ALSA: control: Validate buf_len before strnlen() in snd_ctl_elem_init_enum_names()
Date: Mon,  4 May 2026 15:48:58 +0200
Message-ID: <20260504135144.820581089@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135142.814938198@linuxfoundation.org>
References: <20260504135142.814938198@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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


