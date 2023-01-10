Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88C8A6FBB
	for <patches@lists.linux.dev>; Tue, 10 Jan 2023 18:06:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DE94C433D2;
	Tue, 10 Jan 2023 18:06:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673374012;
	bh=7OCf9YBphPRmke3NbGMxeSKXF1zqc0k+Hm3ka1BUirE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zDFGfkIrGvGb6yYHpI0pAemdtxPyAfUuZbS4nJPzq1bQgtJAPbGGKmTERVBjHrnrk
	 Cy+aZwdauVitVcKBlOmKJ4uS3l5ZOaGVJnhwkfsK5MnZdZJT+CVqj2hYO+Zc3cITfk
	 Lnned61AFa/t9gwK0ejI6Nb4CqYec+g8jUVLQ2SE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shyam Prasad N <sprasad@microsoft.com>,
	"Paulo Alcantara (SUSE)" <pc@cjr.nz>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.0 004/148] cifs: refcount only the selected iface during interface update
Date: Tue, 10 Jan 2023 19:01:48 +0100
Message-Id: <20230110180017.306589539@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230110180017.145591678@linuxfoundation.org>
References: <20230110180017.145591678@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Shyam Prasad N <sprasad@microsoft.com>

commit 7246210ecdd0cda97fa3e3bb15c32c6c2d9a23b5 upstream.

When the server interface for a channel is not active anymore,
we have the logic to select an alternative interface. However
this was not breaking out of the loop as soon as a new alternative
was found. As a result, some interfaces may get refcounted unintentionally.

There was also a bug in checking if we found an alternate iface.
Fixed that too.

Fixes: b54034a73baf ("cifs: during reconnect, update interface if necessary")
Cc: stable@vger.kernel.org # 5.19+
Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
Reviewed-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/cifs/sess.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/fs/cifs/sess.c
+++ b/fs/cifs/sess.c
@@ -292,9 +292,10 @@ cifs_chan_update_iface(struct cifs_ses *
 			continue;
 		}
 		kref_get(&iface->refcount);
+		break;
 	}
 
-	if (!list_entry_is_head(iface, &ses->iface_list, iface_head)) {
+	if (list_entry_is_head(iface, &ses->iface_list, iface_head)) {
 		rc = 1;
 		iface = NULL;
 		cifs_dbg(FYI, "unable to find a suitable iface\n");


