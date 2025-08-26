Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D2B120CCCA;
	Tue, 26 Aug 2025 13:36:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756215414; cv=none; b=Qs48jvA6R3OLxInajDcdPrTmfiGPpXDWG7Hh937XvIdIgmvUNEWypThufgupditLA0ILHinQ81T9GBUlU9dtQvE+XSQLo0uz3iZbrSlec4V+74pQUeBr6yIADBhWAgAaGjDBAk3GDYn9+j5Gg5tgvUJVXadS7utRL+aucwVdV7I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756215414; c=relaxed/simple;
	bh=A9tHZX9GmzemE4LjRDdlz7m2uU0mBeviSgY8EQXSq74=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e9SfLAWco/uWfLaJ0turGy0WEvwsiy3h1lthAB/Skxo8jktJOMvw0Pced2lqloafso/jJCm/Tz40QLw4C2UDbvvN1J7/wjxxUVe+twQgb43c3sNXrKw9ldzJI+i4ZBuwTvqKNGajpNOIj21WeVsZqYfVb4smeKgiloaq34EM7h4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nWX/6sKt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nWX/6sKt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2ED3AC4CEF1;
	Tue, 26 Aug 2025 13:36:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756215414;
	bh=A9tHZX9GmzemE4LjRDdlz7m2uU0mBeviSgY8EQXSq74=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nWX/6sKtUF7YQwgMMWyIg1vQ3T1biQOisqwCSPY+eIoqmsBDQ8gJOhio2soEgpzFu
	 xjHt0+nbHzYTQvqx1FLyoVwIgpxiQALzKn8cwesWm9yO5BjTnNWhTYy7DH6PAbzPXZ
	 xJczOgO3zfUs6opaPZdomXpxDRj2mLuCjk+71uPk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xinyu Liu <katieeliu@tencent.com>,
	stable <stable@kernel.org>
Subject: [PATCH 5.15 005/644] usb: gadget: configfs: Fix OOB read on empty string write
Date: Tue, 26 Aug 2025 13:01:36 +0200
Message-ID: <20250826110946.643427539@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110946.507083938@linuxfoundation.org>
References: <20250826110946.507083938@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Xinyu Liu <1171169449@qq.com>

commit 3014168731b7930300aab656085af784edc861f6 upstream.

When writing an empty string to either 'qw_sign' or 'landingPage'
sysfs attributes, the store functions attempt to access page[l - 1]
before validating that the length 'l' is greater than zero.

This patch fixes the vulnerability by adding a check at the beginning
of os_desc_qw_sign_store() and webusb_landingPage_store() to handle
the zero-length input case gracefully by returning immediately.

Signed-off-by: Xinyu Liu <katieeliu@tencent.com>
Cc: stable <stable@kernel.org>
Link: https://lore.kernel.org/r/tencent_B1C9481688D0E95E7362AB2E999DE8048207@qq.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/configfs.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/usb/gadget/configfs.c
+++ b/drivers/usb/gadget/configfs.c
@@ -861,6 +861,8 @@ static ssize_t os_desc_qw_sign_store(str
 	struct gadget_info *gi = os_desc_item_to_gadget_info(item);
 	int res, l;
 
+	if (!len)
+		return len;
 	l = min((int)len, OS_STRING_QW_SIGN_LEN >> 1);
 	if (page[l - 1] == '\n')
 		--l;


