Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DCD333290A;
	Fri,  9 Jan 2026 11:54:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767959678; cv=none; b=hAX5AZm13MhUT+I4g4vNO7IwyhCW85hVH5lur8TDKxftQeidbA1LnlppsXakpQjZeUGgxXytYwheXGrxw5/CnJoxyQulzCWCgF2bIAbge4uQHYPfJNXhRL9TMnVw+zvZ0X/MFxYcfVcKMGSgfh+mi2h5fJggPDpKB/2tJiJ7nh8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767959678; c=relaxed/simple;
	bh=fqxPh2IEwfAffS6v3gUpMQodRsi4nko5BYRNbpVPTAI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CQzhDr5fhvQjZvx3U/T2dwfupjZK8ALs+ryLDNcsinBDUdFCylmDS6J3uYKz2vhXxPt1EU6AHNmn7voS8fPCHAZOWHup/fX/R0FmEYgJcsJSqY+5PtjKR/H3RSHAaFVgQtTY+wkGUnx/UOb+GBHU6JV/nKEVolJ37hYZx0TA1O0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fRgmBkgq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fRgmBkgq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D953C4CEF1;
	Fri,  9 Jan 2026 11:54:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767959678;
	bh=fqxPh2IEwfAffS6v3gUpMQodRsi4nko5BYRNbpVPTAI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fRgmBkgqJLdAJts4zY2YycCLeCgGY/p+YrdwJtenhE+CR5/1X43EbEW89t9I2CVXt
	 5b3uG9MgVYAVPRtwkZp9MnnUGjw/S+r7oG7roS2KrAH7In6Br4ogAVJpZEQjqJ6Z44
	 kvMDE1I67LZGCPMYMAb32hb511LO2K/g439KbZMg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ma Ke <make24@iscas.ac.cn>,
	Jack Wang <jinpu.wang@ionos.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 135/737] RDMA/rtrs: server: Fix error handling in get_or_create_srv
Date: Fri,  9 Jan 2026 12:34:34 +0100
Message-ID: <20260109112139.079507691@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
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

From: Ma Ke <make24@iscas.ac.cn>

[ Upstream commit a338d6e849ab31f32c08b4fcac11c0c72afbb150 ]

After device_initialize() is called, use put_device() to release the
device according to kernel device management rules. While direct
kfree() work in this case, using put_device() is more correct.

Found by code review.

Fixes: 9cb837480424 ("RDMA/rtrs: server: main functionality")
Signed-off-by: Ma Ke <make24@iscas.ac.cn>
Link: https://patch.msgid.link/20251110005158.13394-1-make24@iscas.ac.cn
Acked-by: Jack Wang <jinpu.wang@ionos.com>
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/ulp/rtrs/rtrs-srv.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/ulp/rtrs/rtrs-srv.c b/drivers/infiniband/ulp/rtrs/rtrs-srv.c
index 84d1654148d76..5dbf315630c1a 100644
--- a/drivers/infiniband/ulp/rtrs/rtrs-srv.c
+++ b/drivers/infiniband/ulp/rtrs/rtrs-srv.c
@@ -1443,7 +1443,7 @@ static struct rtrs_srv_sess *get_or_create_srv(struct rtrs_srv_ctx *ctx,
 	kfree(srv->chunks);
 
 err_free_srv:
-	kfree(srv);
+	put_device(&srv->dev);
 	return ERR_PTR(-ENOMEM);
 }
 
-- 
2.51.0



