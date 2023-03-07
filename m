Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8ADF9BA3E
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 17:46:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2C8CC433EF;
	Tue,  7 Mar 2023 17:46:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678211207;
	bh=swe+fv2gW2cv8UkPMJ5Wy5w9GKEuQATIBNcz8PXmWRI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HLJp1y4Sf15ZCMfqsaaNBlCOiaR467Ds2Bp9ydF1uOhzWiEVZ2PEO9YKEg8nWSHh4
	 4MvQtQ2hyTjHEE0rGAZ6wnhwItirleyHARchb7/S6M1QEokAAwX3detF1YGbvFBKZ4
	 WxNC02ilU2DH0TYfdQgjPxSVTX0t0bfqn7XDHX9c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.2 0786/1001] ksmbd: do not allow the actual frame length to be smaller than the rfc1002 length
Date: Tue,  7 Mar 2023 17:59:18 +0100
Message-Id: <20230307170055.858924918@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Namjae Jeon <linkinjeon@kernel.org>

commit fb533473d1595fe79ecb528fda1de33552b07178 upstream.

ksmbd allowed the actual frame length to be smaller than the rfc1002
length. If allowed, it is possible to allocates a large amount of memory
that can be limited by credit management and can eventually cause memory
exhaustion problem. This patch do not allow it except SMB2 Negotiate
request which will be validated when message handling proceeds.
Also, Allow a message that padded to 8byte boundary.

Fixes: e2f34481b24d ("cifsd: add server-side procedures for SMB3")
Cc: stable@vger.kernel.org
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ksmbd/smb2misc.c |   21 ++++++++++-----------
 1 file changed, 10 insertions(+), 11 deletions(-)

--- a/fs/ksmbd/smb2misc.c
+++ b/fs/ksmbd/smb2misc.c
@@ -408,20 +408,19 @@ int ksmbd_smb2_check_message(struct ksmb
 			goto validate_credit;
 
 		/*
-		 * windows client also pad up to 8 bytes when compounding.
-		 * If pad is longer than eight bytes, log the server behavior
-		 * (once), since may indicate a problem but allow it and
-		 * continue since the frame is parseable.
+		 * SMB2 NEGOTIATE request will be validated when message
+		 * handling proceeds.
 		 */
-		if (clc_len < len) {
-			ksmbd_debug(SMB,
-				    "cli req padded more than expected. Length %d not %d for cmd:%d mid:%llu\n",
-				    len, clc_len, command,
-				    le64_to_cpu(hdr->MessageId));
+		if (command == SMB2_NEGOTIATE_HE)
 			goto validate_credit;
-		}
 
-		ksmbd_debug(SMB,
+		/*
+		 * Allow a message that padded to 8byte boundary.
+		 */
+		if (clc_len < len && (len - clc_len) < 8)
+			goto validate_credit;
+
+		pr_err_ratelimited(
 			    "cli req too short, len %d not %d. cmd:%d mid:%llu\n",
 			    len, clc_len, command,
 			    le64_to_cpu(hdr->MessageId));


