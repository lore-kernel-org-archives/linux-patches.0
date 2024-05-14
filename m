Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5ACC880C04;
	Tue, 14 May 2024 11:38:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715686703; cv=none; b=ppVM4Lxklj27ByH0l0QT+wwsFEtqRcjlLb41+FMkfwotbxwvGofG2yviFt6qIUb16eExZMjdpIp4x+6HsGJuBVd3JnqDgaqA6nJIVUg8BVHnbL7GjSv3QrqOqvu6tshZD4IyynXQGY2YnrMXF04cdR+a8S95j8qu8/wxKY3o20U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715686703; c=relaxed/simple;
	bh=BhE2x5MKeKr1zaxWvO3PGWOSvMEiCsLnOcWadMOz9IU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jbiWqqrmRdISlGAjPL82/PAGZvs0dNmBmErpdgyviNcoTLjPoDVwekcc8aUP0YaJIAEXj9pOGPzh6a5+d1NU5NaEWwb/K9HgOErvpXLtk54HZQ+sguuLoxWTijh74roBgbmKnU6Pni4Ajo+HygkMEIvM6IIz8546PAba1bvcQVo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ViEL6M5G; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ViEL6M5G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79F64C2BD10;
	Tue, 14 May 2024 11:38:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715686702;
	bh=BhE2x5MKeKr1zaxWvO3PGWOSvMEiCsLnOcWadMOz9IU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ViEL6M5GWc+B+zVnpnZSJef7Ek+6/OpK1D4OjAMtc1Ktwz41BDIzB/k4pPMGkamXF
	 IyD69kgC23iyfeWPQr+VPFaGiKoqDuHafUJWQ3lpdNDWty5RsxxcDHp44MobnvqzIG
	 9pbYtpzTHxoskcBTlrNf6EFf8icoqfpGytK3Rb3o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.1 230/236] ksmbd: avoid to send duplicate lease break notifications
Date: Tue, 14 May 2024 12:19:52 +0200
Message-ID: <20240514101029.088712334@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101020.320785513@linuxfoundation.org>
References: <20240514101020.320785513@linuxfoundation.org>
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

From: Namjae Jeon <linkinjeon@kernel.org>

commit 97c2ec64667bacc49881d2b2dd9afd4d1c3fbaeb upstream.

This patch fixes generic/011 when enable smb2 leases.

if ksmbd sends multiple notifications for a file, cifs increments
the reference count of the file but it does not decrement the count by
the failure of queue_work.
So even if the file is closed, cifs does not send a SMB2_CLOSE request.

Cc: stable@vger.kernel.org
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/server/oplock.c |   21 +++++++++++++++------
 1 file changed, 15 insertions(+), 6 deletions(-)

--- a/fs/smb/server/oplock.c
+++ b/fs/smb/server/oplock.c
@@ -612,13 +612,23 @@ static int oplock_break_pending(struct o
 
 		if (opinfo->op_state == OPLOCK_CLOSING)
 			return -ENOENT;
-		else if (!opinfo->is_lease && opinfo->level <= req_op_level)
-			return 1;
+		else if (opinfo->level <= req_op_level) {
+			if (opinfo->is_lease &&
+			    opinfo->o_lease->state !=
+			     (SMB2_LEASE_HANDLE_CACHING_LE |
+			      SMB2_LEASE_READ_CACHING_LE))
+				return 1;
+		}
 	}
 
-	if (!opinfo->is_lease && opinfo->level <= req_op_level) {
-		wake_up_oplock_break(opinfo);
-		return 1;
+	if (opinfo->level <= req_op_level) {
+		if (opinfo->is_lease &&
+		    opinfo->o_lease->state !=
+		     (SMB2_LEASE_HANDLE_CACHING_LE |
+		      SMB2_LEASE_READ_CACHING_LE)) {
+			wake_up_oplock_break(opinfo);
+			return 1;
+		}
 	}
 	return 0;
 }
@@ -886,7 +896,6 @@ static int oplock_break(struct oplock_in
 		struct lease *lease = brk_opinfo->o_lease;
 
 		atomic_inc(&brk_opinfo->breaking_cnt);
-
 		err = oplock_break_pending(brk_opinfo, req_op_level);
 		if (err)
 			return err < 0 ? err : 0;


