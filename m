Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 049781BDFB;
	Wed,  3 Jan 2024 17:11:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eBSWZvDf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AF30C433C7;
	Wed,  3 Jan 2024 17:11:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1704301882;
	bh=b8VmRi5TJ4cWpUKUr1xZoBU5HtYlVgHQN5uhUtG3dCs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eBSWZvDfk3McnlVmx8O/1H+paenvEJKCa5t1CyX7JvoBYftWicVQzoI814WzSFjyQ
	 ai2P4PWZTebnpiocvph5jrlO+u3YxfzQKkTNVf3caYMAsbvOV1chBaki+RKK+jE/Yl
	 MBPgR1icAd1+nSpAUrAM/AUOy8os0rHJDmaUprKQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mike Tipton <quic_mdtipton@quicinc.com>,
	Georgi Djakov <djakov@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 27/75] interconnect: Treat xlate() returning NULL node as an error
Date: Wed,  3 Jan 2024 17:55:08 +0100
Message-ID: <20240103164847.273313681@linuxfoundation.org>
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
index 7db6d0fc6ec2e..9390e22106631 100644
--- a/drivers/interconnect/core.c
+++ b/drivers/interconnect/core.c
@@ -380,6 +380,9 @@ struct icc_node_data *of_icc_get_from_provider(struct of_phandle_args *spec)
 	}
 	mutex_unlock(&icc_lock);
 
+	if (!node)
+		return ERR_PTR(-EINVAL);
+
 	if (IS_ERR(node))
 		return ERR_CAST(node);
 
-- 
2.43.0



