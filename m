Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 598A7215782;
	Thu, 12 Dec 2024 17:01:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734022874; cv=none; b=MWJ6yJNoZFMhN/3SfMayivMLw16srfVOaaeYSNmhXoeL5PlC0Uo4o6kV5077/UoA4laVWie6BVKLOEhdVGvbC7tgZwSQe29YB85lfDcS0Vk4FtcoyQeqPFSeEmqN4GdyU7e/fyoCKZyj3z1a3elv01y4WZ2pq7Alx3kVCmenQns=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734022874; c=relaxed/simple;
	bh=WYm02KkL2MIB0lzRCizbXr751wzTZN3CmPcyHDw7Cm4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EcURQj/ED4otEizRPeh07v8BnjYcczFJg9oXEeNcBiydEuVCmYUd2iaNuiDwFXDIxa/bWafd7gEBbP8qEVZFefD86yoiZ7XrVEEYLvcjjqiRv0kwFZU7SMmN2WNDdhI1Z2vG4UtV2fhFrpXxC0HVmC3PEBpVGk/37CO4fn4qqtw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kW657lVx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kW657lVx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1F1FC4CECE;
	Thu, 12 Dec 2024 17:01:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734022874;
	bh=WYm02KkL2MIB0lzRCizbXr751wzTZN3CmPcyHDw7Cm4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kW657lVxplspRJVUAyg5chZpWthxGuR4/TeSUW0datjD3YNtZkUwBO1MU6JyFJ/r9
	 BjxEu+bobsFWNm1XVP0yzRyWgjPagQwl41H0XQzO6Gl8Ia2H5YEilfylMXUsUyzyji
	 21afLGyYxOsRzlzLnsTN2CewAfsLyMI5/pA/Znbo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Andy Shevchenko <andy@kernel.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Kees Cook <kees@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 5.15 350/565] lib: string_helpers: silence snprintf() output truncation warning
Date: Thu, 12 Dec 2024 15:59:05 +0100
Message-ID: <20241212144325.433349110@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144311.432886635@linuxfoundation.org>
References: <20241212144311.432886635@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -51,7 +51,7 @@ void string_get_size(u64 size, u64 blk_s
 	static const unsigned int rounding[] = { 500, 50, 5 };
 	int i = 0, j;
 	u32 remainder = 0, sf_cap;
-	char tmp[8];
+	char tmp[12];
 	const char *unit;
 
 	tmp[0] = '\0';


