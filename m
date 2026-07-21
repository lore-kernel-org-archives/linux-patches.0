Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EED243E9D5;
	Tue, 21 Jul 2026 22:29:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784672989; cv=none; b=qgcb3zIcaKPHdEu5Fux3NWZoZeCEivcMKy19qh4qvrMpRntY2hdW5OPYv6uFtZbs/p5ArGXRfWglH8WUxeKXQ9PAh+O871QNgm0iwSIHMJl5lGEcYisjWA6mct92mwQSgvMk8KTpgOcEF5rPujOGRxtXgrCSEZCBK8w6NXCvsiA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784672989; c=relaxed/simple;
	bh=X5IVP728suShoJ2IhFy5coJJfE+y7Gp+2Nj64XUBDTU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XnJ3W8L9aZiIET3TLzMNTu0oY6saaDtxwqEGcLdd8hOrMsE2Yn9joiwz1G9Azh5epiCg9MmeME/qnLvf4HByrvja1wRu7vRrSrEjGYzRwxAYu45ZeWWNLbVCTpwZrsUCK9ticTX9kKupJcrPta10naBp0s6D1lBee7tZH7RcOOY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FGWk5+Mi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FGWk5+Mi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 687BD1F000E9;
	Tue, 21 Jul 2026 22:29:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784672986;
	bh=PtmlLS5gFhlRDr9sVDfiui3SqNzAD0hfSfN8BWBw2cE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FGWk5+Miwfb7mKBF+/Rt3FQMZf1jYaXij19+8k35fc2+Py3xKC9ZT0ecG6mHaCs4d
	 6oPfSDMesnhuNIfgJL78uP5PCZFtWDcY5ICFUOHuJFxjP/yMLIG7HfIeT9BPDP2K7Z
	 8WeBLbRSko2O6pl1KH5pXZcQGKejKt5cACdE/qTQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 833/843] regulator: scmi: fix of_node refcount leak in scmi_regulator_probe()
Date: Tue, 21 Jul 2026 17:27:48 +0200
Message-ID: <20260721152424.819261089@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wentao Liang <vulab@iscas.ac.cn>

[ Upstream commit fa11039d6cdff84584a3ef8cc1f5e1b56e045da2 ]

scmi_regulator_probe() calls of_find_node_by_name() which takes a
reference on the returned device node. On the error path where
process_scmi_regulator_of_node() fails, the function returns without
calling of_node_put() on the child node, leaking the reference.

Add of_node_put(np) on the error path to properly release the
reference.

Cc: stable@vger.kernel.org
Fixes: 0fbeae70ee7c ("regulator: add SCMI driver")
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
Link: https://patch.msgid.link/20260527104850.872415-1-vulab@iscas.ac.cn
Signed-off-by: Mark Brown <broonie@kernel.org>
[ kept the existing of_node_put(child) since 5.15 still uses the non-scoped for_each_child_of_node() loop, only adding the new of_node_put(np) line ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/regulator/scmi-regulator.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/regulator/scmi-regulator.c
+++ b/drivers/regulator/scmi-regulator.c
@@ -350,6 +350,7 @@ static int scmi_regulator_probe(struct s
 		/* abort on any mem issue */
 		if (ret == -ENOMEM) {
 			of_node_put(child);
+			of_node_put(np);
 			return ret;
 		}
 	}


