Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CEBF51DE0C;
	Wed, 30 Sep 2026 17:44:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790790297; cv=none; b=TknfVYhVaDc0DFJxrIx05iTnLhCXkM7HoUuF0LP7a83JskdteUU1Sa+qlX0zk6LTs9u31F1bf+6aPAb/62Z1b6TFLuOb2bAC0WURA2MWAnP6QNAXyUfk6OaJ5s+s7dX5MSrTmD1ti5LWhqsyz3kbjAMqaVaD/Pq+vWVvugEk/pQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790790297; c=relaxed/simple;
	bh=BkcCL6RQbpJQqlP5JK8ye+vroMD3Tpi2AfHf+ixIM0Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MJ84IuN+UYDkzZMs2gFHWOQMupkLERMch4RQIGNiM7c9jtdEjM4IYs3pBgVmdJJI+QS5OlK+5o2wJWiZF+0YVjMlH8asIqltmyhNDJHtRDxhwbFsJkMZ64EwpJKRJnFUBzhr034MTbaFdaF5lWKw39/3hZ+HON2zo/Kzdx/OiZA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BIsyGY/S; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BIsyGY/S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6738E1F000FF;
	Wed, 30 Sep 2026 17:44:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790790295;
	bh=CIl/RsI9x16fy3qQwrWVqUP8mKJ6tvlcPsb+WZ91XpY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BIsyGY/SlWfQIjEBzNyJIlAtjpag+UVALSNkg/AxiuR0itutr+VL48DfPt6+X9XJc
	 sik6FJDQDeZMfURMeKb+orz898yp5QRgyXyvlBHAfLgUyRTSTZ+BIvqnNJgH29EHkJ
	 Xpyr6MqJR3PjYayXS7FxjIAoaXb6Fup8O4HuRzPA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Carlos Maiolino <cmaiolino@redhat.com>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 777/877] xfs: report healthy filesystem events in scrub stats
Date: Wed, 30 Sep 2026 17:28:08 +0200
Message-ID: <20260930152431.480072544@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
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

From: "Darrick J. Wong" <djwong@kernel.org>

[ Upstream commit 0ae61c331ec552ad0c278c5c48a1c4ccb90b4bab ]

LOLLM also notices that I forgot to expose the "clean bill of health"
scrub stats.  Fix that.

Cc: stable@vger.kernel.org # v6.9
Fixes: a1f3e0cca41036 ("xfs: update health status if we get a clean bill of health")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
[ adjusted table insertion context for missing METAPATH, RGSUPER, RTRMAPBT, and RTREFCBT entries. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/scrub/stats.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/xfs/scrub/stats.c
+++ b/fs/xfs/scrub/stats.c
@@ -80,6 +80,7 @@ static const char *name_map[XFS_SCRUB_TY
 	[XFS_SCRUB_TYPE_QUOTACHECK]	= "quotacheck",
 	[XFS_SCRUB_TYPE_NLINKS]		= "nlinks",
 	[XFS_SCRUB_TYPE_DIRTREE]	= "dirtree",
+	[XFS_SCRUB_TYPE_HEALTHY]	= "healthy",
 };
 
 /* Format the scrub stats into a text buffer, similar to pcp style. */


