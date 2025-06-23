Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F4D5254844;
	Mon, 23 Jun 2025 13:38:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750685933; cv=none; b=hkYNPNAgvFNNUKg59u84aPOa/EhEBeDf41Z+s8ipEdOt0YHTpXQpCelgOfrhgUZXWm69useesVhYkcUsXclNmt2HrVDO7LmVrtYVdWOfeVTj4zzJVrqpPIN4dCXMxLenJpNcT/hKOKH7r/K1lYgjZYCmug+FnSLoAkNHg3FacuY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750685933; c=relaxed/simple;
	bh=JslsYaaYvIFhl+afpXOvSfxSFeglUV9mx7mlaNL6pP4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h/cKRyMYWgChxs1hrq+BG3JINJohvgD+TD0wjXySFyiV3OA666n8HT/SeKMQN+DqmEIEGVwZx+lhHnRVp8eA2v5g75jZofTdP3xgbW7TQUh+bfVR7JQEqjJ5QTxFPZtnPT/M9nFHY3QPBhVPJl1TvtY3gpzVlWbSoR+KOLUB6ig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=R1NNUZJT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="R1NNUZJT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21EB6C4CEEA;
	Mon, 23 Jun 2025 13:38:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750685933;
	bh=JslsYaaYvIFhl+afpXOvSfxSFeglUV9mx7mlaNL6pP4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=R1NNUZJTZprBD6Yd0jbbSBbfKlOQIcgdKPQLBYfhsKE5pM0Krkags6mV7xS+QO7xr
	 5P3IZhFUOofkCS0f/Rtyf5wKJlmVtnXzVgJYqEIxT7H+fXZeUImZogUlda/SBFXYLl
	 sL2/e5ysKQicdnNLbc4EZi21118L4Tf5EaZdH5r4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gabriel Shahrouzi <gshahrouzi@gmail.com>,
	Marcelo Schmitt <marcelo.schmitt1@gmail.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.4 128/222] staging: iio: ad5933: Correct settling cycles encoding per datasheet
Date: Mon, 23 Jun 2025 15:07:43 +0200
Message-ID: <20250623130615.946532521@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130611.896514667@linuxfoundation.org>
References: <20250623130611.896514667@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gabriel Shahrouzi <gshahrouzi@gmail.com>

commit 60638e2a2d4bc03798f00d5ab65ce9b83cb8b03b upstream.

The AD5933 datasheet (Table 13) lists the maximum cycles to be 0x7FC
(2044).

Clamp the user input to the maximum effective value of 0x7FC cycles.

Fixes: f94aa354d676 ("iio: impedance-analyzer: New driver for AD5933/4 Impedance Converter, Network Analyzer")
Cc: stable@vger.kernel.org
Signed-off-by: Gabriel Shahrouzi <gshahrouzi@gmail.com>
Reviewed-by: Marcelo Schmitt <marcelo.schmitt1@gmail.com>
Link: https://patch.msgid.link/20250420013009.847851-1-gshahrouzi@gmail.com
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/iio/impedance-analyzer/ad5933.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/staging/iio/impedance-analyzer/ad5933.c
+++ b/drivers/staging/iio/impedance-analyzer/ad5933.c
@@ -412,7 +412,7 @@ static ssize_t ad5933_store(struct devic
 		ret = ad5933_cmd(st, 0);
 		break;
 	case AD5933_OUT_SETTLING_CYCLES:
-		val = clamp(val, (u16)0, (u16)0x7FF);
+		val = clamp(val, (u16)0, (u16)0x7FC);
 		st->settling_cycles = val;
 
 		/* 2x, 4x handling, see datasheet */


