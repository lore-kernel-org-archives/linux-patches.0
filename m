Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24E382BEFEF;
	Wed, 30 Sep 2026 16:48:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790786897; cv=none; b=hsI3VrFePbVhzwKu21EIYexlXfdZtl1QCM5nEC/2TL2INvcDdgYnZ1jPfvw6wzKoeexSFYVI6k9qXh9JKiNQIo3bvHeS7j63AhY7ZKnLmfHhEArZZ5C5IcNbpQgd+esJXpPdnA2PwVViB9MFEjHcMSYXuYXJNcszbngbRQkA9r4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790786897; c=relaxed/simple;
	bh=4tx4HpQim5iM8uu5lKYD3knv90TtA1jIFuKqKenCpFE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q72ADxBF0wCidS57aWkzqoAwsfUGjqV94lfOdD99aSEAeb08D4TjFCjTmUB3UwiLiOy3F3LytjFTTW2YbDZzCGLH2DYZE4YiHbg3DzxBhP6I8YBtvNL8F+t7u/bOskMh6JqRg5Zg6PN35LO5ohWL78UcTrYNbDlGTS96dx9SfmQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jlUHrM45; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jlUHrM45"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FFA61F000FF;
	Wed, 30 Sep 2026 16:48:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790786896;
	bh=K8FOfyWlmtmvDhPOithSVp6T45h91asTdvghOtoy7s8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jlUHrM45tk1F47xgrTrGrBAV8a7RDsTRqNzV3mt4qxnQ2CRuVoWsJtnsMY1LnAMes
	 sG+jqNH8KIqA5zs+06pP93UVffaTWcXIZ1gUN6hWVKtBJLPaUE2wrnj2aRTm8uU4Cr
	 gnjyND70yHyJzl0RsrL3p9q2qgTJkw94ceVsCk8M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Claudio Imbrenda <imbrenda@linux.ibm.com>,
	Christoph Schlameuss <schlameuss@linux.ibm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 013/457] s390/uv: Fix loop condition in uv_find_secrets
Date: Wed, 30 Sep 2026 17:21:58 +0200
Message-ID: <20260930152346.318527435@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152346.024115587@linuxfoundation.org>
References: <20260930152346.024115587@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Steffen Eiden <seiden@linux.ibm.com>

[ Upstream commit d12ce6bce5ec5175c3581e01c71e7a5abb286d9b ]

Systems with more than 85 UV secrets got -ENOENT for any secret past the
first page.

Fix this by setting the start index at the beginning of the loop in
uv_find_secret() and not at the end. First test if there are more
secrets left by comparing start_idx with list->next_secret_idx, and then
set the start index to the next secret index.

Fixes: 7c9137af2042 ("s390/uv: Retrieve UV secrets support")
Acked-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Reviewed-by: Christoph Schlameuss <schlameuss@linux.ibm.com>
Signed-off-by: Steffen Eiden <seiden@linux.ibm.com>
Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Message-ID: <20260812-uv_secrets_fix-v3-1-a85bd29e0666@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/kernel/uv.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/s390/kernel/uv.c b/arch/s390/kernel/uv.c
index a284f98d97168..d970b15ef126d 100644
--- a/arch/s390/kernel/uv.c
+++ b/arch/s390/kernel/uv.c
@@ -781,11 +781,14 @@ int uv_find_secret(const u8 secret_id[UV_SECRET_ID_LEN],
 		   struct uv_secret_list *list,
 		   struct uv_secret_list_item_hdr *secret)
 {
-	u16 start_idx = 0;
+	u16 start_idx;
 	u16 list_rc;
 	int ret;
 
+	list->next_secret_idx = 0;
+
 	do {
+		start_idx = list->next_secret_idx;
 		uv_list_secrets(list, start_idx, &list_rc, NULL);
 		if (list_rc != UVC_RC_EXECUTED && list_rc != UVC_RC_MORE_DATA) {
 			if (list_rc == UVC_RC_INV_CMD)
@@ -796,7 +799,6 @@ int uv_find_secret(const u8 secret_id[UV_SECRET_ID_LEN],
 		ret = find_secret_in_page(secret_id, list, secret);
 		if (ret == 0)
 			return ret;
-		start_idx = list->next_secret_idx;
 	} while (list_rc == UVC_RC_MORE_DATA && start_idx < list->next_secret_idx);
 
 	return -ENOENT;
-- 
2.53.0



