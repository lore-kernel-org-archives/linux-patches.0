Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA6BA346FB9;
	Wed,  3 Dec 2025 16:43:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764780219; cv=none; b=L5yknk5dl6bt+FA65JDY8d8CDeL2xlCkgusaBHLZic2daR0dwU4hExEQDMYVNn6P5aXcimMp/q4pMiFnP0KrnELIWHoovFMlx79TBxjjFCYi4s8rKmI6+lw+cqOrSlDd9Yb/lW02xaj6bw3Zw6FiBaa3lvlfDpc/H+bcpV8r4Fk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764780219; c=relaxed/simple;
	bh=hTHX8kqGfFZHYmo75PkRoD5z5LtwKJWpY6JAs+RqgME=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bprLTJMTAgS6npStqdGICFA3bGr3OlwVnyosUIZzVDgdWD1yTbGIDgP3sMFhLT85Xn//LA4vaFRGKwJa4f8qtS60W01H1D6BVB/yYfUYTMWcurlJkOGeQTJbBXkklrXxipVf448lbn8dNmqtxTpkazP5dikZ8XbeTb009RVZVYI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0SKFgv7I; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0SKFgv7I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 001FEC4CEF5;
	Wed,  3 Dec 2025 16:43:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764780219;
	bh=hTHX8kqGfFZHYmo75PkRoD5z5LtwKJWpY6JAs+RqgME=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0SKFgv7IEA2pzdTXyYERVa9GrwxQKMrLR62neQq33vVJQHgb6KEXbgPBTn+gwVBF3
	 +/37wupT1SlmjL/eZkbV30N5hD5QXHlzB/XotsSSc+STTrc/DRsGRERXHRb3XgpTjd
	 24L20E8FO9/CmEJoRbzVb7nRV72jtD3FVUpL/54M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miaoqian Lin <linmq006@gmail.com>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 490/568] pmdomain: imx: Fix reference count leak in imx_gpc_remove
Date: Wed,  3 Dec 2025 16:28:12 +0100
Message-ID: <20251203152458.661076001@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152440.645416925@linuxfoundation.org>
References: <20251203152440.645416925@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -541,6 +541,8 @@ static int imx_gpc_remove(struct platfor
 			return ret;
 	}
 
+	of_node_put(pgc_node);
+
 	return 0;
 }
 


