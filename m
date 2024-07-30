Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F30EC1A6192;
	Tue, 30 Jul 2024 16:35:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722357354; cv=none; b=Ex2dCeeBJWQitUDOoo+QeEln4jI1im9LPZaKIxBysGtBcfXCODYsxC3ew9JOCIbYbuc1Gfb3Qr0/BmEge+KSQ+i/ODmGNSXc4R1BHP+RVX7yPCP2FmUcBhznGq5za45YDXnBYSXz220lD56ZudEGDYsmjHy6eP6SECMpMzQSKo4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722357354; c=relaxed/simple;
	bh=ADAoZnEj7i0vgUImVMjA0ntdmKAY6jYb1H+KP9z5CO0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ACm5sn2hcV/cX7AhwVpsk5bVDT6yVhUkIiZ/0bKwJwR5SAAGk+DhbQWfcbvay2jAOJoGUb6eiIAasIwrGorfuGV0eRraC1KftIeFfk5QClkSKVlM8dNT6NjyWsKKb5SAJSuFSbt29zwtITFCrg3QvQ6BNuRu9Gk8mF++8/k1k78=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=i/ERzRuu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="i/ERzRuu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 415E9C4AF0C;
	Tue, 30 Jul 2024 16:35:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722357353;
	bh=ADAoZnEj7i0vgUImVMjA0ntdmKAY6jYb1H+KP9z5CO0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=i/ERzRuugRgtYJU13sSeGWTys20q4rcWh7eLZV5DjZJrjsIyBDPHSgrYHz5fGLUQQ
	 nhRXtFfDZEWJ0+pT449+ckayRPTfBJn7ZBo3PT+SG+oCWDR44i2UOB5mHSsCWGcuiJ
	 sOl7pevRslvqJD0XPTNogU45Kjud8cIyChBs37/c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chenyuan Yang <chenyuan0y@gmail.com>,
	Matti Vaittinen <mazziesaccount@gmail.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 247/568] iio: Fix the sorting functionality in iio_gts_build_avail_time_table
Date: Tue, 30 Jul 2024 17:45:54 +0200
Message-ID: <20240730151649.535632144@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151639.792277039@linuxfoundation.org>
References: <20240730151639.792277039@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Chenyuan Yang <chenyuan0y@gmail.com>

[ Upstream commit 5acc3f971a01be48d5ff4252d8f9cdb87998cdfb ]

The sorting in iio_gts_build_avail_time_table is not working as intended.
It could result in an out-of-bounds access when the time is zero.

Here are more details:

1. When the gts->itime_table[i].time_us is zero, e.g., the time
sequence is `3, 0, 1`, the inner for-loop will not terminate and do
out-of-bound writes. This is because once `times[j] > new`, the value
`new` will be added in the current position and the `times[j]` will be
moved to `j+1` position, which makes the if-condition always hold.
Meanwhile, idx will be added one, making the loop keep running without
termination and out-of-bound write.
2. If none of the gts->itime_table[i].time_us is zero, the elements
will just be copied without being sorted as described in the comment
"Sort times from all tables to one and remove duplicates".

For more details, please refer to
https://lore.kernel.org/all/6dd0d822-046c-4dd2-9532-79d7ab96ec05@gmail.com.

Reported-by: Chenyuan Yang <chenyuan0y@gmail.com>
Suggested-by: Matti Vaittinen <mazziesaccount@gmail.com>
Fixes: 38416c28e168 ("iio: light: Add gain-time-scale helpers")
Signed-off-by: Chenyuan Yang <chenyuan0y@gmail.com>
Co-developed-by: Matti Vaittinen <mazziesaccount@gmail.com>
Signed-off-by: Matti Vaittinen <mazziesaccount@gmail.com>
Link: https://lore.kernel.org/r/d501ade8c1f7b202d34c6404eda423489cab1df5.1714480171.git.mazziesaccount@gmail.com
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/industrialio-gts-helper.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/iio/industrialio-gts-helper.c b/drivers/iio/industrialio-gts-helper.c
index b51eb6cb766f3..59d7615c0f565 100644
--- a/drivers/iio/industrialio-gts-helper.c
+++ b/drivers/iio/industrialio-gts-helper.c
@@ -362,17 +362,20 @@ static int iio_gts_build_avail_time_table(struct iio_gts *gts)
 	for (i = gts->num_itime - 1; i >= 0; i--) {
 		int new = gts->itime_table[i].time_us;
 
-		if (times[idx] < new) {
+		if (idx == 0 || times[idx - 1] < new) {
 			times[idx++] = new;
 			continue;
 		}
 
-		for (j = 0; j <= idx; j++) {
+		for (j = 0; j < idx; j++) {
+			if (times[j] == new)
+				break;
 			if (times[j] > new) {
 				memmove(&times[j + 1], &times[j],
 					(idx - j) * sizeof(int));
 				times[j] = new;
 				idx++;
+				break;
 			}
 		}
 	}
-- 
2.43.0



