Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3468381BF;
	Fri, 24 Nov 2023 18:31:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pE513jPp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F77FC433C7;
	Fri, 24 Nov 2023 18:31:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700850686;
	bh=A57rKrJcq74Qoy057QDPavpnET90fPyk6M352lHOYW4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pE513jPp5fylKxFACfxcs29c5/sHDLJLlQHlG33gQr3Pon1jExZYG2QpfF9LRcN6M
	 JAXgmGvYpbF1eHQzj/pB9A0CUSkAouTQE/DMJOWiPwrYhIhm0DsLxKWlmQAeLx+5Wd
	 Z0R1YCUUrcrNdGbebLowYenYtnRHezK8KXDLEojg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	Sam Protsenko <semen.protsenko@linaro.org>,
	Thierry Reding <thierry.reding@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 149/491] pwm: Fix double shift bug
Date: Fri, 24 Nov 2023 17:46:25 +0000
Message-ID: <20231124172028.962622964@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124172024.664207345@linuxfoundation.org>
References: <20231124172024.664207345@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@linaro.org>

[ Upstream commit d27abbfd4888d79dd24baf50e774631046ac4732 ]

These enums are passed to set/test_bit().  The set/test_bit() functions
take a bit number instead of a shifted value.  Passing a shifted value
is a double shift bug like doing BIT(BIT(1)).  The double shift bug
doesn't cause a problem here because we are only checking 0 and 1 but
if the value was 5 or above then it can lead to a buffer overflow.

Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Reviewed-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Reviewed-by: Sam Protsenko <semen.protsenko@linaro.org>
Signed-off-by: Thierry Reding <thierry.reding@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/pwm.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/pwm.h b/include/linux/pwm.h
index 04ae1d9073a74..0755ba9938f74 100644
--- a/include/linux/pwm.h
+++ b/include/linux/pwm.h
@@ -41,8 +41,8 @@ struct pwm_args {
 };
 
 enum {
-	PWMF_REQUESTED = 1 << 0,
-	PWMF_EXPORTED = 1 << 1,
+	PWMF_REQUESTED = 0,
+	PWMF_EXPORTED = 1,
 };
 
 /*
-- 
2.42.0



