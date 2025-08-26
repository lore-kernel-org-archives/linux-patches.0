Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 093AF1917ED;
	Tue, 26 Aug 2025 13:24:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756214693; cv=none; b=oHxHm49GWnv89CmesKlHv8G+g3ww1DNa3I1THCCtpFaeF4B8/9YWRPMZ0uhpeBlq1D13XB/pfj4DgN6hDoucIjZxbVvVx+agi99Sjib6VVKnXtnqMdY+gVPoHFXiwqCrSQeWhWKgjihnGIaXjbPZFgnLeCQbe21iVo8k6h1YwUE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756214693; c=relaxed/simple;
	bh=WkJgxodJhurwVObOmTorm2hue1PFGtUq0g8RkavUohM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jiJBNEcFt+WJ2ZdbjDMquE4gWzov9GCzLOyS9LBJ7ZPEEsz2VpP68PwBZofam7omAX6sjQXJqlCc73UGExH+1mGYMxVuZANNUq0a8jmm19r+enqbhG7Y5CJLU862cNxkTcawIb74A0Qo6I1gaeQI777Nafn+0OajtAMIrfUSUVU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fT1VQJ0b; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fT1VQJ0b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D63CC4CEF1;
	Tue, 26 Aug 2025 13:24:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756214692;
	bh=WkJgxodJhurwVObOmTorm2hue1PFGtUq0g8RkavUohM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fT1VQJ0bah/zunP3kAmRYwMeOqzWq+kP3rXRCCweDUwau3Z4x2rfioGrO3eAuTCWq
	 ElnFfxu7bjMh2K99Qtb8bVDnQyyqrG7RNWKtEAX5YQTwyLZzynLk2J0LmfFF/HE2GL
	 zekrB5Fc5NQjO4pZ2TcooHICtVVmsr2Wy5SgnhJY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mateusz Guzik <mjguzik@gmail.com>,
	John Johansen <john.johansen@canonical.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 216/482] apparmor: use the condition in AA_BUG_FMT even with debug disabled
Date: Tue, 26 Aug 2025 13:07:49 +0200
Message-ID: <20250826110936.113149277@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110930.769259449@linuxfoundation.org>
References: <20250826110930.769259449@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index d468c8b90298..fd57e9ffc139 100644
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



