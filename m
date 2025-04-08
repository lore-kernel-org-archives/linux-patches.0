Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C32E626E16B;
	Tue,  8 Apr 2025 12:31:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744115509; cv=none; b=o+3WNHqPTEfH1/NMXsVVaqqf7QDFvnDEpG+gQ6xkv0UU8F0r4iBscWtoFEQCmSFdlu+KHhJraheCNwJeAUusXlSg44z8giz6iz/RWNtlyu6up1db6YCuHF2s9orKI94WHkW49smbnEyAvpBFJAZuThmV1lZjfo7QmyiughnzzvI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744115509; c=relaxed/simple;
	bh=rp+J/JkaeYH/p/bYOY4p23Grz0T7P3QGeI1253lizsA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qj+5NbEf/PlYiddndUsilW6UidXiV2o4ZPuZRwexmqw1GfwHai0ZAlrTSj2jJXK2wzlt+F20qf0OfNLyUtDpv49hbv/g6bBrtb1eV0Act1ey01hsuJlzNnygGhOeTnLxnaicIOYAeHPJvKuluhVyiMgfL1oGu12W6F7nDI+aZck=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CWuE/wlA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CWuE/wlA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCE27C4CEE5;
	Tue,  8 Apr 2025 12:31:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744115509;
	bh=rp+J/JkaeYH/p/bYOY4p23Grz0T7P3QGeI1253lizsA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CWuE/wlAN+JVCXOieQGcrANUIT7O7Rv++3p2LP+Qi/IG+w20Gv4oVZ22JMqi3Pu6e
	 n7bqvUY4rp+6rcT1P92iJusLrJQB80pVyccMsy8ugs0iM//nso4sWxl1OSucSXK5o0
	 xe3V8qFpN3pJwhgG5YjAVvMCToXMlici/iJJlP3E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Norbert Szetei <norbert@doyensec.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.13 466/499] ksmbd: add bounds check for durable handle context
Date: Tue,  8 Apr 2025 12:51:18 +0200
Message-ID: <20250408104902.862421359@linuxfoundation.org>
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
@@ -2703,6 +2703,13 @@ static int parse_durable_handle_context(
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
@@ -2736,6 +2743,13 @@ static int parse_durable_handle_context(
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
@@ -2760,6 +2774,13 @@ static int parse_durable_handle_context(
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


