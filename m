Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42C93288537;
	Thu, 27 Nov 2025 14:51:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764255064; cv=none; b=UEpeueahal5IejOOaSnk42MvMDYyKJhoeADcqZVWmSxs19qlAKOMGjPmaIgXX/GwTkoegrnmOYyJdQLtC9z+H/X4GtRJAEeTiVK1kbCDaAL1x/7BH2osolwakOwsOCvl0U+JGAMA+oYu2GS1zlzzlGLm6LMRdbiRMT4iA3tFyrk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764255064; c=relaxed/simple;
	bh=+uJ3NQUTPznJDqta9QRbhBUWAqaeBo73S19l1ESJcF0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TOkWZZ+WQKBkImBOWo341lHz/VqHcquD4uazjrr0FLT+ucuVHS1I6rQhPmbllkl68JX+LfEzCagCNvru43IMnL4bELFYN93qF1TuNv9UFPAOpGkCWUHY5ZZa0R5gdC6FqmV+pM25KOY0CO6SOKGdjlseuWd2miDKKrYj9rkCEeQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nNVUb7gs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nNVUb7gs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BE8AC4CEF8;
	Thu, 27 Nov 2025 14:51:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764255063;
	bh=+uJ3NQUTPznJDqta9QRbhBUWAqaeBo73S19l1ESJcF0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nNVUb7gsVfJl3KB48RZYuoRdtx4bS/xm1sugwYI7BKFxmoCFMUaZRDb6WiOUfjX/r
	 7jBR0c254ql3uuU8YBweIcyo2j3GbrCG2ZO3Jw86hFbgMJ+2zqPgCuzMFx3rGeOYzH
	 YV6ybXH4YYw7dmkQv2zNfG46wUWhUTXdpHUzmxL0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miaoqian Lin <linmq006@gmail.com>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 81/86] pmdomain: imx: Fix reference count leak in imx_gpc_remove
Date: Thu, 27 Nov 2025 15:46:37 +0100
Message-ID: <20251127144030.794997886@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251127144027.800761504@linuxfoundation.org>
References: <20251127144027.800761504@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pmdomain/imx/gpc.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/pmdomain/imx/gpc.c
+++ b/drivers/pmdomain/imx/gpc.c
@@ -546,6 +546,8 @@ static void imx_gpc_remove(struct platfo
 			return;
 		}
 	}
+
+	of_node_put(pgc_node);
 }
 
 static struct platform_driver imx_gpc_driver = {


