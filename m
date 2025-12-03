Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0524B313532;
	Wed,  3 Dec 2025 15:45:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764776748; cv=none; b=A5OflZPIKj7NI91KDgREoETGbIPb56RsaxNlAQtTcNzZIYhhAtnYd411XrcYJlUeF8x5jCG6VIHc8JsURbiaCK1pb3+GfhBkkrmYXnzOJv2NYEw1tD+nO93z4mPu1FANUqY+7Sf7iG5yKITNYaimV5aOXqGL3udw6PQClfuOc5E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764776748; c=relaxed/simple;
	bh=PpTKXnM6IkTJVH6xxOwm4tz6jxRZYorTILUJF39kr9o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W2FbDjWfawYnt14upKdIb63nPyzK6SpLJWcs5cD8gKTWXL03TCj9vdguCVCALlCCs2GbJh5ovEIJQZaDBkV8vJvH4elscn7gVy868XjnVO7Ccm4HUEjhBvYf2yMuxa/CCTHul57/IThXSAND49SimxeGYt+LZZPl596uPdeITjs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eIB5ClkL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eIB5ClkL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 753C0C4CEF5;
	Wed,  3 Dec 2025 15:45:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764776747;
	bh=PpTKXnM6IkTJVH6xxOwm4tz6jxRZYorTILUJF39kr9o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eIB5ClkLCsifZ82HukuChyHFcNFqbAE0KgAMRKfe8qBGaky8oatNedE/e7VxG+PY0
	 98TI7UrGT9fT6f2GbTYlVq1cPANMpifosxKT8JV52SSrog3GK+mLM123WqgYXX1vpR
	 oIB5ggC94AyNY2ogXMGs/CZqRpqn8CCn3d4PNLj8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miaoqian Lin <linmq006@gmail.com>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 243/300] pmdomain: imx: Fix reference count leak in imx_gpc_remove
Date: Wed,  3 Dec 2025 16:27:27 +0100
Message-ID: <20251203152409.628913156@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152400.447697997@linuxfoundation.org>
References: <20251203152400.447697997@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Miaoqian Lin <linmq006@gmail.com>

[ Upstream commit bbde14682eba21d86f5f3d6fe2d371b1f97f1e61 ]

of_get_child_by_name() returns a node pointer with refcount incremented, we
should use of_node_put() on it when not needed anymore. Add the missing
of_node_put() to avoid refcount leak.

Fixes: 721cabf6c660 ("soc: imx: move PGC handling to a new GPC driver")
Cc: stable@vger.kernel.org
Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
[ drivers/pmdomain/imx/gpc.c -> drivers/soc/imx/gpc.c ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/soc/imx/gpc.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/soc/imx/gpc.c
+++ b/drivers/soc/imx/gpc.c
@@ -540,6 +540,8 @@ static int imx_gpc_remove(struct platfor
 			return ret;
 	}
 
+	of_node_put(pgc_node);
+
 	return 0;
 }
 


