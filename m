Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 209994E7802;
	Wed, 30 Sep 2026 16:54:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790787270; cv=none; b=gSOoPnFCDsljnxcrcauzRndGi5ebX3U16hA2wmJy9PqR4QEKUC+jjSLncEcMrzX6Bmj4v8fdCgsyrGggfCMePwBe5Fjd7GJE9bc+72rgE33/JUFAiFVEiEuJAqz7sMIwQCs5UmNI0GzlBD7If57nAtQEQoXMGfZNdTo6tBmwpSY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790787270; c=relaxed/simple;
	bh=I9ArkRmpkb+G9agWAsmYNVe8gfWv7Qf6qomjph54Y0U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E1sN8RS6/dIitW+SXrzeQeOxhZ43IraJmCjBf5mgoAq2f31B/UdULVIE0DEctnh5dpXTHnQjpsqin0WLOCj/VxNPZ2gMCfH5iJEvVCw7SiV7lgnbSTGtxMdTVTCSYGL15Tw5PO5MnrFa+KJ0CN/ieC9tIIdmC6onp0IFimHvb80=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aCNdUslt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aCNdUslt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 316391F000FF;
	Wed, 30 Sep 2026 16:54:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790787268;
	bh=uAZ3EI5lHrzseQTXV01Cl8FoOwPWEi/gpqDBgiuD+B0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aCNdUslt6IIMMEwbzkA3SuJ8iMNZtOL9Toer57lYcw0HSa5zGfxzgTH2ogT3F83RI
	 10wrNzeB9fjksHmSNFyOMP3RUX7ZcSofUdHWK+GYY6CZwxqq675ivROnc2OccUQVap
	 TiFcZJ+l2E9Fr8DaTvY6hrUcAFQ+WnKDzmX+P1BQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chaithanya Lagisetty <nagachaithanya9911@gmail.com>,
	Hangbin Liu <liuhangbin@kylinos.cn>,
	David Heidelberg <david@ixit.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 172/457] selftests: nci: Fix uninitialized family ID on missing attribute
Date: Wed, 30 Sep 2026 17:24:37 +0200
Message-ID: <20260930152349.764571429@linuxfoundation.org>
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

From: Chaithanya Lagisetty <nagachaithanya9911@gmail.com>

[ Upstream commit eda518d2cdb6074a0bcdfa06af291616bcb5c421 ]

get_family_id() walks the generic netlink CTRL_CMD_GETFAMILY reply
looking for the CTRL_ATTR_FAMILY_ID attribute and returns the parsed
value in the local variable "id". If the reply does not carry that
attribute, the parsing loop never assigns "id" and the function returns
an indeterminate stack value, which the caller stores in self->fid and
uses for subsequent netlink requests.

Initialize "id" to 0 so a missing attribute yields a deterministic
(invalid) family ID instead of a garbage value.

Fixes: f595cf1242f3 ("selftests: Add nci suite")
Signed-off-by: Chaithanya Lagisetty <nagachaithanya9911@gmail.com>
Reviewed-by: Hangbin Liu <liuhangbin@kylinos.cn>
Link: https://patch.msgid.link/20260901070618.3299012-1-nagachaithanya9911@gmail.com
Signed-off-by: David Heidelberg <david@ixit.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/nci/nci_dev.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/nci/nci_dev.c b/tools/testing/selftests/nci/nci_dev.c
index c053f5cf2745d..23fd38acfcf42 100644
--- a/tools/testing/selftests/nci/nci_dev.c
+++ b/tools/testing/selftests/nci/nci_dev.c
@@ -182,7 +182,7 @@ static int get_family_id(int sd, __u32 pid, __u32 *event_group)
 	} ans;
 	struct nlattr *na;
 	int resp_len;
-	__u16 id;
+	__u16 id = 0;
 	int len;
 	int rc;
 
-- 
2.53.0



