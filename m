Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A861313550;
	Thu, 28 May 2026 20:31:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780000308; cv=none; b=io7xc8hTyhKTPGNyH2IMurekYiL78uwZA2P10ySZhRZ8qPrmwJw1/9RIXTghX7DEkzEVSkTws1eMSYcFUF5y9yKy4U0Vme5yFL/PiglrrIp/LUB/KNW6iT5AIAL1Ur3D9Td4VhTsg/c5xggp5TMQrnbbYcL5OAt5Q/dS7wFyq7k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780000308; c=relaxed/simple;
	bh=690Jv5HT0CV5l+LyIKSqPbfKxB4ceN55eH0thnVFknQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CF1N1Z1Y0X/sAcssPa+L1XQGaJtjj01C86TyXBL76OSrWCpKsqUSLuH6FXuGuXjZ8ObbrNuNIoDPq/MVYdHgA79uUnyMVrwJxCkuYSWraauA6Qgd4IYjxDsr7BSg5OV1fNMDQ03SAtVZzsZHJS7iMXong8QO4fhIDeLqs/tuwRU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=f2ID9edJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="f2ID9edJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E93BB1F000E9;
	Thu, 28 May 2026 20:31:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780000307;
	bh=CPxrkqbq2PcqlwbGboemkJonrJNN059piE427CNWUk8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=f2ID9edJ2CEsVT6ofhgHLJL4firTU8H97OfIWapQft0KubvO+VBoaIddmKUtGOblR
	 GODmBCSOGsG3f3v00QXj4H7oQbTVw5XY7Q77ziml8sZSBPm0c1BYFzacT7lZIHO5fA
	 jx2k1n0yCK0vZwMTRZNqJ4rPsn3/eZN29hDccJ8c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Junyi Liu <moss80199@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 376/377] ksmbd: fix durable reconnect error path file lifetime
Date: Thu, 28 May 2026 21:50:14 +0200
Message-ID: <20260528194649.318303731@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194638.371537336@linuxfoundation.org>
References: <20260528194638.371537336@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Junyi Liu <moss80199@gmail.com>

[ Upstream commit 3515503322f4819277091839eed46b695096aca5 ]

After a durable reconnect succeeds, ksmbd_reopen_durable_fd() republishes
the same ksmbd_file into the session volatile-id table. If smb2_open()
then takes a later error path, cleanup first calls ksmbd_fd_put(work, fp)
and then unconditionally calls ksmbd_put_durable_fd(dh_info.fp).

In this case fp and dh_info.fp are the same object. The first put drops the
reconnect lookup reference, but the final durable put can run
__ksmbd_close_fd(NULL, fp). Because the final close is not session-aware,
it can free the file object without removing the volatile-id entry that was
just published into the session table.

Use the session-aware put for the final reconnect drop when the reconnect
had already succeeded and the error path is cleaning up the republished
file. Earlier reconnect failures, before fp is assigned to dh_info.fp, keep
using the durable-only put path.

Fixes: 1baff47b81f9 ("ksmbd: fix use-after-free in smb2_open during durable reconnect")
Signed-off-by: Junyi Liu <moss80199@gmail.com>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/smb2pdu.c | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 756624b4e90e0..da7b96707186e 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -3812,8 +3812,19 @@ int smb2_open(struct ksmbd_work *work)
 		ksmbd_debug(SMB, "Error response: %x\n", rsp->hdr.Status);
 	}
 
-	if (dh_info.reconnected)
-		ksmbd_put_durable_fd(dh_info.fp);
+	if (dh_info.reconnected) {
+		/*
+		 * If reconnect succeeded, fp was republished in the
+		 * session file table.  On a later error, ksmbd_fd_put()
+		 * above drops the session reference; drop the durable
+		 * lookup reference through the same session-aware path so
+		 * final close removes the volatile id before freeing fp.
+		 */
+		if (rc && fp == dh_info.fp)
+			ksmbd_fd_put(work, dh_info.fp);
+		else
+			ksmbd_put_durable_fd(dh_info.fp);
+	}
 
 	kfree(name);
 	kfree(lc);
-- 
2.53.0



