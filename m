Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA9DD199920;
	Tue, 10 Sep 2024 10:19:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725963576; cv=none; b=iXCfMRtw4Ivgb5Cg/8oTAOayr5Hqqz9cLDEr+f9KEsbqUgSq8VT6pTAKurVKWiw2GX8XYyx5p+/lJbczqcgJmU36gmhymLmeWRw6Yxivt0nN7BJ4efuV3J9BINv5HA5SJAhqb0tqAeImdqEhc6IBhd+UxthON+RqwaLO4rTEVUk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725963576; c=relaxed/simple;
	bh=bGwreZJgcCfUQa0fT4VBhcCTzMRnVP1yTmvAhMotYGM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lU0dcDkdUg07KSHu0aiayqmjpzSFtmcGJDKrbIX8ipLBGqT/D78n468YvcIbdfgpcy92ZYT/GumOT6isBa/7UmLNk8E4lR0cg8ItZZoch5x3wS5OO8tXEyxrFZ6DEhVD9da9hJZyi41DMk15fqylRIfhU1TnbrnwVzdxi2vxCvQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IsppqrLg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IsppqrLg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DAADCC4CEC3;
	Tue, 10 Sep 2024 10:19:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725963576;
	bh=bGwreZJgcCfUQa0fT4VBhcCTzMRnVP1yTmvAhMotYGM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IsppqrLgc1Z0HTK60Rbo24YgjSiQFvmGNm/BMW5hpDkDHMbLl8c2QaipTAvHCskAD
	 GHMIGlzAetJp36SpArr8k8vicGgrGqfdhes1WUoOe6WkwOJF3yF9SSHXSyEIXS0Lmb
	 RxlIyyXhV0uRc6+XPZFRQRT1S4CW2xBvS1o50Enc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konstantin Andreev <andreev@swemel.ru>,
	Casey Schaufler <casey@schaufler-ca.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 104/214] smack: unix sockets: fix accept()ed socket label
Date: Tue, 10 Sep 2024 11:32:06 +0200
Message-ID: <20240910092603.041450467@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092558.714365667@linuxfoundation.org>
References: <20240910092558.714365667@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 25c46b56fae8..1eaf3e075db6 100644
--- a/security/smack/smack_lsm.c
+++ b/security/smack/smack_lsm.c
@@ -3641,12 +3641,18 @@ static int smack_unix_stream_connect(struct sock *sock,
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



