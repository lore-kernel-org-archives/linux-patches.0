Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 982B1A94A;
	Tue,  8 Apr 2025 12:01:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744113682; cv=none; b=CvXQ3R+h0UJlEL8OATcR/PaWIGYxQz5WP4rlVBouRF5gPcsSl3xTBmBvx3gTT+IZGz6nzwVUx+w0e+UUtcIgQ1xpVaPeqLG9F/H5cKTgUvC0GZP9ZkVHe77YwwUjvzKd+Kb/7QHlVwRE9FMm8lwo8Kg/UmIUhhmpauS7UJNmfiI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744113682; c=relaxed/simple;
	bh=YdbB0wZjf6CJk4NojXGlHtDPiRt/vpE8afQZQnblEuI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PrZeb19uuesO8AOiGEfGbsYURWQBKufgmkqHfgdgGIzM8+UIfeJchyrWjR9wBvEJiAKEntbLZb8C/nJ8Cc0tWTVfC/8QMwS2UUsjF357zN1az+ek+IFhMcQmx08ZmCFJBPyrjCBkJWP8TiNrALmmLq5k0iO6ufdn5jX9q2kBCZE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ary48HMB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ary48HMB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 008B4C4CEE5;
	Tue,  8 Apr 2025 12:01:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744113682;
	bh=YdbB0wZjf6CJk4NojXGlHtDPiRt/vpE8afQZQnblEuI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ary48HMBrpBC3cxgMPOpCiBuHysblwCY5uk8TjXM9VrkoOGIFQt7/PIW2n0ppzpmL
	 jTZEenHYb5SlKXb3FIxZMObyE029ezRYxUavVPhV+kaQdFOs9kZUD077Q1BbCJQhmb
	 kULqgUiDzkLIrC9Zt/4VA9T83wrInGbeV6c2UraE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Norbert Szetei <norbert@doyensec.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.6 251/268] ksmbd: add bounds check for durable handle context
Date: Tue,  8 Apr 2025 12:51:02 +0200
Message-ID: <20250408104835.354461585@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104828.499967190@linuxfoundation.org>
References: <20250408104828.499967190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2700,6 +2700,13 @@ static int parse_durable_handle_context(
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
@@ -2733,6 +2740,13 @@ static int parse_durable_handle_context(
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
@@ -2757,6 +2771,13 @@ static int parse_durable_handle_context(
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


