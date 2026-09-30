Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3D6A4E73B2;
	Wed, 30 Sep 2026 17:16:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790788609; cv=none; b=JiTq9QNEATlaN5mzb2b2BFc8jg+9kCV7SNzKkVd7S4WKRU0apYa5b8XtlzkvT5YO91psNdMW47G86nTMqj++GgtzR5+gGyeuB8komsqmZfVNLZQg5Pc28JColwDPGGenq2KeleJjGDvZfEdVblF2WW5H77PZRR+KSuNOPjBX1VM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790788609; c=relaxed/simple;
	bh=ngAuUczOlu9dpjly4iYeRWX9dAbcNtnhbBfg7usXZJA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kWRMRWt+d8DpMj/xjcOg7tJDIQ2eg3ukTvtS1zrcgj80faHfdmLAD4nqpkN3tAkFdq9Ag1d+eHFdcfWO0YabgqcRVP6iAu6UNmueax572nKlpgBYXRW966x4vo4L2KhrLSMZpCcPk5s9WNuryOdJy5Ifyb+J+LU1yW3KyHzP5uc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cCtbPnAH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cCtbPnAH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A8AC1F000FF;
	Wed, 30 Sep 2026 17:16:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790788608;
	bh=PopZ5XH0UuV+h3TSRhgCdvgNzmfVGKTESQv/Hq/xCk0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cCtbPnAHf4bG+HGfmghKLusuHlMffRtQlS43DMdwyBGbaVR+9qQlnqElXCCRKHKma
	 XMNpXE66JBOf8OZ5EzFazGz3lTvzeso4EIPeHZ88aztfpKA0Zd1ostkEqnNz4IXuy+
	 tSLF3wYT6yb5weAI5+5qFH816eackRlwXwSsNrYg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aamir Ahmed <elb12345@hotmail.co.uk>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 6.12 185/877] Bluetooth: eir: validate service data length before reading UUID
Date: Wed, 30 Sep 2026 17:18:16 +0200
Message-ID: <20260930152418.720758289@linuxfoundation.org>
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

From: Aamir Ahmed <elb12345@hotmail.co.uk>

commit e8241766794cf551d787fa3a77c0d54bbea6f6aa upstream.

eir_get_service_data() reads a 16-bit UUID from the service data using
get_unaligned_le16() without first checking that the data is long enough
to hold a UUID16 (2 bytes). If a malformed EIR entry has a service data
field with only 1 byte of payload (field_len=2), eir_get_data() returns
dlen=1. The subsequent get_unaligned_le16() then reads 1 byte past the
field boundary.

Additionally, if the corrupted UUID happens to match, the length
calculation "dlen - 2" underflows to SIZE_MAX since dlen is size_t.
Current callers either pass NULL for the length parameter or bounds-check
the returned length, but future callers may not.

Add a check that dlen >= sizeof(u16) and skip fields that are too short
to contain a valid UUID16.

Fixes: 8f9ae5b3ae80 ("Bluetooth: eir: Add helpers for managing service data")
Cc: stable@vger.kernel.org
Signed-off-by: Aamir Ahmed <elb12345@hotmail.co.uk>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/bluetooth/eir.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

--- a/net/bluetooth/eir.c
+++ b/net/bluetooth/eir.c
@@ -373,7 +373,15 @@ void *eir_get_service_data(u8 *eir, size
 	size_t dlen;
 
 	while ((eir = eir_get_data(eir, eir_len, EIR_SERVICE_DATA, &dlen))) {
-		u16 value = get_unaligned_le16(eir);
+		u16 value;
+
+		if (dlen < sizeof(value)) {
+			eir += dlen;
+			eir_len = eir_end - eir;
+			continue;
+		}
+
+		value = get_unaligned_le16(eir);
 
 		if (uuid == value) {
 			if (len)


