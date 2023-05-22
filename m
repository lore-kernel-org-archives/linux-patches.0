Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C02A7171A9
	for <patches@lists.linux.dev>; Mon, 22 May 2023 19:52:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50EC6C433EF;
	Mon, 22 May 2023 19:52:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684785134;
	bh=GSIn+nF2typbYbJIOKFrYK6nXpPY50OOcI1kChhm4wI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JQLJtqEifm9WHawcH84nvn9OCbZ7tV8LhfsM3oNZD+TfO2mhDBk19dprWepGz+KId
	 kz5O6yj0KjdQEb6eVeXFLSNAvN69/Y0+Q0OO0wUYeIfTSu9tPWc9CYfTgr7J4DDp7m
	 t3ofO63LDjX3oi2FAXnkK31mu++joV53RdHBJ66o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gustav Johansson <gustajo@axis.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.3 321/364] ksmbd: smb2: Allow messages padded to 8byte boundary
Date: Mon, 22 May 2023 20:10:26 +0100
Message-Id: <20230522190420.800778437@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230522190412.801391872@linuxfoundation.org>
References: <20230522190412.801391872@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Gustav Johansson <gustajo@axis.com>

commit e7b8b8ed9960bf699bf4029f482d9e869c094ed6 upstream.

clc length is now accepted to <= 8 less than length,
rather than < 8.

Solve issues on some of Axis's smb clients which send
messages where clc length is 8 bytes less than length.

The specific client was running kernel 4.19.217 with
smb dialect 3.0.2 on armv7l.

Cc: stable@vger.kernel.org
Signed-off-by: Gustav Johansson <gustajo@axis.com>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ksmbd/smb2misc.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/fs/ksmbd/smb2misc.c
+++ b/fs/ksmbd/smb2misc.c
@@ -416,8 +416,11 @@ int ksmbd_smb2_check_message(struct ksmb
 
 		/*
 		 * Allow a message that padded to 8byte boundary.
+		 * Linux 4.19.217 with smb 3.0.2 are sometimes
+		 * sending messages where the cls_len is exactly
+		 * 8 bytes less than len.
 		 */
-		if (clc_len < len && (len - clc_len) < 8)
+		if (clc_len < len && (len - clc_len) <= 8)
 			goto validate_credit;
 
 		pr_err_ratelimited(


