Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55CAC22913C;
	Tue, 15 Oct 2024 13:17:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728998227; cv=none; b=pXTVaxqkvoxP00vVXWiKzQNfwHaojz1YyZitu2A1bBgkvJACd2KnRE1ADLhpQEKQOMlwl6qzjRnNVr0qK6t8UESE/hxiTisHi+ErsJtG7DrrWeyZuhmWEacGJhU8SRtUBfq84svEMwE6u0YQBnjEEN1PMcveXYxXQd2bykxk8jM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728998227; c=relaxed/simple;
	bh=+1aPM2Z21OVyPmLDAHbQbG6RChdUKCj/AeF5lM2W38M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CnbKuvEx/wZrWJzzHZPhw8gcQGjM0cpdrgFpsa4uRo/7x9DZmE94LFmtKWCcKRg0Oh1Su3MB6hP7Sgns1HD17BcsWyjpDIi3+NC16kXtA9DFan1eVNqyMeDhBWEjvbBk4I36zFvOVnQss+QxQ+QJXFuVcoHOk2jo2w1blQztAJo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bSv2V/mb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bSv2V/mb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8CD1C4CEC6;
	Tue, 15 Oct 2024 13:17:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728998227;
	bh=+1aPM2Z21OVyPmLDAHbQbG6RChdUKCj/AeF5lM2W38M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bSv2V/mbbyy1i4hHG91U19VnkKlXrVg/2rs9CGHWJYB+Qnv4ONTEcUVcQ1GTEX7Ax
	 eQy2BkImf5FqVMYMGBtwclLmpTCmG4kJUlYuEE1bxoub7w+TTcxXUd3XMdSTndsu47
	 aoOdKCiespcfoDG/0YM7iRMfIlabFNCLGsxQOpRw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masahiro Yamada <masahiroy@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 416/518] kconfig: qconf: fix buffer overflow in debug links
Date: Tue, 15 Oct 2024 14:45:20 +0200
Message-ID: <20241015123933.052815808@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015123916.821186887@linuxfoundation.org>
References: <20241015123916.821186887@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index f7eb093614f27..b889fe604e422 100644
--- a/scripts/kconfig/qconf.cc
+++ b/scripts/kconfig/qconf.cc
@@ -1167,7 +1167,7 @@ void ConfigInfoView::clicked(const QUrl &url)
 {
 	QByteArray str = url.toEncoded();
 	const std::size_t count = str.size();
-	char *data = new char[count + 1];
+	char *data = new char[count + 2];  // '$' + '\0'
 	struct symbol **result;
 	struct menu *m = NULL;
 
-- 
2.43.0



