Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB8DC223C42;
	Thu, 12 Dec 2024 17:44:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734025473; cv=none; b=F7ZP8TEejVsgzZAoYI0MU2T8kvkS6ITf/jt9AZ7KMHLMb6EIUq7BcVZTGCUW0DVhnnRAmhTo9O1HWFM9iYx4ECCYn5QoqrtbnbYldpsz3a+bvYU/Bfu7rFTGUrgSgfF8yUkpOA73REj3Lf1SaXI0ia7EqYcAO83lJ0NG6bmVNPY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734025473; c=relaxed/simple;
	bh=fc2yK8/m05vTPPrxQ5orf1m1S+eX3n2O/yqxC48JeyU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Zhex0QQGU+RWBem3TgV/A3wd5nornkP1zsQAwTUPpKVsBYCLhPgNVTXjup2aCu57BvxBNi3hLCjEf7IbVYsmOj4UPvNo2EQ0Nal3N9wM21/Q6tZm7mFFH/k8gm4470VBaS3Fo3XvoFAPr7nVkF4VZydbXEyG3VnpGem4jl/qxUU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nsPzR2LA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nsPzR2LA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F6A5C4CECE;
	Thu, 12 Dec 2024 17:44:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734025473;
	bh=fc2yK8/m05vTPPrxQ5orf1m1S+eX3n2O/yqxC48JeyU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nsPzR2LAym/A5mm6Mz9slAxBflefztl3tAOJO09zlcaMCTuf55LyEpr0yoWgpdjnn
	 N2azGQ83NDuB1RcKaLY2Kwg0+OHjKZacuc9RovL7Z70jymzXKfEEG45pkfar9iqY/2
	 nLTbeipC1QcjXfrrwlYTpP+R9JLIeRbSdcSceSP8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Andy Shevchenko <andy@kernel.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Kees Cook <kees@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 5.4 174/321] lib: string_helpers: silence snprintf() output truncation warning
Date: Thu, 12 Dec 2024 16:01:32 +0100
Message-ID: <20241212144236.857177115@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144229.291682835@linuxfoundation.org>
References: <20241212144229.291682835@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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


