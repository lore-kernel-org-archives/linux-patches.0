Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 602AE19AD5C;
	Tue,  8 Apr 2025 11:36:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744112163; cv=none; b=dXGIQ8+dhEE0TZC2MPqSSo89GBEmFwP5A0T8RF2MpZ7WVSIc/0opsB8GeTEEpTCHws6k8I5B+aypRJiMP8hnffFzjMXuwimMVw9bCFBxDG/ZVM/Uhm40nyTFAfZVAFd9R3WvFGsnR+f/P+DxZkcciDEpiZgwhjMc7+XQwpM9L88=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744112163; c=relaxed/simple;
	bh=T0PoplPx0EuWe8nbFVRWh2HINYy6hhR0mlsaQXoZExE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lyC2rmRGAzx3Ll0m6F2UxlaJ1RKqosQJzDrBaNNXu0pnrxreq6swh7wg8barLPa2+CAucNjwmdjWkZ6nshuk4huv55xagz6+nPaBoeYV5OE91i+mgL2jiBdndIjPqjkJ2R1S4c81SfZiFntzUKLnqBhUc6RGYB0ok3+STE5EueA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=h+KLXDZC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="h+KLXDZC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2540C4CEE5;
	Tue,  8 Apr 2025 11:36:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744112163;
	bh=T0PoplPx0EuWe8nbFVRWh2HINYy6hhR0mlsaQXoZExE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=h+KLXDZCYSQcFvytoZDcUhucFxK6jTBSQDFeOR7CdBlO+TAO9ozC7xr+Vpdb9VqbZ
	 M6fjbCtp5GXapEov08WLLZHzDTRneOi5zB8x5L1LVMgBRlf0RXyK+rAAt2Mcws7hiC
	 AHcUao5h6q8U5RdiUFyZBFNUmWTBs3iJS99hO+1o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Norbert Szetei <norbert@doyensec.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.14 699/731] ksmbd: add bounds check for create lease context
Date: Tue,  8 Apr 2025 12:49:56 +0200
Message-ID: <20250408104930.528037411@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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


