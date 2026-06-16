Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AF371A682B;
	Tue, 16 Jun 2026 15:48:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781624918; cv=none; b=JGdXq9DNWVgeMOQopIPXy7sgGttFXRAnq6oG05wQf5xBrRNhKlsYzJBv12Fj9jXG//xS/tk8QkBiZjK8OQrhTfWoYnKQ+YAGJzAF9uc7yDPlZyhd2TpN21qQeKO49f2tA0HjAxj37O7CodLBuK+uhTGzuYs8cidYl5g1FqfBzss=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781624918; c=relaxed/simple;
	bh=b5pRp4JNxB44ZSif1Vy7ipw5c8T553NqpZ5j5RynqXM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BO9K8g/RJFcclWus1f/7ewTpyDAYQoz9rrS2cS2BFwuKk/87nGDpd88M7/7ahcQ976TOrf04vZLKSuTFPSKTXKwtlz+zF8OIVa9WDybSRqtkWVFbxbx0PMhfy7xvH1A9nblAaILyXGzjx17WB1TpYb2i4n1UvProwZUjJSxr5KE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XyVAd8+7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XyVAd8+7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 180911F000E9;
	Tue, 16 Jun 2026 15:48:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781624917;
	bh=r/s3ujU0zloMeGYcCPnXCvwdKg3YAaMgJXuF58gRiJE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XyVAd8+7O+0aOcH5EAFGMYmBDMpHDO6ddOCBDEVm2GiKDLrw1a+R41YpP0/eSdEgf
	 Z4vYSgtF510j/K2Kc4VCxMl3ZqftkS/A/OuLuxu1rwfYFLMUAgBXR79x166+9u9dGL
	 Q1ExmCnc2swfOVg1yQG9AuyHqMk03Rp/ycjMh+ps=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paul Menzel <pmenzel@molgen.mpg.de>,
	Zhang Cen <rollkingzzc@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 043/325] Bluetooth: MGMT: validate advertising TLV before type checks
Date: Tue, 16 Jun 2026 20:27:19 +0530
Message-ID: <20260616145059.875636346@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145057.827196531@linuxfoundation.org>
References: <20260616145057.827196531@linuxfoundation.org>
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
index 91d1c0d132f9e1..9bb82d1fdc3cad 100644
--- a/net/bluetooth/mgmt.c
+++ b/net/bluetooth/mgmt.c
@@ -8622,6 +8622,12 @@ static bool tlv_data_is_valid(struct hci_dev *hdev, u32 adv_flags, u8 *data,
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
@@ -8638,12 +8644,6 @@ static bool tlv_data_is_valid(struct hci_dev *hdev, u32 adv_flags, u8 *data,
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



