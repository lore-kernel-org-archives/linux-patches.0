Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F6682F6931;
	Mon, 13 Apr 2026 16:21:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776097265; cv=none; b=m2KiIBN0PBGf4NI4xaLtooxLG5zu2yQ886Q+m30DH0lI43SIeQjDlr19rkNBWhhkh5lmgyGVQcy7z/7bj+atMqm84tsatiKqXf6rzmx5re+VIQcyuiJ12OyQM12s/yUGPvyp/LFLfLQAcGaH55Ke803VXCxYVJIqUSTM8OWYOaQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776097265; c=relaxed/simple;
	bh=etkuvXffcM+AiwRsjcRjC9Ta4ycky7YU2ET6kPPm31o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QCUwVuS5H/j0wgnes+7h2MsuDzx5PiD6zYXFo4Q3ZOpAWLU4R3icjXYw9NXnG7i6TOdtDUVTVQsXolpOZ2ypkK8ne1/gmZZQTpeEZNdxTmwfTcXL9gXuZabO7aivBxU330lYiv0Uwf+pgLMLTYy3dev5ouA/gECXsxkupOQQm2Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QZmI90qU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QZmI90qU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFAD6C2BCAF;
	Mon, 13 Apr 2026 16:21:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776097265;
	bh=etkuvXffcM+AiwRsjcRjC9Ta4ycky7YU2ET6kPPm31o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QZmI90qUW2nEP6Xk1/E8SVoQlzzxF4Oz4a4apbGlyCtdmulOth7HzvcbpPtaRBU/I
	 018lmiiSn2BmLugubtgWwL+3l4VlF4YxLpkPIIvmLysiMsu8WDy86+btJ/kk98lCGI
	 7B4MTMD6K5AqdFc2Io6fWfuXKx5VD9ydPhhdMBj4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thorsten Blum <thorsten.blum@linux.dev>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
Subject: [PATCH 5.15 052/570] platform/x86: dell-wmi-sysman: Dont hex dump plaintext password data
Date: Mon, 13 Apr 2026 17:53:03 +0200
Message-ID: <20260413155832.390445348@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155830.386096114@linuxfoundation.org>
References: <20260413155830.386096114@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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


