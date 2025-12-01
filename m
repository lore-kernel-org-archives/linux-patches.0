Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 862BB258EFB;
	Mon,  1 Dec 2025 11:33:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764588808; cv=none; b=htq5Cx59dLoUAE1w2JQjdCXVk+ho4s9//XUVh0R0gBgwpE4/EqzL9ofAOR8ZqQyiaEQB0v+TwwBwAqkCp/HDMkSR48p4evBxQ3u/mMgNySy307ULf+tgPCuI3rxmeMxytRb7xMNqfZ1DSSoYQ5zr7+Nv5eHQaZkjZrK2Bva+Dow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764588808; c=relaxed/simple;
	bh=P29kUKX/gURmwt7qgVyPgnikAmNrP1c/RFlckkcsqfo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a0mgTJrn/mary9iGgY+E9jb4lTMkmQHOJosul/Gd9kXCD45g5PT8pVJXsRAdf72hoNC+Wt3YxL6u8+HN4VxlzIZmHpfK/IVJ6ttnCMDDUQd59n9udHWJ3DVyqEf6w8LDTBIzMHpGtkDpt8mNSjexUFSBvpYJLO2rfhfpY6ChpuU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lRki2UKf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lRki2UKf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09152C116D0;
	Mon,  1 Dec 2025 11:33:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764588808;
	bh=P29kUKX/gURmwt7qgVyPgnikAmNrP1c/RFlckkcsqfo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lRki2UKfteEfO4t2ob11ECQaEwNvn0iYeDmtHIh3SN+xsI7MTmbH7hHzpd3Adzbr1
	 J3BdxEDnS4nKCxckssXTu39+Qmv5BsL9/LYvojBPpTXiBojRtuYzcDUnXsJ2NZ7fu9
	 Q0oEfpIg4ar+3b0f+lWUS6iN5UiWPlpEXGlfrnrs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miaoqian Lin <linmq006@gmail.com>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 178/187] pmdomain: imx: Fix reference count leak in imx_gpc_remove
Date: Mon,  1 Dec 2025 12:24:46 +0100
Message-ID: <20251201112247.639961908@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251201112241.242614045@linuxfoundation.org>
References: <20251201112241.242614045@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
 


