Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A10EB67E;
	Wed,  8 Apr 2026 18:37:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775673467; cv=none; b=kvu+j3OAqNE6ufntI822q5mEV7AoP0l7eQefk+ZtWjPNYVKhwXNxIWLtih+dv66Tq8lF1W6gLkFzc7vTJSWxJx6Q51dCfcRlb5vZiTeg+heXHGEPT316vN1Xcm4QKw+llpe4FZFPNx/G9e7g1IUiNpsMIVOMiCBeyb4t4CHDFxA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775673467; c=relaxed/simple;
	bh=ngWPWngUaF22j/25YUBsyxuUC1+M7dcfex6/S5mUctg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bA5BB6yv6/+0FXFmjdZ+Zs/CgCg2oTTok6J2jRIzr2AUzEyvqzA3uKCK6wqbGlG3ZEMyVzyS3GG7WnwOW9PIh0gJruYoo11Zyei3vW7U67KijtrgcYm1r3qOEFzmYOSEGgx1EmEp6XEEMJCxLKQSJnv+nqQPB6HEJ5FuM30wYoA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XqJe1Onk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XqJe1Onk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02043C19421;
	Wed,  8 Apr 2026 18:37:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775673467;
	bh=ngWPWngUaF22j/25YUBsyxuUC1+M7dcfex6/S5mUctg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XqJe1Onk1IvJnQ1TcXOlLPvoRbusU0KlhEPgaOf8pTABPea9tWunCde28IJcpUz3d
	 CZ1rENxWdnZKqqweOaqg8zGqJJy5Kny6uObxM9vN2YGO2l0wen4hjCLW+jvuCMGqXy
	 KjKZzxJrCNjycJTHrlh1wZO3qqVBMx9hjOEVteX4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xingjing Deng <xjdeng@buaa.edu.cn>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Subject: [PATCH 6.18 243/277] misc: fastrpc: check qcom_scm_assign_mem() return in rpmsg_probe
Date: Wed,  8 Apr 2026 20:03:48 +0200
Message-ID: <20260408175942.933349023@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175933.836769063@linuxfoundation.org>
References: <20260408175933.836769063@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xingjing Deng <micro6947@gmail.com>

commit 6a502776f4a4f80fb839b22f12aeaf0267fca344 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/misc/fastrpc.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/misc/fastrpc.c
+++ b/drivers/misc/fastrpc.c
@@ -2338,8 +2338,10 @@ static int fastrpc_rpmsg_probe(struct rp
 		if (!err) {
 			src_perms = BIT(QCOM_SCM_VMID_HLOS);
 
-			qcom_scm_assign_mem(res.start, resource_size(&res), &src_perms,
+			err = qcom_scm_assign_mem(res.start, resource_size(&res), &src_perms,
 				    data->vmperms, data->vmcount);
+			if (err)
+				goto err_free_data;
 		}
 
 	}


