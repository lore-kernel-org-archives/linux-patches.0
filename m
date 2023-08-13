Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEAC19446
	for <patches@lists.linux.dev>; Sun, 13 Aug 2023 21:35:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42458C433C8;
	Sun, 13 Aug 2023 21:35:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691962507;
	bh=QTxLNMcngBVpCdOAZKLbpaUn7Uz9/rGlb5zm4YXg/aw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=07d47HyY2OT45Yqa9YEiseopXEhQFu0heQEzWg9tEtT4OCSVwP38/uU3llFCLhGDH
	 UAPVb1mYOd1DxfR+DBBLSmaJsahgEhiWS7q4+lPz++aE6SzP6OII7GOfOwzvIKjKeP
	 Tu9hPs/g/vHKJkrt6QNk47Za+6VBBmVTAW8GCoh0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.1 053/149] iio: frequency: admv1013: propagate errors from regulator_get_voltage()
Date: Sun, 13 Aug 2023 23:18:18 +0200
Message-ID: <20230813211720.402350528@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230813211718.757428827@linuxfoundation.org>
References: <20230813211718.757428827@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Dan Carpenter <dan.carpenter@linaro.org>

commit 507397d19b5a296aa339f7a1bd16284f668a1906 upstream.

The regulator_get_voltage() function returns negative error codes.
This function saves it to an unsigned int and then does some range
checking and, since the error code falls outside the correct range,
it returns -EINVAL.

Beyond the messiness, this is bad because the regulator_get_voltage()
function can return -EPROBE_DEFER and it's important to propagate that
back properly so it can be handled.

Fixes: da35a7b526d9 ("iio: frequency: admv1013: add support for ADMV1013")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Link: https://lore.kernel.org/r/ce75aac3-2aba-4435-8419-02e59fdd862b@moroto.mountain
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/frequency/admv1013.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/iio/frequency/admv1013.c
+++ b/drivers/iio/frequency/admv1013.c
@@ -344,9 +344,12 @@ static int admv1013_update_quad_filters(
 
 static int admv1013_update_mixer_vgate(struct admv1013_state *st)
 {
-	unsigned int vcm, mixer_vgate;
+	unsigned int mixer_vgate;
+	int vcm;
 
 	vcm = regulator_get_voltage(st->reg);
+	if (vcm < 0)
+		return vcm;
 
 	if (vcm < 1800000)
 		mixer_vgate = (2389 * vcm / 1000000 + 8100) / 100;


