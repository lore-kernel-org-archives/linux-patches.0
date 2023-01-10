Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DCC26FBB
	for <patches@lists.linux.dev>; Tue, 10 Jan 2023 18:25:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB8AFC433D2;
	Tue, 10 Jan 2023 18:24:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673375100;
	bh=w0xO49TIzoNjZMAtrlzZnmgqx4upUyfxRLjiQXfWQRw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gbeNdsN8Atr+U2ARFNiLF2kh7Gc+ir9pELqYD0GJd4BeaiDMGq5zTwtWZTkH9F1YK
	 t8GRlqYDduGkh84tBauXZOb+PPMSBWq+LVoff1sUs39wFPw4lGM1BIaEDfbreTrTDX
	 bH57G+QDa0bYFwkODiRuDjA19LTJ+4/fOqqO1+fY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Aring <aahringo@redhat.com>,
	David Teigland <teigland@redhat.com>
Subject: [PATCH 5.15 078/290] fs: dlm: retry accept() until -EAGAIN or error returns
Date: Tue, 10 Jan 2023 19:02:50 +0100
Message-Id: <20230110180034.315200469@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230110180031.620810905@linuxfoundation.org>
References: <20230110180031.620810905@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Alexander Aring <aahringo@redhat.com>

commit f0f4bb431bd543ed7bebbaea3ce326cfcd5388bc upstream.

This patch fixes a race if we get two times an socket data ready event
while the listen connection worker is queued. Currently it will be
served only once but we need to do it (in this case twice) until we hit
-EAGAIN which tells us there is no pending accept going on.

This patch wraps an do while loop until we receive a return value which
is different than 0 as it was done before commit d11ccd451b65 ("fs: dlm:
listen socket out of connection hash").

Cc: stable@vger.kernel.org
Fixes: d11ccd451b65 ("fs: dlm: listen socket out of connection hash")
Signed-off-by: Alexander Aring <aahringo@redhat.com>
Signed-off-by: David Teigland <teigland@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/dlm/lowcomms.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/fs/dlm/lowcomms.c
+++ b/fs/dlm/lowcomms.c
@@ -1520,7 +1520,11 @@ static void process_recv_sockets(struct
 
 static void process_listen_recv_socket(struct work_struct *work)
 {
-	accept_from_sock(&listen_con);
+	int ret;
+
+	do {
+		ret = accept_from_sock(&listen_con);
+	} while (!ret);
 }
 
 static void dlm_connect(struct connection *con)


