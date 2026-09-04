Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E78A43E866B;
	Fri,  4 Sep 2026 05:58:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788501491; cv=none; b=mgT3P0AL1h4kzqbJXHiDLTC8vyGcVXBS6lPWdOTBOJV45CTCY7N5ruGT+ppzwBDYvKmiRCUy+M6iBiSOckFSDudE+bTlt4nYBKVOO1iGNxKDfjLtTygiF3qrQbZKljTY4kLCijhY+8tyT/IwaRjgfEqSwNMP46gZchT6G2gVlD4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788501491; c=relaxed/simple;
	bh=doPCerimHt6K6P5tC79lQUpyigGhTk3LK8DK8j+V55E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=oC66ayNhOmHJESx3gG8eXnBmFhd6ZYriogVwpp0xx6wNUTo4NUB4Q4XAonP1dNYmwKhq9Shbfz3CzhZVSfEXpiLFKb8Qaq1crznTbJkYDwuG6/rTdHI41MwGsu0TLSJB7Jst6/4aLQQSKFlFy0aTiwISl+5LxWsqtCzgG6llEfs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=J/IC3S8+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J/IC3S8+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 055AB1F00A3D;
	Fri,  4 Sep 2026 05:58:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788501489;
	bh=Qd8tApj9o1ae1mOfwwZh4I/I2oatV2x6PkClLWa0Zh0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=J/IC3S8+xU0e9AxzLAk5J/6+m2xiIGwOHEYBEKUX8iv31zRFd9dYY031qVNGlTqTF
	 WZiEWrUsAv5LZSaf8HwZVEkFigcdDU73NBSzfdIjyup/6rjB8tNU5nOwzHeFR0dQCC
	 C1LpHWj+QJG9mJYLoPdGl4+kJay48jvi1ApNI2nA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thorsten Blum <thorsten.blum@linux.dev>,
	Mark Pearson <mpearson-lenovo@squebb.ca>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
Subject: [PATCH 6.18 427/552] platform/x86: think-lmi: Fix certificate thumbprint sysfs output
Date: Fri,  4 Sep 2026 06:59:44 +0200
Message-ID: <20260904045800.279324721@linuxfoundation.org>
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

commit 4f3183f5ae9b8ddfe338d79a96146a05342bbe50 upstream.

cert_thumbprint() already returns the accumulated output length, but
certificate_thumbprint_show() adds that value to count again, making the
next line use the wrong offset. Errors returned by cert_thumbprint() are
also ignored and their negative values added to count.

Assign the total length to count instead and propagate errors correctly.

Fixes: b49f72e7f96d ("platform/x86: think-lmi: Certificate authentication support")
Cc: stable@vger.kernel.org
Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
Reviewed-by: Mark Pearson <mpearson-lenovo@squebb.ca>
Link: https://patch.msgid.link/20260810120556.149416-2-thorsten.blum@linux.dev
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/platform/x86/lenovo/think-lmi.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/drivers/platform/x86/lenovo/think-lmi.c
+++ b/drivers/platform/x86/lenovo/think-lmi.c
@@ -741,6 +741,8 @@ static ssize_t certificate_thumbprint_sh
 		return -EOPNOTSUPP;
 
 	for (i = 0; i < ARRAY_SIZE(thumbtypes); i++) {
+		ssize_t ret;
+
 		if (tlmi_priv.pwdcfg.core.password_mode >= TLMI_PWDCFG_MODE_MULTICERT) {
 			/* Format: 'SVC | SMC, Thumbtype' */
 			wmistr = kasprintf(GFP_KERNEL, "%s,%s",
@@ -752,8 +754,12 @@ static ssize_t certificate_thumbprint_sh
 		}
 		if (!wmistr)
 			return -ENOMEM;
-		count += cert_thumbprint(buf, wmistr, count);
+
+		ret = cert_thumbprint(buf, wmistr, count);
 		kfree(wmistr);
+		if (ret < 0)
+			return ret;
+		count = ret;
 	}
 
 	return count;


