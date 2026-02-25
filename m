Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DA6918B0A;
	Wed, 25 Feb 2026 01:34:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983258; cv=none; b=U7z/GHUbWl7Q8Yi5orcuaVFbLTkoD5KeodIK0G+FIwSU7SKZVSzxgearMv/w+8T+vyw0EDVt4Y5FcPNsV7ifmE4lxoeKZI2eS6tCjB+69DlocijxPh8ubfAQJpIrdarQsUAUvBCPHFtow8g8Y9jLU7Wj2jZ47uwXerhpqdpnpOc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983258; c=relaxed/simple;
	bh=dLOC8WtdoLCIqT4czpy/2SKgBCUBAF9t0uc7zTlO8uQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q9Nl/6I9sawp8CuuzETzvpNVq9eeDS+GtllWlc2hsFwS4nWa46Z/tUTpbdNsceqtIWZjVBpMv+TE4W9yFCQtIclnn1t2oEeB0YJ4/O8i5SQh660VofC6q8ajrdLlwWqL256pONgD7Xp3Yi1x2yv0m5/vfy1KTmPJCz+bRZ/n/24=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lH+9h3YH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lH+9h3YH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54C34C116D0;
	Wed, 25 Feb 2026 01:34:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983258;
	bh=dLOC8WtdoLCIqT4czpy/2SKgBCUBAF9t0uc7zTlO8uQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lH+9h3YHbh9+ZsMYKD0WycjZC/kkyQTNhhx7nvtziFD/sSAtvY1dWzjo+fP7DPI/b
	 bYFwvBU5jaJm6BxCJUSBP0jOVsybl4l0HjIkCeaIoLo8AHWoBVZsAALPFasnbq6OHx
	 Q2XgwAppXf43xhCsKjdre4BRsGNm+Tpx+bxdd074=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tuo Li <islituo@gmail.com>,
	"Rob Herring (Arm)" <robh@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 400/781] of: unittest: fix possible null-pointer dereferences in of_unittest_property_copy()
Date: Tue, 24 Feb 2026 17:18:29 -0800
Message-ID: <20260225012409.516957176@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tuo Li <islituo@gmail.com>

[ Upstream commit d289cb7fcefe41a54d8f9c6d0e0947f5f82b15c6 ]

This function first duplicates p1 and p2 into new, and then checks whether
the duplication succeeds. However, if the duplication fails (e.g.,
kzalloc() returns NULL in __of_prop_dup()), new will be NULL but is still
dereferenced in __of_prop_free(). To ensure that the unit test continues to
run even when duplication fails, add a NULL check before calling
__of_prop_free().

Fixes: 1c5e3d9bf33b ("of: Add a helper to free property struct")
Signed-off-by: Tuo Li <islituo@gmail.com>
Link: https://patch.msgid.link/20260105071438.156186-1-islituo@gmail.com
Signed-off-by: Rob Herring (Arm) <robh@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/of/unittest.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/of/unittest.c b/drivers/of/unittest.c
index 3b773aaf9d050..9c184e93f50c6 100644
--- a/drivers/of/unittest.c
+++ b/drivers/of/unittest.c
@@ -804,11 +804,13 @@ static void __init of_unittest_property_copy(void)
 
 	new = __of_prop_dup(&p1, GFP_KERNEL);
 	unittest(new && propcmp(&p1, new), "empty property didn't copy correctly\n");
-	__of_prop_free(new);
+	if (new)
+		__of_prop_free(new);
 
 	new = __of_prop_dup(&p2, GFP_KERNEL);
 	unittest(new && propcmp(&p2, new), "non-empty property didn't copy correctly\n");
-	__of_prop_free(new);
+	if (new)
+		__of_prop_free(new);
 #endif
 }
 
-- 
2.51.0



