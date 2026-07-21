Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08AF646A5E7;
	Tue, 21 Jul 2026 17:33:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784655218; cv=none; b=sZvCe4RLiyKJs03diUy3aCspzBLy5qXNcF490wF1zPP4udt3JXXb2vFj2hhDtPJpjOt5i1U3S/8fRAX38c0HXsCQ1OYz/3VBTGHiklIRNVD4VcnCvDR4Ae3VdcYLNpTdMTX6ynRDGmgCCe0QNf/6stHvz6+wvdtXXQ78hH1iQCI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784655218; c=relaxed/simple;
	bh=jBSXJUcM0y66T+8YP7EofusCMgM8hOOg/7+cyKgZ278=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZZqjmMLFTAkgNlXYDJgfNEEzah6BWOGOI+4V503r07bzVgrePhETgwRu8F+G57y0CB9KSn4ym6UPVd8r4Nw10lRCsirDnEoshwOwcRLUUHNy3Bw96OqXIqaTXBdCsjjejaPWJ41eeIoQeK0aczlON0p+OWXvcJpJE8wxKicQAqs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jkucwc+k; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jkucwc+k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69DDA1F000E9;
	Tue, 21 Jul 2026 17:33:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784655216;
	bh=vOU3ofr0rsRfs+Tv8m06DnFcCGDa+g1v8GJ0DlvZT+E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jkucwc+k51c4+5/8G1UCt/uHIUbFkRbdLW1dzj1GKDqXtlan3ZxeLUgc4GTItL2Jc
	 VD3bY1M3X1zWtGoosTUCBoxtW/h0jPoeQajA1cGtVH2wJAm8t5Tf11mGvPmRUyXiZH
	 BR9DkPdgMt73hJL/lXkRWvScB8ZBE3Dxw/K63B+w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thorsten Blum <thorsten.blum@linux.dev>,
	Madhavan Srinivasan <maddy@linux.ibm.com>
Subject: [PATCH 7.1 2001/2077] powerpc/pseries: fix memory leak on krealloc failure in papr_init
Date: Tue, 21 Jul 2026 17:27:54 +0200
Message-ID: <20260721152639.911214872@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thorsten Blum <thorsten.blum@linux.dev>

commit bd83c98b988d2c560531084e296dbfb530aff829 upstream.

When krealloc() fails, free the original esi_buf before returning to
avoid a memory leak.

Fixes: 3c14b73454cf ("powerpc/pseries: Interface to represent PAPR firmware attributes")
Cc: stable@vger.kernel.org
Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
Signed-off-by: Madhavan Srinivasan <maddy@linux.ibm.com>
Link: https://patch.msgid.link/20260614142356.658212-2-thorsten.blum@linux.dev
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/powerpc/platforms/pseries/papr_platform_attributes.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

--- a/arch/powerpc/platforms/pseries/papr_platform_attributes.c
+++ b/arch/powerpc/platforms/pseries/papr_platform_attributes.c
@@ -271,11 +271,9 @@ retry:
 		esi_buf_size = ESI_HDR_SIZE + (CURR_MAX_ESI_ATTRS * max_esi_attrs);
 
 		temp_esi_buf = krealloc(esi_buf, esi_buf_size, GFP_KERNEL);
-		if (temp_esi_buf)
-			esi_buf = temp_esi_buf;
-		else
-			return -ENOMEM;
-
+		if (!temp_esi_buf)
+			goto out_free_esi_buf;
+		esi_buf = temp_esi_buf;
 		goto retry;
 	}
 


