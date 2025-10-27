Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A68AD23EA92;
	Mon, 27 Oct 2025 19:13:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761592419; cv=none; b=VfG6lvpOgug1D3dbz3o5xsPnWDeLRf3vlZE8/ND65sb1D/RVZMH3XAeQDW97cAD8woIldMuJ7LqXtZZb/iZgDLX4Ed9uEKtAdgtQpMAb0zwdang4oIM43F42QcnLDGxwshVKOW4m5umdcsH3FIYCJCt2vMwwp+eyj+tZ/IkQHWA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761592419; c=relaxed/simple;
	bh=pjRC55P4NRD/QfinddLnahd7Rz02A6Qt2gDwNBrLcUY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F4oGwBwHZXM1WbzA+23wNp5xinbm4rJwk5O7j2wEw3zinEHlyhuwI3dWd4MGwMh+FbomLm5btsX1zQZ2y3E5Wn2QEf1KOq+lFJlM6XLJTQR2ATEIhndSHrLuyZu2MOLWOQCwaWj7T4jTOE1i6pVSX2qTHy1gtB8Qh1DCBk2xpYE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HGfY/v1F; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HGfY/v1F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF392C4CEF1;
	Mon, 27 Oct 2025 19:13:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761592418;
	bh=pjRC55P4NRD/QfinddLnahd7Rz02A6Qt2gDwNBrLcUY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HGfY/v1FwYMgW7TVb1LJw43mF3Xv5dLFy7TyhNsY02xoB4Y+eRN6D2fhHH48S676i
	 4jWCCszgXOs2kJ617A+RTqt35xg33y5o7wEkAWjAnECH0kdFp+MuMkWh8IjdOXjik+
	 G6EWE9KGLQCcCgp6QkNKgKROaJvYVPGNsi/B573M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Junhao Xie <bigfoot@radxa.com>,
	Xilin Wu <sophon@radxa.com>
Subject: [PATCH 6.1 112/157] misc: fastrpc: Fix dma_buf object leak in fastrpc_map_lookup
Date: Mon, 27 Oct 2025 19:36:13 +0100
Message-ID: <20251027183504.255284477@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183501.227243846@linuxfoundation.org>
References: <20251027183501.227243846@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Junhao Xie <bigfoot@radxa.com>

commit fff111bf45cbeeb659324316d68554e35d350092 upstream.

In fastrpc_map_lookup, dma_buf_get is called to obtain a reference to
the dma_buf for comparison purposes. However, this reference is never
released when the function returns, leading to a dma_buf memory leak.

Fix this by adding dma_buf_put before returning from the function,
ensuring that the temporarily acquired reference is properly released
regardless of whether a matching map is found.

Fixes: 9031626ade38 ("misc: fastrpc: Fix fastrpc_map_lookup operation")
Cc: stable@kernel.org
Signed-off-by: Junhao Xie <bigfoot@radxa.com>
Tested-by: Xilin Wu <sophon@radxa.com>
Link: https://lore.kernel.org/stable/48B368FB4C7007A7%2B20251017083906.3259343-1-bigfoot%40radxa.com
Link: https://patch.msgid.link/48B368FB4C7007A7+20251017083906.3259343-1-bigfoot@radxa.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/misc/fastrpc.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/misc/fastrpc.c
+++ b/drivers/misc/fastrpc.c
@@ -363,6 +363,8 @@ static int fastrpc_map_lookup(struct fas
 	}
 	spin_unlock(&fl->lock);
 
+	dma_buf_put(buf);
+
 	return ret;
 }
 


