Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D02EC3A5E91;
	Tue, 16 Jun 2026 18:21:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781634069; cv=none; b=sSKgH8AXOm7295sUNjYOq1ZJjoOGaKZU73Xa2eFoTH8DihQQfliTKGsUec0PMT0YKtJNr8US9nu8Kk+qhFSlF1naxroikNzxYiGWLHSWUdYoi+YFjnQtzYRvRAp8HF7rguCPTNcpLxWBcS0hNvLGsaLLYSmyYOfbd+w3WnRFTzo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781634069; c=relaxed/simple;
	bh=MK7zJjhYww4ndlD88pzGWG1XxQ2VTv8H5uML95bmmxk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BKpYUVWjtn+tTeiEcIfB7f0E7+pn3Z4xiWKGSs3XYBDe6EPScJTfkAR5G09Hd7JVO7qypnpPm1D9aoZqguyGQpNc2LifyyCDwvgCEx24U0vHokFyRnSQgYYsS3kw/iDPaUhvt0IRAHW7uf9xua13RlMk8MwY+/RGFuLUbs+0r6k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GK6loS00; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GK6loS00"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFC111F000E9;
	Tue, 16 Jun 2026 18:21:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781634068;
	bh=r6ycuLdZ9FIm6IOb+ZnXvE73SAjCID9DuFG1Zcp0sjM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GK6loS00cHgy15zoT19TN9b9ddAYGyqm83Afr6IuxoyjxC9AqfvfcJS1oKeuBkuKO
	 mlihvpFlX50B9mbVQ3wrBnmu066lT2ypjSB3hrpR28lPoMNcKoFXVJGdIYV1WdKJkp
	 aXvJnhYzEWkmNBdvKsxweDcwhB/q8ryhdH7S5sDg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paul Menzel <pmenzel@molgen.mpg.de>,
	Zhang Cen <rollkingzzc@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 163/411] Bluetooth: MGMT: validate advertising TLV before type checks
Date: Tue, 16 Jun 2026 20:26:41 +0530
Message-ID: <20260616145109.170907671@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145100.376842714@linuxfoundation.org>
References: <20260616145100.376842714@linuxfoundation.org>
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

From: Zhang Cen <rollkingzzc@gmail.com>

[ Upstream commit de23fb62259aa01d294f77238ae3b835eb674413 ]

tlv_data_is_valid() reads each advertising data field length from
data[i], then inspects data[i + 1] for managed EIR types before
checking that the current field still fits inside the supplied buffer.

A malformed field whose length byte is the last byte of the buffer can
therefore make the parser read one byte past the advertising data.

KASAN reported the following when a malformed MGMT_OP_ADD_ADVERTISING
request reached that path:

  BUG: KASAN: vmalloc-out-of-bounds in tlv_data_is_valid()
  Read of size 1
  Call trace:
    tlv_data_is_valid()
    add_advertising()
    hci_mgmt_cmd()
    hci_sock_sendmsg()

Move the existing element-length check before any type-octet inspection
so each non-empty element is proven to contain its type byte before the
parser looks at data[i + 1].

Fixes: 2bb36870e8cb ("Bluetooth: Unify advertising instance flags check")
Reviewed-by: Paul Menzel <pmenzel@molgen.mpg.de>
Signed-off-by: Zhang Cen <rollkingzzc@gmail.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/mgmt.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/net/bluetooth/mgmt.c b/net/bluetooth/mgmt.c
index 09232c424446bc..337c3cb8eec589 100644
--- a/net/bluetooth/mgmt.c
+++ b/net/bluetooth/mgmt.c
@@ -7635,6 +7635,12 @@ static bool tlv_data_is_valid(struct hci_dev *hdev, u32 adv_flags, u8 *data,
 		if (!cur_len)
 			continue;
 
+		/* If the current field length would exceed the total data
+		 * length, then it's invalid.
+		 */
+		if (i + cur_len >= len)
+			return false;
+
 		if (data[i + 1] == EIR_FLAGS &&
 		    (!is_adv_data || flags_managed(adv_flags)))
 			return false;
@@ -7651,12 +7657,6 @@ static bool tlv_data_is_valid(struct hci_dev *hdev, u32 adv_flags, u8 *data,
 		if (data[i + 1] == EIR_APPEARANCE &&
 		    appearance_managed(adv_flags))
 			return false;
-
-		/* If the current field length would exceed the total data
-		 * length, then it's invalid.
-		 */
-		if (i + cur_len >= len)
-			return false;
 	}
 
 	return true;
-- 
2.53.0



