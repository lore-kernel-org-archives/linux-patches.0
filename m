Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 903D7313E2B;
	Sat, 12 Sep 2026 10:54:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789210483; cv=none; b=GDTd6NcbDgc3vfGCshQTe5OqHCR2EvqUVTVdBjQdGZyevyF6ThRFENfEeMg1Wd6slBmrd37ceNZ4lk1p7lCOj1oo4g6LYYcD/8fR57ePQSu7pxZDQXwEPyKZ1qTDowY2eYk9FWzJL9eDQrCcbj20fwMV6hykj/t3kt/sOZg0278=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789210483; c=relaxed/simple;
	bh=FpibXqDLlEqgSHREplQdCZnWtZwyF4BsNmqtpUr61F8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XjyHG0vOLKeUW/Zj1Dz0d0jqd48oTEp6AVO8unu1hdMYFGbo1YBQ5NZ3cfV0irZuWZxeM9AU3Q/YLNENFtrOMfsGSZSCUXkncb+yOZntyz59Oo5XiO0U+I4p137Gq9TOeibb99QfRfFbNmYBM2GCfkft1HmGpfbqOVykWjiCo9o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BU4RjP2f; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BU4RjP2f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F3FC1F00893;
	Sat, 12 Sep 2026 10:54:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789210482;
	bh=uW8U5ZCbDOrG38ld9nNcJfzw6etIFpDNkguFAeFROoE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BU4RjP2f7fw131OyUYwjyip8sR1BGKfk4DP8mk3pjHSW+rXZdWYAKY3qxovXJ65x8
	 k2b2t4Il2rI6IO+fXIc4ZSTc4KXB8taq3pveCUNAwIQlHjjaOHTk+WqYCclV6IJWhn
	 DJjsa19OnyZDFeONmp8x/zCCyT23xmBBu+7GofjE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vidhu Sarwal <vidhu.linux@gmail.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1035/1518] iio: light: opt4060: Fix pointer type passed to div_u64_rem()
Date: Sat, 12 Sep 2026 08:53:24 +0200
Message-ID: <20260912065646.865385136@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

From: Vidhu Sarwal <vidhu.linux@gmail.com>

[ Upstream commit 0ba0ed0d42ebd3144f0050c48374817f5f3f07d6 ]

div_u64_rem() expects a u32 * for the remainder, but
opt4060_read_ev_period() passes val2, which is declared as an
int *. While this has no functional impact, it triggers a pointer type
mismatch.

There is no behavioural change because int and u32 have the same
size and representation on all supported architectures, and the
remainder is always less than MICRO, so it fits within the positive
range of int.

Use a local u32 to receive the remainder before assigning it to
*val2.

Fixes: 0c6db4506ad0 ("iio: light: Add support for TI OPT4060 color sensor")
Signed-off-by: Vidhu Sarwal <vidhu.linux@gmail.com>
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/light/opt4060.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/iio/light/opt4060.c b/drivers/iio/light/opt4060.c
index 0f8716d72cf64..9be752535d750 100644
--- a/drivers/iio/light/opt4060.c
+++ b/drivers/iio/light/opt4060.c
@@ -731,6 +731,7 @@ static ssize_t opt4060_read_ev_period(struct opt4060_chip *chip, int *val,
 {
 	int ret, pers, fault_count, int_time;
 	u64 uval;
+	u32 rem;
 
 	int_time = opt4060_int_time_reg[chip->int_time][0];
 
@@ -756,7 +757,8 @@ static ssize_t opt4060_read_ev_period(struct opt4060_chip *chip, int *val,
 	}
 
 	uval = mul_u32_u32(int_time, pers);
-	*val = div_u64_rem(uval, MICRO, val2);
+	*val = div_u64_rem(uval, MICRO, &rem);
+	*val2 = rem;
 
 	return IIO_VAL_INT_PLUS_MICRO;
 }
-- 
2.53.0



