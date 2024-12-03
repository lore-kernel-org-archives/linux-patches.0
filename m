Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A7961F8906;
	Tue,  3 Dec 2024 15:30:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733239858; cv=none; b=aFXGBUpF3xxe0kA2+wABJnT0NndzXsy+YoBZCB98mKp/XE9yaUoR/2wwKdpS5SSSVZMbTjn1hjYJmH03NwNL3D7m9nUDXhACDrvQEBO2YUaOkWcmcgGyahF2f4XRK+lwOJ7O8QuPPyJL7gLMV9dTL+2SHCtN8l//SomvNDA3k6s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733239858; c=relaxed/simple;
	bh=UEzyhcbI43iylZCI/v2GDCH0AB4BaXckl+qAR9rthE8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KSCNdsNEf6NaUV/mYELBHjBIQYIMYzkF/FNfMq05YR/tRsf6xQxM1UCVGkWmT3pItjiyTXiw8Ff9ZEEhGhhxhTqcOKzHKvUH3XX8U0s4xojWXaiMjxQpyX/mtwLEWbBYu9HJrW8WELybTiYeFsMv2wYdmN2eHvdEfNd1HBXsYYk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bQ0ntAyd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bQ0ntAyd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F001EC4CEDD;
	Tue,  3 Dec 2024 15:30:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733239858;
	bh=UEzyhcbI43iylZCI/v2GDCH0AB4BaXckl+qAR9rthE8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bQ0ntAydDxUcoU6k7je7n5nsDeOFNhBEVNkLBRos+77gyr0r+1OznpwIrFhcJHiQW
	 DuPoxWfDtBGoLBSHS8bCbHReB44sjgIZEZM8zAGJyfycW5u5N359juuwHZKn5T4mk4
	 XTs/5u11PKZIiAHG6sPn3vahtZBmtQnQ2ar3/IJk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Andy Shevchenko <andy@kernel.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Kees Cook <kees@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.11 759/817] lib: string_helpers: silence snprintf() output truncation warning
Date: Tue,  3 Dec 2024 15:45:31 +0100
Message-ID: <20241203144025.622142363@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>

commit a508ef4b1dcc82227edc594ffae583874dd425d7 upstream.

The output of ".%03u" with the unsigned int in range [0, 4294966295] may
get truncated if the target buffer is not 12 bytes. This can't really
happen here as the 'remainder' variable cannot exceed 999 but the
compiler doesn't know it. To make it happy just increase the buffer to
where the warning goes away.

Fixes: 3c9f3681d0b4 ("[SCSI] lib: add generic helper to print sizes rounded to the correct SI range")
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Reviewed-by: Andy Shevchenko <andy@kernel.org>
Cc: James E.J. Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Kees Cook <kees@kernel.org>
Cc: stable@vger.kernel.org
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Link: https://lore.kernel.org/r/20241101205453.9353-1-brgl@bgdev.pl
Signed-off-by: Kees Cook <kees@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 lib/string_helpers.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/lib/string_helpers.c
+++ b/lib/string_helpers.c
@@ -57,7 +57,7 @@ int string_get_size(u64 size, u64 blk_si
 	static const unsigned int rounding[] = { 500, 50, 5 };
 	int i = 0, j;
 	u32 remainder = 0, sf_cap;
-	char tmp[8];
+	char tmp[12];
 	const char *unit;
 
 	tmp[0] = '\0';


