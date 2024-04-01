Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C662E4C61B;
	Mon,  1 Apr 2024 16:45:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711989940; cv=none; b=ACiFW7hpfVTRcnyO3jknopgZIhSpzYuLBC0jEycAk0yYu/iUJ8NuTedCz6GbzfzvC9lDE+cWp+PIDCDjN6BdOx32VZ9xhkiyPUFy3I2gVKiAFB6UmpHU20E94AKQ/Ax4uwiC5UzSgL5IVf7yxUCNIn4lG5qC+VikBCDKT1RvTYw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711989940; c=relaxed/simple;
	bh=FmXZqL+U0Rz5ukCQ8auYWcWRT/QtctcdL6pJ8j7CSaQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BggYMicP9dHjB6NcutWi37s07lZz7FpIycls3Egssa3MFcokW49GKBjyLTSijjaU8builDTJQivN7rMZhg8fIBIvWuEQqzN8jG4Mr5I6N3ass3syHHFjduyYdM/3wkD8cDaxdytLs4EFAkKOrZlFl/IHV9JAvHjasvFt+1zmxWI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xSE2ZttR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xSE2ZttR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30598C43399;
	Mon,  1 Apr 2024 16:45:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711989940;
	bh=FmXZqL+U0Rz5ukCQ8auYWcWRT/QtctcdL6pJ8j7CSaQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xSE2ZttRwWdZoG3Nxx8nV0DjPwmWxrfrsghH26gjkcgH7kcutNXf1g13ey8efaGtY
	 LJoklpXdsSyeLuyUHX6d8p9QOzLAccn+d/gBQ/a92ZSu7lloA9rZ5guOc6BwPgoOrc
	 GeI6/6EfuwjHcD5XT6gXLaESC08rO4+aZUvZOcsU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	lonial con <kongln9170@gmail.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 6.6 198/396] netfilter: nf_tables: disallow anonymous set with timeout flag
Date: Mon,  1 Apr 2024 17:44:07 +0200
Message-ID: <20240401152553.837726407@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152547.867452742@linuxfoundation.org>
References: <20240401152547.867452742@linuxfoundation.org>
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

From: Pablo Neira Ayuso <pablo@netfilter.org>

commit 16603605b667b70da974bea8216c93e7db043bf1 upstream.

Anonymous sets are never used with timeout from userspace, reject this.
Exception to this rule is NFT_SET_EVAL to ensure legacy meters still work.

Cc: stable@vger.kernel.org
Fixes: 761da2935d6e ("netfilter: nf_tables: add set timeout API support")
Reported-by: lonial con <kongln9170@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/netfilter/nf_tables_api.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -4942,6 +4942,9 @@ static int nf_tables_newset(struct sk_bu
 		if ((flags & (NFT_SET_EVAL | NFT_SET_OBJECT)) ==
 			     (NFT_SET_EVAL | NFT_SET_OBJECT))
 			return -EOPNOTSUPP;
+		if ((flags & (NFT_SET_ANONYMOUS | NFT_SET_TIMEOUT | NFT_SET_EVAL)) ==
+			     (NFT_SET_ANONYMOUS | NFT_SET_TIMEOUT))
+			return -EOPNOTSUPP;
 	}
 
 	desc.dtype = 0;


