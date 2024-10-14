Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42C5483A14;
	Mon, 14 Oct 2024 15:24:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728919478; cv=none; b=kOh5rqT4y9vOh82UBiz17k+0s7mu1XpiY5WsdKZvEArm3q3Q6OJS8xy+CXN0ZVjIm4mQ6dUCByOcA0O1YQbCnS2dJ4TacPgSsmNNVgMnPB5sl0R9LISqJp4Z7YwieW5NMWxuJNSCU4HpZH77SXi3DmWG3YnPiGWTltjUm/e1dAw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728919478; c=relaxed/simple;
	bh=yvlx4w7xSzDx1cGumehxkxoesN+DAN08e/5vqpF6yec=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iZZRef6GeR3gJchngzlWQRw9TmTQDFTEu5j9yI0wnVhGzi6sh8RM9ukd0l914JJl/0/2LqHaiwudEz3Yea9GKp0PQqLhYT2OHhCef9WDjDdVWgDn1UEGlxOTJ87xssEwJNZXYZ/av/JIDFgv8/AaJewSCaTs7xaH8gTxJYeuH/o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b5+t+Cj9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b5+t+Cj9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7926C4CEC3;
	Mon, 14 Oct 2024 15:24:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728919478;
	bh=yvlx4w7xSzDx1cGumehxkxoesN+DAN08e/5vqpF6yec=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=b5+t+Cj96kR5g7t6DlzrGDoG3q1sUUF9EkuSrKkcglppNtiTehfl+cea2QzWZ/yYc
	 /CRwC9nm40d3SZAx71SP6yvGbvwWmi6GhcFscUYmEkOg747L/deKU709KVoBuNZyRq
	 q6KOkegh1oPWoVK2ymzrWCMIIB8iURaR4D26hWuY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masahiro Yamada <masahiroy@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 617/798] kconfig: qconf: fix buffer overflow in debug links
Date: Mon, 14 Oct 2024 16:19:31 +0200
Message-ID: <20241014141242.280771494@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Masahiro Yamada <masahiroy@kernel.org>

[ Upstream commit 984ed20ece1c6c20789ece040cbff3eb1a388fa9 ]

If you enable "Option -> Show Debug Info" and click a link, the program
terminates with the following error:

    *** buffer overflow detected ***: terminated

The buffer overflow is caused by the following line:

    strcat(data, "$");

The buffer needs one more byte to accommodate the additional character.

Fixes: c4f7398bee9c ("kconfig: qconf: make debug links work again")
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 scripts/kconfig/qconf.cc | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/scripts/kconfig/qconf.cc b/scripts/kconfig/qconf.cc
index 78087b2d9ac67..61b679f6c2f2a 100644
--- a/scripts/kconfig/qconf.cc
+++ b/scripts/kconfig/qconf.cc
@@ -1172,7 +1172,7 @@ void ConfigInfoView::clicked(const QUrl &url)
 {
 	QByteArray str = url.toEncoded();
 	const std::size_t count = str.size();
-	char *data = new char[count + 1];
+	char *data = new char[count + 2];  // '$' + '\0'
 	struct symbol **result;
 	struct menu *m = NULL;
 
-- 
2.43.0



