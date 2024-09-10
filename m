Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D0C618C000;
	Tue, 10 Sep 2024 10:01:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725962466; cv=none; b=o7FhMyJ0Y95XjPssbsvHoIvqW7+0JXtMldrGzIKuLlHRHc5hKDxz6JgXmcCWVw/4mDilhkUoIxdXIFFkyddEcFHWoVOfJixjZYK0E+5Aux6acEz1fhdi84j0agIueAWaCpwVQQct8JuUraNN88TgSqKXapazMsnhnEWbvdyatnQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725962466; c=relaxed/simple;
	bh=/f2tJ2AsfDC+cEeAfTVQK73gcAKwD40JbOhcxwbWKNM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=izlCoCmwvweaDK0uK366I21KUMUbQ9JV7WZ8cKU6+QanRC5T8KwP0Fq0ff6N6WqPHzSBxXRSs5Y6wt52qAElOTFma5KllE/e0IGTldXcNaIDMvhHpBXErPS8a1Uq0fMhmxCyJE4dR1aAEFBlbgC4xIQ4goS8MnchrBqCNNyu5QE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HqwVjQwU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HqwVjQwU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09E4CC4CEC3;
	Tue, 10 Sep 2024 10:01:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725962466;
	bh=/f2tJ2AsfDC+cEeAfTVQK73gcAKwD40JbOhcxwbWKNM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HqwVjQwUL24AAK+N2AAjHJwkAAisMKw2wxHBFgS1bY9KaxWjX+xTbXWRcXGsv9a/D
	 ZN/B4tgMUkDEQCO3RJwF0rPLGd1S7249mAWWXO9Q1wqEpVa8e9anaV3UBBwNh17xah
	 i5487SIRy1Oas1bAsLgFFhFKxPmV6y+wulH3RORE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konstantin Andreev <andreev@swemel.ru>,
	Casey Schaufler <casey@schaufler-ca.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 044/121] smack: unix sockets: fix accept()ed socket label
Date: Tue, 10 Sep 2024 11:31:59 +0200
Message-ID: <20240910092547.840386026@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092545.737864202@linuxfoundation.org>
References: <20240910092545.737864202@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 7d04b21737cf..a9582737c230 100644
--- a/security/smack/smack_lsm.c
+++ b/security/smack/smack_lsm.c
@@ -3640,12 +3640,18 @@ static int smack_unix_stream_connect(struct sock *sock,
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



