Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B84F19E7CC;
	Thu,  6 Jun 2024 14:11:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683105; cv=none; b=ekiFrZn9ctXCNA6Nf7o9+9ZQCDGPwnggYZZzGSShLR/V01REg+HJFhm9lpulGGtCYLcFZRhh8rIndjA4oqy+N2EUnCXmKhGK5YBMxg8ekGnsGOA2cZIrftzRGfEQfB7aaKH0nrEcdckjtpYvPfTHpKNCVoRn5Bz/daqvqw0j05s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683105; c=relaxed/simple;
	bh=rMgTRYdZ0JDxuVN/YS5iRyZFbRz9mGqPe86sZXc6IuQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZOwxCcTiZh+//z3iIGAyP3GfqKnO/bk5+hn8p39lGybjR3FmOGxldZjwRs+YC1D/hJuJvWXtvhOXenQw6zHtSmimrDkCDa8G6lB9bUm95DUjHnEFyzR551VBiPoiPXInH+a5s3cJXVIytI+T01it8qALjmEoJzbBoT8Ik1c3OyI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=w+EZRCJ6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="w+EZRCJ6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4428C2BD10;
	Thu,  6 Jun 2024 14:11:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683105;
	bh=rMgTRYdZ0JDxuVN/YS5iRyZFbRz9mGqPe86sZXc6IuQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=w+EZRCJ6gA9Qs7w6UrYsQ3ou6PlYtUnlxxESTzic4LOTth2lAXGoII1pzeomExTU1
	 N84g6qdT9Xqy4P44mvLOW56mzLsg7HBQXzU4snE1s8ypNMprPMNR3r8S3OpQK/ldr6
	 OrX65BsPjci+IsyOZj6uI4wyFwbzTBXdQ5rsdu/w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.6 027/744] ksmbd: avoid to send duplicate oplock break notifications
Date: Thu,  6 Jun 2024 15:54:59 +0200
Message-ID: <20240606131733.319014954@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
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

From: Namjae Jeon <linkinjeon@kernel.org>

commit c91ecba9e421e4f2c9219cf5042fa63a12025310 upstream.

This patch fixes generic/011 when oplocks is enable.

Avoid to send duplicate oplock break notifications like smb2 leases
case.

Fixes: 97c2ec64667b ("ksmbd: avoid to send duplicate lease break notifications")
Cc: stable@vger.kernel.org
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/server/oplock.c |   21 +++++++++++++--------
 1 file changed, 13 insertions(+), 8 deletions(-)

--- a/fs/smb/server/oplock.c
+++ b/fs/smb/server/oplock.c
@@ -614,19 +614,24 @@ static int oplock_break_pending(struct o
 		if (opinfo->op_state == OPLOCK_CLOSING)
 			return -ENOENT;
 		else if (opinfo->level <= req_op_level) {
-			if (opinfo->is_lease &&
-			    opinfo->o_lease->state !=
-			     (SMB2_LEASE_HANDLE_CACHING_LE |
-			      SMB2_LEASE_READ_CACHING_LE))
+			if (opinfo->is_lease == false)
+				return 1;
+
+			if (opinfo->o_lease->state !=
+			    (SMB2_LEASE_HANDLE_CACHING_LE |
+			     SMB2_LEASE_READ_CACHING_LE))
 				return 1;
 		}
 	}
 
 	if (opinfo->level <= req_op_level) {
-		if (opinfo->is_lease &&
-		    opinfo->o_lease->state !=
-		     (SMB2_LEASE_HANDLE_CACHING_LE |
-		      SMB2_LEASE_READ_CACHING_LE)) {
+		if (opinfo->is_lease == false) {
+			wake_up_oplock_break(opinfo);
+			return 1;
+		}
+		if (opinfo->o_lease->state !=
+		    (SMB2_LEASE_HANDLE_CACHING_LE |
+		     SMB2_LEASE_READ_CACHING_LE)) {
 			wake_up_oplock_break(opinfo);
 			return 1;
 		}


