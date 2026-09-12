Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7C44386C22;
	Sat, 12 Sep 2026 19:37:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789241838; cv=none; b=ihtpBif9ZQB+DE0pst7K9BIH2ZHHmfYQtdv2FUUZFYq2nu3jLxW2S+3tn8Z8PhI9KcKIsy5WWKTyg+q09tIBNBYAk5s8YWDo/PnxIzaNrCjCSCfZpi6Krm7o0qaMrYbcpj1+iN2RbagsVF5muE1xW7ePHkw/P11ZtHNfmzIL/98=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789241838; c=relaxed/simple;
	bh=75zxqOyhna3aYQDI2YJBD4EThsYIgMwFduGtW0zISaM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=InGZTOH9wh80aKVEmMlEgFlezWOprxyTnGUE+S22GRTmU5M+kS6r54z1BNAq5W4KfA9GhcFPrsZFZTGivgXxUKSXc1dNVQ4QpUhTSe4r9TaMXCsPRoFaRztCnUr4eKms+iINNAV4hDv3DgftD1nnNQUYq5WuYDNX7syX0rfODTQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yBySJ6Dt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yBySJ6Dt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEE861F0089E;
	Sat, 12 Sep 2026 19:37:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789241837;
	bh=dgZjkVKMmuJrnk/yVAdCIuIerRKKVFCQ/Jw4AILKqew=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yBySJ6Dtg0PAg9z0kzwOSsnmA2X1IUq43MM5qwPUGtAFcBnrj65mRtIcSJMVqp12R
	 0pEeXRQFfpfSHXnpk17wfg839LqQbtFbGkU3x3f0e+mMWT1125SCM3XXIM33o02HB9
	 unek0GlseVn2k1kXPZjurzS1gXXgDQ4B07nnHzic=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jameson Thies <jthies@google.com>,
	Benson Leung <bleung@chromium.org>
Subject: [PATCH 5.10 218/798] usb: typec: ucsi: displayport: Fix OOB altmode array index
Date: Sat, 12 Sep 2026 08:57:26 +0200
Message-ID: <20260912065522.116614694@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Jameson Thies <jthies@google.com>

commit 04cec690b1fd9d1c4c314b91a10d8c68a3acfe18 upstream.

The UCSI displayport driver indexes the connector's port altmode array
with the GET_CURRENT_CAM response after checking it is not 0xff. The
port altmode array is UCSI_MAX_ALTMODES elements long. If the PPM
returns an invalid GET_CURRENT_CAM response above UCSI_MAX_ALTMODES and
not equal to 0xff, the kernel may crash with an array index OOB error.

Update the UCSI displayport driver to verify the current cam is less
than UCSI_MAX_ALTMODES before accessing the port altmode array.

Fixes: af8622f6a585 ("usb: typec: ucsi: Support for DisplayPort alt mode")
Cc: stable@vger.kernel.org
Signed-off-by: Jameson Thies <jthies@google.com>
Reviewed-by: Benson Leung <bleung@chromium.org>
Link: https://patch.msgid.link/20260825234545.2076049-1-jthies@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/typec/ucsi/displayport.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/typec/ucsi/displayport.c
+++ b/drivers/usb/typec/ucsi/displayport.c
@@ -72,7 +72,7 @@ static int ucsi_displayport_enter(struct
 		cur = 0xff;
 	}
 
-	if (cur != 0xff) {
+	if (cur < UCSI_MAX_ALTMODES) {
 		ret = dp->con->port_altmode[cur] == alt ? 0 : -EBUSY;
 		goto err_unlock;
 	}


