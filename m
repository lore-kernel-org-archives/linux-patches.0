Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24208254879;
	Mon, 12 May 2025 17:53:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747072394; cv=none; b=HJY0omU+vfLdSTcDYtSkc3qMYNli3kBT/EmJrWveovpxxK9yQPNhI+0z7MrS1ZXX2oO/+w1zkkKF3+TQl41Tc8C5+GYH7y4vBl+hHnArvcxWiy6xuFkjgfzHwWaDnt/gR+RgwkHl/qwctf/Hr9HfK6fAjln73iOWMBj5ubWvqOw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747072394; c=relaxed/simple;
	bh=/8oDmPolIdbDxWsHaFIex9V7OfH69RzEOzAWx1K7cs4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X/ilhaNlvW2CDNIbybcC4JJCO6GsqjiDrEh1R0Gu91wKj44zNeHHVTA26qjBH/9eYvH+3cxreki86H7giwnyofaPHKRbEOKFJfyH4tTh5wZD2pRh1hepQ+YhgCUEE7/V1TPh4FuRPMWvSMw+UlGmoT+Vnvou4NyXClazr3DNspI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JXdhzp3I; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JXdhzp3I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1460FC4CEE7;
	Mon, 12 May 2025 17:53:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747072393;
	bh=/8oDmPolIdbDxWsHaFIex9V7OfH69RzEOzAWx1K7cs4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JXdhzp3Iq62ivlzlumHmcLpbHzeAy8Zyp2wzZtAh2bZ4ibu73EdBDa2JB64FPT2bJ
	 dOMTWO0IUrsZcwVZW8/xbXgUP/TL3oQk9Yh0SDqnY5RyR2HYcOqfkf3H9Qs7NEJVmw
	 idLP6hAesF8y1ditPZikv1+i3fWCMdqkq6YYyfGw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wang Zhaolong <wangzhaolong1@huawei.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 07/92] ksmbd: fix memory leak in parse_lease_state()
Date: Mon, 12 May 2025 19:44:42 +0200
Message-ID: <20250512172023.431474293@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250512172023.126467649@linuxfoundation.org>
References: <20250512172023.126467649@linuxfoundation.org>
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
index 2fcfabc35b06b..258ed9978b90e 100644
--- a/fs/smb/server/oplock.c
+++ b/fs/smb/server/oplock.c
@@ -1536,7 +1536,7 @@ struct lease_ctx_info *parse_lease_state(void *open_req, bool is_dir)
 
 		if (le16_to_cpu(cc->DataOffset) + le32_to_cpu(cc->DataLength) <
 		    sizeof(struct create_lease_v2) - 4)
-			return NULL;
+			goto err_out;
 
 		memcpy(lreq->lease_key, lc->lcontext.LeaseKey, SMB2_LEASE_KEY_SIZE);
 		if (is_dir) {
@@ -1557,7 +1557,7 @@ struct lease_ctx_info *parse_lease_state(void *open_req, bool is_dir)
 
 		if (le16_to_cpu(cc->DataOffset) + le32_to_cpu(cc->DataLength) <
 		    sizeof(struct create_lease))
-			return NULL;
+			goto err_out;
 
 		memcpy(lreq->lease_key, lc->lcontext.LeaseKey, SMB2_LEASE_KEY_SIZE);
 		lreq->req_state = lc->lcontext.LeaseState;
@@ -1566,6 +1566,9 @@ struct lease_ctx_info *parse_lease_state(void *open_req, bool is_dir)
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



