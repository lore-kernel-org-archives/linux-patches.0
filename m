Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07FB328314C;
	Mon, 13 Apr 2026 16:11:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776096687; cv=none; b=pi00njCiV7/IJCDIUFvrxagE77jV/ZlPZgIUafFENNr7Ouz+4ujQ4VGC1hMPgM49Fs4glf2LFQPRswC7cs2jYDMFnlVqrnKwoYZxooqowmaYWnWKd/iH8L9Ipl06h4aUuNiJvHLOsusWz42mffZXjLCR00lYP2pbqt9+EX5ofB8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776096687; c=relaxed/simple;
	bh=l06Dmk7opppyzhZrrxr2xQmye/EL1yRxFA2LJepVxtg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jlVhKUbz+v2PyGvB6fPi7p9/C0vEoXvoJitV87jwNC26ANQ5Kceqi8nJtX6GcEb1V6ooi06orMLl04w4n/xG56jetrmVc9AxzoUdReGTFwaGP3fIlK2df3/Q67EPWTQkR1LZY0ATj/jdzh3iQ8SUG1nRWDEEg9X7U4a0iMUu8F0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yv/2mdPm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yv/2mdPm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FF6AC2BCAF;
	Mon, 13 Apr 2026 16:11:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776096686;
	bh=l06Dmk7opppyzhZrrxr2xQmye/EL1yRxFA2LJepVxtg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yv/2mdPmeB2GtPsxsZIUGRGWmeQVIrTnfygJphc9HbuvGh+v569oWolWELenzkh0z
	 ar3oLT0oubyjnDHwB8bS8Lqg8CbV1DHBZTAMEcBS2RqEXUBqHyzQf4j0BYdaVqu5dT
	 fFy+0dQtNRjLwuL0ipYIkNs9o4uAyd/zRIYCglmo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xingjing Deng <xjdeng@buaa.edu.cn>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 24/70] misc: fastrpc: check qcom_scm_assign_mem() return in rpmsg_probe
Date: Mon, 13 Apr 2026 18:00:19 +0200
Message-ID: <20260413155729.089997881@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155728.181580293@linuxfoundation.org>
References: <20260413155728.181580293@linuxfoundation.org>
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

From: Xingjing Deng <micro6947@gmail.com>

[ Upstream commit 6a502776f4a4f80fb839b22f12aeaf0267fca344 ]

In the SDSP probe path, qcom_scm_assign_mem() is used to assign the
reserved memory to the configured VMIDs, but its return value was not checked.

Fail the probe if the SCM call fails to avoid continuing with an
unexpected/incorrect memory permission configuration.

This issue was found by an in-house analysis workflow that extracts AST-based
information and runs static checks, with LLM assistance for triage, and was
confirmed by manual code review.
No hardware testing was performed.

Fixes: c3c0363bc72d4 ("misc: fastrpc: support complete DMA pool access to the DSP")
Cc: stable@vger.kernel.org # 6.11-rc1
Signed-off-by: Xingjing Deng <xjdeng@buaa.edu.cn>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Link: https://patch.msgid.link/20260131065539.2124047-1-xjdeng@buaa.edu.cn
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[ adapted qcom_scm_assign_mem() error check to use fdev_error label and rmem-based memory API ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/misc/fastrpc.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/misc/fastrpc.c
+++ b/drivers/misc/fastrpc.c
@@ -2346,8 +2346,10 @@ static int fastrpc_rpmsg_probe(struct rp
 
 		src_perms = BIT(QCOM_SCM_VMID_HLOS);
 
-		qcom_scm_assign_mem(rmem->base, rmem->size, &src_perms,
+		err = qcom_scm_assign_mem(rmem->base, rmem->size, &src_perms,
 				    data->vmperms, data->vmcount);
+		if (err)
+			goto fdev_error;
 
 	}
 


