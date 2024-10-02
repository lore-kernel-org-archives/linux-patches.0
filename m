Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DD6C198A1A;
	Wed,  2 Oct 2024 14:23:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727879018; cv=none; b=d0I4zOcBRBWDEUNMeVRC2eLs5yrLi2cmGKyW6mvHD8SM5iR7ZIRUL7tS6YSh5NkUWKVVFJuEsiQiZytCbdMHEFiriM5ZrMEHyv4qHjAeCuMO1UGmM5WCEFaqD/oc7q+uTQrh2w1qEbuqTUskVIG81qWanZzceIRCpZP4ew0vvEI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727879018; c=relaxed/simple;
	bh=zLIZ8uXvllxf4kOqywkBzpJILNSpYuAkJDEqBhnYRvo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AfRcEoE4D0TmWGUB9n3/tIifnmNTnHJcJYM7V+QeVHRCMtzSBrB7BsqILkorUuTwpxivchRZdEei7YbdHJHnfoQa8rLx3FAXRWKZ30p7T1Kbr5w4sE4xVtp9mzRFKP4K5WmW0G76TAAYzsEoCs08K+l8M8TOeg7NEY1/CFn9uk4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=I9sjwkmP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="I9sjwkmP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 170D9C4CEC2;
	Wed,  2 Oct 2024 14:23:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727879018;
	bh=zLIZ8uXvllxf4kOqywkBzpJILNSpYuAkJDEqBhnYRvo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=I9sjwkmP5fgGEo/Oemw//fAwtc64Tu6cK99yc6sM+THLaHOeycl49r02rLovSEQmc
	 +x6BphDjIlsBJwqrQHAArBZeTTfqEU2S/1w66GeMlmA5sumA/deN+JuacXoOsvZvRX
	 teg09L/bGqH6eJKM9UEkihLC4dRu0C1hBOaAEkKY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qiuxu Zhuo <qiuxu.zhuo@intel.com>,
	Tony Luck <tony.luck@intel.com>
Subject: [PATCH 6.10 579/634] EDAC/igen6: Fix conversion of system address to physical memory address
Date: Wed,  2 Oct 2024 15:01:19 +0200
Message-ID: <20241002125833.971622340@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125811.070689334@linuxfoundation.org>
References: <20241002125811.070689334@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Qiuxu Zhuo <qiuxu.zhuo@intel.com>

commit 0ad875f442e95d69a1145a38aabac2fd29984fe3 upstream.

The conversion of system address to physical memory address (as viewed by
the memory controller) by igen6_edac is incorrect when the system address
is above the TOM (Total amount Of populated physical Memory) for Elkhart
Lake and Ice Lake (Neural Network Processor). Fix this conversion.

Fixes: 10590a9d4f23 ("EDAC/igen6: Add EDAC driver for Intel client SoCs using IBECC")
Signed-off-by: Qiuxu Zhuo <qiuxu.zhuo@intel.com>
Signed-off-by: Tony Luck <tony.luck@intel.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/stable/20240814061011.43545-1-qiuxu.zhuo%40intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/edac/igen6_edac.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/edac/igen6_edac.c
+++ b/drivers/edac/igen6_edac.c
@@ -311,7 +311,7 @@ static u64 ehl_err_addr_to_imc_addr(u64
 	if (igen6_tom <= _4GB)
 		return eaddr + igen6_tolud - _4GB;
 
-	if (eaddr < _4GB)
+	if (eaddr >= igen6_tom)
 		return eaddr + igen6_tolud - igen6_tom;
 
 	return eaddr;


