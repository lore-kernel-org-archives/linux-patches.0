Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CA4029B233;
	Tue, 26 Aug 2025 11:36:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756208218; cv=none; b=CDeQBR8GIBuMKDDFepPYPHAByvOCMxkY0+yzRde7YDkTSEbuqc3i3NpZWEy1y9vbJmR8rtLUYUFyb0q4bnxpHiFZ8vVOw/HQJSjx4Xxq7XJyRwSi8P9XdjG4HGb/1e4x24Vo1rsvgojgTKtiD7R9O8RdP3raevNUfx10A7qUDCk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756208218; c=relaxed/simple;
	bh=7KhX+t56lxonE5aa9WDdhUbqIHXlvDviWmJyur8GYmw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tX4DEuHMMSI3SdaeG2TNuZQmG5QtjQJOpkVaCI61sG3O0nn1Jtokp/KEs+QT1P52sYxKlOh/UBxUm23pSF6QRUVAHFCE2BB3iyDUxCMRuWBOOH+6eHi1eqhvpzcWZ/lucIKlixEGF5nKuXsfIAD4Ez63G3gnUKHSz290Ec1lIf0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sCXXHLH2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sCXXHLH2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1641CC4CEF1;
	Tue, 26 Aug 2025 11:36:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756208218;
	bh=7KhX+t56lxonE5aa9WDdhUbqIHXlvDviWmJyur8GYmw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sCXXHLH2cB8zFyhP2XyQEi+6Kjiow0m9aHVVJhovcyyhqxAuitp8mvy/vRxARF+cl
	 1TfOXYxc8U7dWRgmvDPr0U/32g0Nqlgfofg6eBmLb/FvFKuSLNPKAPkzePzYqDDmyo
	 wi5xauAgaffVPs89yVHanwisZRavPNN1OHWj68xQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ziyan Xu <ziyan@securitygossip.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.12 026/322] ksmbd: fix refcount leak causing resource not released
Date: Tue, 26 Aug 2025 13:07:21 +0200
Message-ID: <20250826110915.947699642@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110915.169062587@linuxfoundation.org>
References: <20250826110915.169062587@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ziyan Xu <ziyan@securitygossip.com>

commit 89bb430f621124af39bb31763c4a8b504c9651e2 upstream.

When ksmbd_conn_releasing(opinfo->conn) returns true,the refcount was not
decremented properly, causing a refcount leak that prevents the count from
reaching zero and the memory from being released.

Cc: stable@vger.kernel.org
Signed-off-by: Ziyan Xu <ziyan@securitygossip.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/server/oplock.c |   13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

--- a/fs/smb/server/oplock.c
+++ b/fs/smb/server/oplock.c
@@ -1102,8 +1102,10 @@ void smb_send_parent_lease_break_noti(st
 			if (!atomic_inc_not_zero(&opinfo->refcount))
 				continue;
 
-			if (ksmbd_conn_releasing(opinfo->conn))
+			if (ksmbd_conn_releasing(opinfo->conn)) {
+				opinfo_put(opinfo);
 				continue;
+			}
 
 			oplock_break(opinfo, SMB2_OPLOCK_LEVEL_NONE, NULL);
 			opinfo_put(opinfo);
@@ -1139,8 +1141,11 @@ void smb_lazy_parent_lease_break_close(s
 			if (!atomic_inc_not_zero(&opinfo->refcount))
 				continue;
 
-			if (ksmbd_conn_releasing(opinfo->conn))
+			if (ksmbd_conn_releasing(opinfo->conn)) {
+				opinfo_put(opinfo);
 				continue;
+			}
+
 			oplock_break(opinfo, SMB2_OPLOCK_LEVEL_NONE, NULL);
 			opinfo_put(opinfo);
 		}
@@ -1343,8 +1348,10 @@ void smb_break_all_levII_oplock(struct k
 		if (!atomic_inc_not_zero(&brk_op->refcount))
 			continue;
 
-		if (ksmbd_conn_releasing(brk_op->conn))
+		if (ksmbd_conn_releasing(brk_op->conn)) {
+			opinfo_put(brk_op);
 			continue;
+		}
 
 		if (brk_op->is_lease && (brk_op->o_lease->state &
 		    (~(SMB2_LEASE_READ_CACHING_LE |


