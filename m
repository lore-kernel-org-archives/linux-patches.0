Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0A5853F69D;
	Wed, 23 Sep 2026 14:46:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790174817; cv=none; b=GrZkufiJEIFiV5IiHUkZVSc3DQ0o1+MQ8TMpk8lAIbqmz9fn8nI9QivyBrmiTH71BQKYRIprzcUnCOdeIzsM6M9tzup+unfvpmIhqmeDxQkbCVGsKGWvhMWr2yOEqI9kwNI8ubFFi/A8wPweN7gVTnOZcyXPZbh5iJ3GOVzFbeU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790174817; c=relaxed/simple;
	bh=bwsBWwTzqBGwqhlIAOk1J0SuOMl9NfSDYm6g38XSTGc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WMyL1BBNA/Q3pEcASveE9M4PrEL/+VgZWpL6pVzJll0K5oW9n/Wba2CrfufXaWftMM+m5CgR12L7LQtb4rcKWd7Wu92fXyNRLsqAKVmlDByTwmV4gvTYheWkjyIPZCmrR5UHcu6BFcFj2HyfZdR8IGgp3gBfFbMcOCuN6vLZ9Cs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Sz1dEwtx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Sz1dEwtx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A3A71F00893;
	Wed, 23 Sep 2026 14:46:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790174815;
	bh=4dyYAjsvUUlE74EvM1PUt3067uhTh2XwMQB20e0l5LM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Sz1dEwtxcyQ1SlUBH+UB0kp9MJY4hQc0jRJBZbN2IxK5jjgosY0j5s5ipgKiFtZ0k
	 8S0sXZHcFfJkQehjq6nn/S4pLisjxmoBv+qVo6e1pKepsRQ1yzuRUl+g70Zkcg+1ut
	 jyQd8TWf5iFPO6GZaBnmI9srCUfYsC/kME1uUeSk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aamir Ahmed <elb12345@hotmail.co.uk>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 6.18 234/398] Bluetooth: eir: validate service data length before reading UUID
Date: Wed, 23 Sep 2026 16:05:08 +0200
Message-ID: <20260923140649.483778349@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140643.441954610@linuxfoundation.org>
References: <20260923140643.441954610@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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


