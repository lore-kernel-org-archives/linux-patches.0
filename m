Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4616418B487;
	Tue, 10 Sep 2024 10:29:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725964173; cv=none; b=rd3EyHlr05+7YWA8CJ0j7hKh9t62EXlxCPJ32pS2cuqIlEsjd+3+HccHWOuQObMEocU8ETUQyzgk9UAgPz5o1n2gMjQVK01FZJHlXTtpLHl+Pi5TZDq/C1JF5FQ193Ni8JuwY462ysVPeju+oBOXHTIZR4ouj7RF8jbvqnNU43Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725964173; c=relaxed/simple;
	bh=lfcA1tMasXpTMte/oWLxu9NGmxepC0UAxk761dztpzo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FBPhLChiUKfaeNt/rj+t5DfGaKC6kwstYoENWS/oGmK9D122PIqHaihDPzJ5JvMYzwjB87vgwXpmDnktbYSnl/o13TTsOfpgdF2CAu9wG+lohklomHwDqhL59yKzuxv07mtfltOJP9i+JsgHI6ZRaX9TeUKKXh0BeP47PmEjv1k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bhaz5c4J; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bhaz5c4J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C044AC4CEC3;
	Tue, 10 Sep 2024 10:29:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725964173;
	bh=lfcA1tMasXpTMte/oWLxu9NGmxepC0UAxk761dztpzo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bhaz5c4JlmZl6c1wKPw3KHVsr2JHPdqbfnemk2bSL1t0mG5bZiW5CbW1ZFBBZRE7Q
	 R/EBcBzkoBykFYpPzLlL7497RHoOT/i9RG4xjnp+OeX81V/Qi+AkqxY67G36W1zopG
	 Rbq2tcRFXe3yBT3yWLbzpNYpaOLBipJ5DPgl8Wmc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konstantin Andreev <andreev@swemel.ru>,
	Casey Schaufler <casey@schaufler-ca.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 065/269] smack: unix sockets: fix accept()ed socket label
Date: Tue, 10 Sep 2024 11:30:52 +0200
Message-ID: <20240910092610.508401131@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092608.225137854@linuxfoundation.org>
References: <20240910092608.225137854@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 98c2bdbfcaed..4625674f0e95 100644
--- a/security/smack/smack_lsm.c
+++ b/security/smack/smack_lsm.c
@@ -3769,12 +3769,18 @@ static int smack_unix_stream_connect(struct sock *sock,
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



