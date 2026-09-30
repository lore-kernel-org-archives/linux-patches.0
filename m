Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49AD8348C6B;
	Wed, 30 Sep 2026 19:24:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790796288; cv=none; b=N9AVC+9q85tBaicziTArsrUkPYLM7FdD8S7WtwXbAJFkppmURjCnb8o4iMAxhRgjcPqhjafGtqQPXURXgxtN4rxWX2GxID9DTZF7snaHFWs5Hk4NWgQBS5jbr0N7W2i2tPDUAjziAURj9SDFZMCPii5BeK9fhDh7gmgQzbwCh+k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790796288; c=relaxed/simple;
	bh=Cfv0l2MMUdw4x6OX0DDgEFOzKYD2VKBeL9QR4Q+gq0k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S6J/PnAogh88CJ5eczF6wdVXuHFmu42mx8vLB1OC9lvtFGAXYrtbI1GswTfjSOOnvC8GtEgDLriJ3Yej6ZmwhZUWlavuOS7qR9gWxWwjmZD0F68gudzJFT6p6H9cjEFikwSVVpcf6sMFt96d+QANhrr0v8eBjg8AJnPwrQjU5ug=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FDQ+3M4k; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FDQ+3M4k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A59951F000FF;
	Wed, 30 Sep 2026 19:24:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790796287;
	bh=7Z8OI6RjPFkxc1hCrBsmK9VV0yvjEDV+uPBPNH7T//Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FDQ+3M4kDO6cxQ2Dds5+8vFFMHdxlcF68UzX40CrwQd5BXOEA2fAnovBExsO2qSc1
	 OWxTvZLeTJftuDgLVCdbBMBasZQElqyVVL+AT45ecoj14vd2kEoMlL9Qk/g8W//EGp
	 RiPaczzciUmlJs268QDpT1gznnj4UytHxHV3ahgs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aamir Ahmed <elb12345@hotmail.co.uk>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 6.6 0853/1193] Bluetooth: eir: validate service data length before reading UUID
Date: Wed, 30 Sep 2026 17:25:37 +0200
Message-ID: <20260930152453.186798873@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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
@@ -370,7 +370,15 @@ void *eir_get_service_data(u8 *eir, size
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


