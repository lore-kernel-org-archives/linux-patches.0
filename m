Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65EFA39182F;
	Mon, 23 Mar 2026 14:58:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774277920; cv=none; b=QxWdndrzUqib6cFJWy+C1HAq/lecLtVlK4EosbIrdhjWR3aEZ6Oz6O3V+W0GpgtDabi9ydt/eQRd5ORqZKDsVygqa7ueSURWEVtYTwt5wjI/y0bC5YFgLf1MsAtDDImtKiJmCi85xJ915UjIEisgIoMRuidRsZbJ9nt4Xq5fJvI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774277920; c=relaxed/simple;
	bh=NkGJJnbGmi9RlTFJ55zyvjfz9rUvUO0F4kjn15l3ff8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=m6U/p4f2aTR/O0m5yx6imiTTCfZky9cWsIrGSh1Wo+pHDQ92NdtsaRCd2spBq+zg9Ia0eJOrl9OQbEBRB2T/CJ6ccmw/FRxyIFvyQktAInoJdw8SSc68iUTQVevtnZ5M5yJdI+3RD+NY7GzM3j3B42mPNiyPQom5dJhieTVi9AE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=h5LTa3ow; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="h5LTa3ow"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD845C4CEF7;
	Mon, 23 Mar 2026 14:58:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774277920;
	bh=NkGJJnbGmi9RlTFJ55zyvjfz9rUvUO0F4kjn15l3ff8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=h5LTa3owGIz76f6RJKuLyV26Bz4Trdd9XC2C+eDKiyIgZFx+La52RTFdEvq3N6EkZ
	 RuHaF2cNP2cz76walFqlzwPu6GeplRp6rRXND0HRYCGsMchUoHE50uFAW+XUh9xQ35
	 7Yi1KOwxjDpoTeEUwu75+vHFAnHdBNfIt8Khjztw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thorsten Blum <thorsten.blum@linux.dev>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
Subject: [PATCH 6.6 101/567] platform/x86: dell-wmi-sysman: Dont hex dump plaintext password data
Date: Mon, 23 Mar 2026 14:40:21 +0100
Message-ID: <20260323134536.322720646@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134533.749096647@linuxfoundation.org>
References: <20260323134533.749096647@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


