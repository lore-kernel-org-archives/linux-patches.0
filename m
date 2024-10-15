Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B66E41C57B1;
	Tue, 15 Oct 2024 12:07:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728994043; cv=none; b=PKmTsHbPe0xghh2tGm/6lNbjEF4mtQQ5TrxMV2p5RE2kf2/D8JRYm0sVoHL+mRRCileNLjsD8QRpF6tK5adPx1bPhnnSBEMjN1LSnt5Par7OGKMLslu+tu+HQqcCOka2c7zpvogCsBJD8CFxidvci0kRTJReJv4HVYQHNrY/ECg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728994043; c=relaxed/simple;
	bh=TupkwhHdmb3j4/diAYhm3OzxQbx9TllmrJpDdTaRuUE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aRXJSm/Td+ntlbV8O/QzuIx6x6NH8DDaat4z/vV81sB8dbGnY4+AdRy/D0+gbXaKyONu0pTR+PrqxOg3micPR7AKFIOdeRakTy5OeZtWW7Es5rP6hKHYfC+KubyFRrzef3sB0Xt0HKtl2tyHRTdV8o+DyDsKv1dvGv+jlIi8G1Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XWOGmeUq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XWOGmeUq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26FEBC4CECE;
	Tue, 15 Oct 2024 12:07:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728994043;
	bh=TupkwhHdmb3j4/diAYhm3OzxQbx9TllmrJpDdTaRuUE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XWOGmeUq01W4NozRMB7mHtiBeyMZW8uiThGKyJyhJl/Xx8oaZf2XkdePF68Teqthh
	 GYN68OHL8pYB1XOHlouxFDkYsJODKKiyS7aZLEmyjDqkChinuAFJm4UqHx0Qxl91I2
	 Bc9QLAOz7pr48zKfZkUGPwPYgeM1r9KaXp6xPtPQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masahiro Yamada <masahiroy@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 549/691] kconfig: qconf: fix buffer overflow in debug links
Date: Tue, 15 Oct 2024 13:28:17 +0200
Message-ID: <20241015112502.131227729@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015112440.309539031@linuxfoundation.org>
References: <20241015112440.309539031@linuxfoundation.org>
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



