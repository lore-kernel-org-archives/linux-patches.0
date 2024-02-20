Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C580A151CD6;
	Tue, 20 Feb 2024 21:28:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708464525; cv=none; b=e7Kpr0atRgTh/U4KPnMiRRInrHRq0KaMuveObkmjQkjAa9chNpQAzkG1iqKhIOnxPiFRCghDzdVat/e1TJr1vILX9SqQOcGSLzOQpazC9Agh6yXGD5gzjDiZIUnZBYDNzUKbwGo7T2ofix6c5OGCq3Ph//CUgcTW5izdhNWD+kw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708464525; c=relaxed/simple;
	bh=+dmMKUEnsNm4LP+kVMaiedRemHU3pQ+zAcZkn7t/ZJQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J4B358k67xwYnxHvHe+E4WwJZBdhv+4YacMxbBQxItpWaX4sWTbplHfptiMXN/xWeK80orKz5ioEeFPfGLPMThHxnHd1UWph0q1LvHgzj6FeL92ckLyXaxtQJSAdGuVb2/OMOLOZrBhn7rJLwWsgwYryqFz+KUHVtpyIlWMAYkc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Za21l+nB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Za21l+nB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 372FCC433C7;
	Tue, 20 Feb 2024 21:28:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708464525;
	bh=+dmMKUEnsNm4LP+kVMaiedRemHU3pQ+zAcZkn7t/ZJQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Za21l+nBIVU/OBqrjOBwArRZag3JP11Q3Q3nr8M2XuTHCgBTastgajLv087A14NeX
	 uo8OijZ4aoIgvDXo4FLkdmow6dZjgUsbrPx8jJKIn9Ibc9a8W6a99jhAPfRJi2vmp8
	 xYuUfYKapxUYyL62/TYsMb1pGRfa4ry+3FoNXS7Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sabrina Dubroca <sd@queasysnail.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Simon Horman <horms@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 052/309] net: tls: fix returned read length with async decrypt
Date: Tue, 20 Feb 2024 21:53:31 +0100
Message-ID: <20240220205634.829218311@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220205633.096363225@linuxfoundation.org>
References: <20240220205633.096363225@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit ac437a51ce662364062f704e321227f6728e6adc ]

We double count async, non-zc rx data. The previous fix was
lucky because if we fully zc async_copy_bytes is 0 so we add 0.
Decrypted already has all the bytes we handled, in all cases.
We don't have to adjust anything, delete the erroneous line.

Fixes: 4d42cd6bc2ac ("tls: rx: fix return value for async crypto")
Co-developed-by: Sabrina Dubroca <sd@queasysnail.net>
Signed-off-by: Sabrina Dubroca <sd@queasysnail.net>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Reviewed-by: Simon Horman <horms@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/tls/tls_sw.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/net/tls/tls_sw.c b/net/tls/tls_sw.c
index a6eff21ade23..9fbc70200cd0 100644
--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -2132,7 +2132,6 @@ int tls_sw_recvmsg(struct sock *sk,
 		else
 			err = process_rx_list(ctx, msg, &control, 0,
 					      async_copy_bytes, is_peek);
-		decrypted += max(err, 0);
 	}
 
 	copied += decrypted;
-- 
2.43.0



