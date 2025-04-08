Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E3B222257E;
	Tue,  8 Apr 2025 11:55:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744113327; cv=none; b=WvKApJBTiHUK6Eu3iyMPeEHoSmRYN3HKg77AJC6rW8A8uoM+rjQp6BrEUEGfDF2YF79IspqN8jJuwa9n9otoboPiRqSGOqhuxnShjSH59NgsTeuhS+lRoymIDK6TbuvTb4mQwmzi5htPzE3CQxs6sxTl/5DucZel8OS9lri7nLA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744113327; c=relaxed/simple;
	bh=A3fyY8sBMv0pUVZH2Lt7FArYLIuYHKGruKgRlYz7pFg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=eMGZeGla7O0W6+Zx4Co1xAvX/vUcHiQJym478NKq8bfTezi17T7j3+R9EcpvHFtuDkgHmZr7qpfs+ngIJvakth+M5jejGpDJ1ieKrk8KnRyaSRhLxRKpWqAppCgG2A+mRyPdqYHVuAUesxxGHlkvLcI/8wadILoM7+GVsMDZveY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kcYA9Fqk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kcYA9Fqk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 903B2C4CEEA;
	Tue,  8 Apr 2025 11:55:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744113326;
	bh=A3fyY8sBMv0pUVZH2Lt7FArYLIuYHKGruKgRlYz7pFg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kcYA9FqkZ87xjyl2hu2AckLh40WfU2zu4EkdKfaaFKgHRQ/hKLoVXR9wNWPie13hP
	 3mnp8JZdLtLplsX1lX1iHim5veCPDjBwaxWhC4D0IT+4gGqx5Pc+IbMSU7DXaco7jy
	 pVeuEJk0uSi0j4sTwD78kilE7oBBWIidqectqOqM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@baylibre.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 119/268] iio: adc: ad4130: Fix comparison of channel setups
Date: Tue,  8 Apr 2025 12:48:50 +0200
Message-ID: <20250408104831.708583530@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104828.499967190@linuxfoundation.org>
References: <20250408104828.499967190@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Uwe Kleine-König <u.kleine-koenig@baylibre.com>

[ Upstream commit 280acb19824663d55a3f4d09087c76fabe86fa3c ]

Checking the binary representation of two structs (of the same type)
for equality doesn't have the same semantic as comparing all members for
equality. The former might find a difference where the latter doesn't in
the presence of padding or when ambiguous types like float or bool are
involved. (Floats typically have different representations for single
values, like -0.0 vs +0.0, or 0.5 * 2² vs 0.25 * 2³. The type bool has
at least 8 bits and the raw values 1 and 2 (probably) both evaluate to
true, but memcmp finds a difference.)

When searching for a channel that already has the configuration we need,
the comparison by member is the one that is needed.

Convert the comparison accordingly to compare the members one after
another. Also add a static_assert guard to (somewhat) ensure that when
struct ad4130_setup_info is expanded, the comparison is adapted, too.

This issue is somewhat theoretic, but using memcmp() on a struct is a
bad pattern that is worth fixing.

Fixes: 62094060cf3a ("iio: adc: ad4130: add AD4130 driver")
Signed-off-by: Uwe Kleine-König <u.kleine-koenig@baylibre.com>
Link: https://patch.msgid.link/20250303114659.1672695-12-u.kleine-koenig@baylibre.com
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/adc/ad4130.c | 41 ++++++++++++++++++++++++++++++++++++++--
 1 file changed, 39 insertions(+), 2 deletions(-)

diff --git a/drivers/iio/adc/ad4130.c b/drivers/iio/adc/ad4130.c
index e650ebd167b03..6442218628518 100644
--- a/drivers/iio/adc/ad4130.c
+++ b/drivers/iio/adc/ad4130.c
@@ -223,6 +223,10 @@ enum ad4130_pin_function {
 	AD4130_PIN_FN_VBIAS = BIT(3),
 };
 
+/*
+ * If you make adaptations in this struct, you most likely also have to adapt
+ * ad4130_setup_info_eq(), too.
+ */
 struct ad4130_setup_info {
 	unsigned int			iout0_val;
 	unsigned int			iout1_val;
@@ -591,6 +595,40 @@ static irqreturn_t ad4130_irq_handler(int irq, void *private)
 	return IRQ_HANDLED;
 }
 
+static bool ad4130_setup_info_eq(struct ad4130_setup_info *a,
+				 struct ad4130_setup_info *b)
+{
+	/*
+	 * This is just to make sure that the comparison is adapted after
+	 * struct ad4130_setup_info was changed.
+	 */
+	static_assert(sizeof(*a) ==
+		      sizeof(struct {
+				     unsigned int iout0_val;
+				     unsigned int iout1_val;
+				     unsigned int burnout;
+				     unsigned int pga;
+				     unsigned int fs;
+				     u32 ref_sel;
+				     enum ad4130_filter_mode filter_mode;
+				     bool ref_bufp;
+				     bool ref_bufm;
+			     }));
+
+	if (a->iout0_val != b->iout0_val ||
+	    a->iout1_val != b->iout1_val ||
+	    a->burnout != b->burnout ||
+	    a->pga != b->pga ||
+	    a->fs != b->fs ||
+	    a->ref_sel != b->ref_sel ||
+	    a->filter_mode != b->filter_mode ||
+	    a->ref_bufp != b->ref_bufp ||
+	    a->ref_bufm != b->ref_bufm)
+		return false;
+
+	return true;
+}
+
 static int ad4130_find_slot(struct ad4130_state *st,
 			    struct ad4130_setup_info *target_setup_info,
 			    unsigned int *slot, bool *overwrite)
@@ -604,8 +642,7 @@ static int ad4130_find_slot(struct ad4130_state *st,
 		struct ad4130_slot_info *slot_info = &st->slots_info[i];
 
 		/* Immediately accept a matching setup info. */
-		if (!memcmp(target_setup_info, &slot_info->setup,
-			    sizeof(*target_setup_info))) {
+		if (ad4130_setup_info_eq(target_setup_info, &slot_info->setup)) {
 			*slot = i;
 			return 0;
 		}
-- 
2.39.5



