Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD5B9A93F
	for <patches@lists.linux.dev>; Tue, 10 Jan 2023 18:14:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12E6CC433EF;
	Tue, 10 Jan 2023 18:14:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673374447;
	bh=7OCf9YBphPRmke3NbGMxeSKXF1zqc0k+Hm3ka1BUirE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=c6C9uCmjpUZyvee6EyrTvIVg72ejuXY7IBRed0D9nBT+KNA6VAhcumq4oK562qs5f
	 17xA760DT38/MBIQ/eU8MdceaASu2WPMKJw7Zxy9DLwbKlgjwCIdmuGdBVv37Ny3jC
	 pJlPb//uRduWqzNMccTbg8eIlpNZ2Vagmlk09XqQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shyam Prasad N <sprasad@microsoft.com>,
	"Paulo Alcantara (SUSE)" <pc@cjr.nz>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.1 004/159] cifs: refcount only the selected iface during interface update
Date: Tue, 10 Jan 2023 19:02:32 +0100
Message-Id: <20230110180018.440453645@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230110180018.288460217@linuxfoundation.org>
References: <20230110180018.288460217@linuxfoundation.org>
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


