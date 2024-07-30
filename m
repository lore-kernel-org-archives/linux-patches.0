Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CADC1C9EA6;
	Tue, 30 Jul 2024 16:00:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722355248; cv=none; b=dpa8MR/DEeoYQ68DZZhxv3aGKrT5AkUuBDf/Twmn/1iTdsvuyu3kTiEsoOtrdoWlBU7ua+tJhIR3A8LZcakBYiXVR3Cg+XwOYza1U6afzt546nXN39WBdX1I46RZOapb5ygvxsNJt8p7+71yVY9dD4HvC/P5lgiLrAbv1OLjZvo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722355248; c=relaxed/simple;
	bh=aztqhg9yLqjZ41JJSAKdsH9Nr53tNs5LP/mkiY1s09U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QSo58gPeDJ6qF/IOJ4hnjdl+03oDcyTF6nsVIGjW1veo4F+x2rz6F3mwpv4XJsxbDzltFRob/glxCR9s0vFDIrDFkyCiPiKNei8OmAUrZ1CyXpBSg8iVax1heM3SI6S7/uaUxAQaBbV/ILEgVK8NA0G7LDlSo4szWT7w6wulCxg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dzDg/ppu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dzDg/ppu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3E56C32782;
	Tue, 30 Jul 2024 16:00:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722355248;
	bh=aztqhg9yLqjZ41JJSAKdsH9Nr53tNs5LP/mkiY1s09U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dzDg/ppuhaN1otGQ8GCSaJft9dy4MLpsDILYXb9i2U+m6W0eSZJm48ukGzr2wmuDE
	 8Oc2PD679VbxGB0tCAs+OuEnOHTznHHBkxEzXI29NfyhICbLc7dHJ7FeX5vosGsbGt
	 anftHlR1EsGk5dHKMhYC7sviSfpYedIDVv89IZm4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thorsten Blum <thorsten.blum@toblux.com>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 076/440] m68k: cmpxchg: Fix return value for default case in __arch_xchg()
Date: Tue, 30 Jul 2024 17:45:09 +0200
Message-ID: <20240730151618.730873705@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151615.753688326@linuxfoundation.org>
References: <20240730151615.753688326@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thorsten Blum <thorsten.blum@toblux.com>

[ Upstream commit 21b9e722ad28c19c2bc83f18f540b3dbd89bf762 ]

The return value of __invalid_xchg_size() is assigned to tmp instead of
the return variable x. Assign it to x instead.

Fixes: 2501cf768e4009a0 ("m68k: Fix xchg/cmpxchg to fail to link if given an inappropriate pointer")
Signed-off-by: Thorsten Blum <thorsten.blum@toblux.com>
Reviewed-by: Geert Uytterhoeven <geert@linux-m68k.org>
Link: https://lore.kernel.org/20240702034116.140234-2-thorsten.blum@toblux.com
Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/m68k/include/asm/cmpxchg.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/m68k/include/asm/cmpxchg.h b/arch/m68k/include/asm/cmpxchg.h
index 6cf464cdab067..694a44a5c3b05 100644
--- a/arch/m68k/include/asm/cmpxchg.h
+++ b/arch/m68k/include/asm/cmpxchg.h
@@ -32,7 +32,7 @@ static inline unsigned long __xchg(unsigned long x, volatile void * ptr, int siz
 		x = tmp;
 		break;
 	default:
-		tmp = __invalid_xchg_size(x, ptr, size);
+		x = __invalid_xchg_size(x, ptr, size);
 		break;
 	}
 
-- 
2.43.0



