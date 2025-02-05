Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA60F1519AF;
	Wed,  5 Feb 2025 14:31:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738765904; cv=none; b=mwmP6Hjbxhi+chwWJ3SJIWV3A1Ek0aAhQKm+siej0bWR0q9z5niELOwrlF3KqeIB+mgiAFFmoS2Pw5TvSSNn/jGiG99fbGMq/Oa2IzA27gJfxK+vIj8OszaDf+/tvlCc88zNdMpifIJ/cJbyShl4952q/WcmKnXyoEsuLX90JJA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738765904; c=relaxed/simple;
	bh=vXPF7fEHkh5T1Iz2pn8Uptmj8DmFzg316w7UmvQ/JXQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=XJQ5Dgoi5VC6e2WzARrpqebxlE9OqipWNeqX+qllvaocJyp5lSRRa0cX3unrpIs85mV6NBVDcFJRQcE5SUCllnkWScJNSxSrW52Rio0QdKRttCmCnmsSHGW8KWXvZHI+i1tQIAlW8BOgaTgS21aYc86WCWfmU2l+lQ5RoDCB3hg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=J1wGs0nV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J1wGs0nV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 184BBC4CED1;
	Wed,  5 Feb 2025 14:31:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738765904;
	bh=vXPF7fEHkh5T1Iz2pn8Uptmj8DmFzg316w7UmvQ/JXQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=J1wGs0nVs1b1WLMiak49bOMwes/3Lqsqm6oEV+kAZ1crc9HLv7uIPxNNwBnWkW/Qk
	 m7fVi3ks+WSjoxyxGFbQfRtXBdYGGSmQBfQ4Ic6hijIWDjG734AyoODRoxZW2zlQi4
	 NU5eVyzyM1uqe/jkPLANchdlDtSr5hN9v6FBZGbA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <linux@weissschuh.net>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 266/590] padata: fix sysfs store callback check
Date: Wed,  5 Feb 2025 14:40:21 +0100
Message-ID: <20250205134505.452311772@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134455.220373560@linuxfoundation.org>
References: <20250205134455.220373560@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Weißschuh <linux@weissschuh.net>

[ Upstream commit 9ff6e943bce67d125781fe4780a5d6f072dc44c0 ]

padata_sysfs_store() was copied from padata_sysfs_show() but this check
was not adapted. Today there is no attribute which can fail this
check, but if there is one it may as well be correct.

Fixes: 5e017dc3f8bc ("padata: Added sysfs primitives to padata subsystem")
Signed-off-by: Thomas Weißschuh <linux@weissschuh.net>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/padata.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/padata.c b/kernel/padata.c
index d899f34558afc..ada4a0d137d9b 100644
--- a/kernel/padata.c
+++ b/kernel/padata.c
@@ -977,7 +977,7 @@ static ssize_t padata_sysfs_store(struct kobject *kobj, struct attribute *attr,
 
 	pinst = kobj2pinst(kobj);
 	pentry = attr2pentry(attr);
-	if (pentry->show)
+	if (pentry->store)
 		ret = pentry->store(pinst, attr, buf, count);
 
 	return ret;
-- 
2.39.5



