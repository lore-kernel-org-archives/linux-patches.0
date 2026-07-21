Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FD6E3FC5BD;
	Tue, 21 Jul 2026 18:42:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784659331; cv=none; b=lXwRUE3RL5iaqFOOUqInmGtNzfZwDl7JofoZ3ndU4XqeXiyZ2LMyYjJFJX5jbr2HPX2qL/+4ggNs7h/iq4PexIS8lE6a0VAW7TAqmUpwMu6mIADIcP2z0z7IELAWfHgKP/xmr8BOVW5MZGlXKPdYQjfDAGppmludmkaB5zWBUUA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784659331; c=relaxed/simple;
	bh=nsB8hWPDFSiy7QLoPfn8g+ZfaYDxcGtm8tMp30xTWZw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VZVTVX2XOYvhXoARbPa/WJXVC6VXGyNlgnSVQ6nIPlQSTLz1cjPba7+ocPOovGWyHmlJLGfhqQNpXInS4l31d9l+wSX8HQmaBTrKVUEiL5h0eDsEcZEn3HBZK17O681krUyEN3SzFMu9HTu1wKay0S/lBYKljRHgNbI7SXs1s7o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oMpMpKXJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oMpMpKXJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 857DB1F00A3A;
	Tue, 21 Jul 2026 18:42:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784659330;
	bh=5KPCCfe3M0Np+INBgHBbo3DbCBpGiDE5A8tHkZ8NrUU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oMpMpKXJi4y6ObgBO03kBbJyvU+mstuMv+WqbtgECJ5Ie6AtB9mBc0/skDAjv5nTi
	 FomH6/h3cE8uyARY2QoJ1OYvQ7KW+tKbLV3tXNayh3f2YJ9sF/cmaQ7Xq8ApwDIN8w
	 i73Zi3rmDpIohjOk9+Wd3jV67zkcJP52+7v7tZPc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thorsten Blum <thorsten.blum@linux.dev>,
	Madhavan Srinivasan <maddy@linux.ibm.com>
Subject: [PATCH 6.18 1478/1611] powerpc/pseries: fix memory leak on krealloc failure in papr_init
Date: Tue, 21 Jul 2026 17:26:34 +0200
Message-ID: <20260721152548.691320888@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
 


