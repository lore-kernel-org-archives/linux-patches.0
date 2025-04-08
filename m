Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B671A26561C;
	Tue,  8 Apr 2025 11:36:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744112160; cv=none; b=J4+UkqC2SlkxNgT3BHDlzMZQ08N2zRnTKWrN/f7qzbVhVkRKzrCNtv8S0RErCZjgBwwoiVo0fnzFyelSxT1YxtZidj6tOxzocNd2b4sclxgXAS0y4e69/55Ao7SnO48UHNVM6eR0LipATGKwExdMOj3F0vrY4fIT3UgcEsGedXY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744112160; c=relaxed/simple;
	bh=gSm8hnzAmMWnrvBzQZeZs60khRSYt6GNyS5GrDubMt0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rddA9CeZ6BUk8gjyvbH9rctJgrWSlU6oEtAavrUYGUeho6UCp/jL1mcW0yRgZh7JZgq6GSWQbyYpsryaM5eEd6ySiujE0xJjYUkIi05UcO3VTDxWa8WFN3NrINr7MRZVfhJI6z0xf7cWLdWmnN49nDpJtu4Sk7ziX8QyUZNadrM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ja1AeBkp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ja1AeBkp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43824C4CEE5;
	Tue,  8 Apr 2025 11:36:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744112160;
	bh=gSm8hnzAmMWnrvBzQZeZs60khRSYt6GNyS5GrDubMt0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ja1AeBkp4RCp6poMHINPJYq6r6P/5/ODJISEgui/UYwSpYqiaEEssYrY2Iip1654Q
	 b0toxphbJnbzWapjZIhnmOdXzvJ1x7B+tjj2xPGSj6Iab0FjRpfBuiDGxqSsonfIpZ
	 TFATieli0316zGuICkFMgjm6/Emkjb57XMLY2Rd8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Norbert Szetei <norbert@doyensec.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.14 698/731] ksmbd: add bounds check for durable handle context
Date: Tue,  8 Apr 2025 12:49:55 +0200
Message-ID: <20250408104930.504219853@linuxfoundation.org>
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
@@ -2704,6 +2704,13 @@ static int parse_durable_handle_context(
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
@@ -2737,6 +2744,13 @@ static int parse_durable_handle_context(
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
@@ -2761,6 +2775,13 @@ static int parse_durable_handle_context(
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


