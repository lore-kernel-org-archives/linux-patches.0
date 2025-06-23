Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 655FB221FDD;
	Mon, 23 Jun 2025 21:33:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750714404; cv=none; b=a1ZPnsP3WDuYaxEcylJsD7gp3xR5s/YRBfQTZQ975iqtxkTw7RibBL2lF/aZR+q4dZmxvYuGc8qYZ9uMOXnDlt94loEKr7rbJbJ/OaChUVnE1R/DEf28EUq7hRCm/gOwiVnvPmlcXMRhIbz86dO+NqSPZ0qRnPYcDWoyrA9/PdY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750714404; c=relaxed/simple;
	bh=4mmjLt5gEVlvUMPLbbDabWOwfR9x83x+tCW0fCZvmz8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i2W/zodcmQ2y0zfkC28OMEYhk4FEomtey2DYiXPrc1lWeflkmka10//Rb8RHnRLxUYwYCLv+bvAdMRnP3T+SnC5u2gNEqP3RpgzsVc4lhNbYmtg4KJ0bwSY+dGKBTkrHbo4lOieOHCbSCIAByrHd3OTWI9FK3qmwGKgmZ+v6Juw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OwggPfrP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OwggPfrP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1F44C4CEEA;
	Mon, 23 Jun 2025 21:33:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750714404;
	bh=4mmjLt5gEVlvUMPLbbDabWOwfR9x83x+tCW0fCZvmz8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OwggPfrPL/9uLwAGQcihzqgGC+MRPF4GGvuHoKTsUfGiOFt2DCNvg4bzt7CjTr8y5
	 rPCKEWySqoR2UiRCm0oCiVpODWi86Ls8xUNaHhCIkir92fiErM5+3nO+sMQpeDHG1P
	 pm3kMRAecwn3mg8puwmB8+47hEJnMNQXQfEAalO4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gabriel Shahrouzi <gshahrouzi@gmail.com>,
	Marcelo Schmitt <marcelo.schmitt1@gmail.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.10 204/355] staging: iio: ad5933: Correct settling cycles encoding per datasheet
Date: Mon, 23 Jun 2025 15:06:45 +0200
Message-ID: <20250623130632.789335663@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130626.716971725@linuxfoundation.org>
References: <20250623130626.716971725@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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


