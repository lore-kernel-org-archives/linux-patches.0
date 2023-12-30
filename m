Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C9E879DD;
	Sat, 30 Dec 2023 12:10:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="InAnZvZH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9BCAC433C8;
	Sat, 30 Dec 2023 12:10:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1703938233;
	bh=uvHZUWuXCE1ibtpvuOLlN+a3oFsmfL3JmkWwgfwxnGc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=InAnZvZH8Wr56H9+X2ZSjeNHEdDa49tBfqLMXbEpYQ47LDjzwiuMo+sD9yNIqHjXe
	 jmaT/0gEZarlwbf+Jc3H33aYid2ONBCotZ6vcKhdetSIri/h5XFdfn0JPJ794UMwnj
	 2rwaBunglcC+Gs4OTHNdgnlUg2P2Fo8Kljxdk0E0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mike Tipton <quic_mdtipton@quicinc.com>,
	Georgi Djakov <djakov@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 054/112] interconnect: Treat xlate() returning NULL node as an error
Date: Sat, 30 Dec 2023 11:59:27 +0000
Message-ID: <20231230115808.438480211@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231230115806.714618407@linuxfoundation.org>
References: <20231230115806.714618407@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mike Tipton <quic_mdtipton@quicinc.com>

[ Upstream commit ad2ab1297d0c80899125a842bb7a078abfe1e6ce ]

Currently, if provider->xlate() or provider->xlate_extended()
"successfully" return a NULL node, then of_icc_get_from_provider() won't
consider that an error and will successfully return the NULL node. This
bypasses error handling in of_icc_get_by_index() and leads to NULL
dereferences in path_find().

This could be avoided by ensuring provider callbacks always return an
error for NULL nodes, but it's better to explicitly protect against this
in the common framework.

Fixes: 87e3031b6fbd ("interconnect: Allow endpoints translation via DT")
Signed-off-by: Mike Tipton <quic_mdtipton@quicinc.com>
Link: https://lore.kernel.org/r/20231025145829.11603-1-quic_mdtipton@quicinc.com
Signed-off-by: Georgi Djakov <djakov@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/interconnect/core.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/interconnect/core.c b/drivers/interconnect/core.c
index 0c6fc954e7296..1d9494f64a215 100644
--- a/drivers/interconnect/core.c
+++ b/drivers/interconnect/core.c
@@ -381,6 +381,9 @@ struct icc_node_data *of_icc_get_from_provider(struct of_phandle_args *spec)
 	}
 	mutex_unlock(&icc_lock);
 
+	if (!node)
+		return ERR_PTR(-EINVAL);
+
 	if (IS_ERR(node))
 		return ERR_CAST(node);
 
-- 
2.43.0



