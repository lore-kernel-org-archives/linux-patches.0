Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6BD238C437;
	Tue, 16 Jun 2026 15:14:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781622870; cv=none; b=TRRtX41iitJA+PyM5/T58d11Nk7OsTiDqGDi5LJ70Fk7ZEMVbe8yXWWmaTAxi/4ZplRLmOuV53yNxLeG7YxssEUShP1s9Rw6TElKeNM6puudPGIWNMYzFmvBmVscSfNKaAHF0/NIY+CvvdxS8+zkfTxqsOmCllN/QBAXeR19Eyc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781622870; c=relaxed/simple;
	bh=RzEhbFBxtzDk7bEj0gJghhn71Ck5drAMb7XyHV1fJiM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G7XKXu3mHEslNN+C744aBPI1CzXQ+Jd7G66knqgMql3mQkLfqRMdE/gjU4NY5iByLxEeqOxZiyJrcBQsjkftfIN8c2uzE0wo/fHC+MQXnYF+ohwZnT9qZT+kldWcLYY8jE/IXLC7gvkhImxmMmmIhkjz/0WVNmBuWZ5qeyZKsBE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CoiY5VxV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CoiY5VxV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D06EB1F000E9;
	Tue, 16 Jun 2026 15:14:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781622868;
	bh=D1jCOfzJPYY5tGsOa+tyKMsOQF37UWiF7YzRGylEV3I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CoiY5VxVdb7zBKFTsbhWL87EdNYdpQgcAp9P/0nXeA1agSoghXwPMh+xPvNS/XdAA
	 ff4kAtqtN6Fgjm0i+BjQp4af/LyxMiE2MMn0aFGFb4WqPGxgqTNTkTb130sZ3m7DtC
	 KqDR9AVfBnDyBrd+RbZfpALerkCmKRSyzY7ngs90=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paul Menzel <pmenzel@molgen.mpg.de>,
	Zhang Cen <rollkingzzc@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 045/378] Bluetooth: MGMT: validate advertising TLV before type checks
Date: Tue, 16 Jun 2026 20:24:36 +0530
Message-ID: <20260616145112.284141057@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145109.744539446@linuxfoundation.org>
References: <20260616145109.744539446@linuxfoundation.org>
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
index de5bd6b637b205..027b266ccc747c 100644
--- a/net/bluetooth/mgmt.c
+++ b/net/bluetooth/mgmt.c
@@ -8638,6 +8638,12 @@ static bool tlv_data_is_valid(struct hci_dev *hdev, u32 adv_flags, u8 *data,
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
@@ -8654,12 +8660,6 @@ static bool tlv_data_is_valid(struct hci_dev *hdev, u32 adv_flags, u8 *data,
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



