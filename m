Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93C251922CA;
	Tue, 10 Sep 2024 09:45:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725961520; cv=none; b=Zg5tID/nNFGeCF/dNBGX1fiGDpFbxo9sbypaIFMr2nnGczGQyr/TtVLYPRQeDSz4XjaPtVW9D69kuw7n2cA2tz8Pe3kqlmTlWxonQ1oir+UsFUFmoUkBMxcDh0AW+Hm8SmemNytvDd1uC2w8Q95DMjt6xWR9qK3VKq+ikOXW2vw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725961520; c=relaxed/simple;
	bh=HKj0PYwjk3/4jtawvTDb6MzrmKGO/JRKaG0ySavD5Hw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qLgs87FA7I2e4C+MqBfZy2muGVnsPd9HKuSiMKu7WKrJMJi7oDocZAjeRnI6Kw82vuvom2vLA3rNnjOFMAmX69HpiP7/OJPJVTgDH3PtyyvySYSXsiZ9ygmqlOjCWIhQlq6lrb0HHrmSCpNsRLpGU8qf+3hgUuxi8NsmMBnWWBs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=puFzd1dA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="puFzd1dA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5DB8C4CED0;
	Tue, 10 Sep 2024 09:45:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725961520;
	bh=HKj0PYwjk3/4jtawvTDb6MzrmKGO/JRKaG0ySavD5Hw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=puFzd1dAcstZIAt0Fbk2phbgEACajAUT3s0FOLKkg+84nOMflD8cktu2mcy4MFfKm
	 4ucIwUEwKg2W6nLUxsPR2rasfrR5sKJLOoCq30tPTWZVktu0/oP2y6wVbtoJZLtKFb
	 mRZ4XYbWOhr1H4Lsag3DnsTNfCslwISEUIGaLnC8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konstantin Andreev <andreev@swemel.ru>,
	Casey Schaufler <casey@schaufler-ca.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 097/375] smack: unix sockets: fix accept()ed socket label
Date: Tue, 10 Sep 2024 11:28:14 +0200
Message-ID: <20240910092625.502467871@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092622.245959861@linuxfoundation.org>
References: <20240910092622.245959861@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Konstantin Andreev <andreev@swemel.ru>

[ Upstream commit e86cac0acdb1a74f608bacefe702f2034133a047 ]

When a process accept()s connection from a unix socket
(either stream or seqpacket)
it gets the socket with the label of the connecting process.

For example, if a connecting process has a label 'foo',
the accept()ed socket will also have 'in' and 'out' labels 'foo',
regardless of the label of the listener process.

This is because kernel creates unix child sockets
in the context of the connecting process.

I do not see any obvious way for the listener to abuse
alien labels coming with the new socket, but,
to be on the safe side, it's better fix new socket labels.

Signed-off-by: Konstantin Andreev <andreev@swemel.ru>
Signed-off-by: Casey Schaufler <casey@schaufler-ca.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/smack/smack_lsm.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/security/smack/smack_lsm.c b/security/smack/smack_lsm.c
index ab939e6449e4..002a1b9ed83a 100644
--- a/security/smack/smack_lsm.c
+++ b/security/smack/smack_lsm.c
@@ -3871,12 +3871,18 @@ static int smack_unix_stream_connect(struct sock *sock,
 		}
 	}
 
-	/*
-	 * Cross reference the peer labels for SO_PEERSEC.
-	 */
 	if (rc == 0) {
+		/*
+		 * Cross reference the peer labels for SO_PEERSEC.
+		 */
 		nsp->smk_packet = ssp->smk_out;
 		ssp->smk_packet = osp->smk_out;
+
+		/*
+		 * new/child/established socket must inherit listening socket labels
+		 */
+		nsp->smk_out = osp->smk_out;
+		nsp->smk_in  = osp->smk_in;
 	}
 
 	return rc;
-- 
2.43.0



