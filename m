Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEBE41D88AC;
	Mon,  6 Jan 2025 16:01:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736179298; cv=none; b=Vr+g0dSLDNU+oTk/QV/sMhd9d61QiTc1vWSNGqB3R4Jnt0bKJ7eyS/ydhzd+AocHcBietXGlTRew0SYfkOzKF4SS6ZDWneN+UJISeNcdNwAIUUYzdCYH6sN/Zfj2ycG310gCvawb1jRV2R/SaxVw1pSGoa7cdrqXPBHVAig31rI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736179298; c=relaxed/simple;
	bh=pN51KGmNtIyvCsbONzBtUko9U6pzZeunVS0NtI9LyQ4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K/Jn/cHlFb3u2WbQL1O6SS1plQp5QVJtKFctL21oF4nIRK6Lp5k2Nqi1niTfn7X2GCabnqZ/2c325NzSThl2320zkGq9KWsq2j62WHo6DMPqtsIrJULByaafa4m0TrLSSEkVtV5B2kRcB7lyJG0IUGE2NxYIBLYZxAf6LQZ7QGY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Vm13tYPI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Vm13tYPI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75D1BC4CED2;
	Mon,  6 Jan 2025 16:01:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736179297;
	bh=pN51KGmNtIyvCsbONzBtUko9U6pzZeunVS0NtI9LyQ4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Vm13tYPIkS3/ANbTkq/rQXXBvgmBPN92wnCuo9Ie65dKEPGsnedllTLxMjn7j7lU2
	 ebZV3HkVawZTKJTc5OlZywIU4iDOnJoo5RZKL994Cs54DDyWb6pgFl1wS4tJ9xrQGb
	 F1nlF0MDILhI+qihK0bRkKz1sRf8hcC9xyhFUU5g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nikolay Kuratov <kniv@yandex-team.ru>,
	Xin Long <lucien.xin@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.4 91/93] net/sctp: Prevent autoclose integer overflow in sctp_association_init()
Date: Mon,  6 Jan 2025 16:18:07 +0100
Message-ID: <20250106151132.136055002@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151128.686130933@linuxfoundation.org>
References: <20250106151128.686130933@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nikolay Kuratov <kniv@yandex-team.ru>

commit 4e86729d1ff329815a6e8a920cb554a1d4cb5b8d upstream.

While by default max_autoclose equals to INT_MAX / HZ, one may set
net.sctp.max_autoclose to UINT_MAX. There is code in
sctp_association_init() that can consequently trigger overflow.

Cc: stable@vger.kernel.org
Fixes: 9f70f46bd4c7 ("sctp: properly latch and use autoclose value from sock to association")
Signed-off-by: Nikolay Kuratov <kniv@yandex-team.ru>
Acked-by: Xin Long <lucien.xin@gmail.com>
Link: https://patch.msgid.link/20241219162114.2863827-1-kniv@yandex-team.ru
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sctp/associola.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/net/sctp/associola.c
+++ b/net/sctp/associola.c
@@ -132,7 +132,8 @@ static struct sctp_association *sctp_ass
 		= 5 * asoc->rto_max;
 
 	asoc->timeouts[SCTP_EVENT_TIMEOUT_SACK] = asoc->sackdelay;
-	asoc->timeouts[SCTP_EVENT_TIMEOUT_AUTOCLOSE] = sp->autoclose * HZ;
+	asoc->timeouts[SCTP_EVENT_TIMEOUT_AUTOCLOSE] =
+		(unsigned long)sp->autoclose * HZ;
 
 	/* Initializes the timers */
 	for (i = SCTP_EVENT_TIMEOUT_NONE; i < SCTP_NUM_TIMEOUT_TYPES; ++i)


