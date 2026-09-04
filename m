Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76BAF411A1C;
	Fri,  4 Sep 2026 05:58:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788501496; cv=none; b=NaJQT0rwdz72zhUbikIgx3BuBWhFUuK2ojYTgvrchQUlSghXZkMd0cQnCqcsRidjNGchr75nFzkFnl712P+CAz5NJl+WO6G+lD76XAWp/1Uizkvt+AHl3RzjFBO5c0H7XzIdvKcAYcm4PB6FbgTHvjM9pUYjL8w9OJ08vf96guE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788501496; c=relaxed/simple;
	bh=UVLQpJoeGiWd36UkGsKoYDXCI/GT4ZbmlIOVUONme9A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=cwdViEb4pIcXVv0Sod/Bs60EHTvt3QhcqWkfjW3Y/STz6Qe7s27lAfdTcsPhbg7fnQVu5NX3fE4ExQxThLiKl0LKAYynXnAW3CKqy1dLB4JEWYfOz4S6oxzdjffvZ2fjnF8AM4bnFItNJtvYCqf50IPRpBPcGEpRmdl48k3cA9w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0YrI0OwP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0YrI0OwP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B08001F00A3D;
	Fri,  4 Sep 2026 05:58:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788501495;
	bh=qqdxww0eTl0FCJiVH4d/DZ129T0T/hjMsLMwhy1hcWg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0YrI0OwPlFOqifQnv8Hdp/rzSSSrNABs4JnTB1QSoj70iVPaB49R4jruk4e5IPIMp
	 t8siZc5pTiMHeiiLIdGl8atlo7Irsfv4JzJBOLfzGkt8gkZ4LkukNeeIbY/Lv8pGVH
	 9rUTB6o9bBeqehMW2+XBAnad3o3UXX2ehHBct6dw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Pearson <mpearson-lenovo@squebb.ca>,
	Thorsten Blum <thorsten.blum@linux.dev>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
Subject: [PATCH 6.18 429/552] platform/x86: think-lmi: Fix current password length check
Date: Fri,  4 Sep 2026 06:59:46 +0200
Message-ID: <20260904045800.323160559@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045747.813364717@linuxfoundation.org>
References: <20260904045747.813364717@linuxfoundation.org>
User-Agent: quilt/0.69
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thorsten Blum <thorsten.blum@linux.dev>

commit 54745d563114b74f6fecebce68cd020d06c1772b upstream.

current_password_store() checks the password length before removing the
trailing newline, which can reject valid passwords that are exactly
->maxlen bytes long.

It also passes ->maxlen to strscpy(), which truncates passwords without
a newline.

Use strchrnul() to measure the password length up to the newline, then
copy that many bytes and add a trailing NUL terminator using strscpy().

Fixes: a40cd7ef22fb ("platform/x86: think-lmi: Add WMI interface support on Lenovo platforms")
Cc: stable@vger.kernel.org
Reviewed-by: Mark Pearson <mpearson-lenovo@squebb.ca>
Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
Link: https://patch.msgid.link/20260818151635.37094-2-thorsten.blum@linux.dev
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/platform/x86/lenovo/think-lmi.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

--- a/drivers/platform/x86/lenovo/think-lmi.c
+++ b/drivers/platform/x86/lenovo/think-lmi.c
@@ -438,14 +438,13 @@ static ssize_t current_password_store(st
 	struct tlmi_pwd_setting *setting = to_tlmi_pwd_setting(kobj);
 	size_t pwdlen;
 
-	pwdlen = strlen(buf);
+	/* Strip newline; setting password won't work if one is present. */
+	pwdlen = strchrnul(buf, '\n') - buf;
 	/* pwdlen == 0 is allowed to clear the password */
 	if (pwdlen && ((pwdlen < setting->minlen) || (pwdlen > setting->maxlen)))
 		return -EINVAL;
 
-	strscpy(setting->password, buf, setting->maxlen);
-	/* Strip out CR if one is present, setting password won't work if it is present */
-	strreplace(setting->password, '\n', '\0');
+	strscpy(setting->password, buf, pwdlen + 1);
 	return count;
 }
 


