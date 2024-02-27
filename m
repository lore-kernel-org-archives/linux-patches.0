Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FF7E13B295;
	Tue, 27 Feb 2024 13:56:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709042174; cv=none; b=Mkp/WSn3/0BQmkuIaAxeFwDYlQOrEk+6HDb8Yhz2lj+bbH4T2bcWbsjIUrp3lH0xFWs4jD3PTSAAQZV10R7c7sXC1zWeFEjhqs6dWG74eJCXaNULLa8kpMgLq1xhXS4oycbRl06NTy62OQKh3gj11ZPoe6SXPQwPj8UBXwG1CaE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709042174; c=relaxed/simple;
	bh=nvf1nPv0uMi7Eq3liR9NMyuQFq7soEhQc8YrpQ6F+lY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D60DP+PvFmC0ys7P+Q7t4wjjh2WYAMKVVWwCu8n1liJLMALyjuISTDmUkf1vX8NIft020DiCMVUnMfk2NdvWaqljr0xgNArSAEuiI7ku6POdOIBRMRkbmolRCQAPsPcxlWD1edL9gYQWL+5g4uHdXQU1T4brv1mjVa0qJALOeA0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Se+cpdaM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Se+cpdaM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B329BC433F1;
	Tue, 27 Feb 2024 13:56:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709042174;
	bh=nvf1nPv0uMi7Eq3liR9NMyuQFq7soEhQc8YrpQ6F+lY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Se+cpdaMhYcVY20dC30Vr9EFyUOalGdcGBcMXlpERQAiU1g/nSPTUmlO7SKJU0iS8
	 5wkaErr+7O8dt5pU7Xc/HrmSm1G5h1CiBdof39JSogLnn+PvC3xLNHIdLTbUf6/dn0
	 4glJxN3RW2zLY4jGK6svruUK2JNGqdfrsr5j46Ec=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Shyam Prasad N <sprasad@microsoft.com>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.6 205/299] smb3: add missing null server pointer check
Date: Tue, 27 Feb 2024 14:25:16 +0100
Message-ID: <20240227131632.400186504@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131625.847743063@linuxfoundation.org>
References: <20240227131625.847743063@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Steve French <stfrench@microsoft.com>

commit 45be0882c5f91e1b92e645001dd1a53b3bd58c97 upstream.

Address static checker warning in cifs_ses_get_chan_index():
    warn: variable dereferenced before check 'server'
To be consistent, and reduce risk, we should add another check
for null server pointer.

Fixes: 88675b22d34e ("cifs: do not search for channel if server is terminating")
Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
Reviewed-by: Shyam Prasad N <sprasad@microsoft.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/sess.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/smb/client/sess.c
+++ b/fs/smb/client/sess.c
@@ -76,7 +76,7 @@ cifs_ses_get_chan_index(struct cifs_ses
 	unsigned int i;
 
 	/* if the channel is waiting for termination */
-	if (server->terminate)
+	if (server && server->terminate)
 		return CIFS_INVAL_CHAN_INDEX;
 
 	for (i = 0; i < ses->chan_count; i++) {


