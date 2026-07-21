Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D3743B71A0;
	Tue, 21 Jul 2026 21:46:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784670400; cv=none; b=HeBoa0cwBAbzrjcrJLXNOOVQoSbblMrhCi3F+yHv1llfF1QhNG4wZKMYiwfGNgoB76DxAO3R4FkQbLEMS77HJYrrXCH2iph3+knPWEesofFMJPgc72X+jsxNdHiE2Q6ZWhRuOyIXLgoe1+cG+jqC/PaKxSpciudvLIMw1ngr90M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784670400; c=relaxed/simple;
	bh=qxkomf/qR/HPmy4zruvwpFya+UAAOl5dfYxLB6F3H5Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oRV0R9lNvtnjg3ax/ds5QUWdUbJU05JV5IkIE35vVU2pofC1rXlEYIzlkcpmB/fv2SA67viAXrdgDx/hSFH30yqhxMOD5ktpIlXSeAeeI8XfwAHImnsDUfIzWI66pQMZJ/0eeqsVdoCHfeQyrMetYrNsxqEROGlHFMHGHa9vA50=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JQC9ZFQh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JQC9ZFQh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D90001F000E9;
	Tue, 21 Jul 2026 21:46:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784670399;
	bh=a/kwiRPkJsfKITjsLLbX+I7Dyb0i06m/IloV00Qco2Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JQC9ZFQhUa7uEyymrzzEmP0PlG5/c1Wc9jAZ15YJWaTJ/hmCRk94pJizSTLmMgg8f
	 MH7C5rS2tjKihY4m2Zm9uGv4dWVv3MNJk0Z1+0YYdqKJjmMfWZNOwyTl4aHxu3TrmD
	 TPLHdz4/fm4g0vSMkG9SCiWNztj1i8JgyyEvdfPc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thorsten Blum <thorsten.blum@linux.dev>,
	Madhavan Srinivasan <maddy@linux.ibm.com>
Subject: [PATCH 6.1 0917/1067] powerpc/pseries: fix memory leak on krealloc failure in papr_init
Date: Tue, 21 Jul 2026 17:25:18 +0200
Message-ID: <20260721152445.048603767@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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
 


