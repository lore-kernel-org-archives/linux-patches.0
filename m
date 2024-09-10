Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12A9746444;
	Tue, 10 Sep 2024 09:37:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725961025; cv=none; b=ZfiT4/SUUdp01ysa5l7Q4BQa7OleJ2PS7uAvGmgMlr2/diJXfAe9ZQfzg20kqHIbDq95yVZtvyftbvt0y6FDRl9dYMIX78Gu0oEMTZv2vppa8noDT6i6MfiYj0emNyypOHjzSOYUNlzrUuE69BV/sNjql0FtIWJatn4OEernmAo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725961025; c=relaxed/simple;
	bh=+gKKOdbDyueWim7wNxVl5ri2cTo9BmidYRL7aLN+f0k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PCOKwcDnZ04ZC+StZmdfOqnkG8RIkN8wItGIv+cvZ4ii/p/YogzFAK2dezurGKbgRGQHfwYCZWFwUPk1yFOpNnXb6HmNJMCynrHT/i1LmludxOWy9XreDp2/q2c2Cu4TbJ1S0oBTTqBYpx1znfNSBzS44199QTUKrNw/MXK+Fuw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DFwme9lf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DFwme9lf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 606D4C4CEC6;
	Tue, 10 Sep 2024 09:37:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725961024;
	bh=+gKKOdbDyueWim7wNxVl5ri2cTo9BmidYRL7aLN+f0k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DFwme9lfmtjSfwn/HzqhuNqQ5vLeGDz0tfMZI5APAscBEysSvrSIzaYjsxrdgxDoU
	 eXSiDMszLQhHkszeaLn0V27cKvDgHZooJVDYUgaTAu6sr5kfQh7oO59w5jC0tV4UYe
	 DJNKHv1kWVITVJlDwOHPZXsjrkZ/Weq58sf+dtOk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konstantin Andreev <andreev@swemel.ru>,
	Casey Schaufler <casey@schaufler-ca.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 27/96] smack: unix sockets: fix accept()ed socket label
Date: Tue, 10 Sep 2024 11:31:29 +0200
Message-ID: <20240910092542.664881264@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092541.383432924@linuxfoundation.org>
References: <20240910092541.383432924@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
index 158f4df39be4..00d8e1b53b2a 100644
--- a/security/smack/smack_lsm.c
+++ b/security/smack/smack_lsm.c
@@ -3745,12 +3745,18 @@ static int smack_unix_stream_connect(struct sock *sock,
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



