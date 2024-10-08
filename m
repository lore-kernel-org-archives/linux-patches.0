Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A1B11B81CC;
	Tue,  8 Oct 2024 12:36:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728390962; cv=none; b=ApIRhxGxZz8BHQZRT1Y7Ojb6uxM9FrUX7RsNGzHhkRHun0VQZYM36sfbH6txmST1GQO0iOWzr44f8VkmG0z3fYZZY3KDZEEbL6IzuVlMZDPxDy0Okbdl4xIDT0Qf9+mvSbveUdpI7bofxKoR3k5+CvjDAb0We6LM/i2Z9wpeGGg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728390962; c=relaxed/simple;
	bh=UhgENZiIs/mKFaHyoyLQtepFnXxZkzopPy7MYylNsn0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PLKlYp09B0NFYu91xcEOS5f55e+P80CU1GpljFn++WUjW6Lkh0QBd4dNqMyzaywS4xnn1z2Ep+UBcvbGZVQykpJyKfVLqPFlehlP0c6gxNaJwB6ePUM1TJ5BgL8nBWYoDCGZTJmX+Ln5dQF+oUn0y4WDFa255LZ35HKgKanQois=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LTLldsrN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LTLldsrN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F224CC4CEC7;
	Tue,  8 Oct 2024 12:36:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728390962;
	bh=UhgENZiIs/mKFaHyoyLQtepFnXxZkzopPy7MYylNsn0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LTLldsrNS3r9R7BytNYDrPJ56uCQKOeAp02e7+XhLTOytGjg9K8omkpY/k5YJEzck
	 9jQXhIitd+/jMmwaMiNcRr2onEWqLeegnvOpVkgWoGcZmCJMF3pojgSEu8K4/uyu45
	 1JRBD/1989X6zbTRG96verbXt6uQwzV7CSOPyqJs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masahiro Yamada <masahiroy@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 447/482] kconfig: qconf: fix buffer overflow in debug links
Date: Tue,  8 Oct 2024 14:08:30 +0200
Message-ID: <20241008115706.112401488@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115648.280954295@linuxfoundation.org>
References: <20241008115648.280954295@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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
index c6c42c0f4e5d5..b7fc5aeb78cc0 100644
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



