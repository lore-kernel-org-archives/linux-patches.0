Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5143E174ED0;
	Wed,  3 Jul 2024 10:56:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720004197; cv=none; b=PODtbf66psrfU0ZGGZ/qmdSujKGHVUbdPtJ7HFKWKunqxpYkI+t4039jCeWDKQv79WurZaIVougA5juOCkHq8XjLAFusxNQzT32f9QiTVIB1Teo/TYAKamB2uDJ2Ytik2xi90N1cZ4VBKBkgm70wzHzTXJmg+z0Do1j2UxJdH80=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720004197; c=relaxed/simple;
	bh=hqtvxnbBgJmH3Pwp29ZUc6dks65AYasuRBXXw9yLBdo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mCxl+Vo3YNYRByQ3TgipPITH+hX6qi2YJz28+2LNTWT0LSmGVhPIEwAy67urk92NX6VkkDTUyRM72+yd6m0o7evT18Zqcu1/mlDDjT4DAcvi47kV6iTmDby5TtakMeNAMEsbrx/GzoEMNepTzUuf0gWT35mS4JyUJ9+oN0TVYIY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CVrJQvto; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CVrJQvto"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D1E0C2BD10;
	Wed,  3 Jul 2024 10:56:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720004196;
	bh=hqtvxnbBgJmH3Pwp29ZUc6dks65AYasuRBXXw9yLBdo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CVrJQvtoNXHuMAopiboGwOcDYhNk7DV2A93P7h+G9e7DY9HldmBiaokR05Uo6w0ZA
	 nwvxvZZaMSMkU8O7t7jls/cANVMD5nCFszryM/pRujtOS8QySv+yeULEWKzpHPDcZa
	 dJwgwjTD4e3X+RVPm34BZOOgpydoC4Mz7duA0ibk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ricardo Ribalda <ribalda@chromium.org>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 152/189] media: dvbdev: Initialize sbuf
Date: Wed,  3 Jul 2024 12:40:13 +0200
Message-ID: <20240703102847.209341672@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102841.492044697@linuxfoundation.org>
References: <20240703102841.492044697@linuxfoundation.org>
User-Agent: quilt/0.67
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ricardo Ribalda <ribalda@chromium.org>

[ Upstream commit 17d1316de0d7dc1bdc5d6e3ad4efd30a9bf1a381 ]

Because the size passed to copy_from_user() cannot be known beforehand,
it needs to be checked during runtime with check_object_size. That makes
gcc believe that the content of sbuf can be used before init.

Fix:
./include/linux/thread_info.h:215:17: warning: ‘sbuf’ may be used uninitialized [-Wmaybe-uninitialized]

Signed-off-by: Ricardo Ribalda <ribalda@chromium.org>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/dvb-core/dvbdev.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/dvb-core/dvbdev.c b/drivers/media/dvb-core/dvbdev.c
index d4d903a9dc31e..ba91c6f8fe1d8 100644
--- a/drivers/media/dvb-core/dvbdev.c
+++ b/drivers/media/dvb-core/dvbdev.c
@@ -974,7 +974,7 @@ int dvb_usercopy(struct file *file,
 		     int (*func)(struct file *file,
 		     unsigned int cmd, void *arg))
 {
-	char    sbuf[128];
+	char    sbuf[128] = {};
 	void    *mbuf = NULL;
 	void    *parg = NULL;
 	int     err  = -EINVAL;
-- 
2.43.0



