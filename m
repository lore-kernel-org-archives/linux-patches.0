Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FA33168C5
	for <patches@lists.linux.dev>; Mon,  8 May 2023 10:56:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A29B1C433EF;
	Mon,  8 May 2023 10:56:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683543371;
	bh=T1R8yPmLqP0YAsnOVMPb+K5lsaUi8ZvL2PbH6t7KVuU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mGZ7P3cFlcvxjCkgoRZ8YN5r3INDMPpnE2/MMkHOAkN51NovpMNjbZaEBTKpb32+f
	 pqj0bgOFRNUget43+vA0MRxso0VHK8tNHa9v6RCvkjzBASWHOInffVwM6O9OP77/xU
	 x26Wu3Mgmm588rIyBkb/vWf2gOD3VBnltjh9JT44=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	zdi-disclosures@trendmicro.com
Subject: [PATCH 6.3 068/694] ksmbd: fix NULL pointer dereference in smb2_get_info_filesystem()
Date: Mon,  8 May 2023 11:38:23 +0200
Message-Id: <20230508094434.762421176@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094432.603705160@linuxfoundation.org>
References: <20230508094432.603705160@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Namjae Jeon <linkinjeon@kernel.org>

commit 3ac00a2ab69b34189942afa9e862d5170cdcb018 upstream.

If share is , share->path is NULL and it cause NULL pointer
dereference issue.

Cc: stable@vger.kernel.org
Reported-by: zdi-disclosures@trendmicro.com # ZDI-CAN-20479
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ksmbd/smb2pdu.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/fs/ksmbd/smb2pdu.c
+++ b/fs/ksmbd/smb2pdu.c
@@ -4908,6 +4908,9 @@ static int smb2_get_info_filesystem(stru
 	int rc = 0, len;
 	int fs_infoclass_size = 0;
 
+	if (!share->path)
+		return -EIO;
+
 	rc = kern_path(share->path, LOOKUP_NO_SYMLINKS, &path);
 	if (rc) {
 		pr_err("cannot create vfs path\n");


