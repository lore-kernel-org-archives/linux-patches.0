Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64947188CC1;
	Tue, 10 Sep 2024 10:07:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725962831; cv=none; b=aRwqkzOz9OFerURhU0W/d+OOAuq3rhYC1FqqrIMHUPiPfJ5vd6OUxz9XsE6/C5NJc1Q4RpgN9U8twL61yaNjDQcOnSU+XBcJo8IBodafDYX/KWp4ZQ1hP8CfS20n0RsGFFGPgh/W8RBu6m7MtsFPkSIaX68Y7R+COiIw0930+7I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725962831; c=relaxed/simple;
	bh=G/cM4lIEH80RPafaRh14vUmyW2MIM2kFjcUwpl3G9F4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SC9Vi6PKulXJSP1pz5PwVU89QPgsWZo1JBVO7vQSKUmBlfrrPAF4hqtY9AJ018TnkfFqKNC9uTX8y7XGoKK6qv6OFKOADtCkpcTCvNnCBeLO5nS5SVr075maKrynohOJfWLRyQd2GOydZjXSarsFXGIXQuemfKeCWFDXLMwihZc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dZj4nXMA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dZj4nXMA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFB8DC4CEC3;
	Tue, 10 Sep 2024 10:07:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725962831;
	bh=G/cM4lIEH80RPafaRh14vUmyW2MIM2kFjcUwpl3G9F4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dZj4nXMAzOLT7+g/OtHFmyoL8ZNndLY9Dff1nKk7paR1NkUF2j+szv0UEiXo5vFeV
	 JgSKhXYRX1/UBWbwjNzRzSJuCgn6H+QS72p/kT5AoXwv4GDg47DnuHF36AcZKhcOSL
	 vf+oXfgg5cQgPs8VuMfFOM8gSQ+xi3QbVc+sk3FM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konstantin Andreev <andreev@swemel.ru>,
	Casey Schaufler <casey@schaufler-ca.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 044/192] smack: unix sockets: fix accept()ed socket label
Date: Tue, 10 Sep 2024 11:31:08 +0200
Message-ID: <20240910092559.814581897@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092557.876094467@linuxfoundation.org>
References: <20240910092557.876094467@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 75b3e91d5a5f..c18366dbbfed 100644
--- a/security/smack/smack_lsm.c
+++ b/security/smack/smack_lsm.c
@@ -3706,12 +3706,18 @@ static int smack_unix_stream_connect(struct sock *sock,
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



