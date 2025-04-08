Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3DB48836;
	Tue,  8 Apr 2025 13:00:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744117221; cv=none; b=i9jq5Y+/R7/W9T5dH7Wo1d6p1VHyakmK2HNZTHO5mE+mwDO87dKaWaorZ0+NO6kTVCqN+TSEs/zfCSD829ywzIn7T8FW/Ous1vIhPZzJii26SAmRD69a3pz6FhJGGfGMxWZWJ2aTikTwFOc2qzHUqXEjNsUmbOtBvoxQ9bbQNYc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744117221; c=relaxed/simple;
	bh=lb1iaE7YN4BuUEwpUOSGlVQaB+/YwLG5DPVPTDs0SOE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CjvOlv1CAz2R6p0rjLdqUpzSIOtjse0XNTOt60PS98Nsd7rxaNLlM0/j/zTceKNsa4HrzqG2+JkS7ZdOkR7yp70hHV7bk7gWi4GxAXNCZ0/U93q5u8WVZqkdosx3+NTxq9fEZs6qTFgpdNCP2PSS4cq/h78PcyadYjmm9mVcMSg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=p/YcTqMw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="p/YcTqMw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 570CEC4CEE5;
	Tue,  8 Apr 2025 13:00:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744117221;
	bh=lb1iaE7YN4BuUEwpUOSGlVQaB+/YwLG5DPVPTDs0SOE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=p/YcTqMwxaLVZd3bEGhhgijYFYibDoKhOyAi7Jx/uYrk1VFeBtQyQEM4px4UFIwnq
	 OAyZkkKz3yP9XI4IUcp6JzjsWE5kthJQivzOTndBr/Gjja5zCzVkabc6pnR2hdsAp9
	 On1jbdVMPCE8PrJBZ0XGhtfbh8/lbX+j6M+MAbtM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Norbert Szetei <norbert@doyensec.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.12 394/423] ksmbd: add bounds check for durable handle context
Date: Tue,  8 Apr 2025 12:52:00 +0200
Message-ID: <20250408104855.074210995@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104845.675475678@linuxfoundation.org>
References: <20250408104845.675475678@linuxfoundation.org>
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

From: Namjae Jeon <linkinjeon@kernel.org>

commit 542027e123fc0bfd61dd59e21ae0ee4ef2101b29 upstream.

Add missing bounds check for durable handle context.

Cc: stable@vger.kernel.org
Reported-by: Norbert Szetei <norbert@doyensec.com>
Tested-by: Norbert Szetei <norbert@doyensec.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/server/smb2pdu.c |   21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -2699,6 +2699,13 @@ static int parse_durable_handle_context(
 				goto out;
 			}
 
+			if (le16_to_cpu(context->DataOffset) +
+				le32_to_cpu(context->DataLength) <
+			    sizeof(struct create_durable_reconn_v2_req)) {
+				err = -EINVAL;
+				goto out;
+			}
+
 			recon_v2 = (struct create_durable_reconn_v2_req *)context;
 			persistent_id = recon_v2->Fid.PersistentFileId;
 			dh_info->fp = ksmbd_lookup_durable_fd(persistent_id);
@@ -2732,6 +2739,13 @@ static int parse_durable_handle_context(
 				goto out;
 			}
 
+			if (le16_to_cpu(context->DataOffset) +
+				le32_to_cpu(context->DataLength) <
+			    sizeof(struct create_durable_reconn_req)) {
+				err = -EINVAL;
+				goto out;
+			}
+
 			recon = (struct create_durable_reconn_req *)context;
 			persistent_id = recon->Data.Fid.PersistentFileId;
 			dh_info->fp = ksmbd_lookup_durable_fd(persistent_id);
@@ -2756,6 +2770,13 @@ static int parse_durable_handle_context(
 				err = -EINVAL;
 				goto out;
 			}
+
+			if (le16_to_cpu(context->DataOffset) +
+				le32_to_cpu(context->DataLength) <
+			    sizeof(struct create_durable_req_v2)) {
+				err = -EINVAL;
+				goto out;
+			}
 
 			durable_v2_blob =
 				(struct create_durable_req_v2 *)context;


