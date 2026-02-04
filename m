Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C7DC18859B;
	Wed,  4 Feb 2026 15:15:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770218139; cv=none; b=Axz9SrguEaYlUPQiIpIJZm9QALhEb67wlunoAJZrO1xwu/9jg0pF1Y2GoeCLjdKdUozftUloueQJg/Qr3G67SDJ06X9WHMf7TWRnBX9CjRtzT1JOAm0FpKv0LMeYv0eVdNLaANtFWBeclRIVBVErJCxNNfMB8TnLcRwm8LE5Hcc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770218139; c=relaxed/simple;
	bh=vJ1d5US3IRPBB9KnWCrItYPdBgpTuCE1HUV7GQwwfE0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DpoeRFjfeDfS3tRB+47v8tJ57wqPE+AlomFOXByCP53pt9ILsNf23Po71KpxWGiws2KY5XLTLq8rFFdhbk/OnnYYR3/63svsPOirHcWomgWbUfe9zR95j4yCt6Cv5rfBdlx0w1j0acaocPr7sWYVNae4pVDDGeC1nm+/wkPZl9k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=D7ufntIV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="D7ufntIV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6D07C4CEF7;
	Wed,  4 Feb 2026 15:15:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770218139;
	bh=vJ1d5US3IRPBB9KnWCrItYPdBgpTuCE1HUV7GQwwfE0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=D7ufntIVQtgmbWfP2fdMPOoNEqB1cZX9mixqwZUATsY9aPMEYfO0RZdDlScXwmJni
	 ebaFwNBfeNijSFc2ZRW7igz3HnhHlKke7i7CdcxXZUYrqzVOQAME0cGu6KaflvfZW1
	 zv9Jr82g1g+WcT4l1Hn2LtCcuyM6ZM9wuBFpje8Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abdun Nihaal <nihaal@cse.iitm.ac.in>,
	Juergen Gross <jgross@suse.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 223/280] scsi: xen: scsiback: Fix potential memory leak in scsiback_remove()
Date: Wed,  4 Feb 2026 15:39:57 +0100
Message-ID: <20260204143917.634812744@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143909.614719725@linuxfoundation.org>
References: <20260204143909.614719725@linuxfoundation.org>
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

From: Abdun Nihaal <nihaal@cse.iitm.ac.in>

[ Upstream commit 901a5f309daba412e2a30364d7ec1492fa11c32c ]

Memory allocated for struct vscsiblk_info in scsiback_probe() is not
freed in scsiback_remove() leading to potential memory leaks on remove,
as well as in the scsiback_probe() error paths. Fix that by freeing it
in scsiback_remove().

Cc: stable@vger.kernel.org
Fixes: d9d660f6e562 ("xen-scsiback: Add Xen PV SCSI backend driver")
Signed-off-by: Abdun Nihaal <nihaal@cse.iitm.ac.in>
Reviewed-by: Juergen Gross <jgross@suse.com>
Link: https://patch.msgid.link/20251223063012.119035-1-nihaal@cse.iitm.ac.in
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/xen/xen-scsiback.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/xen/xen-scsiback.c
+++ b/drivers/xen/xen-scsiback.c
@@ -1261,6 +1261,7 @@ static void scsiback_remove(struct xenbu
 	gnttab_page_cache_shrink(&info->free_pages, 0);
 
 	dev_set_drvdata(&dev->dev, NULL);
+	kfree(info);
 }
 
 static int scsiback_probe(struct xenbus_device *dev,


