Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 316FA1E5B88;
	Tue, 26 Aug 2025 13:00:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756213230; cv=none; b=fpyG/pZHuZKfMmHEIzQsWyjGvIecg05AUBPV8VzbmDH4c+y3hfE1c5gIcUBTsLXwmrfkK24LX3j7wM/ZWW9DfTAzPb+loFmKFFbdByjzVdvuhnWdFynkbLopM11dJN5Tt2x0Lo0cFFLEieIOO4vuEIB34llKxPopMM6HFi0jJtE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756213230; c=relaxed/simple;
	bh=8ryxCbZGak5bUn21FTNots4p5piHp844vk01gA3F9NE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=FNKfVuZ4ruhtUZIiYdvFC4rka2lnQAJzZgPJFoa2Uk1VA44JOZJ1WX07gUFYdMXQRxtZ0LZ9bb9BUzFP5VMmxsoIQW7ls+43r2IoJTHr6T7utUq+vj51oXgiaZmAaGlCXbgeBwIwGvcYPkmPR+RXMNKGixDpDc7DV1DwffePsIo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cZIOTiT3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cZIOTiT3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3BDDC4CEF1;
	Tue, 26 Aug 2025 13:00:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756213230;
	bh=8ryxCbZGak5bUn21FTNots4p5piHp844vk01gA3F9NE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cZIOTiT3+xB20eC44IJ28eNoGu7je5v6DoPRF+pSv3EWNqW0NacJ8gJumW5mQ2X3Z
	 ISVzhOCwDf2MmY9l4AfOePR1sNgl0D6Nrc99QCv4qmdlFxwFZgHXnRE3xjCPw1FZtc
	 fuZmEUtwmWwYSNZkHdse4xhfB2UteT95T/WXpphM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mateusz Guzik <mjguzik@gmail.com>,
	John Johansen <john.johansen@canonical.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 270/587] apparmor: use the condition in AA_BUG_FMT even with debug disabled
Date: Tue, 26 Aug 2025 13:06:59 +0200
Message-ID: <20250826110959.797362159@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110952.942403671@linuxfoundation.org>
References: <20250826110952.942403671@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mateusz Guzik <mjguzik@gmail.com>

[ Upstream commit 67e370aa7f968f6a4f3573ed61a77b36d1b26475 ]

This follows the established practice and fixes a build failure for me:
security/apparmor/file.c: In function ‘__file_sock_perm’:
security/apparmor/file.c:544:24: error: unused variable ‘sock’ [-Werror=unused-variable]
  544 |         struct socket *sock = (struct socket *) file->private_data;
      |                        ^~~~

Signed-off-by: Mateusz Guzik <mjguzik@gmail.com>
Signed-off-by: John Johansen <john.johansen@canonical.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/apparmor/include/lib.h | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/security/apparmor/include/lib.h b/security/apparmor/include/lib.h
index 73c8a32c6861..6e88e99da80f 100644
--- a/security/apparmor/include/lib.h
+++ b/security/apparmor/include/lib.h
@@ -46,7 +46,11 @@
 #define AA_BUG_FMT(X, fmt, args...)					\
 	WARN((X), "AppArmor WARN %s: (" #X "): " fmt, __func__, ##args)
 #else
-#define AA_BUG_FMT(X, fmt, args...) no_printk(fmt, ##args)
+#define AA_BUG_FMT(X, fmt, args...)					\
+	do {								\
+		BUILD_BUG_ON_INVALID(X);				\
+		no_printk(fmt, ##args);					\
+	} while (0)
 #endif
 
 #define AA_ERROR(fmt, args...)						\
-- 
2.39.5



