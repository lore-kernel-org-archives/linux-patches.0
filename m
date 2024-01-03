Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C16631C289;
	Wed,  3 Jan 2024 17:04:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PB1AQpzt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDEF6C433C8;
	Wed,  3 Jan 2024 17:04:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1704301445;
	bh=deShfhui+8mNbKNbEA1zgk0drPGubqM5EAmW6/v0XO4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PB1AQpzt6QmFpTqC4mj8agdgFQTCpRI4POD+gwuA5LB0/JSr6Ulg1oDzok2DUa4nr
	 WDMbu0cxgsfTud9pc+TChjvFJIBjAuRgtLlG+vNj2PIqaPxMyrEA+k6VyHgXefMY4w
	 rKi873kG/TZDjg3EP6bicd9h0BjwD8mmQKTf4nEU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mike Tipton <quic_mdtipton@quicinc.com>,
	Georgi Djakov <djakov@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 35/95] interconnect: Treat xlate() returning NULL node as an error
Date: Wed,  3 Jan 2024 17:54:43 +0100
Message-ID: <20240103164859.342838418@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240103164853.921194838@linuxfoundation.org>
References: <20240103164853.921194838@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index b7c41bd7409cd..aadb2b97498a0 100644
--- a/drivers/interconnect/core.c
+++ b/drivers/interconnect/core.c
@@ -382,6 +382,9 @@ struct icc_node_data *of_icc_get_from_provider(struct of_phandle_args *spec)
 	}
 	mutex_unlock(&icc_lock);
 
+	if (!node)
+		return ERR_PTR(-EINVAL);
+
 	if (IS_ERR(node))
 		return ERR_CAST(node);
 
-- 
2.43.0



