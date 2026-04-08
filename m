Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C29E25A321;
	Wed,  8 Apr 2026 19:02:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775674928; cv=none; b=Rhnj05Xl2tXJPOBIKwwRAMDGiIK2x7s8aGo6+Coj0GJiJpTuSYt+IaViwEv36fkIn+2A0TxLEZMWJgSKzFnwWGyvYYClvJqa+8kkOOfrYjhh1j+RV4wFiQKn3W0UO7JQmJiFD3Ek79SACW8gsNdyhwJRHLVBkKKRYXxWYXvA2TY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775674928; c=relaxed/simple;
	bh=QYpRlk/Vs5MdEXJWWw7+IHtDm7TqEoC2i97dscSvIbA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qzH1d3zPoGIpfDK32FZoVoSyaOgfEP8EXRnyFpPhBWb0RT6hvRoVSAmIAbJg21qT3/j7KeGkZZFrdrxOBHHvf8yLvxiQ/UYMB6EMtTOgr5T/SjI1Pv29501prHiUwDpq4/EM+klK+yFhBe3SVTVTjTstrDMqw2ztEIGKCZiPDUs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bWDd5Ro9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bWDd5Ro9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 951A1C19421;
	Wed,  8 Apr 2026 19:02:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775674927;
	bh=QYpRlk/Vs5MdEXJWWw7+IHtDm7TqEoC2i97dscSvIbA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bWDd5Ro9HLHVLDCVTAGg4rkmaW15Z3NQBtgE+HXMl2+HxDaSzlzAbvjEk2VnAOx+2
	 tGcNIdT/ML27IlCgXwM9xCYw6FwalG7yxyB9DFYHktfBVteLVI1V4uWexgOt6aL592
	 eQTtLFZYMeZgscPM6utRtIlX7iO0X1dxnNRUvJPk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xingjing Deng <xjdeng@buaa.edu.cn>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Subject: [PATCH 6.19 288/311] misc: fastrpc: check qcom_scm_assign_mem() return in rpmsg_probe
Date: Wed,  8 Apr 2026 20:04:48 +0200
Message-ID: <20260408175950.134236281@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175939.393281918@linuxfoundation.org>
References: <20260408175939.393281918@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

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


