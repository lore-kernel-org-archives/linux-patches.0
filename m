Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFC4421B8F6;
	Mon, 23 Jun 2025 22:13:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750716798; cv=none; b=uNmlhrtfBN6C7R+SoDT5yUkQW1fat/euO7IodqAP488NiZNmzGJ2CmDZLlAoN+mUPD6H9YCbVI19iX7FBAp7QaC4en3fDi6lXaDODYSnd4JVVX1c8M04QXmXJR094Uhr1pm2H1Z1ZO5LGITjZCer9mzU/GEskNgutWXLjck22k0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750716798; c=relaxed/simple;
	bh=cSx7xi5w3rHpkfUHO1192dPTQ2yrjwL7JIiPLhXaEL4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=spBKQYSq+vZCbhEJ8oLDh1lsQCcvqNh7kFZ8WLrQ+w3ESwP+xzFQ5X9eo8StqN9S04z+dUn784jLDRKsUro16XMdKDibnZyW5vAIJycIPcypMjYrmCer6zn7M9lkUhBBdWY096YTfE43s6L7YtMdc0omBLjBrnRHAWCcxxx2itQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=z988FZnH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z988FZnH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A451C4CEEA;
	Mon, 23 Jun 2025 22:13:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750716798;
	bh=cSx7xi5w3rHpkfUHO1192dPTQ2yrjwL7JIiPLhXaEL4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=z988FZnHjorNe3ojuRDy9lY/QkC+cTQKM6bZHampAO3DRw+T6CYu1cFvmV3qmz49F
	 VsZ0xNryxtdX3a7tUT0oXAFTO/ho8RyR3h8PKA8Q0688knb1feeiWzZ43xP73AiJpM
	 p6UBxPcnPm/BQRop9SO/+lrbSq/zKo2DS9PMeJTI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gabriel Shahrouzi <gshahrouzi@gmail.com>,
	Marcelo Schmitt <marcelo.schmitt1@gmail.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.1 360/508] staging: iio: ad5933: Correct settling cycles encoding per datasheet
Date: Mon, 23 Jun 2025 15:06:45 +0200
Message-ID: <20250623130654.220583563@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130645.255320792@linuxfoundation.org>
References: <20250623130645.255320792@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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


