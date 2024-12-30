Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E0A915E8B;
	Mon, 30 Dec 2024 15:48:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735573703; cv=none; b=f4acu6TqI7f4o4RGp/cUTiCxmy1u/27Eb5G8ieWtwd6V2Dq5NyzfZK6qIfIlCFr3A1sx0Dt3ek3Y6csYcljutTJX8Z7dDNOLzYFaZ0wq5WBd9bLvaK3YqHTgmFKRdlFWsdxhTEIa10WioJ5zRJoxwIXJUClalIZhu4a3u/99lsg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735573703; c=relaxed/simple;
	bh=OFYny5ygQaYtfVCiwjokbA9itmTuU9gAZSrEMEK+QJQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mDe85b5Y/XxfsVmCmeT3qPawCjSTUGF1TUWxe7ku2cGlBVCJuDy594x3DTY6QQ8mbqAVid60QRHjTw/O4cUgukVv5wsHcdS7E86yjWNKKL9cEBAf6kzPXs0oAQJAFi4JbnD0KKESgSd+JNgFOO2G8y7vYgaDY/m4MT1m5z+qPIE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LRPpEAKF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LRPpEAKF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EC85C4CED0;
	Mon, 30 Dec 2024 15:48:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1735573703;
	bh=OFYny5ygQaYtfVCiwjokbA9itmTuU9gAZSrEMEK+QJQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LRPpEAKF+lHl/5v9xXxObPpYxb84IdjwJC/99NCMsANMsBUg58ofp0Hkz2Cp7bm4n
	 a5APCQpdBrk6LOSwVSTuXwDXdVSF0Yx7grk/1yZBb0wd9X+MqfEF5ZPKPMihjM4x7z
	 J4Skql+G+PE43NR+YEChVE4SLVpCX1skpw04rbLs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zichen Xie <zichenxie0106@gmail.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH 6.6 11/86] mtd: diskonchip: Cast an operand to prevent potential overflow
Date: Mon, 30 Dec 2024 16:42:19 +0100
Message-ID: <20241230154212.144208705@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241230154211.711515682@linuxfoundation.org>
References: <20241230154211.711515682@linuxfoundation.org>
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

From: Zichen Xie <zichenxie0106@gmail.com>

commit 9b458e8be0d13e81ed03fffa23f8f9b528bbd786 upstream.

There may be a potential integer overflow issue in inftl_partscan().
parts[0].size is defined as "uint64_t"  while mtd->erasesize and
ip->firstUnit are defined as 32-bit unsigned integer. The result of
the calculation will be limited to 32 bits without correct casting.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Zichen Xie <zichenxie0106@gmail.com>
Cc: stable@vger.kernel.org
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mtd/nand/raw/diskonchip.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/mtd/nand/raw/diskonchip.c
+++ b/drivers/mtd/nand/raw/diskonchip.c
@@ -1098,7 +1098,7 @@ static inline int __init inftl_partscan(
 		    (i == 0) && (ip->firstUnit > 0)) {
 			parts[0].name = " DiskOnChip IPL / Media Header partition";
 			parts[0].offset = 0;
-			parts[0].size = mtd->erasesize * ip->firstUnit;
+			parts[0].size = (uint64_t)mtd->erasesize * ip->firstUnit;
 			numparts = 1;
 		}
 


