Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CADC53D9EE;
	Thu, 17 Sep 2026 17:06:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789664815; cv=none; b=NZMcSz0DxxDkcA+G7y2WG9dbcfchuAAXwoiW66+lZLHWMfFHM9awGSyqtW3gChL0zLAN3InZAd4V6o5PT/+KCZV0+VVEmmFq2kKcG2GabQbuQfOQDNLbaytUP3hH8v2RJB3+VD3mr4YoyFtXCuryzConIMOkSvFbvtIcw4n8740=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789664815; c=relaxed/simple;
	bh=/msGBgYGb1iknxfJGcwOwYOOHROOm7Nuwhhkj60Ik+c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bhrNsFIMKbacqw3elWvlZy5UjzPEPoRn4UtlHfl29CXY6nk3H7cg8Z7rPKyj7vQFm7eJlBQuk0t1ePo1vNuuBDEUPI+joBWKymmP9Fbs1OvJgoqFsXnVe1cAQn7BG7Tzur5gjWvyAuJgvPMUZMz3RuYo4U7JLbLeS79HvOS3frs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rXteE6a+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rXteE6a+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 804501F000FF;
	Thu, 17 Sep 2026 17:06:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789664814;
	bh=dQ+s1+0dvM1HP7XLWDL6nN+Z8sMz7lv9fuIwbyL2rEw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rXteE6a+M6TzhLrajsCyrth7WdNubMzAf8N4IKelM9PCzONsOe/DllRrp9IeFc6f5
	 c4F18oUQ+CFKqVaOPbhdRSzw6EXqNET0iyS+R0UJz385hNTc0QztobVm1mXxBVo5s9
	 /8koAV3+4musaRdn0AUWrexv6TlkhkZYGlvK1NWk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0497/1250] ksmbd: find bound sessions during reauthentication
Date: Thu, 17 Sep 2026 16:04:52 +0100
Message-ID: <20260917151605.433388157@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

From: Namjae Jeon <linkinjeon@kernel.org>

[ Upstream commit faf8578c77f3d846aca9cd882c293e03eafcc6df ]

A session bound to an additional connection is stored in the session
channel list, but it is not added to that connection's local session table.
After the binding exchange completes, conn->binding is cleared.

A later SESSION_SETUP reauthentication on the bound channel only searches
the local session table. It fails to find the session and returns
STATUS_USER_SESSION_DELETED instead of processing authentication and
returning STATUS_LOGON_FAILURE for invalid credentials.

If the local lookup fails, look up the session globally and accept it only
when the current connection is registered in its channel list. This keeps
unbound connections from using the session while allowing reauthentication
on an established channel.

This fixes smb2.session.bind_invalid_auth.

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/smb2pdu.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 7cdf345a2e7ce..f2a53841e8a81 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -1795,6 +1795,13 @@ int smb2_sess_setup(struct ksmbd_work *work)
 	} else {
 		sess = ksmbd_session_lookup(conn,
 					    le64_to_cpu(req->hdr.SessionId));
+		if (!sess) {
+			sess = ksmbd_session_lookup_slowpath(le64_to_cpu(req->hdr.SessionId));
+			if (sess && !lookup_chann_list(sess, conn)) {
+				ksmbd_user_session_put(sess);
+				sess = NULL;
+			}
+		}
 		if (!sess) {
 			rc = -ENOENT;
 			goto out_err;
-- 
2.53.0



