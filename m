Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B67981E04B1;
	Tue,  8 Oct 2024 13:29:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728394141; cv=none; b=C9+V69Vsj3x4u1Zs4lLzBme0Tp2TYjFUhXzXJMIdMju3Ta0Xs+TcHOjHDUYgIGA3lwpL3qqla+Bl/uJdmz9iaXv5ry7XOGnCLFaTea05Nn9ZUbVNN7FGxWQ8i2mknGsSf301yORMA7gULdEIuIBEP0qCc/ZOHI2GSsLSSnje7es=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728394141; c=relaxed/simple;
	bh=F2U8gnE1xZpAZR6F5MjYyBrhZJiUzFvSbmUP63SXloI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tNWiFB1qwd3LscRV2bRZeoJrQh67fX0B35wZtNEmhjHPwhpTTeBYi8WFJWzkD8OgXdJb/BSZsx/D2pHK0NZp/fZbO41JHMjO+tcQOSQH4YT1fAIJlHuLi3X9T1qHr4DR/G+jS7sqB7Ry2E0EHAALWM+/3vtPUlJtKqzDAP9JfVI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W1rhPo3Y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W1rhPo3Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2339CC4CEC7;
	Tue,  8 Oct 2024 13:29:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728394141;
	bh=F2U8gnE1xZpAZR6F5MjYyBrhZJiUzFvSbmUP63SXloI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=W1rhPo3Yz0BcWcU5HpTY49CrYn2c1c//O9l7AtZ9kR4XC9WYFahZcw6/LhsVRUM9A
	 TTOryq5xQnKWX2wxV1F34It6cffZZN8+5IsfZUjjTtpxPvBswnakrLfUhVOQYYAIck
	 RQugmliyS5DPh9x1Pu7VepnomqZe0ygC0f7a2yV8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masahiro Yamada <masahiroy@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 328/386] kconfig: qconf: fix buffer overflow in debug links
Date: Tue,  8 Oct 2024 14:09:33 +0200
Message-ID: <20241008115642.291923970@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115629.309157387@linuxfoundation.org>
References: <20241008115629.309157387@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 620a3527c767a..4f3ba3debc08e 100644
--- a/scripts/kconfig/qconf.cc
+++ b/scripts/kconfig/qconf.cc
@@ -1174,7 +1174,7 @@ void ConfigInfoView::clicked(const QUrl &url)
 {
 	QByteArray str = url.toEncoded();
 	const std::size_t count = str.size();
-	char *data = new char[count + 1];
+	char *data = new char[count + 2];  // '$' + '\0'
 	struct symbol **result;
 	struct menu *m = NULL;
 
-- 
2.43.0



