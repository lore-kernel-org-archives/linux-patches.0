Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8794532AAD8;
	Mon, 27 Oct 2025 19:33:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761593621; cv=none; b=sq5iBnLbvMGahEe6/egqNODM6uIKSPN20pGhKD6FP0KH3euvBMlGBCDltTP7TTbQzZMVqcCcOYFly775KbMjiAVj6WR2OY4ykpvAWF6+BUdWZ5ZPKWib6M7hobUvgEXvz77vg5YX8oEvkbMxX2PmtAyHUws/DmM7RhEzDEmr+70=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761593621; c=relaxed/simple;
	bh=87IKOnEX0wbh/BrVi2Ii7HzQH1eqr09IOlKzVj3YN90=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GFWidp34bBTMoBf4nTbdqi2RLct2Q72Uq/bkWCyPQgVs1NuVASeTIf+kwPHoxWYmMpVQA7s9HhiP18JrAm1+N3bPABNV9TfG3kGGVo8mc+k8x7pLJWM4PGakbw0Ajyy58tt5nxNUWfNm+mR4HGCynXKIHgRXxM1OVytc1mweI70=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mvdb7Q9q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mvdb7Q9q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9150C4CEF1;
	Mon, 27 Oct 2025 19:33:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761593621;
	bh=87IKOnEX0wbh/BrVi2Ii7HzQH1eqr09IOlKzVj3YN90=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mvdb7Q9qrUKpp576ikte340W+7w55svQySu3fu0CcPXajgIhRI9hLBuGkeXUOqYbc
	 KZSycygN/AFTWrGcBGhGYgZxukK+HdIvpqcGJFXKuASpoQp5B9mmLG3nXh/HTn97hV
	 e58JxO0qU8l6zBi2Tv+XDeOtBof0DhCAR3GyYWKM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Junhao Xie <bigfoot@radxa.com>,
	Xilin Wu <sophon@radxa.com>
Subject: [PATCH 6.17 162/184] misc: fastrpc: Fix dma_buf object leak in fastrpc_map_lookup
Date: Mon, 27 Oct 2025 19:37:24 +0100
Message-ID: <20251027183519.288347409@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183514.934710872@linuxfoundation.org>
References: <20251027183514.934710872@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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
@@ -384,6 +384,8 @@ static int fastrpc_map_lookup(struct fas
 	}
 	spin_unlock(&fl->lock);
 
+	dma_buf_put(buf);
+
 	return ret;
 }
 


