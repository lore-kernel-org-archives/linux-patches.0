Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90360339B3C;
	Fri, 21 Nov 2025 13:33:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763731994; cv=none; b=W/X8KDWCpjpyXhYTxaYd2vzy2a8NBtedweNLy2tjWXtinwoPF/P21H2XFY+1JOC09lSE8o3shMEN8RXDV/YKBaTQsPFUFX7a8Qnn148bAHT7xnaC9cjEac3V9B4TxaKoJuW5Kxg0NNqyU7WbRuMqAsv3s3dLzssDGh7xeXL+rFM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763731994; c=relaxed/simple;
	bh=aWB4aE7a+42vREeaTq1zzefnYbM8blMqpcbl82HRhdo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Fptm6SaQhhKD0a0Bd1jdlDucXH6LMZtG5P0otxQD64ok4Ia3WvGsQQIMM34w7b3QxgtibnUiL7IinB91A5ECEQKNaXq9DTW1dOIzIQdO/YnYgEtDuz2fJK1Aqm1ao+SwdmNzCzLjt8fyr/VcEngVKXmYrPWfDaz1XYsr0tzyYXc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=biJIYw1P; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="biJIYw1P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48FF8C4CEF1;
	Fri, 21 Nov 2025 13:33:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763731993;
	bh=aWB4aE7a+42vREeaTq1zzefnYbM8blMqpcbl82HRhdo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=biJIYw1Pqth7c2+v5qthZk5xmgYWU0HkU035xe0Ar/vJsq2oiY+EWItzm297JwYuB
	 Y/GqW1AKucIkSM9WaTOAfbEdrxGxaln13H+yIVR7GPA/N2Vod3DrVrSDw07cV/ng/E
	 mjvGAAualEZ/DBy2pOmtMPRzYUbQ5r90tf1YnA14=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miaoqian Lin <linmq006@gmail.com>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 6.12 151/185] pmdomain: imx: Fix reference count leak in imx_gpc_remove
Date: Fri, 21 Nov 2025 14:12:58 +0100
Message-ID: <20251121130149.327486151@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130143.857798067@linuxfoundation.org>
References: <20251121130143.857798067@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Miaoqian Lin <linmq006@gmail.com>

commit bbde14682eba21d86f5f3d6fe2d371b1f97f1e61 upstream.

of_get_child_by_name() returns a node pointer with refcount incremented, we
should use of_node_put() on it when not needed anymore. Add the missing
of_node_put() to avoid refcount leak.

Fixes: 721cabf6c660 ("soc: imx: move PGC handling to a new GPC driver")
Cc: stable@vger.kernel.org
Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pmdomain/imx/gpc.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/pmdomain/imx/gpc.c
+++ b/drivers/pmdomain/imx/gpc.c
@@ -537,6 +537,8 @@ static void imx_gpc_remove(struct platfo
 			return;
 		}
 	}
+
+	of_node_put(pgc_node);
 }
 
 static struct platform_driver imx_gpc_driver = {


