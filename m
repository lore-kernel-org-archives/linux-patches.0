Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3AC11E51FA;
	Mon, 23 Jun 2025 21:25:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750713918; cv=none; b=sQ0ISm12xDzszAmwcBx6WlOrArntUlGXgCL+MfjSjl7sh9uCW93K3mkTCiqofNcj0Nk2R6Sl/H3Ff7QkosrRzGOUBPnKsOKazFDGf7DrZ8Jz3571PtqaXkLPIsEcwZPXo8lc4sq+TJyrED8wQqLaES9ymvXKOiI+/lrCR2dFZIM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750713918; c=relaxed/simple;
	bh=Ux/3aPNajAwpJuyzAeDYlDAQhG4al7P9n2bLOCD9/Xw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PBvd7lhYbmhEPARh2YYoiI6Jwz6vYfyYpecWFrYQpQaCS8CICxOkV89kdRYb1R2TEulqNwTuPxwCgJfYpcs+5Coa/tCC7Zm1mB1Ww6ye90stzLouiIH4W9j1ItuguoZWGjUVKyiOgMyN7uYTRbWB4+S0wqdMEv2qWrsajFsz7gs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0jhPAmh6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0jhPAmh6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79E87C4CEEA;
	Mon, 23 Jun 2025 21:25:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750713917;
	bh=Ux/3aPNajAwpJuyzAeDYlDAQhG4al7P9n2bLOCD9/Xw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0jhPAmh6E6TQOuRiIbh9p7qqAin/im50vNhNZAnpRwZnPbnir6lKZ9Pk7nSF2AsAV
	 4dicMObkNndKeGCkyUYKURh6TRJGw+IkddkCx9us/I83gN7SeThlQFhp3fYCml5WlK
	 RFhbImaWSrcGdZw3HChtGnERgw5ls610u6mi0dD4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gabriel Shahrouzi <gshahrouzi@gmail.com>,
	Marcelo Schmitt <marcelo.schmitt1@gmail.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.6 097/290] staging: iio: ad5933: Correct settling cycles encoding per datasheet
Date: Mon, 23 Jun 2025 15:05:58 +0200
Message-ID: <20250623130629.886978580@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130626.910356556@linuxfoundation.org>
References: <20250623130626.910356556@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


