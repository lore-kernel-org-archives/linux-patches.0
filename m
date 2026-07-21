Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10A5246AA89;
	Tue, 21 Jul 2026 15:41:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784648464; cv=none; b=USRP2om94gbt3LK/EyYnZZsp0m+ZdMSG1dOVhAUIMtP1pzKZPto+Mo9iBhxMQjo7ZiZ30lNxUFf19SAXvZ580k1H7COmLnQKhpFDvN40RT4MjeTUkiRj7+2EmzqkDX7Vj0NZq6SzEr7K33+YQjayYa4QMB9f1Jxw+Jzx2hr42ww=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784648464; c=relaxed/simple;
	bh=Mm9cBU+s6mqavaGlwlu8g9ar//Pbul5ILUH6WGvaRaA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Yflenyo5c76LlgLAekLZkgJo7q8HzlWh5xW0JF+4BfpX4pHrO1Uos//ivj0L9ILrlstXfOJqSMxDwu0CFcjheCsvFYf/AQ+YHPyBrAc7fVVp2SLsZDIL/au3M5vhAMS6/4SsTtO3KZzyrESXDh9GcvfVAJUJjzKvn2BP0ufuu+Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cK0IPGYO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cK0IPGYO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EDD31F000E9;
	Tue, 21 Jul 2026 15:41:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784648463;
	bh=ZUtUHysf9w98Z8/rKiodnDeMUExleGQTO95F63PV75c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cK0IPGYOWPV66ihhpb+ssjW/gDHjTvT9sEGtpdb+kHgJXUJ4IJlwNG2vTAaR8+T19
	 iqHVrn/AZP9LQgliKw15Rg8igf7SD22nnSB+VmpLKo+nYJFkKmoy/2OggNyXhc9ank
	 3w+c7Ytzcji+pPd801JH7fjJSnbXknh4/qB6qT/M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stepan Ionichev <sozdayvek@gmail.com>,
	Sudeep Holla <sudeep.holla@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0208/2077] clk: scpi: Unregister child clock providers on remove
Date: Tue, 21 Jul 2026 16:58:01 +0200
Message-ID: <20260721152557.587319760@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stepan Ionichev <sozdayvek@gmail.com>

[ Upstream commit b79d9b5747d961516c35ef4d5e91efa579fd3e9a ]

SCPI clock providers are registered for each child node in
scpi_clk_add(), but scpi_clocks_remove() unregisters the parent node on
each iteration.

of_clk_del_provider() matches providers by the node used at registration
time, so passing the parent node leaves the child providers registered.
This leaks the provider allocations and the node references held by the
clock provider core.

Pass the child node to of_clk_del_provider() so the remove path matches
the probe path.

Fixes: cd52c2a4b5c4 ("clk: add support for clocks provided by SCP(System Control Processor)")
Signed-off-by: Stepan Ionichev <sozdayvek@gmail.com>
Link: https://patch.msgid.link/20260513090900.5323-1-sozdayvek@gmail.com
(sudeep.holla: Updated commit title and message a bit)
Signed-off-by: Sudeep Holla <sudeep.holla@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/clk-scpi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clk/clk-scpi.c b/drivers/clk/clk-scpi.c
index 7806569cd0d5c4..24cee7c9fda6c5 100644
--- a/drivers/clk/clk-scpi.c
+++ b/drivers/clk/clk-scpi.c
@@ -258,7 +258,7 @@ static void scpi_clocks_remove(struct platform_device *pdev)
 	}
 
 	for_each_available_child_of_node(np, child)
-		of_clk_del_provider(np);
+		of_clk_del_provider(child);
 }
 
 static int scpi_clocks_probe(struct platform_device *pdev)
-- 
2.53.0



