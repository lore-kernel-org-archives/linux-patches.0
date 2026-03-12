Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDD93370D5D;
	Thu, 12 Mar 2026 20:20:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773346849; cv=none; b=s2bvt5rAMrlwmo1ALxQyVdNcMLw4po58Hum/O4+y0Khg80b7TIwYS1dV84s9WfiMpxFHFzawOdQbE7UEpkuX3PUqROj5oC0yVFqLZeKobLpF0/oEc6n9VA/+69XXuyD/he9NkZJu+i/RKErC/0dZ5wZr7DU654CMzfl/dqG2f6M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773346849; c=relaxed/simple;
	bh=/QYoo4zg8gyOqN6bHu26rOiN8vMjRG8RIPykaLTVGKc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qNWgubNWTv67HsR0N0UU/j+OTazskierY8FH0p7gBnojHwOcGw0nooSNKdySxvVm2qyPvVSClbb5p8VNA9ZAFtJNzngt6dQQD3UvLp3xXc2FTYJ1hDWUxzRBsCJ6hGJtd5j8tKYfGOU9K5nQvOh64c9k6qpnpfKLtRd/Exn63vg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=k4A77P1O; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="k4A77P1O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4943CC19425;
	Thu, 12 Mar 2026 20:20:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773346849;
	bh=/QYoo4zg8gyOqN6bHu26rOiN8vMjRG8RIPykaLTVGKc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=k4A77P1OGebo60VbYMFQUzfufMloRUFGIKdxUA4BPzqQQeyPuSrLJK0MilbJEZ4bM
	 d2LZ04SuWVAy3XJAS32oZs0UM8mEZm/cO+alyo0zWbk8ZeOBAUTqKiuoDLhuvW9HfG
	 FzybR+oQQdB9Tg6/OIuA5tSzprAiMSpupzGwOYXQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thorsten Blum <thorsten.blum@linux.dev>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
Subject: [PATCH 6.12 141/265] platform/x86: dell-wmi-sysman: Dont hex dump plaintext password data
Date: Thu, 12 Mar 2026 21:08:48 +0100
Message-ID: <20260312201023.350624894@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260312201018.128816016@linuxfoundation.org>
References: <20260312201018.128816016@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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


