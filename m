Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C175747A0B2;
	Tue, 16 Jun 2026 18:52:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781635945; cv=none; b=FIanXJf360cOPpe8kq+UkHpD6wpqvIJSPAuUAdM52YsTonFcsaRWtPpaBirJ46RLtGPjItO1dihTjsu9QjQ7eb/FenOkC9A9HPQqaSQNBWorMwhIGKYJMCJKG3cgNlpl89JXA4HaqeTc8M/a9/tkZYyBd/KMYc0rAfwFd7IZtK4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781635945; c=relaxed/simple;
	bh=XDlo/9R6mACppYH8f83+k5Nitpe0U+p/YR5W82FtLWY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nvlRU+aBTRZDGxd+iAYppR5agEq3TszEZzt9H9jf79C+z5rS8+X+sx7qQOc/8L9W2fi7WajGgX7Z7wvDny+Tx697u13Ymsd5bhH4JM8uqAG7QRvSy+Dnnb+4jrjnxvBa3Hge3n74AZpeTQWepFtAaFhbkPCVrSBZfJuzv82aEQc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DrTVUOiQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DrTVUOiQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9875F1F000E9;
	Tue, 16 Jun 2026 18:52:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781635944;
	bh=7uIQsKcMOJbzgxcQNV8fE37XjfChf51Wa2Pn/RWd0xY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DrTVUOiQU3SFt6mWKk6GTCzbP+v2YQT8gbxP2x02rgf42rQ0PHiEIaZZR5GMSUBc1
	 T0dIYQd25yrVymK6dycKy72xgo4F8cq8uN8Sklk6+0grnrvkglr4oMjmSiYQwVN/FH
	 +aBIFQa/h4ZXFibd5iPCu/K8xezuVDz7M3JhscT4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paul Menzel <pmenzel@molgen.mpg.de>,
	Zhang Cen <rollkingzzc@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 145/342] Bluetooth: MGMT: validate advertising TLV before type checks
Date: Tue, 16 Jun 2026 20:27:21 +0530
Message-ID: <20260616145054.932657001@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145048.348037099@linuxfoundation.org>
References: <20260616145048.348037099@linuxfoundation.org>
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
index b768abbf2b121a..3647e51d31062b 100644
--- a/net/bluetooth/mgmt.c
+++ b/net/bluetooth/mgmt.c
@@ -7364,6 +7364,12 @@ static bool tlv_data_is_valid(struct hci_dev *hdev, u32 adv_flags, u8 *data,
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
@@ -7380,12 +7386,6 @@ static bool tlv_data_is_valid(struct hci_dev *hdev, u32 adv_flags, u8 *data,
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



