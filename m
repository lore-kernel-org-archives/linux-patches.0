Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 978833B8D5C;
	Mon, 23 Mar 2026 16:10:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774282235; cv=none; b=tUzEa6RnLGzL05+QFODPdKSwd2OKIMYTYKWLfdd4hrIKV87HiMw/jRH8/DNNoxTm1BXK9ngHIfdxtvOsH5nyTptfnq+oxoBIobHf1aywVMabj4wWFr6LWYGJteAGR0LQcwpMe0lVSWt9cHePI6RegpbYLjsAadf4YRaBJV0YUPg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774282235; c=relaxed/simple;
	bh=G2ltqW/ok5LE3qiCCOMsfGLnUI2yaFJC8vj3qJbzMFw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=iq+Euq22enwWbPn20rJVbQKxKSZ6V/qIVUT6o4CbjAhV2xSrqQy1TXp+u3RPMsod+R3CAwojIDtZ40NYYLWB5yTj5DV9ipM+uxwO9bJtlwva5kwpCj3YWFPYwBnuFTsFbeBXb0m7+JnfoSqExwOQQsu/Lsak8ZcBXQp5RPXcZGE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rvwhmSMy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rvwhmSMy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD137C4CEF7;
	Mon, 23 Mar 2026 16:10:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774282235;
	bh=G2ltqW/ok5LE3qiCCOMsfGLnUI2yaFJC8vj3qJbzMFw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rvwhmSMyEJW0BOl71l9UwW4VUK4o6M5ydBjJdOm9q1qkpvCSplcNpbUnRpYS7t6Ys
	 ayYnHwk3eufbY8lu8e0qb4/h8LMtavmytIgnKn12UEp/7yf7YCs/mGWmrEFiUlJ8GQ
	 YtRr8ns9OVMjgf9YbCM5mln4Xi9V2E0bgqZZ67tY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thorsten Blum <thorsten.blum@linux.dev>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
Subject: [PATCH 6.1 080/481] platform/x86: dell-wmi-sysman: Dont hex dump plaintext password data
Date: Mon, 23 Mar 2026 14:41:02 +0100
Message-ID: <20260323134527.208775506@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134525.256603107@linuxfoundation.org>
References: <20260323134525.256603107@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thorsten Blum <thorsten.blum@linux.dev>

commit d1a196e0a6dcddd03748468a0e9e3100790fc85c upstream.

set_new_password() hex dumps the entire buffer, which contains plaintext
password data, including current and new passwords. Remove the hex dump
to avoid leaking credentials.

Fixes: e8a60aa7404b ("platform/x86: Introduce support for Systems Management Driver over WMI for Dell Systems")
Cc: stable@vger.kernel.org
Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
Link: https://patch.msgid.link/20260303113050.58127-2-thorsten.blum@linux.dev
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/platform/x86/dell/dell-wmi-sysman/passwordattr-interface.c |    1 -
 1 file changed, 1 deletion(-)

--- a/drivers/platform/x86/dell/dell-wmi-sysman/passwordattr-interface.c
+++ b/drivers/platform/x86/dell/dell-wmi-sysman/passwordattr-interface.c
@@ -93,7 +93,6 @@ int set_new_password(const char *passwor
 	if (ret < 0)
 		goto out;
 
-	print_hex_dump_bytes("set new password data: ", DUMP_PREFIX_NONE, buffer, buffer_size);
 	ret = call_password_interface(wmi_priv.password_attr_wdev, buffer, buffer_size);
 	/* on success copy the new password to current password */
 	if (!ret)


