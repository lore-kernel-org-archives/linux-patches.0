Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3FE91DED48;
	Tue,  8 Oct 2024 13:07:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728392829; cv=none; b=KVUbocBwkKRNDZF+VUIuAIOUhvd0LUHTIRYmf6ca75bTG4ZuzrocqtGQhkvOYrwdqHR5oMbYUShfYU948JEW9paYhbmtQ2v5QpZxbLLiJX4wvfu7K5uS2fUb7JTfL8k6w+2qCSM75MOLBT5gIAek0xr64Xf1hmj6Dcx97ZaneVQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728392829; c=relaxed/simple;
	bh=ZY9J1rUoAMbFRWfwDmkyUngGnGpFCHOvpmdNkNL4vMs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lNaK4ukY5Ow+5QfR3mBVx7Sz+HBt4fR5WWmQdnSWlL2JBTNUtSobafPZgVDDOi8hrO4deNCVmwN1YuDfm2Oi8c60+STFwiDjLau65OWv2JzeRL5bfrh1cBQLiSC6DliDrVLY5SqqHQdA5Nfz1YlJoWQ7h++m22Z03jPZuDpJTgI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OlcKwBOK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OlcKwBOK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DF98C4CEC7;
	Tue,  8 Oct 2024 13:07:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728392829;
	bh=ZY9J1rUoAMbFRWfwDmkyUngGnGpFCHOvpmdNkNL4vMs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OlcKwBOKAGX6Yq3VwssrHXyg4mVs1ZHDaM8HwGnD8YSjkx4ao2Wmw0sIiFcUwDvKu
	 i35KXygtJ9xWaw3poYIGuBJohrc4Q9hwkSewbEv1OG/mKVNDIW9oyUGFvDB52CYdY0
	 sZCRHuRchSkKhF+DVLhSDcSDjRvgnJFoVYiu7q5U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masahiro Yamada <masahiroy@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 531/558] kconfig: qconf: fix buffer overflow in debug links
Date: Tue,  8 Oct 2024 14:09:21 +0200
Message-ID: <20241008115723.120655154@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115702.214071228@linuxfoundation.org>
References: <20241008115702.214071228@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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
index 959c2c78e1ef9..5e9f810b9e7f7 100644
--- a/scripts/kconfig/qconf.cc
+++ b/scripts/kconfig/qconf.cc
@@ -1166,7 +1166,7 @@ void ConfigInfoView::clicked(const QUrl &url)
 {
 	QByteArray str = url.toEncoded();
 	const std::size_t count = str.size();
-	char *data = new char[count + 1];
+	char *data = new char[count + 2];  // '$' + '\0'
 	struct symbol **result;
 	struct menu *m = NULL;
 
-- 
2.43.0



