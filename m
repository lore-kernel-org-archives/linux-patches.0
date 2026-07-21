Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FFE13BBFC0;
	Tue, 21 Jul 2026 21:00:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784667614; cv=none; b=jvw7uKq2cRrteC1xp+Np8+rmF/7nZ9bQKgPXVAaZnCew82utF5izL/rVY81xMqc2OPoSAZJA7EmJ7o2LEerdWI3KZVx1Y7SwxeST6SdfIgQYxGj80GH5ghIcOOjpDuWaU0cSCAswO6DAwtnMM+oz5NzLD/U61x5aoGfypq3fZGI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784667614; c=relaxed/simple;
	bh=q3W2ccOkl6969LDA8TfwQAzcT3Yc+hrGA6Fo2SIhENo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MTORxcPE/Uv7ezOpxuP8sRhfYzPi/Juh0aLY1zFwVJ/WECUpkNlm+1bWBEqN0nwLvKT39T53frCAxPw9SqV1JOVuF/tu1e6tccSCZrqIfbSEK0QfNmJxBTC7ZhlmSrSvRhOKpOUN+PVk8gw+hiOJhti59WTN+yk4cnlv31zG8Ok=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ow8emfCv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ow8emfCv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35DD91F000E9;
	Tue, 21 Jul 2026 21:00:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784667612;
	bh=stkvM4gHXrp3rhot4sRVRlorLRcvPkuVu0N+oc0fSQw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ow8emfCv5DLBj55GBSxRRa+hZL4I4h5HjxC8vTH5mhxV6oUvGL9Ujz6vNVdVXJTmN
	 jJKhHqc8PRzbPnfE/zQ67DmdBCVpprFNtBvxK96KWcLaORrTO8L3vvpljreqOPua1W
	 bivNDzv/RYI9MUgTc44TlGuwjIaN0HcClw+o7rrA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thorsten Blum <thorsten.blum@linux.dev>,
	Madhavan Srinivasan <maddy@linux.ibm.com>
Subject: [PATCH 6.6 1127/1266] powerpc/pseries: fix memory leak on krealloc failure in papr_init
Date: Tue, 21 Jul 2026 17:26:04 +0200
Message-ID: <20260721152507.016010056@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
 


