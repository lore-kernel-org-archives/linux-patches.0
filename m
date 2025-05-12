Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75DE624DFF6;
	Mon, 12 May 2025 17:57:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747072658; cv=none; b=tMRVoteuQiyDWMjOy9Mh6I0++z/FUSpTv6HRElamrAu8Ahla7nYesqWTGO3OlTfjiAHgUkhROmfFrwb7AnZgiXES67yxyCr4oalCTtUSSWFH9Vf2HWktKeX4zc88Hfwi7tKFv7nGZgZVWtDTs4B0hD+qqCOgSpIyJUd+lGeOXgY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747072658; c=relaxed/simple;
	bh=m3Mm4Er/Rk/ehXR2eyV00jUTwpD2Uf0XzVgoo9PsYmw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WATLi9JUMV/RqT8l2bCb6KPGZdg2NBySBdLVIVjOKA3fFUuDvegXEnpP3km6Qc0WnmQwXz3sRcQFSl/VgHbUmLs5T+35AQRKRHHVLMWKPB07zwzqaF+l9jMm72wZTt92rnLr0//BGNo4G2q97v6gNoobjVwLsFY+TV0iX2W1qJ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b3QoViaq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b3QoViaq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A75BBC4CEE7;
	Mon, 12 May 2025 17:57:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747072658;
	bh=m3Mm4Er/Rk/ehXR2eyV00jUTwpD2Uf0XzVgoo9PsYmw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=b3QoViaqwShihCz2CChc4i+GZrQ6gs0DgghARC1U7R9322nzbTUiUEl6M2Hym0cqT
	 DxB4laGCqANyfmDa7sKjYYN4ZVoaTn86KUVXxaLY8vgwgv8O3GEY7t8sZp8wz6oGbh
	 DXnUBPYnIU6x0xEFgZWfwieTAfJSqIzjS1n7szUc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wang Zhaolong <wangzhaolong1@huawei.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 017/184] ksmbd: fix memory leak in parse_lease_state()
Date: Mon, 12 May 2025 19:43:38 +0200
Message-ID: <20250512172042.376878353@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250512172041.624042835@linuxfoundation.org>
References: <20250512172041.624042835@linuxfoundation.org>
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

From: Wang Zhaolong <wangzhaolong1@huawei.com>

[ Upstream commit eb4447bcce915b43b691123118893fca4f372a8f ]

The previous patch that added bounds check for create lease context
introduced a memory leak. When the bounds check fails, the function
returns NULL without freeing the previously allocated lease_ctx_info
structure.

This patch fixes the issue by adding kfree(lreq) before returning NULL
in both boundary check cases.

Fixes: bab703ed8472 ("ksmbd: add bounds check for create lease context")
Signed-off-by: Wang Zhaolong <wangzhaolong1@huawei.com>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/oplock.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/fs/smb/server/oplock.c b/fs/smb/server/oplock.c
index 81a29857b1e32..03f606afad93a 100644
--- a/fs/smb/server/oplock.c
+++ b/fs/smb/server/oplock.c
@@ -1496,7 +1496,7 @@ struct lease_ctx_info *parse_lease_state(void *open_req)
 
 		if (le16_to_cpu(cc->DataOffset) + le32_to_cpu(cc->DataLength) <
 		    sizeof(struct create_lease_v2) - 4)
-			return NULL;
+			goto err_out;
 
 		memcpy(lreq->lease_key, lc->lcontext.LeaseKey, SMB2_LEASE_KEY_SIZE);
 		lreq->req_state = lc->lcontext.LeaseState;
@@ -1512,7 +1512,7 @@ struct lease_ctx_info *parse_lease_state(void *open_req)
 
 		if (le16_to_cpu(cc->DataOffset) + le32_to_cpu(cc->DataLength) <
 		    sizeof(struct create_lease))
-			return NULL;
+			goto err_out;
 
 		memcpy(lreq->lease_key, lc->lcontext.LeaseKey, SMB2_LEASE_KEY_SIZE);
 		lreq->req_state = lc->lcontext.LeaseState;
@@ -1521,6 +1521,9 @@ struct lease_ctx_info *parse_lease_state(void *open_req)
 		lreq->version = 1;
 	}
 	return lreq;
+err_out:
+	kfree(lreq);
+	return NULL;
 }
 
 /**
-- 
2.39.5



