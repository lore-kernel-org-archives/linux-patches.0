Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B23E26989E;
	Tue,  8 Apr 2025 12:31:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744115512; cv=none; b=qs2Td5Mqqf5fvRw0i1pChNvJ1/8nDSwuv3chwCgwhBD8Nt3k9UZdGsOx29Ex0N0FizOqc3Q5V7KAdYwyjGyrvOQseMNe3gGMY+ShVGpmiNYT4peGIT7ubLY6qhusK6+8eHpUX5qBR/8Z+GgrUKyF/zbwAMuBx6rKW7IpcvPCsv0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744115512; c=relaxed/simple;
	bh=8GHBySf/n9zU+6MPR4rdSRwfPodYLsKZeqcKVrG7HGY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZpDHgwIU/OqE3t3UP6uNy29ep2uhkmmSgrxSI9IecWfmxOewH162LinysencrW09ASH+NM8JxeWqahBsV4P9R4NPsOlvlCIGj7vwifRd5s79QHcASPHESwfy4z85nwXxTYPm79II/GOvo6xk629vMtHeBMvYAcnghaHQhTosilk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JF+5VmJz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JF+5VmJz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FA6BC4CEE5;
	Tue,  8 Apr 2025 12:31:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744115511;
	bh=8GHBySf/n9zU+6MPR4rdSRwfPodYLsKZeqcKVrG7HGY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JF+5VmJzw6/mJgW5s9EC8+vSXTOFpwmn/YuDnQQeY1PD69fdZK+3GfE/r/QWoyMIE
	 dKHK8XXzVk9sW30/y4tU5+OdhyBatJU43hmJq+V75QZpp7+3alFzwIAY1qD7gHEbOs
	 gHQvjj6pYiMokfkA8TMrXoY/BHo2b6rRIecim5A0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Norbert Szetei <norbert@doyensec.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.13 467/499] ksmbd: add bounds check for create lease context
Date: Tue,  8 Apr 2025 12:51:19 +0200
Message-ID: <20250408104902.888575970@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104851.256868745@linuxfoundation.org>
References: <20250408104851.256868745@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1505,6 +1505,10 @@ struct lease_ctx_info *parse_lease_state
 	if (sizeof(struct lease_context_v2) == le32_to_cpu(cc->DataLength)) {
 		struct create_lease_v2 *lc = (struct create_lease_v2 *)cc;
 
+		if (le16_to_cpu(cc->DataOffset) + le32_to_cpu(cc->DataLength) <
+		    sizeof(struct create_lease_v2) - 4)
+			return NULL;
+
 		memcpy(lreq->lease_key, lc->lcontext.LeaseKey, SMB2_LEASE_KEY_SIZE);
 		lreq->req_state = lc->lcontext.LeaseState;
 		lreq->flags = lc->lcontext.LeaseFlags;
@@ -1517,6 +1521,10 @@ struct lease_ctx_info *parse_lease_state
 	} else {
 		struct create_lease *lc = (struct create_lease *)cc;
 
+		if (le16_to_cpu(cc->DataOffset) + le32_to_cpu(cc->DataLength) <
+		    sizeof(struct create_lease))
+			return NULL;
+
 		memcpy(lreq->lease_key, lc->lcontext.LeaseKey, SMB2_LEASE_KEY_SIZE);
 		lreq->req_state = lc->lcontext.LeaseState;
 		lreq->flags = lc->lcontext.LeaseFlags;


