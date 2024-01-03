Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B7F51BDEC;
	Wed,  3 Jan 2024 17:10:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qI7d6VIK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5415C433C7;
	Wed,  3 Jan 2024 17:10:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1704301836;
	bh=mqNyxZNn2od4iVWETaDfW9NPvj7LXrgrtKDp5joFwd0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qI7d6VIKf/ovXPrqCLlO6kf/f1D9jsF5E0RDxgUj3Os2IcVrGl38Rap3JHRC3PmLg
	 YjwfIoP2mgoPzWjJo6l3Usogre1KUvAtqLacS/oS5v9gIt6xFTh5s9kSWIsuLxbC/D
	 wnL+plvmC1XBgqGf/pmtvl5vLEAqWPs+8M/ynryA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fedor Pchelkin <pchelkin@ispras.ru>,
	Simon Horman <horms@kernel.org>,
	Christian Schoenebeck <linux_oss@crudebyte.com>,
	Dominique Martinet <asmadeus@codewreck.org>
Subject: [PATCH 5.10 43/75] net: 9p: avoid freeing uninit memory in p9pdu_vreadf
Date: Wed,  3 Jan 2024 17:55:24 +0100
Message-ID: <20240103164849.653187706@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240103164842.953224409@linuxfoundation.org>
References: <20240103164842.953224409@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fedor Pchelkin <pchelkin@ispras.ru>

commit ff49bf1867578f23a5ffdd38f927f6e1e16796c4 upstream.

If some of p9pdu_readf() calls inside case 'T' in p9pdu_vreadf() fails,
the error path is not handled properly. *wnames or members of *wnames
array may be left uninitialized and invalidly freed.

Initialize *wnames to NULL in beginning of case 'T'. Initialize the first
*wnames array element to NULL and nullify the failing *wnames element so
that the error path freeing loop stops on the first NULL element and
doesn't proceed further.

Found by Linux Verification Center (linuxtesting.org).

Fixes: ace51c4dd2f9 ("9p: add new protocol support code")
Signed-off-by: Fedor Pchelkin <pchelkin@ispras.ru>
Message-ID: <20231206200913.16135-1-pchelkin@ispras.ru>
Cc: stable@vger.kernel.org
Reviewed-by: Simon Horman <horms@kernel.org>
Reviewed-by: Christian Schoenebeck <linux_oss@crudebyte.com>
Signed-off-by: Dominique Martinet <asmadeus@codewreck.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/9p/protocol.c |   17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

--- a/net/9p/protocol.c
+++ b/net/9p/protocol.c
@@ -228,6 +228,8 @@ p9pdu_vreadf(struct p9_fcall *pdu, int p
 				uint16_t *nwname = va_arg(ap, uint16_t *);
 				char ***wnames = va_arg(ap, char ***);
 
+				*wnames = NULL;
+
 				errcode = p9pdu_readf(pdu, proto_version,
 								"w", nwname);
 				if (!errcode) {
@@ -237,6 +239,8 @@ p9pdu_vreadf(struct p9_fcall *pdu, int p
 							  GFP_NOFS);
 					if (!*wnames)
 						errcode = -ENOMEM;
+					else
+						(*wnames)[0] = NULL;
 				}
 
 				if (!errcode) {
@@ -248,8 +252,10 @@ p9pdu_vreadf(struct p9_fcall *pdu, int p
 								proto_version,
 								"s",
 								&(*wnames)[i]);
-						if (errcode)
+						if (errcode) {
+							(*wnames)[i] = NULL;
 							break;
+						}
 					}
 				}
 
@@ -257,11 +263,14 @@ p9pdu_vreadf(struct p9_fcall *pdu, int p
 					if (*wnames) {
 						int i;
 
-						for (i = 0; i < *nwname; i++)
+						for (i = 0; i < *nwname; i++) {
+							if (!(*wnames)[i])
+								break;
 							kfree((*wnames)[i]);
+						}
+						kfree(*wnames);
+						*wnames = NULL;
 					}
-					kfree(*wnames);
-					*wnames = NULL;
 				}
 			}
 			break;


