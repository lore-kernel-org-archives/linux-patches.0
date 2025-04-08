Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05869224AEB;
	Tue,  8 Apr 2025 12:40:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744116019; cv=none; b=ihqtyruvAnYtAWbTmtSphdbDlvapFFs0g/rM12yzzYZeQqtDdAzQ4bxMZgolTNy0s2LHjCzKK3ktUS7ZJbGsc4QER30sioyn4RLL45FBBmSOl3JhGtJvRrYBHk3GL4UEH52gZuoFgHXUfSkf81q4qGr0LiHHArqfJ7FMkREnsfQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744116019; c=relaxed/simple;
	bh=v+6YD6PgZd1Lp7ah4XOumnmNkecgiABOX2u/8dSBwQ4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mXBWGdm7y9YQclrbKpXroR/gA928HW/yXQEMeyE2rzYDBgB2T03+wiFXtYnsLaReSoap1rpu3NInBk+rGVIBzPzVr683aSKemrRw2gUB3E+1CDTuzv/OwiK+/ABHSB2CI9sCKWl2iZLEOPCDiS5eIFOJHEg2yr2MYceWPfIJOeA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Evjc5U5F; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Evjc5U5F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29D0DC4CEE5;
	Tue,  8 Apr 2025 12:40:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744116018;
	bh=v+6YD6PgZd1Lp7ah4XOumnmNkecgiABOX2u/8dSBwQ4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Evjc5U5FXSaD2wp/nOcTgZ14J41wILTqrZjaF7Q5IeV4aDaKgODt4HYc6v9KV1Q4a
	 wH6YmOphswke8v9BOkLAFEqmJAPc/C8NsqKnCkYhhxzvntEUpwXV1gFpfZP7p46o0a
	 FI6ZoLV8EPx5xz0gpGIx8Ton4A00CjGHdDoghi58=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Norbert Szetei <norbert@doyensec.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.1 189/204] ksmbd: add bounds check for create lease context
Date: Tue,  8 Apr 2025 12:51:59 +0200
Message-ID: <20250408104825.859642849@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104820.266892317@linuxfoundation.org>
References: <20250408104820.266892317@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Norbert Szetei <norbert@doyensec.com>

commit bab703ed8472aa9d109c5f8c1863921533363dae upstream.

Add missing bounds check for create lease context.

Cc: stable@vger.kernel.org
Reported-by: Norbert Szetei <norbert@doyensec.com>
Tested-by: Norbert Szetei <norbert@doyensec.com>
Signed-off-by: Norbert Szetei <norbert@doyensec.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/server/oplock.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/fs/smb/server/oplock.c
+++ b/fs/smb/server/oplock.c
@@ -1534,6 +1534,10 @@ struct lease_ctx_info *parse_lease_state
 	if (sizeof(struct lease_context_v2) == le32_to_cpu(cc->DataLength)) {
 		struct create_lease_v2 *lc = (struct create_lease_v2 *)cc;
 
+		if (le16_to_cpu(cc->DataOffset) + le32_to_cpu(cc->DataLength) <
+		    sizeof(struct create_lease_v2) - 4)
+			return NULL;
+
 		memcpy(lreq->lease_key, lc->lcontext.LeaseKey, SMB2_LEASE_KEY_SIZE);
 		if (is_dir) {
 			lreq->req_state = lc->lcontext.LeaseState &
@@ -1551,6 +1555,10 @@ struct lease_ctx_info *parse_lease_state
 	} else {
 		struct create_lease *lc = (struct create_lease *)cc;
 
+		if (le16_to_cpu(cc->DataOffset) + le32_to_cpu(cc->DataLength) <
+		    sizeof(struct create_lease))
+			return NULL;
+
 		memcpy(lreq->lease_key, lc->lcontext.LeaseKey, SMB2_LEASE_KEY_SIZE);
 		lreq->req_state = lc->lcontext.LeaseState;
 		lreq->flags = lc->lcontext.LeaseFlags;


