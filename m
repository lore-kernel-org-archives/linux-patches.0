Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C17841D131;
	Sat, 12 Sep 2026 08:45:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789202712; cv=none; b=c4YZOOmHRRdfghVj7yn/w+khinVPn2Xm5rGqwjFUM7hnHVSlc53fALCx3/dNo5oY+ID2PqmNVBz//I2a0e729771NTMiGOK1Ey4TPr7UvsoOxsLjd6Nemycn8OuGdvRrGxwmSGU4nOZrrCo9IAaWJATU5lGXyLc+w5/GgBkUpRU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789202712; c=relaxed/simple;
	bh=8PaY6SL9WfCcrYyW/a4p3wqpa7slebZJ/diwRJdKUYg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Sr2WaDSx3L1Ln5cxieFzsMa8hTO1uZN+XPK2kkeGlDTjJ61Sgwd1cj6O0+LVOKPw3b3r51qJRcqTyc8l/rgFoWO43xmofrgXyC0AeddwhTGNu6iEtI5hoeM4tWJzOTB3rl3aFopm1oQiigKrtxrfDxVTArwwgEtjIliVHigcjpA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wxO7NvIf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wxO7NvIf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 589DC1F00898;
	Sat, 12 Sep 2026 08:45:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789202711;
	bh=wgkg1TtHwLjNkaB2chbz6Wofcf13p/njObp7HCSDffs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wxO7NvIfXMBLsy1+r6o80DeUJftjG43MRIhLh5D5JhToh8o4n2xd1eBagvVf5RZRI
	 Ak999f2QI2anbsECrTyCKkp2CdFfK3ZEe2uQJsV2fRhLb3knEEJlFznGnTsq8LsJpP
	 kaD/Nhfw7sQdPwJs6XAsAcyuQlGd7nzzod49b7S0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vidhu Sarwal <vidhu.linux@gmail.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1259/1815] iio: light: opt4060: Fix pointer type passed to div_u64_rem()
Date: Sat, 12 Sep 2026 08:50:09 +0200
Message-ID: <20260912065718.572755551@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index d248db1c42e8a..f79dd342937d6 100644
--- a/drivers/iio/light/opt4060.c
+++ b/drivers/iio/light/opt4060.c
@@ -713,6 +713,7 @@ static ssize_t opt4060_read_ev_period(struct opt4060_chip *chip, int *val,
 {
 	int ret, pers, fault_count, int_time;
 	u64 uval;
+	u32 rem;
 
 	int_time = opt4060_int_time_reg[chip->int_time][0];
 
@@ -738,7 +739,8 @@ static ssize_t opt4060_read_ev_period(struct opt4060_chip *chip, int *val,
 	}
 
 	uval = mul_u32_u32(int_time, pers);
-	*val = div_u64_rem(uval, MICRO, val2);
+	*val = div_u64_rem(uval, MICRO, &rem);
+	*val2 = rem;
 
 	return IIO_VAL_INT_PLUS_MICRO;
 }
-- 
2.53.0



